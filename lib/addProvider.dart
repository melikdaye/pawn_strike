import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'constants.dart';

class AddManagement extends ChangeNotifier {


  RewardedAd? rewardedAd;
  InterstitialAd? interstitialAd;

  createInterstitialAd(){

    if(interstitialAd == null){
        _createInterstitialAd();
    }

    notifyListeners();
  }

  createRewardedAd(){

    if(rewardedAd == null){
      _createRewardedAd();
    }

    notifyListeners();
  }

  disposeInterstitialAd(){
    interstitialAd = null;
    notifyListeners();
  }

  disposeRewardedAd(){
    rewardedAd = null;
    notifyListeners();
  }

  void _createInterstitialAd() async{
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            if (kDebugMode) {
              print('$ad loaded');
            }
            interstitialAd = ad;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            if (kDebugMode) {
              print('InterstitialAd failed to load: $error.');
            }
          },
        ));
  }

  void _createRewardedAd() {

    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            if (kDebugMode) {
              print('$ad rewarded add loaded');
            }
            rewardedAd = ad;
            rewardedAd!.setImmersiveMode(true);

          },
          onAdFailedToLoad: (LoadAdError error) {
            if (kDebugMode) {
              print('RewardedAd failed to load: $error.');
            }
          },
        ));
  }

}