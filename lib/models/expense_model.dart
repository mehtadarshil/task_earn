// To parse this JSON data, do
//
//     final expenseModel = expenseModelFromJson(jsonString);

import 'dart:convert';

ExpenseModel expenseModelFromJson(String str) =>
    ExpenseModel.fromJson(json.decode(str));

String expenseModelToJson(ExpenseModel data) => json.encode(data.toJson());

class ExpenseModel {
  String? id;
  String? uid;
  double? amount;
  String? item;
  String? categoryId;
  dynamic createdAt;

  ExpenseModel({
    this.id,
    this.uid,
    this.amount,
    this.item,
    this.categoryId,
    this.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json["id"],
        uid: json["uid"],
        amount: json["amount"]?.toDouble(),
        item: json["item"],
        categoryId: json["categoryId"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uid": uid,
        "amount": amount,
        "item": item,
        "categoryId": categoryId,
        "createdAt": createdAt,
      };
}
