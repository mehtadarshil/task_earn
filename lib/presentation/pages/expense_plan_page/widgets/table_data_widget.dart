import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/services/input_formator.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/models/expense_model.dart';
import 'package:uuid/uuid.dart';

class TableDataWidget extends StatefulWidget {
  const TableDataWidget({
    super.key,
    required this.title,
    required this.total,
    required this.data,
    required this.onAdd,
    required this.onUpdate,
    required this.isReadOnly,
    required this.onDelete,
  });

  final String title;
  final double total;
  final List<ExpenseModel> data;
  final Function(ExpenseModel data) onAdd;
  final Function(ExpenseModel data) onUpdate;
  final bool isReadOnly;
  final Function(ExpenseModel data) onDelete;

  @override
  State<TableDataWidget> createState() => _TableDataWidgetState();
}

class _TableDataWidgetState extends State<TableDataWidget> {
  RxBool isAdded = false.obs;
  TextEditingController addTitleController = TextEditingController();
  FocusNode addTitleFocusNode = FocusNode();
  TextEditingController addAmountController = TextEditingController();
  FocusNode addAmountFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                        color: AppColors.primaryDarkColor,
                        fontFamily: FontFamily.poppinsBold,
                        fontSize: 16.sp),
                  ),
                ),
                Text(
                  widget.total.toString(),
                  style: TextStyle(
                      color: AppColors.primaryDarkColor,
                      fontFamily: FontFamily.poppinsBold,
                      fontSize: 16.sp),
                )
              ],
            ),
          ),
          Table(
            border: TableBorder(
                horizontalInside:
                    BorderSide(color: AppColors.whiteColor, width: 0.5)),
            children: widget.data.isEmpty
                ? [
                    TableRow(children: [
                      Obx(
                        () => isAdded.value
                            ? const SizedBox.shrink()
                            : Container(
                                color: AppColors.secondaryDarkColor,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 14.h),
                                child: Text(
                                  Strings.strNoDataFound,
                                  style: TextStyle(
                                      fontFamily: FontFamily.poppinsMedium,
                                      fontSize: 15.sp),
                                ),
                              ),
                      )
                    ])
                  ]
                : widget.data.map(
                    (element) {
                      TextEditingController titleController =
                          TextEditingController(text: element.item ?? "");
                      FocusNode titleFocusNode = FocusNode();
                      TextEditingController amountController =
                          TextEditingController(
                              text: element.amount?.toString() ?? "0.0");
                      FocusNode amountFocusNode = FocusNode();
                      return TableRow(
                          decoration: BoxDecoration(
                              color: AppColors.secondaryDarkColor),
                          children: [
                            Slidable(
                              groupTag: "Tables",
                              key: ValueKey(element.id),
                              closeOnScroll: true,
                              direction: Axis.horizontal,
                              endActionPane: widget.isReadOnly
                                  ? null
                                  : ActionPane(
                                      motion: const BehindMotion(),
                                      children: [
                                          SlidableAction(
                                            onPressed: (_) {
                                              widget.onDelete(element);
                                            },
                                            backgroundColor:
                                                AppColors.primaryLightColor,
                                            autoClose: true,
                                            icon: Icons.delete_forever_rounded,
                                          )
                                        ]),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.focusScope?.unfocus();
                                        titleFocusNode.requestFocus();
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 14.h),
                                        child: EditableText(
                                            controller: titleController,
                                            focusNode: titleFocusNode,
                                            readOnly: widget.isReadOnly,
                                            onSubmitted: (value) {
                                              amountFocusNode.requestFocus();
                                            },
                                            style: TextStyle(
                                                fontFamily:
                                                    FontFamily.poppinsMedium,
                                                fontSize: 15.sp),
                                            cursorColor:
                                                AppColors.primaryLightColor,
                                            backgroundCursorColor:
                                                AppColors.primaryLightColor),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.focusScope?.unfocus();
                                        amountFocusNode.requestFocus();
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.w, vertical: 14.h),
                                        child: EditableText(
                                            controller: amountController,
                                            focusNode: amountFocusNode,
                                            readOnly: widget.isReadOnly,
                                            textAlign: TextAlign.end,
                                            onSubmitted: (value) {
                                              if (titleController.text
                                                      .trim()
                                                      .isNotEmpty &&
                                                  amountController.text
                                                      .trim()
                                                      .isNotEmpty &&
                                                  double.tryParse(
                                                          amountController
                                                              .text) !=
                                                      null) {
                                                element.item =
                                                    titleController.text.trim();
                                                element.amount = double.parse(
                                                    amountController.text);
                                                widget.onUpdate(element);
                                              }
                                              isAdded.value = false;
                                              Get.focusScope?.unfocus();
                                              amountController.clear();
                                              titleController.clear();
                                            },
                                            inputFormatters: [
                                              AmountOnlyFormatter()
                                            ],
                                            style: TextStyle(
                                                fontFamily:
                                                    FontFamily.poppinsMedium,
                                                fontSize: 15.sp),
                                            cursorColor:
                                                AppColors.primaryLightColor,
                                            backgroundCursorColor:
                                                AppColors.primaryLightColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]);
                    },
                  ).toList(),
          ),
          Obx(
            () => isAdded.value
                ? Container(
                    decoration: BoxDecoration(
                        color: AppColors.secondaryDarkColor,
                        border: Border(
                            top: BorderSide(
                                color: AppColors.whiteColor, width: 0.5))),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.focusScope?.unfocus();
                              addTitleFocusNode.requestFocus();
                            },
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 14.h),
                              child: EditableText(
                                  controller: addTitleController,
                                  focusNode: addTitleFocusNode,
                                  readOnly: widget.isReadOnly,
                                  onTapOutside: (event) {
                                    isAdded.value = false;
                                    Get.focusScope?.unfocus();
                                    addAmountController.clear();
                                    addTitleController.clear();
                                  },
                                  onSubmitted: (value) {
                                    addAmountFocusNode.requestFocus();
                                  },
                                  style: TextStyle(
                                      fontFamily: FontFamily.poppinsMedium,
                                      fontSize: 15.sp),
                                  cursorColor: AppColors.primaryLightColor,
                                  backgroundCursorColor:
                                      AppColors.primaryLightColor),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Get.focusScope?.unfocus();
                              addAmountFocusNode.requestFocus();
                            },
                            child: Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 14.h),
                              child: EditableText(
                                  controller: addAmountController,
                                  focusNode: addAmountFocusNode,
                                  readOnly: widget.isReadOnly,
                                  inputFormatters: [AmountOnlyFormatter()],
                                  onTapOutside: (event) {
                                    isAdded.value = false;
                                    Get.focusScope?.unfocus();
                                    addAmountController.clear();
                                    addTitleController.clear();
                                  },
                                  onSubmitted: (value) {
                                    if (addTitleController.text
                                            .trim()
                                            .isNotEmpty &&
                                        addAmountController.text
                                            .trim()
                                            .isNotEmpty &&
                                        double.tryParse(
                                                addAmountController.text) !=
                                            null) {
                                      widget.onAdd(ExpenseModel(
                                          id: const Uuid().v4(),
                                          amount: double.parse(
                                              addAmountController.text),
                                          createdAt:
                                              FieldValue.serverTimestamp(),
                                          item: addTitleController.text.trim(),
                                          uid: FirebaseAuth
                                              .instance.currentUser?.uid));
                                    }
                                    isAdded.value = false;
                                    Get.focusScope?.unfocus();
                                    addAmountController.clear();
                                    addTitleController.clear();
                                  },
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontFamily: FontFamily.poppinsMedium,
                                      fontSize: 15.sp),
                                  cursorColor: AppColors.primaryLightColor,
                                  backgroundCursorColor:
                                      AppColors.primaryLightColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          if (!widget.isReadOnly)
            GestureDetector(
              onTap: () {
                isAdded.value = true;
                addTitleFocusNode.requestFocus();
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.secondaryDarkColor,
                    border: Border(
                        top: BorderSide(
                            color: AppColors.whiteColor, width: 0.5))),
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 14.h),
                child: Text(
                  "+ Add ${widget.title}",
                  style: TextStyle(
                      fontFamily: FontFamily.poppinsBold, fontSize: 15.sp),
                ),
              ),
            )
        ],
      ),
    );
  }
}
