import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_earn/presentation/common_widgets/common_appbar.dart';
import 'package:task_earn/presentation/pages/dashboard_page/controller/dashboard_controller.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CommonAppbar(),
    );
  }
}
