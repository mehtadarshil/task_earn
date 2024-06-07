import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/gen/fonts.gen.dart';

class SnackBarUtil {
  static void showSnackBar(
      {String? title,
      required String message,
      Duration? duration,
      bool? success}) {
    Get.closeCurrentSnackbar();
    Get.showSnackbar(GetSnackBar(
      messageText: Text(
        message,
        style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 15,
            fontFamily: FontFamily.anekDevanagariBold),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      animationDuration: const Duration(milliseconds: 600),
      duration: duration ?? const Duration(seconds: 6),
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 20,
      boxShadows: [
        BoxShadow(color: AppColors.whiteColor.withOpacity(0.3), blurRadius: 10)
      ],
      barBlur: 0,
      backgroundColor: (success ?? false)
          ? AppColors.primaryDarkColor
          : AppColors.primaryLightColor,
      snackStyle: SnackStyle.FLOATING,

      // backgroundGradient: LinearGradient(
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //     colors: [AppColors.primaryDarkColor, AppColors.primaryLightColor]),
    ));
  }
}
