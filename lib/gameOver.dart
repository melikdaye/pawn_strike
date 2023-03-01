import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pawn_strike/constants.dart';
import 'package:pawn_strike/main.dart';

import 'mainMenu.dart';

class GameOver extends StatefulWidget {
  const GameOver({Key? key, required this.level,required this.flagCount}) : super(key: key);
  final int level;
  final int flagCount;

  @override
  State<GameOver> createState() => _GameOverPage();
}

class _GameOverPage extends State<GameOver> {
  double fem = 1.3;
  double ffem = 1;
  InterstitialAd? _interstitialAd;
  bool backToPage = false;
  @override
  void initState() {

    _createInterstitialAd();
    gameOverSound();
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    setHighestScore(widget.flagCount);

  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            if (kDebugMode) {
              print('$ad loaded');
            }
            _interstitialAd = ad;
            _interstitialAd!.setImmersiveMode(true);
            _showInterstitialAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            if (kDebugMode) {
              print('InterstitialAd failed to load: $error.');
            }
            setState(() {
              backToPage = true;
            });
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      if (kDebugMode) {
        print('Warning: attempt to show interstitial before loaded.');
      }
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        if (kDebugMode) {
          print('$ad onAdDismissedFullScreenContent.');
        }
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        if (kDebugMode) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
        }
        ad.dispose();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
    setState(() {
      backToPage = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return backToPage ? WillPopScope(
        onWillPop: () async => false,
    child:Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Color(0xffffffff),
            image: DecorationImage(
              image: AssetImage("assets/checkerbg.jpeg"),
              fit: BoxFit.fill,
            )),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              left: 0,
              child: Align(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.18,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff000000),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.13),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 222 * fem,
                    height: 43 * fem,
                    child: Text(
                      'GAME OVER!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.itim(
                        fontSize: 44 * ffem,
                        fontWeight: FontWeight.w400,
                        height: 0.97 * ffem / fem,
                        color: const Color(0xffEFA617),
                      ),
                    ),
                  ),
                ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 136 * fem,
                  height: 22 * fem,
                  child: Text(
                    'LEVELS: ' + widget.level.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.itim(
                      fontSize: 32 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 0.97 * ffem / fem,
                      color: const Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.55),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 136 * fem,
                  height: 22 * fem,
                  child: Text(
                    'KINGS: ' + widget.flagCount.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.itim(
                      fontSize: 32 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 0.97 * ffem / fem,
                      color: const Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Flex(
                    direction: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      GestureDetector(
                        onTap: () async {
                          buttonSound();
                          Future.delayed(Duration(milliseconds: await getSoundState() ? 300 : 0), ()
                          {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => const MainMenu())));
                          });
                        },
                        child: Container(
                          width:  MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration:  const BoxDecoration (
                            image:  DecorationImage (
                              fit:  BoxFit.fill,
                              image:  AssetImage (
                                  "assets/button.png"
                              ),
                            ),
                          ),
                          child:
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1,left: MediaQuery.of(context).size.width * 0.01),
                            child:
                            Text(
                              'MAIN MENU',
                              textAlign:  TextAlign.center,
                              style:  GoogleFonts.itim (
                                fontSize:  30.4530124664*ffem,
                                fontWeight:  FontWeight.w400,
                                height:  0.97*ffem/fem,
                                color:  const Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                            buttonSound();
                            Future.delayed(Duration(milliseconds: await getSoundState() ? 300 : 0), ()
                            {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => const MyHomePage(
                                    level: 1,
                                    leftMoves: 8,
                                    numberOfTotalFlagFound: 0,))));
                            });
                        },
                        child: Container(
                          width:  MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.25,
                          decoration:  const BoxDecoration (
                            image:  DecorationImage (
                              fit:  BoxFit.fill,
                              image:  AssetImage (
                                  "assets/button.png"
                              ),
                            ),
                          ),
                          child:
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1,left: MediaQuery.of(context).size.width * 0.01),
                            child:
                            Text(
                              'PLAY AGAIN',
                              textAlign:  TextAlign.center,
                              style:  GoogleFonts.itim (
                                fontSize:  30.4530124664*ffem,
                                fontWeight:  FontWeight.w400,
                                height:  0.97*ffem/fem,
                                color:  const Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),


            )
          ],
        ),
      ),
    ),
    ): Container();
  }
}
