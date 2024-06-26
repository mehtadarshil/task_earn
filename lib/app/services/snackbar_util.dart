import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/routes/route_const.dart';
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
            fontFamily: FontFamily.poppinsSemiBold),
      ),
      margin: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: (Get.currentRoute != RouteConst.dashboardPage ||
                  (Get.isBottomSheetOpen ?? false))
              ? 10
              : 70.h),
      animationDuration: const Duration(milliseconds: 600),
      duration: duration ?? const Duration(seconds: 6),
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 20,
      boxShadows: [
        BoxShadow(
            color: AppColors.primaryDarkColor.withOpacity(0.3), blurRadius: 10)
      ],
      barBlur: 0,
      backgroundColor: (success ?? false)
          ? AppColors.secondaryDarkColor
          : AppColors.primaryLightColor,
      snackStyle: SnackStyle.FLOATING,

      // backgroundGradient: LinearGradient(
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //     colors: [AppColors.primaryDarkColor, AppColors.primaryLightColor]),
    ));
  }
}
