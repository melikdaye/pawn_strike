import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:pawn_strike/gameOver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:core';
import 'package:pawn_strike/constants.dart';
import 'package:pawn_strike/mainMenu.dart';
import 'package:pawn_strike/nextLevel.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      title: 'Pawn Strike',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MainMenu(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.level,required this.leftMoves,required this.numberOfTotalFlagFound}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final int level;
  final int leftMoves;
  final int numberOfTotalFlagFound;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  List<Color> colorStates = List<Color>.filled(9, Colors.transparent);
  List<bool> flagStates = List<bool>.filled(9,false);
  List<bool> selectionState = List<bool>.filled(9,false);
  int puckIndex = 0;
  int leftMoves = 8;
  int randomFlagCount = 0;
  int foundFlags = 0;
  int numberOfTurns = 0;
  int level = 1;
  int gridRow = 3;
  int minKingCount = 1;
  int maxKingCount = 3;
  int numberOfTotalFlagFound = 0;
  Character currentCharacter = Character.pawn;
  Map borders = Map<dynamic,dynamic>.from({0:[1,3],1:[0,2,4],2:[1,5],3:[0,4,6],4:[1,3,5,7],5:[2,4,8],6:[3,7],7:[4,6,8],8:[5,7]});
  Random random = Random();
  int nearestDistance = 0;

  @override
  void initState() {
    super.initState();
    leftMoves = widget.leftMoves;
    level = widget.level;
    numberOfTotalFlagFound = widget.numberOfTotalFlagFound;
    gridRow = getGridCount(numberOfTotalFlagFound);
    currentCharacter = getCharacterType(numberOfTotalFlagFound);
    minKingCount = getMinKingCount(numberOfTotalFlagFound);
    maxKingCount = getMaxKingCount(numberOfTotalFlagFound);
    resetGame();
    startSound();
  }

  bool knightMovement(int index){

      bool validMove = false;
      List<int> x = [2, 1, -1, -2, -2, -1, 1, 2];
      List<int> y = [1, 2, 2, 1, -1, -2, -2, -1];
      int px,py;
      int sIndexX = index ~/ gridRow;
      int sIndexY = index % gridRow;
      for(var i=0; i<8; i++) {
        px = puckIndex ~/ gridRow + x[i];
        py = puckIndex % gridRow + y[i];
        if (px >= 0 && py >= 0 && px < gridRow &&
            py < gridRow && px == sIndexX && py == sIndexY) {
            validMove = true;
            break;
        }
      }
      return validMove;
  }
  bool pawnMovement(int index){

    bool validMove = false;
    List<int> x = [0,0, 1,-1];
    List<int> y = [1,-1, 0,0];
    int px,py;
    int sIndexX = index ~/ gridRow;
    int sIndexY = index % gridRow;
    for(var i=0; i<4; i++) {
      px = puckIndex ~/ gridRow + x[i];
      py = puckIndex % gridRow + y[i];
      if (px >= 0 && py >= 0 && px < gridRow &&
          py < gridRow && px == sIndexX && py == sIndexY) {
        validMove = true;
        break;
      }
    }
    return validMove;
  }

  bool bishopMovement(int index){

    bool validMove = false;
    int px,py;
    int sIndexX = index ~/ gridRow;
    int sIndexY = index % gridRow;
    px = puckIndex ~/ gridRow;
    py = puckIndex % gridRow;
    int dx = (sIndexX - px).abs();
    int dy = (sIndexY - py).abs();
    if(dx == dy && dx > 0){
      validMove = true;
    }


    return validMove;
  }

  void resetGame(){
    colorStates = List<Color>.filled(gridRow*gridRow, Colors.transparent);
    flagStates = List<bool>.filled(gridRow*gridRow,false);
    selectionState = List<bool>.filled(gridRow*gridRow,false);
    randomFlagCount = minKingCount + random.nextInt(maxKingCount);
    List<int> randomIndex = [];
    puckIndex = random.nextInt(gridRow*gridRow);
    for(var i=0; i<randomFlagCount; i++){
      int index = random.nextInt(gridRow*gridRow);
      while (randomIndex.contains(index) || puckIndex == index){
          index = random.nextInt(gridRow*gridRow);
      }

      flagStates[index] = true;
      randomIndex.add(index);
    }

    foundFlags = 0;
    numberOfTurns = 0;
    calculateProximity();
  }

  bool nearPuck(int index){

    if (currentCharacter == Character.knight){
       return pawnMovement(index)  || knightMovement(index);
    }
    else if(currentCharacter == Character.pawn){
      return pawnMovement(index);
    }
    else if(currentCharacter == Character.bishop){
      return pawnMovement(index) || bishopMovement(index);
    }
    else if(currentCharacter == Character.rook){
      return !bishopMovement(index);
    }
    else if(currentCharacter == Character.queen){
      return (!bishopMovement(index) || bishopMovement(index)) && !knightMovement(index);
    }
    else {
      if (borders[puckIndex].contains(index)) {
        return true;
      }
    }

    return false;
  }

  void calculateProximity(){

      int px = puckIndex ~/ gridRow;
      int py = puckIndex % gridRow;
      List<int> coords = [];
      for(var i=0; i < gridRow*gridRow; i++){
        if(flagStates[i] && !selectionState[i]){
          int sIndexX = i ~/ gridRow;
          int sIndexY = i % gridRow;
          int dx = (sIndexX - px)*(sIndexX - px);
          int dy = (sIndexY - py)*(sIndexY - py);
          int distance = sqrt(dx + dy).toInt();
          coords.add(distance);
        }
      }
      if (kDebugMode) {
        print(coords);
      }
      if(coords.isNotEmpty) {
        setState(() {
          nearestDistance = coords.reduce(min);
        });
      }
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
                  'Are you sure you want to return the main menu ?',
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
                child: Text('Go to Main Menu ==>',style:  GoogleFonts.itim (
                  fontSize:  30.4530124664,
                  fontWeight:  FontWeight.w400,
                  height:  0.97,
                  color:  Colors.redAccent,
                )),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const MainMenu())));                },
              ),
            ),
            Center(
              child: TextButton(
                child: Text('<== Back to Game',style:  GoogleFonts.itim (
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
    return leftMoves > 0 ?
    WillPopScope(
        onWillPop: () async => _showMyDialog(),
        child:
    Container(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            color: Color(0xffffffff),
            image: DecorationImage(
              image: AssetImage("assets/gray-wall.jpg"),
              fit: BoxFit.fill,
            )),
        child: Stack(
          clipBehavior: Clip.none,
      children:[
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1,left: MediaQuery.of(context).size.width * 0.08),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 200,
              height: 30,
              child: Text(
                'MOVES: ' + leftMoves.toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.itim(
                  fontSize: 32 ,
                  fontWeight: FontWeight.w400,
                  height: 0.97,
                  color: const Color(0xffffffff),
                  decoration: TextDecoration.none
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1,left: MediaQuery.of(context).size.width * 0.08),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: 150,
              height: 30,
              child: Text(
                'LVL ' + level.toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.itim(
                  fontSize: 32 ,
                  fontWeight: FontWeight.w400,
                  height: 0.97,
                  color: const Color(0xffffffff),
                  decoration: TextDecoration.none
                ),
              ),
            ),
          ),
        ),
       Padding(
         padding:EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1,right: MediaQuery.of(context).size.width * 0.08),
         child: Align(
           alignment: Alignment.topRight,
           child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                for(var i = 0;i<randomFlagCount;i++)
                  i >= foundFlags ?
                  Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/king.png"),
                          fit: BoxFit.fill,
                        ),
                      ))
                : const SizedBox(),
              ],
            ),
         ),
       ),

        if(currentCharacter.index  >= Character.bishop.index)
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1,right:  MediaQuery.of(context).size.width * 0.07),
          child: Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: 200,
              height: 30,
              child: Text(
                'PROXIMITY: ' + nearestDistance.toString(),
                textAlign: TextAlign.left,
                style: GoogleFonts.itim(
                  fontSize: 32 ,
                  fontWeight: FontWeight.w400,
                  height: 0.97,
                  color: const Color(0xffffffff),
                  decoration: TextDecoration.none
                ),
              ),
            ),
          ),
        ),


        Positioned(
          top: 0,
          height: MediaQuery.of(context).size.height * 1.1,
          child: Transform(
            transform: Matrix4(
              1,0,0,0,
              0,1,0,0,
              0,0,1,0,
              MediaQuery.of(context).size.width * 0.22,0,0,0.9,
            )..rotateX(1.2)..rotateY(0)..rotateZ(0.8),
            alignment: FractionalOffset.center,
            child: Container(
              clipBehavior: Clip.none,
              width: MediaQuery.of(context).size.width * 0.5,
              child: GridView.builder(

                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: gridRow),

                    itemBuilder: (_,index) => GestureDetector(
                      child: Container(
                            child: selectionState[index] && flagStates[index] && index!=puckIndex ? Transform(
                                    transform:
                                    Matrix4(
                                      1,0,0,0,
                                      0,1,0,0,
                                      0,0,1,0,
                                      0,0,0,1.3,
                                    )..rotateZ(-0.8),
                                    alignment: FractionalOffset.center,child: Image.asset("assets/king.png")) : index == puckIndex ?
                                Transform(transform:
                                Matrix4(
                                  1,0,0,0,
                                  0,1,0,0,
                                  0,0,1,0,
                                  0,0,0,1.3,
                                )..rotateZ(-0.8),
                                    alignment: FractionalOffset.center,child: Image.asset(characterAssets[currentCharacter])):const SizedBox(),

                          decoration: BoxDecoration(shape: BoxShape.rectangle, border: Border.all(width: 3.0,color: Colors.white),color: colorStates[index],
                          )),
                      onTap: () {
                        if(nearPuck(index) && leftMoves > 0) {
                          moveSound();
                          if (!selectionState[index]) {
                            if (flagStates[index]) {
                              setState(() {
                                foundKingSound();
                                colorStates[index] = const Color(0xff0E6C39);
                                foundFlags++;
                                numberOfTotalFlagFound++;
                                if (foundFlags == randomFlagCount) {
                                  leftMoves += ((currentCharacter.index+1)*16 - numberOfTurns);
                                  setHighestScore(numberOfTotalFlagFound);
                                  if(leftMoves>0) {
                                    nextSound();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: ((context) =>
                                            NextLevel(level: level,
                                              moves: leftMoves,
                                              flagCount: numberOfTotalFlagFound,))));
                                  }
                                  else{
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: ((context) =>
                                            GameOver(level: level,flagCount: numberOfTotalFlagFound))));

                                  }
                                }
                              });
                            }
                            else {
                              setState(() {
                                colorStates[index] = const Color(0xffe76129);
                                leftMoves-= (currentCharacter.index+1)*(currentCharacter.index+1);
                              });
                            }

                            setState(() {
                              selectionState[index] = true;
                              puckIndex = index;
                              numberOfTurns++;
                            });
                          }
                          else{

                            setState(() {
                              numberOfTurns++;
                              puckIndex = index;
                              leftMoves-= (currentCharacter.index+1)*(currentCharacter.index+1);
                            });
                          }
                          if(currentCharacter.index >= Character.bishop.index){
                            calculateProximity();
                          }
                        }
                      },
                    ),
                    itemCount: gridRow*gridRow,
                  ),
            ),
          ),
        ),
      ]
        )
    )):  GameOver(level: level,flagCount: numberOfTotalFlagFound);
  }
}
