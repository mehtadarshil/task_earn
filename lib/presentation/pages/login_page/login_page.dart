import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/services/input_formator.dart';
import 'package:task_earn/gen/assets.gen.dart';
import 'package:task_earn/gen/fonts.gen.dart';
import 'package:task_earn/presentation/common_widgets/common_text_field.dart';
import 'package:task_earn/presentation/pages/login_page/controller/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(25)),
                child: Assets.images.banknotesWorld.image(
                    height: 220, width: double.infinity, fit: BoxFit.cover)),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.whiteColor, width: 1.5)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.strLogin,
                    style: TextStyle(
                        fontFamily: FontFamily.poppinsBold,
                        fontSize: 22,
                        color: AppColors.whiteColor),
                  ).paddingOnly(left: 5, bottom: 15),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            useSafeArea: true,
                            showPhoneCode: true,
                            countryListTheme: CountryListThemeData(
                                inputDecoration: InputDecoration(
                                    hintText: Strings.strSearchCountry,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.primaryLightColor,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primaryLightColor),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primaryLightColor),
                                        borderRadius:
                                            BorderRadius.circular(25)))),
                            onSelect: (value) {
                              controller.chnageCountryCode(value.phoneCode);
                            },
                          );
                        },
                        child: Container(
                          height: 64,
                          width: 64,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(right: 13),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: AppColors.whiteColor,
                              )),
                          child: Obx(
                            () => Text(
                              controller.countryCode.value,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: FontFamily.poppinsSemiBold),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CommonTextField(
                          controller: controller.mobileNumberController,
                          hintText: Strings.strMobileNumber,
                          inputFormatters: [DigitOnlyFormatter()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!controller.btnController.isActive) {
                        Future.delayed(const Duration(seconds: 1), () {
                          controller.onLogin();
                        });
                      }
                      controller.btnController.isActive = true;
                    },
                    child: Hero(
                      tag: Strings.strLogin,
                      child: SizedBox(
                        height: 64,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Stack(
                          children: [
                            RiveAnimation.asset(
                              Assets.animations.button,
                              controllers: [controller.btnController],
                            ),
                            Material(
                              type: MaterialType.transparency,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, left: 15),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(Strings.strLogin,
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily:
                                                      FontFamily.poppinsBold,
                                                  color: AppColors
                                                      .primaryDarkColor))
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
