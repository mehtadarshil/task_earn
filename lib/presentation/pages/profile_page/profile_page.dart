import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/dbkeys.dart';
import 'package:task_earn/app/config/event_tag.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/routes/route_const.dart';
import 'package:task_earn/app/services/app_component.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/presentation/common_bottom_sheets/confirmation_sheet.dart';
import 'package:task_earn/presentation/common_bottom_sheets/name_update_sheet.dart';
import 'package:task_earn/presentation/pages/profile_page/controller/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  ProfileController get controller => Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              NameUpdateSheet.showBottomSheet(profileController: controller);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.secondaryDarkColor,
                  borderRadius: BorderRadius.circular(25.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "${Strings.strName} :",
                    style: TextStyle(
                        fontFamily: FontFamily.poppinsMedium, fontSize: 14.sp),
                  ),
                  Obx(
                    () => Text(
                      controller.name.isEmpty
                          ? Strings.strNoNameFound
                          : controller.name.value,
                      style: controller.name.isEmpty
                          ? TextStyle(
                              fontFamily: FontFamily.poppinsRegular,
                              fontSize: 11.sp,
                              color: AppColors.whiteColor.withOpacity(0.3))
                          : TextStyle(
                              fontFamily: FontFamily.poppinsRegular,
                              fontSize: 12.sp),
                    ),
                  )
                ],
              ).paddingSymmetric(horizontal: 15.w, vertical: 10.h),
            ).paddingSymmetric(horizontal: 15.w, vertical: 10.h),
          ),
          ListTile(
            onTap: () {
              ConfirmationSheet.showBottomSheet(
                  onConfirm: () async {
                    AppBaseComponent.instance.addEvent(EventTag.deleteUser);
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .delete();
                    await FirebaseAuth.instance.signOut();
                    await GetStorage().remove(Dbkeys.userData);
                    AppBaseComponent.instance.removeEvent(EventTag.deleteUser);
                    Get.offAllNamed(RouteConst.loginPage);
                  },
                  title: Strings.strDeleteUserTitle);
            },
            tileColor: AppColors.secondaryDarkColor,
            title: Text(
              Strings.strDeleteAccount,
              style: TextStyle(
                  fontFamily: FontFamily.poppinsSemiBold, fontSize: 15.sp),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          SizedBox(
            height: 10.h,
          ),
          ListTile(
            onTap: () async {
              AppBaseComponent.instance.addEvent(EventTag.logout);
              await FirebaseAuth.instance.signOut();
              await GetStorage().remove(Dbkeys.userData);
              AppBaseComponent.instance.removeEvent(EventTag.logout);
              Get.offAllNamed(RouteConst.loginPage);
            },
            tileColor: AppColors.secondaryDarkColor,
            title: Text(
              Strings.strLogOut,
              style: TextStyle(
                  fontFamily: FontFamily.poppinsSemiBold, fontSize: 15.sp),
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          )
        ],
      ),
    );
  }
}
