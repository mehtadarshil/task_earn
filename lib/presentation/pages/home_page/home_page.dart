// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/routes/route_const.dart';
import 'package:task_earn/app/services/input_formator.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/presentation/common_widgets/action_button.dart';
import 'package:task_earn/presentation/common_widgets/category_card.dart';
import 'package:task_earn/presentation/common_widgets/common_button.dart';
import 'package:task_earn/presentation/common_widgets/common_text_field.dart';
import 'package:task_earn/presentation/pages/home_page/controller/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  HomeController get controller => Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => controller.isBannerLoaded.value
              ? Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      height: controller.bannerAd!.size.height.toDouble(),
                      width: controller.bannerAd!.size.width.toDouble(),
                      child: AdWidget(ad: controller.bannerAd!)),
                )
              : const SizedBox.shrink()),
          Row(
            children: [
              Expanded(
                  child: Text(
                Strings.strAddExpense,
                style: TextStyle(
                    fontFamily: FontFamily.poppinsBold,
                    fontSize: 18.sp,
                    color: AppColors.whiteColor),
              )),
              ActionButton(
                onTap: () {
                  Get.toNamed(RouteConst.categoryPage)?.then(
                    (value) {
                      controller.selectedCategory.value =
                          controller.categoryList
                                  .where(
                                    (element) => element.active ?? false,
                                  )
                                  .first
                                  .id ??
                              "";
                    },
                  );
                },
                icon: Icon(
                  Icons.menu_rounded,
                  size: 25.sp,
                  color: AppColors.whiteColor,
                ),
              )
            ],
          ).paddingSymmetric(horizontal: 15.w, vertical: 20.h),
          CommonTextField(
                  controller: controller.amountController,
                  inputFormatters: [AmountOnlyFormatter()],
                  hintText: Strings.strAmount)
              .paddingSymmetric(horizontal: 15.w, vertical: 10.h),
          CommonTextField(
                  controller: controller.itemController,
                  hintText: Strings.strItem)
              .paddingSymmetric(
            horizontal: 15.w,
          ),
          Obx(
            () => Wrap(
              spacing: 10.w,
              runSpacing: 7.h,
              children: controller.categoryList.value
                  .where(
                    (element) => element.active ?? false,
                  )
                  .map(
                    (e) => Obx(
                      () => GestureDetector(
                        onTap: () {
                          controller.selectedCategory.value = e.id ?? "";
                        },
                        child: CategoryCard(
                          model: e,
                          isSelected: controller.selectedCategory.value == e.id,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ).paddingSymmetric(horizontal: 15.w, vertical: 20.h),
          CommonButton(
            title: Strings.strSubmit,
            onTap: () {
              controller.addExpense();
            },
          ).paddingSymmetric(horizontal: 15.w, vertical: 10)
        ],
      ),
    );
  }
}
