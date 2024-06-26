import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/repos/user_repo.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/presentation/common_widgets/common_button.dart';
import 'package:task_earn/presentation/common_widgets/common_text_field.dart';
import 'package:task_earn/presentation/pages/profile_page/controller/profile_controller.dart';

class NameUpdateSheet {
  static void showBottomSheet(
      {required ProfileController profileController}) async {
    TextEditingController nameController =
        TextEditingController(text: UserRepo.currentUser().name);
    Get.bottomSheet(
        NameUpdateWidget(
          nameController: nameController,
          profileController: profileController,
        ),
        isScrollControlled: true);
  }
}

class NameUpdateWidget extends StatelessWidget {
  const NameUpdateWidget({
    super.key,
    required this.nameController,
    required this.profileController,
  });

  final TextEditingController nameController;
  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
          color: AppColors.primaryDarkColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 70.w,
              height: 5.h,
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(5.r)),
            ).paddingOnly(top: 5.h, bottom: 15.h),
          ),
          Text(
            Strings.strUpdateYourName,
            style: TextStyle(
                fontFamily: FontFamily.poppinsBold,
                color: AppColors.whiteColor,
                fontSize: 16.sp),
          ).paddingOnly(bottom: 10.h),
          CommonTextField(
              controller: nameController, hintText: Strings.strName),
          CommonButton(
            title: Strings.strSubmit,
            onTap: () async {
              await profileController.updateUserName(
                  updatedName: nameController.text);
              if (Get.isBottomSheetOpen ?? false) {
                Get.close(1);
              }
            },
          ).paddingOnly(top: 10.h)
        ],
      ),
    );
  }
}
