import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_earn/presentation/pages/expense_plan_page/controller/expense_plan_controller.dart';

class ExpensePlanPage extends GetView<ExpensePlanController> {
  const ExpensePlanPage({super.key});

  @override
  ExpensePlanController get controller => Get.put(ExpensePlanController());

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}
