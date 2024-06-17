import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/gen/fonts.gen.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppbar({super.key, this.title, this.actions});

  final String? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      forceMaterialTransparency: true,
      backgroundColor: AppColors.primaryDarkColor,
      leading: (ModalRoute.of(context)?.canPop ?? false)
          ? IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded))
          : null,
      title: title != null
          ? Text(
              title ?? "",
              style: const TextStyle(fontFamily: FontFamily.poppinsBold),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
