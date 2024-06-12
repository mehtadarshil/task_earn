import 'package:get/get.dart';
import 'package:task_earn/presentation/pages/verify_otp_page/controller/verify_otp_controller.dart';

class VerifyOtpBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(VerifyOtpController());
  }
}
