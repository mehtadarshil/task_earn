import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:task_earn/app/config/error_codes.dart';
import 'package:task_earn/app/config/event_tag.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/services/app_component.dart';
import 'package:task_earn/app/services/snackbar_util.dart';

class LoginController extends GetxController {
  TextEditingController mobileNumberController = TextEditingController();
  late RiveAnimationController btnController;
  RxString countryCode = "+1".obs;

  @override
  void onInit() {
    btnController = OneShotAnimation('active', autoplay: false);
    super.onInit();
  }

  void chnageCountryCode(String newCode) {
    countryCode.value = "+$newCode";
  }

  void onLogin() async {
    if (mobileNumberController.text.isNotEmpty) {
      Get.focusScope!.unfocus();
      AppBaseComponent.instance.addEvent(EventTag.login);
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.verifyPhoneNumber(
        phoneNumber: "${countryCode.value}${mobileNumberController.text}",
        codeAutoRetrievalTimeout: (String verificationId) {},
        codeSent: (String verificationId, int? forceResendingToken) {
          AppBaseComponent.instance.stopLoading();
          // Get.toNamed(RoutesConsts.verifypage, arguments: {
          //   'number': "$countryCode ${numberController.text}",
          //   'id': verificationId,
          //   "forceResendingToken": forceResendingToken
          // });
        },
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: (FirebaseAuthException error) {
          AppBaseComponent.instance.stopLoading();
          if (error.code == ErrorCodes.invalidNumber) {
            SnackBarUtil.showSnackBar(
                message: Strings.strYouEnteredInvalidNumber);
          } else {
            SnackBarUtil.showSnackBar(message: Strings.strErrorOccured);
          }
        },
      );
    } else {
      SnackBarUtil.showSnackBar(message: Strings.strProperNumber);
    }
  }
}
