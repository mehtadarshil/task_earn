import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:task_earn/app/config/ad_unit_id.dart';
import 'package:task_earn/app/config/event_tag.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/repos/user_repo.dart';
import 'package:task_earn/app/services/app_component.dart';
import 'package:task_earn/app/services/snackbar_util.dart';
import 'package:task_earn/models/expense_model.dart';
import 'package:task_earn/models/user_model.dart';
import 'package:uuid/uuid.dart';

class HomeController extends GetxController {
  BannerAd? bannerAd;
  RxBool isBannerLoaded = false.obs;
  RxList<Category> categoryList = <Category>[].obs;
  RxString selectedCategory = "".obs;

  TextEditingController amountController = TextEditingController();
  TextEditingController itemController = TextEditingController();

  @override
  void onReady() {
    if (UserRepo.currentUser().category != null &&
        UserRepo.currentUser().category!.isNotEmpty) {
      selectedCategory.value = UserRepo.currentUser().category?.first.id ?? "";
    }
    categoryList.value = UserRepo.currentUser().category ?? [];
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdUnitId.bannerAd,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isBannerLoaded.value = true;
          },
          onAdClicked: (ad) {
            var user = UserRepo.currentUser();
            UserRepo.updateUserCoins(coins: (user.coins ?? 0) + 2);
          },
        ),
        request: const AdRequest())
      ..load();
    super.onReady();
  }

  void addExpense() async {
    if (amountController.text.trim().isEmpty ||
        double.tryParse(amountController.text.trim()) == null) {
      SnackBarUtil.showSnackBar(message: Strings.strEnterProperAmount);
    } else if (itemController.text.trim().isEmpty) {
      SnackBarUtil.showSnackBar(message: Strings.strEnterProperItem);
    } else {
      AppBaseComponent.instance.addEvent(EventTag.addExpense);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("expense")
          .add(ExpenseModel(
                  id: const Uuid().v4(),
                  amount: double.parse(amountController.text),
                  categoryId: selectedCategory.value,
                  createdAt: FieldValue.serverTimestamp(),
                  item: itemController.text.trim(),
                  uid: FirebaseAuth.instance.currentUser?.uid)
              .toJson());
      SnackBarUtil.showSnackBar(
          message: Strings.strExpenseAddedSuccessfully, success: true);
      AppBaseComponent.instance.removeEvent(EventTag.addExpense);
    }
  }
}
