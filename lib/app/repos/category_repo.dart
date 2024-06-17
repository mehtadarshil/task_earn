import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_earn/app/config/event_tag.dart';
import 'package:task_earn/app/repos/user_repo.dart';
import 'package:task_earn/app/services/app_component.dart';
import 'package:task_earn/models/user_model.dart';

class CategoryRepo {
  static Future updateCategory(List<Category> updatedList) async {
    AppBaseComponent.instance.addEvent(EventTag.categoryUpdate);
    var user = UserRepo.currentUser();
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "category": updatedList
          .map(
            (e) => e.toJson(),
          )
          .toList()
    });
    user.category = updatedList;
    await UserRepo.saveCurrentUser(user: user);
    AppBaseComponent.instance.removeEvent(EventTag.categoryUpdate);
  }

  static Future addCategory(Category model) async {
    AppBaseComponent.instance.addEvent(EventTag.categoryAdd);
    var user = UserRepo.currentUser();
    (user.category ?? []).add(model);
    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "category": (user.category ?? [])
          .map(
            (e) => e.toJson(),
          )
          .toList()
    });
    await UserRepo.saveCurrentUser(user: user);
    AppBaseComponent.instance.removeEvent(EventTag.categoryAdd);
  }
}
