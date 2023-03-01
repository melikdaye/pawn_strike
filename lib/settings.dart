import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:pawn_strike/constants.dart';


class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  State<Settings> createState() => _SettingsPage();
}

class _SettingsPage extends State<Settings> {
  double fem = 1.3;
  double ffem = 1;
  bool soundStatus = false;
  int highestScore = 0;
  @override
  void initState() {

    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    getSoundState().then((value) => setState((){
      soundStatus = value;
    }));
    getHighestScore().then((value) => setState((){
      highestScore = value;
    }));
  }

  void toggleSound() async{
    bool newStatus = await setSoundState(!soundStatus);
    setState(() {
        soundStatus = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                    'SETTINGS',
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
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.30,left: MediaQuery.of(context).size.width * 0.2),
              child: Align(
                alignment: Alignment.topCenter,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                      child: SizedBox(
                        width: 136 * fem,
                        height: 22 * fem,
                        child: Text(
                          'SOUND',
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
                    GestureDetector(
                      onTap: () async {
                          buttonSound();
                          Future.delayed(Duration(milliseconds: await getSoundState() ? 300 : 0), ()
                          {
                            toggleSound();
                          });
                      },
                      child: Container(
                        width:  MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.2,
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
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
                          child:
                          Text(
                            soundStatus ? "ON" : "OFF",
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
            Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.18),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.55),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: SizedBox(
                        width: 156 * fem,
                        height: 42 * fem,
                        child: Text(
                          'HIGHEST SCORE: ',
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
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.58),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width:  MediaQuery.of(context).size.width * 0.27,
                        height: 42 * fem,
                        child: Text(
                          highestScore.toString(),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
