import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_earn/app/config/app_colors.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.onTap,
    required this.icon,
  });

  final VoidCallback onTap;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5.h),
        decoration: BoxDecoration(
            color: AppColors.secondaryDarkColor,
            borderRadius: BorderRadius.circular(10.r)),
        child: icon,
      ),
    );
  }
}
