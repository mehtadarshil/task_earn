import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:task_earn/app/config/dbkeys.dart';
import 'package:task_earn/models/user_model.dart';

class UserRepo {
  static Future updateUserCoins({required int coins}) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({"coins": coins});
  }

  static void updateCoinsLocally({required int coins}) {
    var user = currentUser();
    user.coins = coins;
    saveCurrentUser(user: user);
  }

  static UserModel currentUser() =>
      UserModel.fromJson(GetStorage().read(Dbkeys.userData));

  static Future saveCurrentUser({required UserModel user}) async =>
      GetStorage().write(Dbkeys.userData, user.toJson());
}
