import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/models/expense_model.dart';
import 'package:task_earn/presentation/pages/expense_plan_page/controller/expense_plan_controller.dart';

import 'widgets/table_data_widget.dart';

class ExpensePlanPage extends GetView<ExpensePlanController> {
  const ExpensePlanPage({super.key});

  @override
  ExpensePlanController get controller => Get.put(ExpensePlanController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => DropdownButton(
                  borderRadius: BorderRadius.circular(25.r),
                  dropdownColor: AppColors.secondaryDarkColor,
                  underline: const SizedBox.shrink(),
                  value: controller.months[controller.selectedMonth.value - 1],
                  onChanged: (value) {
                    controller.selectedMonth.value =
                        controller.months.indexOf(value!) + 1;
                    controller.from = DateTime(controller.selectedYear.value,
                        controller.selectedMonth.value);
                    controller.to = DateTime(controller.selectedYear.value,
                        controller.selectedMonth.value + 1);
                    controller.getPlanningData();
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
                    controller.from = DateTime(controller.selectedYear.value,
                        controller.selectedMonth.value);
                    controller.to = DateTime(controller.selectedYear.value,
                        controller.selectedMonth.value + 1);
                    controller.getPlanningData();
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
        Container(
          decoration: BoxDecoration(
            color: AppColors.secondaryDarkColor,
            borderRadius: BorderRadius.circular(25.r),
          ),
          child: Obx(
            () {
              double total = controller.incomeTotal.value -
                  controller.savingsTotal.value -
                  controller.expensesTotal.value;
              return Row(
                children: [
                  Expanded(
                    child: Text(
                      "${total.isNegative ? Strings.strLoss : Strings.strProfit} :",
                      style: TextStyle(
                          fontFamily: FontFamily.poppinsSemiBold,
                          fontSize: 16.sp),
                    ),
                  ),
                  Text(
                    total.abs().toString(),
                    style: TextStyle(
                        fontFamily: FontFamily.poppinsSemiBold,
                        fontSize: 16.sp,
                        color: total.isNegative
                            ? AppColors.primaryLightColor
                            : AppColors.whiteColor),
                  )
                ],
              );
            },
          ).paddingSymmetric(horizontal: 15.w, vertical: 10.h),
        ).paddingOnly(bottom: 10.h),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Obx(
                () => TableDataWidget(
                  data: controller.incomeData,
                  title: Strings.strIncome,
                  total: controller.incomeTotal.value,
                  onAdd: (ExpenseModel data) {
                    controller.addIncome(data: data);
                  },
                  onUpdate: (ExpenseModel data) {
                    controller.updateIncome(data: data);
                  },
                  isReadOnly: false,
                ),
              ),
              Obx(() => controller.nativeAd.value != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                            height: controller.adheight,
                            width: controller.adWidth,
                            child: AdWidget(ad: controller.nativeAd.value!)),
                      ],
                    )
                  : const SizedBox.shrink()),
              SizedBox(
                height: 20.h,
              ),
              Obx(
                () => TableDataWidget(
                  data: controller.savingsData,
                  title: Strings.strSavings,
                  total: controller.savingsTotal.value,
                  onAdd: (ExpenseModel data) {
                    controller.addSavings(data: data);
                  },
                  onUpdate: (ExpenseModel data) {
                    controller.updateSavings(data: data);
                  },
                  isReadOnly: false,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Obx(
                () => TableDataWidget(
                  data: controller.expensesData,
                  title: Strings.strExpense,
                  total: controller.expensesTotal.value,
                  onAdd: (ExpenseModel data) {},
                  onUpdate: (ExpenseModel data) {},
                  isReadOnly: true,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ))
      ],
    ).paddingSymmetric(horizontal: 20.w);
  }
}
