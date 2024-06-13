// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? uid;
  String? name;
  String? fcmToken;
  int? coins;

  UserModel({
    this.uid,
    this.name,
    this.fcmToken,
    this.coins,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        name: json["name"],
        fcmToken: json["fcm_token"],
        coins: json["coins"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid ?? "",
        "name": name ?? "",
        "fcm_token": fcmToken ?? "",
        "coins": coins ?? 0,
      };
}
