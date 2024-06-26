import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/config/event_tag.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/repos/user_repo.dart';
import 'package:task_earn/app/services/app_component.dart';
import 'package:task_earn/app/services/snackbar_util.dart';

class ProfileController extends GetxController {
  RxString name = "".obs;
  @override
  void onInit() {
    name.value = UserRepo.currentUser().name ?? "";
    super.onInit();
  }

  Future updateUserName({required String updatedName}) async {
    if (updatedName.trim().isEmpty) {
      SnackBarUtil.showSnackBar(message: Strings.strEnterProperName);
    } else {
      AppBaseComponent.instance.addEvent(EventTag.updateUserName);
      var user = UserRepo.currentUser();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({"name": updatedName});
      user.name = updatedName;
      await UserRepo.saveCurrentUser(user: user);
      name.value = updatedName;
      AppBaseComponent.instance.removeEvent(EventTag.updateUserName);
    }
  }
}
