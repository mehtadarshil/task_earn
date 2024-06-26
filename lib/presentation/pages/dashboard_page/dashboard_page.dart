import 'package:animated_digit/animated_digit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/repos/user_repo.dart';
import 'package:task_earn/gen/assets.gen.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/presentation/common_widgets/common_appbar.dart';
import 'package:task_earn/presentation/common_widgets/common_navbar.dart';
import 'package:task_earn/presentation/pages/dashboard_page/controller/dashboard_controller.dart';
import 'package:task_earn/presentation/pages/expense_page/expense_page.dart';
import 'package:task_earn/presentation/pages/expense_plan_page/expense_plan_page.dart';
import 'package:task_earn/presentation/pages/home_page/home_page.dart';
import 'package:task_earn/presentation/pages/profile_page/profile_page.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppbar(
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
                color: AppColors.secondaryDarkColor,
                borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              children: [
                Assets.images.coin
                    .image(height: 20.h, width: 20.w)
                    .paddingOnly(right: 5.w),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data != null &&
                          !snapshot.hasError) {
                        UserRepo.updateCoinsLocally(
                            coins: snapshot.data!.get("coins") ?? 0);
                      }
                      return AnimatedDigitWidget(
                        value: snapshot.hasData &&
                                snapshot.data != null &&
                                !snapshot.hasError
                            ? (snapshot.data!.get("coins") ?? 0)
                            : 0,
                        textStyle: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: FontFamily.poppinsSemiBold,
                            fontSize: 18.sp),
                        duration: const Duration(seconds: 1),
                        curve: Curves.decelerate,
                      );
                    })
              ],
            ),
          )
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: const [
          HomePage(),
          ExpensePage(),
          ExpensePlanPage(),
          ProfilePage()
        ],
      ),
      bottomNavigationBar: CommonNavbar(
        controller: controller,
      ),
    );
  }
}
