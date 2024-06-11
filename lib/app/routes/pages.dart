import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_earn/app/routes/bindings/login_bindings.dart';
import 'package:task_earn/app/routes/route_const.dart';
import 'package:task_earn/app/services/app_component.dart';
import 'package:task_earn/presentation/pages/intro_page/intro_page.dart';
import 'package:task_earn/presentation/pages/login_page/login_page.dart';

class Pages {
  static final List<GetPage<dynamic>> pages = [
    getPage(
      name: RouteConst.initial,
      page: const IntroPage(),
    ),
    getPage(
        name: RouteConst.loginPage,
        page: const LoginPage(),
        binding: LoginBindings())
  ];
}

GetPage<dynamic> getPage(
    {required String name, required Widget page, Bindings? binding}) {
  return GetPage(
      name: name,
      page: () => PopScope(
          canPop: AppBaseComponent.instance.completed.value, child: page),
      binding: binding,
      transition: Transition.cupertino);
}
