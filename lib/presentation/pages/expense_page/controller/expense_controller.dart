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

  List<DateTime> years =
      List.generate(6, (index) => DateTime(DateTime.now().year - index));
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
    super.onInit();
  }

  void getExpenseHistory() async {
    AppBaseComponent.instance.addEvent(EventTag.getExpense);
    expenseList.clear();
    var expenseJson = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("expense")
        .where("createdAt", isGreaterThanOrEqualTo: from, isLessThan: to)
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
