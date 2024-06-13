import 'package:get/get.dart';
import 'package:task_earn/presentation/pages/dashboard_page/controller/dashboard_controller.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}
