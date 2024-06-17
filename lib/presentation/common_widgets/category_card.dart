import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/models/user_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.model,
    required this.isSelected,
  });

  final Category model;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              color: isSelected
                  ? AppColors.primaryLightColor
                  : AppColors.whiteColor),
          borderRadius: BorderRadius.circular(25.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            model.emoji ?? "",
            style: TextStyle(fontSize: 14.sp),
          ).paddingOnly(right: 5.w),
          Text(
            model.name ?? "",
            style: TextStyle(
                fontFamily: FontFamily.poppinsMedium, fontSize: 12.sp),
          )
        ],
      ),
    );
  }
}
