import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/models/expense_model.dart';
import 'package:task_earn/models/user_model.dart';
import 'package:task_earn/presentation/pages/home_page/controller/home_controller.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard(
      {super.key, required this.expenseModel, required this.controller});

  final ExpenseModel expenseModel;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    var category = controller.categoryList.firstWhere(
      (element) => element.id == expenseModel.categoryId,
      orElse: () => Category(emoji: ""),
    );
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 31),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18),
                child: Text(
                  category.emoji!,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            expenseModel.item!,
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontFamily: FontFamily.poppinsSemiBold,
                                fontSize: 16),
                          ),
                        ),
                        Text(
                          "- ${expenseModel.amount}",
                          style: TextStyle(
                              fontFamily: FontFamily.poppinsSemiBold,
                              fontSize: 16.sp,
                              color: AppColors.primaryLightColor),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category.name ?? "Not Found",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: FontFamily.poppinsRegular,
                                fontSize: 12.sp,
                                color: AppColors.whiteColor),
                          ),
                        ),
                        Text(
                          DateFormat("MM/dd/yy - h:mm aa").format(
                              (expenseModel.createdAt as Timestamp).toDate()),
                          style: TextStyle(
                              fontFamily: FontFamily.poppinsRegular,
                              fontSize: 12.sp,
                              color: AppColors.whiteColor),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
