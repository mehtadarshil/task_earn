import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/repos/category_repo.dart';
import 'package:task_earn/app/services/snackbar_util.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/presentation/common_bottom_sheets/confirmation_sheet.dart';
import 'package:task_earn/presentation/common_widgets/common_appbar.dart';
import 'package:task_earn/presentation/pages/category_page/bottom_sheets/add_edit_category.dart';
import 'package:task_earn/presentation/pages/home_page/controller/home_controller.dart';

class CategoryPage extends GetView<HomeController> {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppbar(
        title: Strings.strCategory,
      ),
      body: Obx(() {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          itemBuilder: (context, index) {
            var data = controller.categoryList.value[index];
            return (data.active ?? false)
                ? ListTile(
                    onTap: () {
                      AddEditCategory.showBottomSheet(
                          homecontroller: controller,
                          category: data,
                          index: index);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r)),
                    tileColor: AppColors.secondaryDarkColor,
                    leading: Text(
                      data.emoji ?? "",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          "\$${data.limit.toString()}",
                          style: TextStyle(
                              fontFamily: FontFamily.poppinsMedium,
                              fontSize: 15.sp),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (controller.categoryList
                                    .where(
                                      (element) => element.active ?? false,
                                    )
                                    .length ==
                                1) {
                              SnackBarUtil.showSnackBar(
                                  message:
                                      Strings.strMinimumOneCategoryIsRequired);
                            } else {
                              ConfirmationSheet.showBottomSheet(
                                onConfirm: () {
                                  data.active = false;
                                  controller.categoryList.refresh();
                                  CategoryRepo.updateCategory(
                                      controller.categoryList);
                                },
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.h),
                            decoration: BoxDecoration(
                                color: AppColors.primaryLightColor,
                                borderRadius: BorderRadius.circular(5.r)),
                            child: Icon(
                              Icons.delete_forever_rounded,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    title: Text(data.name ?? "",
                        style: TextStyle(
                            fontFamily: FontFamily.poppinsMedium,
                            fontSize: 14.sp)),
                  ).paddingOnly(bottom: 10.h)
                : const SizedBox.shrink();
          },
          itemCount: controller.categoryList.length,
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.secondaryDarkColor,
        child: const Icon(Icons.add),
        onPressed: () {
          AddEditCategory.showBottomSheet(homecontroller: controller);
        },
      ),
    );
  }
}
