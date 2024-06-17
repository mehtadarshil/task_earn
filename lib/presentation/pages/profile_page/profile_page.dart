import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:task_earn/presentation/pages/profile_page/controller/profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  ProfileController get controller => Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}
