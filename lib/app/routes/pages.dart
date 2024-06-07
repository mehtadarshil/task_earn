import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/services/app_component.dart';

class Pages {
  static final pages = [];

  static GetPage<dynamic> getPage(
      {required String name, required Widget page, Bindings? binding}) {
    return GetPage(
        name: name,
        page: () => PopScope(
            canPop: AppBaseComponent.instance.completed.value, child: page),
        binding: binding,
        transition: Transition.cupertino);
  }
}
