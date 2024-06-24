import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:task_earn/app/config/event_tag.dart';
import 'package:task_earn/app/services/app_component.dart';
import 'package:task_earn/app/services/logger.dart';
import 'package:task_earn/models/expense_model.dart';

class ExpensePlanController extends GetxController {
  List<int> years = List.generate(6, (index) => DateTime.now().year - index);
  RxInt selectedYear = DateTime.now().year.obs;
  RxInt selectedMonth = DateTime.now().month.obs;

  DateTime from = DateTime.now();
  DateTime to = DateTime.now();

  RxList<ExpenseModel> incomeData = <ExpenseModel>[].obs;
  RxDouble incomeTotal = 0.0.obs;
  RxList<ExpenseModel> savingsData = <ExpenseModel>[].obs;
  RxDouble savingsTotal = 0.0.obs;
  RxList<ExpenseModel> expensesData = <ExpenseModel>[].obs;
  RxDouble expensesTotal = 0.0.obs;

  Rxn<BannerAd> nativeAd = Rxn();
  final Orientation currentOrientation =
      MediaQuery.of(Get.context!).orientation;

  double get adWidth => MediaQuery.of(Get.context!).size.width - (2 * 16);
  double adheight = 0.0;

  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void onReady() {
    from = DateTime(selectedYear.value, selectedMonth.value);
    to = DateTime(selectedYear.value, selectedMonth.value + 1);
    getPlanningData();
    super.onReady();
  }

  @override
  void onInit() {
    loadNativeAd();
    super.onInit();
  }

  void loadNativeAd() async {
    AdSize size = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(
        adWidth.truncate());
    var bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/9214589741',
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) async {
          BannerAd bannerAd = (ad as BannerAd);

          final AdSize? size = await bannerAd.getPlatformAdSize();
          if (size == null) {
            return;
          } else {
            adheight = size.height.toDouble();
            nativeAd.value = bannerAd;
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          Logger.prints("ad failed ${error.message}");
          ad.dispose();
        },
      ),
    );
    await bannerAd.load();
  }

  void addIncome({required ExpenseModel data}) async {
    AppBaseComponent.instance.addEvent(EventTag.addIncome);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("income")
        .doc(data.id)
        .set(data.toJson());
    data.createdAt = Timestamp.now();
    incomeData.add(data);
    incomeTotal.value += data.amount ?? 0;
    AppBaseComponent.instance.removeEvent(EventTag.addIncome);
  }

  void addSavings({required ExpenseModel data}) async {
    AppBaseComponent.instance.addEvent(EventTag.addSavings);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("savings")
        .doc(data.id)
        .set(data.toJson());
    data.createdAt = Timestamp.now();
    savingsData.add(data);
    savingsTotal.value += data.amount ?? 0;
    AppBaseComponent.instance.removeEvent(EventTag.addSavings);
  }

  void updateSavings({required ExpenseModel data}) async {
    AppBaseComponent.instance.addEvent(EventTag.updateSavings);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("savings")
        .doc(data.id)
        .update(data.toJson());
    incomeData.refresh();
    savingsTotal.value = savingsData.fold(
      0.0,
      (previousValue, element) => previousValue + (element.amount ?? 0),
    );
    AppBaseComponent.instance.removeEvent(EventTag.updateSavings);
  }

  void updateIncome({required ExpenseModel data}) async {
    AppBaseComponent.instance.addEvent(EventTag.updateIncome);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("income")
        .doc(data.id)
        .update(data.toJson());
    incomeData.refresh();
    incomeTotal.value = incomeData.fold(
      0.0,
      (previousValue, element) => previousValue + (element.amount ?? 0),
    );
    AppBaseComponent.instance.removeEvent(EventTag.updateIncome);
  }

  void getPlanningData() async {
    AppBaseComponent.instance.addEvent(EventTag.getPlanningData);
    incomeData.clear();
    incomeTotal.value = 0.0;
    savingsData.clear();
    savingsTotal.value = 0.0;
    expensesData.clear();
    expensesTotal.value = 0.0;
    var incomeJson = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("income")
        .where("createdAt", isGreaterThanOrEqualTo: from, isLessThan: to)
        .orderBy("createdAt", descending: true)
        .get();
    incomeData.value = incomeJson.docs.map(
      (e) {
        var data = ExpenseModel.fromJson(e.data());
        incomeTotal.value += data.amount ?? 0;
        return data;
      },
    ).toList();

    var savingsJson = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("savings")
        .where("createdAt", isGreaterThanOrEqualTo: from, isLessThan: to)
        .orderBy("createdAt", descending: true)
        .get();
    savingsData.value = savingsJson.docs.map(
      (e) {
        var data = ExpenseModel.fromJson(e.data());
        savingsTotal.value += data.amount ?? 0;
        return data;
      },
    ).toList();

    var expenseJson = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("expense")
        .where("createdAt", isGreaterThanOrEqualTo: from, isLessThan: to)
        .orderBy("createdAt", descending: true)
        .get();
    expensesData.value = expenseJson.docs.map(
      (e) {
        var data = ExpenseModel.fromJson(e.data());
        expensesTotal.value += data.amount ?? 0;
        return data;
      },
    ).toList();

    AppBaseComponent.instance.removeEvent(EventTag.getPlanningData);
  }
}
