import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_earn/app/config/dbkeys.dart';
import 'package:task_earn/app/config/error_codes.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/routes/route_const.dart';
import 'package:task_earn/app/services/app_component.dart';
import 'package:task_earn/app/services/logger.dart';
import 'package:task_earn/app/services/snackbar_util.dart';
import 'package:task_earn/models/user_model.dart';

class VerifyOtpController extends GetxController {
  final number = Get.arguments['number'];
  final Duration resendTime = const Duration(minutes: 3);
  var forceResendingToken = Get.arguments['forceResendingToken'];
  final TextEditingController otpPinPutController = TextEditingController();
  final StreamController<Duration> _countdownController =
      StreamController<Duration>();

  Stream<Duration> get countdownStream => _countdownController.stream;

  Timer? _timer;

  @override
  void onInit() {
    start(resendTime);
    super.onInit();
  }

  @override
  void onClose() {
    disposeTimer();
    super.onClose();
  }

  void start(Duration countdownDuration) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countdownDuration = countdownDuration - const Duration(seconds: 1);
      _countdownController.sink.add(countdownDuration);
      if (countdownDuration.inSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  void verifyOtp() async {
    if (otpPinPutController.text.isNotEmpty &&
        otpPinPutController.text.length >= 6) {
      FocusScope.of(Get.context!).unfocus();
      FirebaseAuth auth = FirebaseAuth.instance;
      AppBaseComponent.instance.startLoading();

      try {
        await auth.signInWithCredential(PhoneAuthProvider.credential(
            verificationId: Get.arguments['id'],
            smsCode: otpPinPutController.text));
        if (Get.arguments["deleteAcc"] != null) {
          Get.back(result: true);
          return;
        }
        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();
        if (userData.exists) {
          await GetStorage().write(Dbkeys.userData, userData.data());
          Get.offAllNamed(RouteConst.dashboardPage);
          AppBaseComponent.instance.stopLoading();
        } else {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .set(UserModel(uid: FirebaseAuth.instance.currentUser?.uid)
                  .toJson());
          Get.offAllNamed(RouteConst.dashboardPage);
          AppBaseComponent.instance.stopLoading();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == ErrorCodes.invalidOtp) {
          SnackBarUtil.showSnackBar(message: Strings.strInvalidOtpError);
        } else {
          SnackBarUtil.showSnackBar(message: Strings.strLoginFailed);
        }
        Logger.prints(e.code);
        AppBaseComponent.instance.stopLoading();
      } catch (e) {
        Logger.prints(e);
        AppBaseComponent.instance.stopLoading();
      }
    } else {
      SnackBarUtil.showSnackBar(message: Strings.strPleaseEnterOtp);
    }
  }

  void resendOtp() async {
    AppBaseComponent.instance.startLoading();
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      forceResendingToken: forceResendingToken,
      codeAutoRetrievalTimeout: (String verificationId) {},
      codeSent: (String verificationId, int? forceResendingToken) {
        AppBaseComponent.instance.stopLoading();
        this.forceResendingToken = forceResendingToken;
        start(resendTime);
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
      verificationFailed: (FirebaseAuthException error) {
        AppBaseComponent.instance.stopLoading();
        SnackBarUtil.showSnackBar(message: error.message ?? "");
        Logger.prints(error.message);
      },
    );
  }

  void disposeTimer() {
    _timer?.cancel();
    _countdownController.close();
  }
}
