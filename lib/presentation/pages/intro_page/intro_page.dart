import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/routes/route_const.dart';
import 'package:task_earn/gen/assets.gen.dart';
import 'package:task_earn/gen/fonts.gen.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late RiveAnimationController _btnController;
  @override
  void initState() {
    _btnController = OneShotAnimation('active', autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          RiveAnimation.asset(
            Assets.animations.shapes,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
              child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: const SizedBox(),
          )),
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  Strings.strIntroTile,
                  style: TextStyle(
                      fontFamily: FontFamily.poppinsBold, fontSize: 34),
                ).paddingOnly(top: 25, left: 10, right: 10),
                const Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () {
                    if (!_btnController.isActive) {
                      Future.delayed(const Duration(seconds: 1), () {
                        Get.offAllNamed(RouteConst.loginPage);
                      });
                    }
                    _btnController.isActive = true;
                  },
                  child: Hero(
                    tag: Strings.strLogin,
                    child: SizedBox(
                      height: 64,
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Stack(
                        children: [
                          RiveAnimation.asset(
                            Assets.animations.button,
                            controllers: [_btnController],
                          ),
                          Material(
                            type: MaterialType.transparency,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, left: 15),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(Strings.strLetStart,
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontFamily:
                                                    FontFamily.poppinsBold,
                                                color:
                                                    AppColors.primaryDarkColor))
                                        .paddingOnly(right: 5),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: AppColors.primaryDarkColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
