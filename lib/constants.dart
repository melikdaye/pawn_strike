import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
enum Character{
  pawn,
  bishop,
  knight,
  rook,
  queen,
}
Map kingsToLevel = Map<List<int>,List<dynamic>>.from({[10,20]:[Character.bishop,4,[2,4]],[20,30]:[Character.knight,5,[3,5]],[30,40]:[Character.rook,5,[4,6]],[40,80]:[Character.queen,6,[4,6]]});
Map characterAssets = Map<Character,String>.from({Character.knight:"assets/knight.png",Character.bishop:"assets/bishop.png",Character.pawn:"assets/pawn.png",Character.queen:"assets/queen.png",Character.rook:"assets/rook.png"});

int getGridCount(int numberOfFlags){
  if(numberOfFlags < 10){
    return 3;
  }
  else{
    for(var i=0; i<kingsToLevel.keys.toList().length;i++){
      if(numberOfFlags>=kingsToLevel.keys.toList()[i][0] && numberOfFlags<kingsToLevel.keys.toList()[i][1]){
        return kingsToLevel[kingsToLevel.keys.toList()[i]][1];
      }
    }
  }
  return 3;
}

Character getCharacterType(int numberOfFlags){
  for(var i=0; i<kingsToLevel.keys.toList().length;i++){
    if(numberOfFlags>=kingsToLevel.keys.toList()[i][0] && numberOfFlags<kingsToLevel.keys.toList()[i][1]){
      return kingsToLevel[kingsToLevel.keys.toList()[i]][0];
    }
  }
  return Character.pawn;
}

int getMinKingCount(int numberOfFlags){
  for(var i=0; i<kingsToLevel.keys.toList().length;i++){
    if(numberOfFlags>=kingsToLevel.keys.toList()[i][0] && numberOfFlags<kingsToLevel.keys.toList()[i][1]){
      return kingsToLevel[kingsToLevel.keys.toList()[i]][2][0];
    }
  }
  return 1;
}

int getMaxKingCount(int numberOfFlags){
  for(var i=0; i<kingsToLevel.keys.toList().length;i++){
    if(numberOfFlags>=kingsToLevel.keys.toList()[i][0] && numberOfFlags<kingsToLevel.keys.toList()[i][1]){
      return kingsToLevel[kingsToLevel.keys.toList()[i]][2][1];
    }
  }
  return 2;
}

Future<int> getHighestScore()async {
  var sharedPreferences = await SharedPreferences.getInstance();
  int highestScore = sharedPreferences.getInt("kings") ?? 0;
  return highestScore;
}


Future<void> setHighestScore(int score)async {
  var sharedPreferences = await SharedPreferences.getInstance();
  int highestScore = await getHighestScore();

  if(highestScore < score) {
      sharedPreferences.setInt("kings", score);
  }
}

Future<bool> setSoundState(bool state)async {
  var sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setBool("sound", state);
  return getSoundState();
}

Future<bool> getSoundState()async {
  var sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getBool("sound") ?? true;
}

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return '';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2020423994553520/8221426712";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-2020423994553520/6916369315";
    } else if (Platform.isIOS) {
      return "";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}

void moveSound() async {
  bool soundState = await getSoundState();
  if(soundState) {
    final player = AudioPlayer();
    return await player.play(AssetSource('move.mp3'));
  }

}

void startSound() async {
  bool soundState = await getSoundState();
  if(soundState) {
    final player = AudioPlayer();
    return await player.play(AssetSource('gameStart.mp3'));
  }
}

void nextSound() async {
  bool soundState = await getSoundState();
  if(soundState) {
    final player = AudioPlayer();
    return await player.play(AssetSource('nextLevel.mp3'));
  }
}

void gameOverSound() async {
  bool soundState = await getSoundState();
  if(soundState) {
    final player = AudioPlayer();
    return await player.play(AssetSource('gameOver.mp3'));
  }
}
void foundKingSound() async {
  bool soundState = await getSoundState();
  if(soundState) {
    final player = AudioPlayer();
    return await player.play(AssetSource('knockDown.mp3'));
  }
}