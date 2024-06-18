import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/gen/fonts.gen.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            minimumSize: Size(double.infinity, 45.h),
            backgroundColor: AppColors.secondaryDarkColor),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
              fontFamily: FontFamily.poppinsSemiBold,
              color: AppColors.whiteColor,
              fontSize: 17.sp),
        ));
  }
}
