import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/services/snackbar_util.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/models/expense_model.dart';
import 'package:task_earn/presentation/common_bottom_sheets/confirmation_sheet.dart';
import 'package:task_earn/presentation/common_widgets/action_button.dart';
import 'package:task_earn/presentation/common_widgets/category_card.dart';
import 'package:task_earn/presentation/common_widgets/common_button.dart';
import 'package:task_earn/presentation/common_widgets/common_text_field.dart';
import 'package:task_earn/presentation/pages/expense_page/controller/expense_controller.dart';
import 'package:task_earn/presentation/pages/home_page/controller/home_controller.dart';

class ExpenseDetailSheet {
  static void showBottomSheet(
      {required ExpenseModel expenseModel,
      required ExpenseController expenseController}) async {
    await showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => ExpenseDetailWidget(
        expenseController: expenseController,
        expenseModel: expenseModel,
      ),
    );
  }
}

class ExpenseDetailWidget extends StatefulWidget {
  const ExpenseDetailWidget({
    super.key,
    required this.expenseModel,
    required this.expenseController,
  });

  final ExpenseModel expenseModel;
  final ExpenseController expenseController;

  @override
  State<ExpenseDetailWidget> createState() => _ExpenseDetailWidgetState();
}

class _ExpenseDetailWidgetState extends State<ExpenseDetailWidget> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  RxString selectedCategory = "".obs;
  @override
  void initState() {
    selectedCategory.value = widget.expenseModel.categoryId ?? "";
    titleController.text = widget.expenseModel.item ?? "";
    amountController.text = (widget.expenseModel.amount ?? 0).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.primaryDarkColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 70.w,
              height: 5.h,
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(5.r)),
            ).paddingOnly(
              top: 10.h,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ActionButton(
                  onTap: () {
                    Get.close(1);
                  },
                  icon: const Icon(Icons.close_rounded)),
              Expanded(
                child: Text(
                  Strings.strExpenseDetail,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: FontFamily.poppinsSemiBold, fontSize: 18.sp),
                ),
              ),
              ActionButton(
                  onTap: () {
                    ConfirmationSheet.showBottomSheet(
                      onConfirm: () async {
                        await widget.expenseController
                            .deleteExpense(expenseModel: widget.expenseModel);
                        Get.close(1);
                      },
                    );
                  },
                  icon: Icon(
                    Icons.delete_forever_rounded,
                    color: AppColors.primaryLightColor,
                  )),
            ],
          ).paddingSymmetric(vertical: 10.h),
          CommonTextField(
                  controller: titleController, hintText: Strings.strItem)
              .paddingSymmetric(vertical: 10.h),
          CommonTextField(
              controller: amountController, hintText: Strings.strAmount),
          Wrap(
            spacing: 10.w,
            runSpacing: 7.h,
            children: Get.find<HomeController>()
                .categoryList
                .value
                .where(
                  (element) => element.active ?? false,
                )
                .map(
                  (e) => Obx(
                    () => GestureDetector(
                      onTap: () {
                        selectedCategory.value = e.id ?? "";
                      },
                      child: CategoryCard(
                        model: e,
                        isSelected: selectedCategory.value == e.id,
                      ),
                    ),
                  ),
                )
                .toList(),
          ).paddingOnly(top: 20.h, bottom: 25.h),
          CommonButton(
            title: Strings.strSubmit,
            onTap: () async {
              if (amountController.text.trim().isEmpty ||
                  double.tryParse(amountController.text.trim()) == null) {
                SnackBarUtil.showSnackBar(
                    message: Strings.strEnterProperAmount);
              } else if (titleController.text.trim().isEmpty) {
                SnackBarUtil.showSnackBar(message: Strings.strEnterProperItem);
              } else {
                ExpenseModel data = widget.expenseModel;
                data.amount = double.parse(amountController.text);
                data.item = titleController.text.trim();
                data.categoryId = selectedCategory.value;
                await widget.expenseController
                    .updateExpense(expenseModel: data);
                Get.close(1);
                Get.find<ExpenseController>().expenseList.refresh();
              }
            },
          ).paddingOnly(bottom: 10.h)
        ],
      ).paddingSymmetric(horizontal: 15.w),
    );
  }
}
