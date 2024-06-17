import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/gen/fonts.gen.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.inputFormatters,
      this.prefixIcon});
  final TextEditingController controller;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: TextField(
        controller: controller,
        expands: true,
        maxLines: null,
        inputFormatters: inputFormatters,
        cursorColor: AppColors.primaryLightColor,
        style:
            TextStyle(fontSize: 18.sp, fontFamily: FontFamily.poppinsSemiBold),
        decoration: InputDecoration(
            prefixIcon: prefixIcon,
            labelStyle: TextStyle(color: AppColors.whiteColor.withOpacity(0.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: AppColors.whiteColor,
                )),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: AppColors.whiteColor,
                )),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: AppColors.whiteColor,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: AppColors.whiteColor,
                )),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: AppColors.whiteColor,
                )),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: AppColors.whiteColor,
                )),
            labelText: hintText),
      ),
    );
  }
}
