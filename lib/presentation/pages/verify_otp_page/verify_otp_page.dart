import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/presentation/common_widgets/common_appbar.dart';
import 'package:task_earn/presentation/pages/verify_otp_page/controller/verify_otp_controller.dart';

class VerifyOtpPage extends GetView<VerifyOtpController> {
  const VerifyOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppbar(title: Strings.strVerifyOTP),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 19, top: 56),
              child: Text.rich(TextSpan(children: [
                const TextSpan(
                    text: Strings.strEnterOTPsentto,
                    style: TextStyle(
                        fontSize: 16, fontFamily: FontFamily.poppinsRegular)),
                TextSpan(
                    text: controller.number,
                    style: const TextStyle(
                        fontSize: 16, fontFamily: FontFamily.poppinsSemiBold))
              ])),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 19, left: 10, right: 10),
            child: SizedBox(
              height: 60,
              child: Pinput(
                length: 6,
                controller: controller.otpPinPutController,
                cursor: Container(
                  color: AppColors.primaryLightColor,
                  width: 1,
                  height: 20,
                ),
                onCompleted: (value) {
                  controller.verifyOtp();
                },
                focusedPinTheme: PinTheme(
                  height: 58,
                  width: 58,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: AppColors.whiteColor, width: 2.5)),
                ),
                defaultPinTheme: PinTheme(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: AppColors.whiteColor, width: 1.5)),
                ),
              ),
            ),
          ),
          StreamBuilder<Duration>(
            initialData: const Duration(minutes: 3),
            stream: controller.countdownStream,
            builder: (context, snapshot) {
              return Column(
                children: [
                  snapshot.data!.inSeconds != 0
                      ? Text(
                          "${snapshot.data.toString().split(":").elementAt(1)}:${snapshot.data.toString().split(":").elementAt(2).split(".").elementAt(0)}",
                          style: const TextStyle(),
                        ).paddingOnly(bottom: 16)
                      : const SizedBox.shrink(),
                  GestureDetector(
                    onTap: () {
                      if (snapshot.data!.inSeconds == 0) {
                        controller.resendOtp();
                      }
                    },
                    child: Text(
                      Strings.strResendOTP,
                      style: TextStyle(
                          color: snapshot.data!.inSeconds == 0
                              ? AppColors.primaryLightColor
                              : AppColors.whiteColor),
                    ),
                  ),
                ],
              ).paddingOnly(
                top: 38,
              );
            },
          ),
        ],
      ),
    );
  }
}
