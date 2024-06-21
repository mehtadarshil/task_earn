import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/repos/user_repo.dart';

class ProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();

  RxString name = "".obs;
  @override
  void onInit() {
    nameController.text = UserRepo.currentUser().name ?? "";
    name.value = UserRepo.currentUser().name ?? "";
    super.onInit();
  }
}
