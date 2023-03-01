import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:pawn_strike/main.dart';
import 'package:pawn_strike/settings.dart';

import 'constants.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);
  @override
  State<MainMenu> createState() => _MainMenuPage();
}

class _MainMenuPage extends State<MainMenu> {
  double fem = 1.3;
  double ffem = 1;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  Future<bool> _showMyDialog() async {
    return (await showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      barrierColor: const Color(0xffEFA617),
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to exit the game ?',
                  textAlign:  TextAlign.center,
                  style:  GoogleFonts.itim (
                    fontSize:  30.4530124664,
                    fontWeight:  FontWeight.w400,
                    height:  0.97,
                    color:  const Color(0xff000000),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text('<<< Exit the Game >>>',style:  GoogleFonts.itim (
                  fontSize:  30.4530124664,
                  fontWeight:  FontWeight.w400,
                  height:  0.97,
                  color:  Colors.redAccent,
                )),
                onPressed: () {
                  SystemNavigator.pop();
                  },
              ),
            ),
            Center(
              child: TextButton(
                child: Text('>>> Back to Game <<<',style:  GoogleFonts.itim (
                    fontSize:  30.4530124664,
                    fontWeight:  FontWeight.w400,
                    height:  0.97,
                    color:  Colors.green[700])),
                onPressed: () {
                  Navigator.of(context).pop();
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

    return WillPopScope(
      onWillPop: () async => _showMyDialog(),
      child: Scaffold(
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
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                  child: Transform(
                    transform: Matrix4.translationValues(100, 20, 0.0),
                    alignment: FractionalOffset.center,
                    child: Container(
                      width:MediaQuery.of(context).size.width * 0.8,
                      height:MediaQuery.of(context).size.height * 0.8,
                      decoration:  const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/scene.png"),
                            fit: BoxFit.contain,
                          )),),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.18),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.8,
                    height: MediaQuery.of(context).size.height*0.2,
                    child: Text(
                      'PAWN STRIKE',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.itim(
                        fontSize: 74 * ffem,
                        fontWeight: FontWeight.w700,
                        height: 0.97 * ffem / fem,
                        color: const Color(0xffEFA617),
                        shadows: <Shadow>[const BoxShadow(
                          offset: Offset(0.0, 0.0),
                          blurRadius: 12.0,
                          spreadRadius: 5,
                          color: Color(0xff000000),
                        ),
                         ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.37,left: MediaQuery.of(context).size.width * 0.05),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      GestureDetector(
                        onTap: () async {
                          buttonSound();
                          Future.delayed(Duration(milliseconds: await getSoundState() ? 300 : 0), ()
                          {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) =>
                                const MyHomePage(level: 1,
                                  leftMoves: 8,
                                  numberOfTotalFlagFound: 0,))));
                          });
                        },
                        child: Container(
                          width:  MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.height * 0.25,
                          alignment: Alignment.center,
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
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02) ,
                            child:
                            Text(
                              'PLAY',
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
                                builder: ((context) => const Settings())));
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
                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                            child:
                            Text(
                              'SETTINGS',
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
              ),

            ],
          ),
        ),
      ),
    );
  }
}
