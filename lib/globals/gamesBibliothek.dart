import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parla_italiano/games/classicGame/classicGameHandler.dart';
import 'package:parla_italiano/games/generic/genericGameHandler.dart';
import 'package:parla_italiano/games/memory/memoryGameHandler.dart';
import 'package:parla_italiano/widgets/rulesDialogBuilder.dart' as rulesBuilder;
import 'package:parla_italiano/constants/texts.dart' as ruleTexts;
import 'package:parla_italiano/constants/colors.dart' as colors;

class GamesBibliothek{

  BuildContext context;
  GamesBibliothek(this.context);

  late List<GameInfo> games = _createGames();
  late List<GameInfo> releasedGames = _createReleasedGames();

  
  late Widget classicGameContainerSmall = classicGameContainerConstructionSmall();
  late Widget roundGameContainerSmall = roundGameContainerConstructionSmall();
  late Widget memoryGameContainerSmall = memoryGameContainerConstructionSmall();

  late Widget classicGameContainerBig = classicGameContainerConstructionBig();
  late Widget roundGameContainerBig = roundGameContainerConstructionBig();
  late Widget memoryGameContainerBig = memoryGameContainerConstructionBig();

  Widget classicGameContainerConstructionSmall(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child:Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.sports),
                  ),
                  Expanded(
                    flex: 9,
                    child: Center(
                      child: Text(
                        'Klassisches Spiel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                  ),
                ],
              ),
              flex: 1
            ),
            Expanded(
              child: Text(
                  'Spielt abwechselnd in drei Runden. In jeder Runde müssen innerhalb von 60 Sekunden 10 Wörter beantwortet werden.\nWer von insgesamt 30 Wörtern mehr richtig übersetzt, gewinnt!',
                  style: TextStyle(
                    fontSize: 10
                  )
                ),
              flex: 1
            ),
            Flexible(
              child: Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      backgroundColor: colors.appBarColor,
                      side: BorderSide(
                        color: Colors.black
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        "Regeln",
                        style: TextStyle(
                          fontSize: 12
                        ),
                      ),
                    ),
                    onPressed: () {
                      rulesBuilder.dialogBuilderRulesOutsideOfGame(context, ruleTexts.classicGameRules);
                    },
                  ),
              ),
              flex: 1
            ),
          ],
        )
      )
    );
  }
  Widget roundGameContainerConstructionSmall(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20)
      ),
      child:Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Rundenspiel',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              flex: 1
            ),
            Expanded(
              child: Center(
                child: Text(
                    'Gedulde dich bis zum ersten Update',
                    style: TextStyle(
                      fontSize: 12
                    )
                  ),
              ),
              flex: 2
            ),
          ],
        )
      )
    );
  }
  Widget memoryGameContainerConstructionSmall(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child:Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.memory),
                  ),
                  Expanded(
                    flex: 9,
                    child: Center(
                      child: Text(
                        'Memory',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                  ),
                ],
              ),
              flex: 1
            ),
            Expanded(
              child: Center(
                child: Text(
                    'Spielt nacheinander eine Runde memoroy. Finde die zusammengehörigen Vokabeln in so wenig Zügen wie möglich.\nWer für alle Karten weniger Züge braucht, gewinnt!',
                  style: TextStyle(
                    fontSize: 10
                  )
                  ),
              ),
              flex: 2
            ),
            Flexible(
              child: Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      backgroundColor: colors.appBarColor,
                      side: BorderSide(
                        color: Colors.black
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        "Regeln",
                        style: TextStyle(
                          fontSize: 12
                        ),
                      ),
                    ),
                    onPressed: () {
                      rulesBuilder.dialogBuilderRulesOutsideOfGame(context, ruleTexts.memoryGameRules);
                    },
                  ),
              ),
              flex: 1
            ),
          ],
        )
      )
    );
  }


  Widget classicGameContainerConstructionBig(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30)
      ),
      child:Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.sports),
                  ),
                  Expanded(
                    flex: 9,
                    child: Center(
                      child: Text(
                        'Klassisches Spiel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                  ),
                ],
              ),
              flex: 1
            ),
            Expanded(
              child: Text(
                  'Spielt abwechselnd in drei Runden. In jeder Runde müssen innerhalb von 60 Sekunden 10 Wörter beantwortet werden.\nWer von insgesamt 30 Wörtern mehr richtig übersetzt, gewinnt!',
                  style: TextStyle(
                    fontSize: 12
                  )
                ),
              flex: 1
            ),
            Flexible(
              child: Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      backgroundColor: colors.appBarColor,
                      side: BorderSide(
                        color: Colors.black
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: Text(
                        "Regeln",
                        style: TextStyle(
                          fontSize: 14
                        ),
                      ),
                    ),
                    onPressed: () {
                      rulesBuilder.dialogBuilderRulesOutsideOfGame(context, ruleTexts.classicGameRules);
                    },
                  ),
              ),
              flex: 1
            ),
          ],
        )
      )
    );
  }
  Widget roundGameContainerConstructionBig(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(30)
      ),
      child:Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Rundenspiel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              flex: 1
            ),
            Expanded(
              child: Center(
                child: Text(
                    'Gedulde dich bis zum ersten Update',
                    style: TextStyle(
                      fontSize: 14
                    )
                  ),
              ),
              flex: 2
            ),
          ],
        )
      )
    );
  }
  Widget memoryGameContainerConstructionBig(){
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30)
      ),
      child:Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.memory),
                  ),
                  Expanded(
                    flex: 9,
                    child: Center(
                      child: Text(
                        'Memory',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                  ),
                ],
              ),
              flex: 1
            ),
            Expanded(
              child: Center(
                    child: Text(
                    'Spielt nacheinander eine Runde memoroy. Finde die zusammengehörigen Vokabeln in so wenig Zügen wie möglich.\nWer für alle Karten weniger Züge braucht, gewinnt!',
                  style: TextStyle(
                    fontSize: 12
                  )
                  ),
                  
              ),
              flex: 2
            ),
            Flexible(
              child: Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                      backgroundColor: colors.appBarColor,
                      side: BorderSide(
                        color: Colors.black
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: Text(
                        "Regeln",
                        style: TextStyle(
                          fontSize: 12
                        ),
                      ),
                    ),
                    onPressed: () {
                      rulesBuilder.dialogBuilderRulesOutsideOfGame(context, ruleTexts.memoryGameRules);
                    },
                  ),
              ),
              flex: 1
            ),
          ],
        )
      )
    );
  }


  List<GameInfo> _createGames(){
    List<GameInfo> games = [];
    games.add(GameInfo("Rundenspiel", 1, 30, roundGameContainerBig, roundGameContainerSmall, Icons.backpack, 2, ClassicGameHandler()));
    games.add(GameInfo("Klassisches Spiel", 3, 30, classicGameContainerBig, classicGameContainerSmall, Icons.sports, 0, ClassicGameHandler()));
    games.add(GameInfo("Memory", 1, 30, memoryGameContainerBig, memoryGameContainerSmall,Icons.memory, 1, MemoryGameHandler()));
    return games;
  }

  List<GameInfo> _createReleasedGames(){
    List<GameInfo> games = [];
    games.add(GameInfo("Klassisches Spiel", 3, 30, classicGameContainerBig, classicGameContainerSmall, Icons.sports, 0, ClassicGameHandler()));
    games.add(GameInfo("Memory", 1, 30, memoryGameContainerBig, memoryGameContainerSmall, Icons.memory, 1, MemoryGameHandler()));
    return games;
  }
}

