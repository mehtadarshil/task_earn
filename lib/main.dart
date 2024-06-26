import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:task_earn/app/config/app_colors.dart';
import 'package:task_earn/app/config/dbkeys.dart';
import 'package:task_earn/app/config/strings.dart';
import 'package:task_earn/app/routes/pages.dart';
import 'package:task_earn/app/routes/route_const.dart';
import 'package:task_earn/app/services/app_component.dart';
import 'package:task_earn/firebase_options.dart';
import 'package:task_earn/gen/fonts.gen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // await MobileAds.instance.initialize();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AppBaseComponent.instance.startListen();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: kIsWeb ? const Size(1024, 768) : const Size(360, 690),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            appBarTheme:
                AppBarTheme(backgroundColor: AppColors.primaryDarkColor),
            scaffoldBackgroundColor: AppColors.primaryDarkColor,
            primaryColor: AppColors.primaryLightColor),
        initialRoute: GetStorage().read(Dbkeys.userData) != null
            ? RouteConst.dashboardPage
            : RouteConst.initial,
        getPages: Pages.pages,
        builder: (context, child) {
          return Stack(
            children: [
              child!,
              StreamBuilder<bool>(
                initialData: false,
                stream: AppBaseComponent.instance.progressStream,
                builder: (context, snapshot) {
                  return Obx(
                    () => AppBaseComponent.instance.completed.value
                        ? const Offstage()
                        : Positioned.fill(
                            child: AnimatedOpacity(
                              opacity: snapshot.data! ? 1 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: Container(
                                color: Colors.black.withOpacity(0.3),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryLightColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  );
                },
              ),
              StreamBuilder<bool>(
                initialData: true,
                stream: AppBaseComponent.instance.networkStream,
                builder: (context, snapshot) {
                  return Positioned(
                      top: 0,
                      child: SafeArea(
                        child: AnimatedContainer(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColors.primaryLightColor,
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 0),
                                    blurRadius: 14,
                                    spreadRadius: 0,
                                    color:
                                        AppColors.whiteColor.withOpacity(0.3))
                              ],
                              borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(15))),
                          height: snapshot.data! ? 0 : 100,
                          width: MediaQuery.of(context).size.width,
                          curve: Curves.decelerate,
                          duration: const Duration(seconds: 1),
                          child: Material(
                            type: MaterialType.transparency,
                            child: Text(
                              Strings.strNoInternetAvailable,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  fontFamily: FontFamily.poppinsBold,
                                  color: AppColors.whiteColor,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ));
                },
              )
            ],
          );
        },
      ),
    );
  }
}
