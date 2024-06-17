import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/presentation/common_widgets/common_appbar.dart';
import 'package:task_earn/presentation/pages/home_page/controller/home_controller.dart';

class CategoryPage extends GetView<HomeController> {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppbar(
        title: Strings.strCategory,
      ),
      body: Obx(() => ListView.separated(
            itemBuilder: (context, index) {
              var data = controller.categoryList.value[index];
              return ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r)),
                tileColor: AppColors.secondaryDarkColor,
                title: Text(data.name ?? ""),
              );
            },
            itemCount: controller.categoryList.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10.h,
              );
            },
          )),
    );
  }
}
