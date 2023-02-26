import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pawn_strike/main.dart';
import 'package:pawn_strike/mainMenu.dart';

import 'constants.dart';

class NextLevel extends StatefulWidget {
  const NextLevel({Key? key, required this.level,required this.flagCount,required this.moves}) : super(key: key);
  final int level;
  final int flagCount;
  final int moves;
  @override
  State<NextLevel> createState() => _NextLevelPage();
}

class _NextLevelPage extends State<NextLevel> {
  double fem = 1.3;
  double ffem = 1;

  RewardedAd? _rewardedAd;
  late int _numInterstitialLoadAttempts;
  int leftMoves = 0;
  bool backToPage = false;
  @override
  void initState() {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    leftMoves = widget.moves;
    super.initState();
    if(widget.flagCount >= 10 && widget.moves <= 40){
      _createRewardedAd();
    }
    else{
      backToPage = true;
    }



  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad rewarded add loaded');
            _rewardedAd = ad;
            _numInterstitialLoadAttempts = 0;
            _rewardedAd!.setImmersiveMode(true);
            _showMyDialog();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error.');
            setState(() {
              backToPage = true;
            });
          },
        ));
  }


  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );
    _rewardedAd!.show(onUserEarnedReward: (_,reward){
      setState(() {
        leftMoves += 10;
        backToPage = true;
      });

    });
    _rewardedAd = null;
    Navigator.of(context).pop();
  }

  Future<bool> _showMyDialog() async {
    return (await showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      barrierColor: Color(0xffEFA617),
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'You ran out of moves do you want to watch add and earn 10 moves?',
                  textAlign:  TextAlign.center,
                  style:  GoogleFonts.itim (
                    fontSize:  30.4530124664,
                    fontWeight:  FontWeight.w400,
                    height:  0.97,
                    color:  Color(0xff000000),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text('<<< Go to add >>>',style:  GoogleFonts.itim (
                  fontSize:  30.4530124664,
                  fontWeight:  FontWeight.w400,
                  height:  0.97,
                  color:  Colors.redAccent,
                )),
                onPressed: () {
                  _showRewardedAd();
                },
              ),
            ),
            Center(
              child: TextButton(
                child: Text('>>> No,thanks <<<',style:  GoogleFonts.itim (
                    fontSize:  30.4530124664,
                    fontWeight:  FontWeight.w400,
                    height:  0.97,
                    color:  Colors.green[700])),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    backToPage = true;
                  });
                },
              ),
            ),
          ],
        );
      },
    )) ?? false;
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
              image: AssetImage("assets/checkerbg.jpg"),
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
                    decoration: BoxDecoration(
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
                  width: 322 * fem,
                  height: 43 * fem,
                  child: Text(
                    'LVL ' + widget.level.toString() + " COMPLETE!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.itim(
                      fontSize: 44 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 0.97 * ffem / fem,
                      color: Color(0xffEFA617),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35,left: MediaQuery.of(context).size.width * 0.11),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 156 * fem,
                  height: 22 * fem,
                  child: Text(
                    'MOVES: ' + leftMoves.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.itim(
                      fontSize: 32 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 0.97 * ffem / fem,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.55,left: MediaQuery.of(context).size.width * 0.11),
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 156 * fem,
                  height: 22 * fem,
                  child: Text(
                    'KINGS: ' + widget.flagCount.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.itim(
                      fontSize: 32 * ffem,
                      fontWeight: FontWeight.w400,
                      height: 0.97 * ffem / fem,
                      color: Color(0xffffffff),
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                for(var i=0;i<4;i++)
                  if((widget.flagCount>=kingsToLevel.keys.toList()[i][0] && widget.flagCount<kingsToLevel.keys.toList()[i][1]) || (widget.flagCount>0 && widget.flagCount<10 && i==0))
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.40,right: MediaQuery.of(context).size.width * 0.08),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                              SizedBox(
                                width: 32 * fem,
                                height: 22 * fem,
                                child: Text(
                                  kingsToLevel.keys.toList()[i][0].toString(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.itim(
                                    fontSize: 32 * ffem,
                                    fontWeight: FontWeight.w400,
                                    height: 0.97 * ffem / fem,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                              ),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Container(
                                    width:  MediaQuery.of(context).size.width * 0.05,
                                    height: MediaQuery.of(context).size.height * 0.08,
                                    decoration:  BoxDecoration (
                                      image:  DecorationImage (
                                        fit:  BoxFit.contain,
                                        image:  AssetImage (
                                            "assets/king.png"
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Container(
                            decoration: BoxDecoration (shape: BoxShape.rectangle, border: Border.all(width: 3.0,color: Colors.white)),
                            child: Row(
                              children: [
                                Container(
                                  width:  MediaQuery.of(context).size.width * 0.05,
                                  height: MediaQuery.of(context).size.height * 0.1,
                                  decoration:  BoxDecoration (
                                    image:  DecorationImage (
                                      fit:  BoxFit.contain,
                                      image:  AssetImage (
                                          characterAssets[kingsToLevel[kingsToLevel.keys.toList()[i]][0]]
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: SizedBox(
                                    width: 60 * fem,
                                    height: 22 * fem,
                                    child: Text(
                                      kingsToLevel[kingsToLevel.keys.toList()[i]][1].toString() + "x" + kingsToLevel[kingsToLevel.keys.toList()[i]][1].toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.itim(
                                        fontSize: 32 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 0.97 * ffem / fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: SizedBox(
                                    width: 42 * fem,
                                    height: 22 * fem,
                                    child: Text(
                                      kingsToLevel[kingsToLevel.keys.toList()[i]][2][0].toString() + '-' + kingsToLevel[kingsToLevel.keys.toList()[i]][2][1].toString(),
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.itim(
                                        fontSize: 32 * ffem,
                                        fontWeight: FontWeight.w400,
                                        height: 0.97 * ffem / fem,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Container(
                                    width:  MediaQuery.of(context).size.width * 0.05,
                                    height: MediaQuery.of(context).size.height * 0.08,
                                    decoration:  BoxDecoration (
                                      image:  DecorationImage (
                                        fit:  BoxFit.contain,
                                        image:  AssetImage (
                                            "assets/king.png"
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.60),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => MainMenu())));
                      },
                      child: Container(
                        width:  MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration:  BoxDecoration (
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
                              color:  Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: ((context) => MyHomePage(level: widget.level+1,numberOfTotalFlagFound: widget.flagCount,leftMoves: leftMoves,))));
                      },
                      child: Container(
                        width:  MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.25,
                        decoration:  BoxDecoration (
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
                            'NEXT LEVEL',
                            textAlign:  TextAlign.center,
                            style:  GoogleFonts.itim (
                              fontSize:  30.4530124664*ffem,
                              fontWeight:  FontWeight.w400,
                              height:  0.97*ffem/fem,
                              color:  Color(0xffffffff),
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
    ) : Container();
  }
}
