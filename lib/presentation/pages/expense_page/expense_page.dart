import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/gen/assets.gen.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/presentation/pages/expense_page/controller/expense_controller.dart';
import 'package:task_earn/presentation/pages/expense_page/widgets/expense_card.dart';

class ExpensePage extends GetView<ExpenseController> {
  const ExpensePage({super.key});

  @override
  ExpenseController get controller => Get.put(ExpenseController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: controller.tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          overlayColor: WidgetStatePropertyAll(AppColors.secondaryDarkColor),
          dividerColor: Colors.transparent,
          tabs: [Strings.strToday, Strings.strMonth, Strings.strYear]
              .map((e) => Tab(
                    height: 26.h,
                    child: Text(
                      e,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 14.sp,
                          fontFamily: FontFamily.poppinsMedium),
                    ),
                  ))
              .toList(),
          // splashFactory: NoSplash.splashFactory,
          splashBorderRadius: BorderRadius.circular(20.r),
          indicator: BoxDecoration(
              color: AppColors.secondaryDarkColor,
              borderRadius: BorderRadius.circular(20.r)),
        ).paddingSymmetric(horizontal: 15.w),
        SizedBox(
            height: 60.h,
            child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.tabController,
                children: [
                  GestureDetector(
                    onTap: () async {
                      var date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        initialDate: controller.selectedDay.value,
                        builder: (context, child) {
                          return Theme(
                              data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.dark(
                                    primary: AppColors.primaryLightColor,
                                  ),
                                  datePickerTheme: DatePickerThemeData(
                                      todayForegroundColor:
                                          WidgetStatePropertyAll(
                                              AppColors.whiteColor),
                                      headerForegroundColor:
                                          AppColors.primaryLightColor,
                                      backgroundColor:
                                          AppColors.primaryDarkColor,
                                      cancelButtonStyle: ButtonStyle(
                                          foregroundColor:
                                              WidgetStatePropertyAll(
                                                  AppColors.whiteColor)),
                                      confirmButtonStyle: ButtonStyle(
                                          foregroundColor:
                                              WidgetStatePropertyAll(
                                                  AppColors.whiteColor)),
                                      dayStyle: TextStyle(
                                          color: AppColors.whiteColor))),
                              child: child!);
                        },
                      );
                      if (date != null) {
                        controller.selectedDay.value = date;
                        controller.from =
                            DateTime(date.year, date.month, date.day);
                        controller.to =
                            DateTime(date.year, date.month, date.day + 1);
                        controller.getExpenseHistory();
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Obx(
                            () => Text(
                              DateFormat("dd MMM,yyyy")
                                  .format(controller.selectedDay.value),
                              style: TextStyle(
                                  fontFamily: FontFamily.poppinsRegular,
                                  fontSize: 14.sp,
                                  color: AppColors.whiteColor),
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            color: AppColors.whiteColor,
                            size: 27.sp,
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => DropdownButton(
                            borderRadius: BorderRadius.circular(25.r),
                            dropdownColor: AppColors.secondaryDarkColor,
                            underline: const SizedBox.shrink(),
                            value: controller
                                .months[controller.selectedMonth.value - 1],
                            onChanged: (value) {
                              controller.selectedMonth.value =
                                  controller.months.indexOf(value!) + 1;
                              controller.from = DateTime(
                                  controller.selectedYear.value,
                                  controller.selectedMonth.value);
                              controller.to = DateTime(
                                  controller.selectedYear.value,
                                  controller.selectedMonth.value + 1);
                              controller.getExpenseHistory();
                            },
                            items: controller.months
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                          fontFamily: FontFamily.poppinsMedium,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                )
                                .toList()),
                      ),
                      Obx(
                        () => DropdownButton(
                            borderRadius: BorderRadius.circular(25.r),
                            dropdownColor: AppColors.secondaryDarkColor,
                            underline: const SizedBox.shrink(),
                            value: controller.selectedYear.value,
                            onChanged: (value) {
                              controller.selectedYear.value =
                                  value ?? DateTime.now().year;
                              controller.from = DateTime(
                                  controller.selectedYear.value,
                                  controller.selectedMonth.value);
                              controller.to = DateTime(
                                  controller.selectedYear.value,
                                  controller.selectedMonth.value + 1);
                              controller.getExpenseHistory();
                            },
                            items: controller.years
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.toString(),
                                      style: TextStyle(
                                          fontFamily: FontFamily.poppinsMedium,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                )
                                .toList()),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(
                        () => DropdownButton(
                            borderRadius: BorderRadius.circular(25.r),
                            dropdownColor: AppColors.secondaryDarkColor,
                            underline: const SizedBox.shrink(),
                            value: controller.selectedYear.value,
                            onChanged: (value) {
                              controller.selectedYear.value =
                                  value ?? DateTime.now().year;
                              controller.from =
                                  DateTime(controller.selectedYear.value);
                              controller.to =
                                  DateTime(controller.selectedYear.value + 1);
                              controller.getExpenseHistory();
                            },
                            items: controller.years
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.toString(),
                                      style: TextStyle(
                                          fontFamily: FontFamily.poppinsMedium,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                )
                                .toList()),
                      ),
                    ],
                  )
                ])).paddingSymmetric(horizontal: 15.w),
        Container(
          decoration: BoxDecoration(
            color: AppColors.secondaryDarkColor,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "${Strings.strTotal} :",
                  style: TextStyle(
                      fontFamily: FontFamily.poppinsSemiBold, fontSize: 16.sp),
                ),
              ),
              Obx(() => Text(
                    controller.total.value.toString(),
                    style: TextStyle(
                        fontFamily: FontFamily.poppinsSemiBold,
                        fontSize: 16.sp),
                  ))
            ],
          ).paddingSymmetric(horizontal: 15.w, vertical: 10.h),
        ).paddingSymmetric(horizontal: 15.w),
        Expanded(
            child: Obx(
          () => controller.expenseList.isNotEmpty
              ? ListView.builder(
                  itemCount: controller.expenseList.length,
                  itemBuilder: (context, index) {
                    var data = controller.expenseList[index];
                    return ExpenseCard(
                        expenseModel: data, controller: Get.find());
                  },
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.images.noExpense
                          .image(
                              height: MediaQuery.of(context).size.width * 0.25,
                              color: AppColors.whiteColor)
                          .paddingOnly(bottom: 10.h),
                      Text(
                        Strings.strNoExpenseFound,
                        style: TextStyle(
                            fontFamily: FontFamily.poppinsBold,
                            fontSize: 18.sp),
                      )
                    ],
                  ),
                ),
        ))
      ],
    );
  }
}
