import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/repos/category_repo.dart';
import 'package:task_earn/app/repos/user_repo.dart';
import 'package:task_earn/app/services/input_formator.dart';
import 'package:task_earn/app/services/snackbar_util.dart';
import 'package:task_earn/gen/assets.gen.dart';
import 'package:task_earn/models/user_model.dart';
import 'package:task_earn/presentation/common_widgets/common_button.dart';
import 'package:task_earn/presentation/common_widgets/common_text_field.dart';
import 'package:task_earn/presentation/common_widgets/custom_emoji_picker.dart';
import 'package:task_earn/presentation/pages/home_page/controller/home_controller.dart';
import 'package:uuid/uuid.dart';

class AddEditCategory {
  static void showBottomSheet(
      {required HomeController homecontroller,
      Category? category,
      int? index}) {
    RxBool isShowing = false.obs;
    RxString emoji = (category?.emoji ?? "").obs;
    TextEditingController titleController =
        TextEditingController(text: category?.name);
    TextEditingController limitController =
        TextEditingController(text: (category?.limit ?? 0).toString());

    Get.bottomSheet(
        AddEditCategoryWidget(
          isShowing: isShowing,
          emoji: emoji,
          homeController: homecontroller,
          limitController: limitController,
          titleController: titleController,
          category: category,
          index: index,
        ),
        isScrollControlled: true);
  }
}

class AddEditCategoryWidget extends StatelessWidget {
  const AddEditCategoryWidget(
      {super.key,
      required this.isShowing,
      required this.homeController,
      required this.titleController,
      required this.limitController,
      required this.emoji,
      this.category,
      this.index});

  final RxBool isShowing;
  final RxString emoji;
  final HomeController homeController;
  final TextEditingController titleController;
  final TextEditingController limitController;
  final Category? category;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryDarkColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70.w,
              height: 5.h,
              decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(5.r)),
            ).paddingOnly(top: 10.h, bottom: 20.h),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(Get.context!).unfocus();
                    isShowing.value = true;
                  },
                  child: Container(
                    height: 64,
                    width: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(
                          color: AppColors.whiteColor,
                        )),
                    child: Obx(() => emoji.value.isNotEmpty
                        ? Text(
                            emoji.value,
                            style: TextStyle(fontSize: 15.sp),
                          )
                        : Assets.images.smile
                            .image(color: AppColors.whiteColor.withOpacity(0.2))
                            .paddingAll(12.h)),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: CommonTextField(
                      inputFormatters: [AmountOnlyFormatter()],
                      controller: limitController,
                      onTap: () {
                        isShowing.value = false;
                      },
                      prefixIcon: const Icon(Icons.attach_money_rounded),
                      hintText: Strings.strLimit),
                )
              ],
            ).paddingSymmetric(horizontal: 15.w),
            SizedBox(
              height: 10.h,
            ),
            CommonTextField(
              controller: titleController,
              hintText: Strings.strTitle,
              onTap: () {
                isShowing.value = false;
              },
            ).paddingSymmetric(horizontal: 15.w),
            SizedBox(
              height: 15.h,
            ),
            CommonButton(
              title: Strings.strSubmit,
              onTap: () async {
                if (emoji.isEmpty) {
                  SnackBarUtil.showSnackBar(
                      message: Strings.strSelectCategoryIcon);
                } else if (titleController.text.trim().isEmpty) {
                  SnackBarUtil.showSnackBar(
                      message: Strings.strSelectCategoryTitle);
                } else {
                  if (category != null && index != null) {
                    var cat = homeController.categoryList[index!];
                    cat.emoji = emoji.value;
                    cat.limit = limitController.text.trim().isNotEmpty &&
                            int.tryParse(limitController.text.trim()) != null
                        ? int.parse(limitController.text)
                        : 0;
                    cat.name = titleController.text.trim();
                    homeController.categoryList.refresh();
                    await CategoryRepo.updateCategory(
                        homeController.categoryList);
                    if (Get.isBottomSheetOpen ?? false) {
                      Get.close(1);
                    }
                  } else {
                    var newCat = Category(
                        id: const Uuid().v4(),
                        active: true,
                        emoji: emoji.value,
                        limit: limitController.text.trim().isNotEmpty &&
                                int.tryParse(limitController.text) != null
                            ? int.parse(limitController.text)
                            : 0,
                        name: titleController.text);
                    await CategoryRepo.addCategory(newCat);
                    homeController.categoryList.value =
                        UserRepo.currentUser().category ?? [];
                    if (Get.isBottomSheetOpen ?? false) {
                      Get.close(1);
                    }
                  }
                }
              },
            ).paddingSymmetric(horizontal: 15.w),
            SizedBox(
              height: 20.h,
            ),
            Obx(
              () => CustomEmojiPicker(
                emojiShowing: isShowing.value,
                onEmojiSelect: (e) {
                  isShowing.value = false;
                  emoji.value = e.emoji;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
