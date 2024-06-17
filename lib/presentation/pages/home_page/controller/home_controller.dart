import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:task_earn/app/config/ad_unit_id.dart';
import 'package:task_earn/app/repos/user_repo.dart';
import 'package:task_earn/models/user_model.dart';

class HomeController extends GetxController {
  BannerAd? bannerAd;
  RxBool isBannerLoaded = false.obs;
  RxList<Category> categoryList = <Category>[].obs;
  RxString selectedCategory = "".obs;

  TextEditingController amountController = TextEditingController();
  TextEditingController itemController = TextEditingController();

  @override
  void onReady() {
    if (UserRepo.currentUser().category != null &&
        UserRepo.currentUser().category!.isNotEmpty) {
      selectedCategory.value = UserRepo.currentUser().category?.first.id ?? "";
    }
    categoryList.value = UserRepo.currentUser().category ?? [];
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdUnitId.bannerAd,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isBannerLoaded.value = true;
          },
          onAdClicked: (ad) {
            var user = UserRepo.currentUser();
            UserRepo.updateUserCoins(coins: (user.coins ?? 0) + 2);
          },
        ),
        request: const AdRequest())
      ..load();
    super.onReady();
  }
}