class GamesBibliothekInfo{

  late List<GameInfoCompromised> games;
  late List<GameInfoCompromised> releasedGames;

  GamesBibliothekInfo(){
    games= _createGames();
    releasedGames = _createReleasedGames();

  }

  List<GameInfoCompromised> _createGames(){
    List<GameInfoCompromised> games = [];
    games.add(GameInfoCompromised("Klassisches Spiel", 30, 0, ClassicGameHandler()));
    games.add(GameInfoCompromised("Memory", 10, 1, MemoryGameHandler()));
    return games;
  }

  List<GameInfoCompromised> _createReleasedGames(){
    List<GameInfoCompromised> games = [];
    games.add(GameInfoCompromised("Klassisches Spiel", 30, 0, ClassicGameHandler()));
    games.add(GameInfoCompromised("Memory", 10, 1, MemoryGameHandler()));
    return games;
  }
}

class GameInfo{

  String title;
  int roundNumbers;
  int totalVocabularies;
  //AssetImage img;
  Widget infoBoxBig;
  Widget infoBoxSmall;
  int gameCategory;
  GenericGameHandler handler;
  IconData icon;

  GameInfo(this.title, this.totalVocabularies, this.roundNumbers, this.infoBoxBig, this.infoBoxSmall, this.icon, this.gameCategory, this.handler);

}

class GameInfoCompromised{

  String title;
  int totalVocabularies;
  int gameCategory;
  GenericGameHandler handler;

  GameInfoCompromised(this.title, this.totalVocabularies, this.gameCategory, this.handler);

}

