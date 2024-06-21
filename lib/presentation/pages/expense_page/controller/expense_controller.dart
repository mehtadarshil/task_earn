import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/event_tag.dart';
import 'package:task_earn/app/services/app_component.dart';
import 'package:task_earn/models/expense_model.dart';

class ExpenseController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final TabController tabController;
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  RxList<ExpenseModel> expenseList = <ExpenseModel>[].obs;
  RxDouble total = 0.0.obs;

  List<int> years = List.generate(6, (index) => DateTime.now().year - index);
  RxInt selectedYear = DateTime.now().year.obs;
  RxInt selectedMonth = DateTime.now().month.obs;
  Rx<DateTime> selectedDay = DateTime.now().obs;

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
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(
      () {
        if (tabController.index == 0 && tabController.indexIsChanging) {
          from = DateTime(selectedDay.value.year, selectedDay.value.month,
              selectedDay.value.day);
          to = DateTime(selectedDay.value.year, selectedDay.value.month,
              selectedDay.value.day + 1);
          getExpenseHistory();
        } else if (tabController.index == 1 && tabController.indexIsChanging) {
          from = DateTime(selectedYear.value, selectedMonth.value);
          to = DateTime(selectedYear.value, selectedMonth.value + 1);
          getExpenseHistory();
        } else if (tabController.index == 2 && tabController.indexIsChanging) {
          from = DateTime(selectedYear.value);
          to = DateTime(selectedYear.value + 1);
          getExpenseHistory();
        }
      },
    );
    super.onInit();
  }

  @override
  void onReady() {
    from =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    to = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

    getExpenseHistory();
    super.onReady();
  }

  void getExpenseHistory() async {
    AppBaseComponent.instance.addEvent(EventTag.getExpense);
    expenseList.clear();
    total.value = 0;
    var expenseJson = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("expense")
        .where("createdAt", isGreaterThanOrEqualTo: from, isLessThan: to)
        .orderBy("createdAt", descending: true)
        .get();
    expenseList.value = expenseJson.docs.map(
      (e) {
        var data = ExpenseModel.fromJson(e.data());
        total.value += data.amount ?? 0;
        return data;
      },
    ).toList();
    AppBaseComponent.instance.removeEvent(EventTag.getExpense);
  }
}
