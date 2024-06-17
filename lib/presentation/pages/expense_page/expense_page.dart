import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_earn/presentation/pages/expense_page/controller/expense_controller.dart';

class ExpensePage extends GetView<ExpenseController> {
  const ExpensePage({super.key});

  @override
  ExpenseController get controller => Get.put(ExpenseController());

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}
