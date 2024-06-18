import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/presentation/common_widgets/common_button.dart';

class ConfirmationSheet {
  static Future showBottomSheet(
      {String? title, required VoidCallback onConfirm}) async {
    await Get.bottomSheet(Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
          color: AppColors.primaryDarkColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? Strings.strAreYouSureYouWantToDelete,
            style: TextStyle(
                fontFamily: FontFamily.poppinsSemiBold, fontSize: 16.sp),
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            children: [
              Expanded(
                child: CommonButton(
                  title: Strings.strCancle,
                  onTap: () {
                    if (Get.isBottomSheetOpen ?? false) {
                      Get.close(1);
                    }
                  },
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                  child: CommonButton(
                title: Strings.strConfirm,
                onTap: () {
                  if (Get.isBottomSheetOpen ?? false) {
                    Get.close(1);
                    onConfirm();
                  }
                },
              ))
            ],
          )
        ],
      ),
    ));
  }
}
