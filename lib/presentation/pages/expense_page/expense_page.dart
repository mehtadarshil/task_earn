import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
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
            child: TabBarView(controller: controller.tabController, children: [
              GestureDetector(
                onTap: () async {
                  var date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: AppColors.primaryLightColor,
                              ),
                              datePickerTheme: DatePickerThemeData(
                                  todayForegroundColor: WidgetStatePropertyAll(
                                      AppColors.whiteColor),
                                  headerForegroundColor:
                                      AppColors.primaryLightColor,
                                  backgroundColor: AppColors.primaryDarkColor,
                                  cancelButtonStyle: ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(
                                          AppColors.whiteColor)),
                                  confirmButtonStyle: ButtonStyle(
                                      foregroundColor: WidgetStatePropertyAll(
                                          AppColors.whiteColor)),
                                  dayStyle:
                                      TextStyle(color: AppColors.whiteColor))),
                          child: child!);
                    },
                  );
                  if (date != null) {
                    controller.selectedDay.value = date;
                    controller.from = DateTime(date.year, date.month, date.day);
                    controller.to =
                        DateTime(date.year, date.month, date.day + 1);
                    controller.getExpenseHistory();
                  }
                },
                child: Container(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Text(
                        DateFormat("dd MMM,yyyy")
                            .format(controller.selectedDay.value),
                        style: TextStyle(
                            fontFamily: FontFamily.poppinsRegular,
                            fontSize: 14.sp,
                            color: AppColors.whiteColor),
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
              const Row(),
              const Row()
            ])).paddingSymmetric(horizontal: 15.w),
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
              : const SizedBox.shrink(),
        ))
      ],
    );
  }
}
