// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? uid;
  String? name;
  int? coins;
  List<Category>? category;

  UserModel({
    this.uid,
    this.name,
    this.coins,
    this.category,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        name: json["name"],
        coins: json["coins"],
        category: json["category"] == null
            ? []
            : List<Category>.from(
                json["category"]!.map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "coins": coins,
        "category": category == null
            ? []
            : List<dynamic>.from(category!.map((x) => x.toJson())),
      };
}

class Category {
  String? id;
  String? emoji;
  String? name;
  int? limit;
  bool? active;

  Category({this.id, this.emoji, this.name, this.limit, this.active});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        emoji: json["emoji"],
        name: json["name"],
        limit: json["limit"] ?? 0,
        active: json["active"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "emoji": emoji,
        "name": name,
        "limit": limit ?? 0,
        "active": active ?? true
      };
}
