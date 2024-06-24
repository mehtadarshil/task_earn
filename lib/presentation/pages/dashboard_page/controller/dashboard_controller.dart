import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:task_earn/app/config/ad_unit_id.dart';
import 'package:task_earn/app/repos/user_repo.dart';
import 'package:task_earn/app/services/logger.dart';

class DashboardController extends GetxController {
  RxInt pageIndex = 0.obs;

  PageController pageController = PageController();

  bool isScroling = false;

  @override
  void onInit() {
    pageIndex.listen(
      (page) async {
        isScroling = true;
        await pageController.animateToPage(page,
            duration: const Duration(milliseconds: 400), curve: Curves.linear);
        isScroling = false;
      },
    );
    super.onInit();
  }

  @override
  void onReady() {
    // showVideoAd();
    super.onReady();
  }

  void showVideoAd() {
    RewardedAd.load(
        adUnitId: AdUnitId.videoAd,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            Logger.prints("Ad loaded");
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                Logger.prints("Ad showed");
              },
              onAdImpression: (ad) {
                // var user = UserRepo.currentUser();
                // UserRepo.updateUserCoins(coins: (user.coins ?? 0) + 3);
              },
              onAdClicked: (ad) {
                var user = UserRepo.currentUser();
                UserRepo.updateUserCoins(coins: (user.coins ?? 0) + 10);
              },
            );
            ad.show(
              onUserEarnedReward: (ad, reward) {
                var user = UserRepo.currentUser();
                UserRepo.updateUserCoins(coins: (user.coins ?? 0) + 10);
              },
            );
          },
          onAdFailedToLoad: (error) {
            Logger.prints("Error ${error.message}");
          },
        ));
  }
}
