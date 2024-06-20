import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/gen/assets.gen.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/presentation/pages/dashboard_page/controller/dashboard_controller.dart';

class CommonNavbar extends StatelessWidget {
  const CommonNavbar({
    super.key,
    required this.controller,
  });

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      decoration: BoxDecoration(
          color: AppColors.secondaryDarkColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
      child: Row(
        children: [
          Obx(() => NavButton(
                iconData: Assets.images.home,
                title: Strings.strHomePage,
                isSelected: controller.pageIndex.value == 0,
                onTap: () {
                  if (!controller.isScroling) {
                    controller.pageIndex.value = 0;
                  }
                },
              )),
          Obx(() => NavButton(
                iconData: Assets.images.expense,
                title: Strings.strExpensePage,
                isSelected: controller.pageIndex.value == 1,
                onTap: () {
                  if (!controller.isScroling) {
                    controller.pageIndex.value = 1;
                  }
                },
              )),
          Obx(() => NavButton(
                iconData: Assets.images.planning,
                title: Strings.strPlanning,
                isSelected: controller.pageIndex.value == 2,
                onTap: () {
                  if (!controller.isScroling) {
                    controller.pageIndex.value = 2;
                  }
                },
              )),
          Obx(() => NavButton(
                iconData: Assets.images.profile,
                title: Strings.strProfile,
                isSelected: controller.pageIndex.value == 3,
                onTap: () {
                  if (!controller.isScroling) {
                    controller.pageIndex.value = 3;
                  }
                },
              )),
        ],
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  const NavButton(
      {super.key,
      required this.iconData,
      required this.title,
      required this.isSelected,
      required this.onTap});

  final AssetGenImage iconData;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isSelected ? (MediaQuery.of(context).size.width / 4) : 0,
              height: 4.h,
              decoration: BoxDecoration(
                  color: AppColors.primaryLightColor,
                  borderRadius: BorderRadius.circular(5.r)),
            ).paddingSymmetric(horizontal: 20.w).paddingOnly(bottom: 5.h),
            iconData
                .image(
                    height: 20.h,
                    width: 20.w,
                    color: isSelected
                        ? AppColors.whiteColor
                        : AppColors.whiteColor.withOpacity(0.4))
                .paddingOnly(bottom: 2.h),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              softWrap: false,
              style: TextStyle(
                fontFamily: FontFamily.poppinsLight,
                fontSize: 11.sp,
                color: AppColors.whiteColor.withOpacity(isSelected ? 1 : 0.4),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
