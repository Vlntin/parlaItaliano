import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parla_italiano/games/frontendGame.dart';
import 'package:parla_italiano/games/memory/memoryGame.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/navigationBar.dart';
import 'package:parla_italiano/globals/globalData.dart' as UserDataGlobals;
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/screens/oneVsOneScreen.dart';
import 'package:parla_italiano/screens/start_screen.dart';

import 'package:confetti/confetti.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:parla_italiano/constants/colors.dart' as globalColors;

class MemoryScreen extends StatefulWidget {

  FrontGame game;
  MemoryScreen({super.key, required this.game});


  @override
  _MemoryScreenState createState() => _MemoryScreenState(frontgame: game, game: game.getGame() as MemoryGame);
}

class _MemoryScreenState extends State<MemoryScreen> {

  FrontGame frontgame;
  MemoryGame game;
  int currentPageIndex = 2;
  int selectedIndexFirstCard = -1;
  int selectedIndexSecondCard = -1;
  List<String> cardTexts = [];
  bool isGameFinished = false;
  bool isPlayerFinished = false;

  late Scaffold bigScreen = getBigScreen();
  late Scaffold smartphoneScreen = getSmartphoneScreen();


  _MemoryScreenState({required this.frontgame, required this.game}){
    cardTexts = game.getCardTexts();
  }

  late ConfettiController _controllerCenter;

  @override
  void initState() {
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
          builder: ((context, constraints) {
            if (constraints.maxWidth > 500) {
              return bigScreen;
            } else {
              return smartphoneScreen;
            }
          })
        );
  }

  Scaffold getSmartphoneScreen(){
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(currentPageIndex),
      appBar: CustomAppBarSmartphone(actualPageName: 'Memory'),
      body: Center(
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.05,
            shouldLoop: false,
            colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
            ],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Runde ' + game.roundNumber.toString(),
                          style: TextStyle(
                            fontSize: 14
                          ),
                          textAlign: TextAlign.center,
                        ),
                        flex: 1
                      ),
                      Expanded(
                        child: Text(
                          'Punkte: ' + game.getFinishedVocabularies().length.toString(),
                          style: TextStyle(
                            fontSize: 14
                          ),
                          textAlign: TextAlign.center,
                        ),
                        flex: 1
                      )
                    ]
                  ),
                  _getMainContainerSmartphone()
                ],
              )
            )
          )
        )
    );
  }

  Scaffold getBigScreen(){
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(currentPageIndex),
      appBar: CustomAppBar(), 
      body: Center(
        child: ConfettiWidget(
          confettiController: _controllerCenter,
          blastDirectionality: BlastDirectionality.explosive,
          particleDrag: 0.05,
          emissionFrequency: 0.05,
          numberOfParticles: 50,
          gravity: 0.05,
          shouldLoop: false,
          colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
          ],
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 40),
            child: Column(
              children: [
                Expanded(
                  child: Text(
                    'Memory gegen ${game.actualPlayer.userID == game.player1.userID ? game.player2.username : game.player1.username}',
                    style: TextStyle(
                      fontSize: 26
                    ),
                    textAlign: TextAlign.center,
                  ),
                  flex: 2
                ),
                Expanded(
                  flex: 12,
                  child: Container(
                    decoration: BoxDecoration(
                      color: globalColors.appGreen
                    ),
                    child: _getMainContainer()
                  )
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Runde ' + game.roundNumber.toString(),
                          style: TextStyle(
                            fontSize: 20
                          ),
                          textAlign: TextAlign.center,
                        ),
                        flex: 1
                      ),
                      Expanded(
                        child: Text(
                          'Punkte: ' + game.getFinishedVocabularies().length.toString(),
                          style: TextStyle(
                            fontSize: 20
                          ),
                          textAlign: TextAlign.center,
                        ),
                        flex: 1
                      )
                    ]
                  )
                )
              ],
            )
          )
        )
      )
    );
  }

  _getWidget(int index) {
    bool shouldGetShown = !game.isCardSolved(index);
    return Visibility(
      visible: shouldGetShown,
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Center(
            child: Expanded(
              child: ElevatedButton(
                onPressed:() async =>  {
                  if (selectedIndexFirstCard < 0){
                    setState(() {
                      selectedIndexFirstCard = index;
                    })
                  } else if (selectedIndexFirstCard >= 0 && selectedIndexSecondCard < 0 && selectedIndexFirstCard != index) {
                    setState(() {
                      selectedIndexSecondCard = index;
                      smartphoneScreen = getSmartphoneScreen();
                      bigScreen = getBigScreen();
                    }),
                    await Future.delayed(Duration(seconds: 1)),
                    setState(() {
                      if (game.validateAnswer(cardTexts[selectedIndexFirstCard], cardTexts[selectedIndexSecondCard])){
                        if (game.isPlayerFinished()){
                          if (game.isGameFinished()){
                            UserDataGlobals.gamesRepo!.updateGameState(frontgame);
                            UserHandler().updateFinishedGamesIDsNews(game.player1, game.gameID!);
                            isGameFinished = true;
                            if (game.player1Points! < game.player2Points!){
                              _showResultDialog('Loooooser', 60);
                            } else if (game.player2Points! < game.player1Points!){
                              _controllerCenter.play();
                              _showResultDialog('Sieger', 60);
                            } else {
                              _showResultDialog('Unentschieden', 60);
                            }
                          } else {
                            isPlayerFinished = true;
                          }
                        }
                      }
                      selectedIndexFirstCard = - 1;
                      selectedIndexSecondCard = -1;
                    })
                  },
                  setState(() {
                    smartphoneScreen = getSmartphoneScreen();
                    bigScreen = getBigScreen();
                  })
                }, 
                child: Expanded(
                  child: Container(
                    height: 100,
                    width: 150,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: (selectedIndexFirstCard == index || selectedIndexSecondCard == index) 
                      ? Text(cardTexts[index]) 
                      : Text(
                        'parla Italiano',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(100, 0, 0, 0)
                        ),
                      )
                      ,
                    ),
                  )
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(color: Colors.black, width: 2)
                    )
                  ),
                  backgroundColor: (selectedIndexFirstCard == index || selectedIndexSecondCard == index) ? MaterialStateProperty.all<Color>(Colors.white) : MaterialStateProperty.all<Color>(Colors.grey)
                ),
              )
            ),
          )
        )
      )
    );
  }

  _getWidgetSmartphone(int index){
    bool shouldGetShown = !game.isCardSolved(index);
    return Visibility(
      visible: shouldGetShown,
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.all(1),
          child: Center(
            child: Expanded(
              child: ElevatedButton(
                onPressed:() async =>  {
                  if (selectedIndexFirstCard < 0){
                    setState(() {
                      selectedIndexFirstCard = index;
                    })
                  } else if (selectedIndexFirstCard >= 0 && selectedIndexSecondCard < 0 && selectedIndexFirstCard != index){
                    setState(() {
                      selectedIndexSecondCard = index;
                      smartphoneScreen = getSmartphoneScreen();
                    }),
                    await Future.delayed(Duration(seconds: 1)),
                    setState(() {
                      if (game.validateAnswer(cardTexts[selectedIndexFirstCard], cardTexts[selectedIndexSecondCard])){
                        if (game.isPlayerFinished()){
                          if (game.isGameFinished()){
                            UserDataGlobals.gamesRepo!.updateGameState(frontgame);
                            UserHandler().updateFinishedGamesIDsNews(game.player1, game.gameID!);
                            isGameFinished = true;
                            if (game.player1Points! < game.player2Points!){
                              _showResultDialog('Loooooser', 30);
                            } else if (game.player2Points! < game.player1Points!){
                              _controllerCenter.play();
                              _showResultDialog('Sieger', 30);
                            } else {
                              _showResultDialog('Unentschieden', 30);
                            }
                          } else {
                            isPlayerFinished = true;
                          }
                        }
                      }
                      selectedIndexFirstCard = -1;
                      selectedIndexSecondCard = -1;
                    })
                  },
                  setState(() {
                    smartphoneScreen = getSmartphoneScreen();
                  })
                }, 
                child: Expanded(
                  child: Container(
                    height: 100,
                    width: 150,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: (selectedIndexFirstCard == index || selectedIndexSecondCard == index) 
                      ? Text(cardTexts[index]) 
                      : Text(
                        'parla Italiano',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(100, 0, 0, 0)
                        ),
                      )
                      ,
                    ),
                  )
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      side: BorderSide(color: Colors.black, width: 1)
                    )
                  ),
                  backgroundColor: (selectedIndexFirstCard == index || selectedIndexSecondCard == index) ? MaterialStateProperty.all<Color>(Colors.white) : MaterialStateProperty.all<Color>(Colors.grey)
                ),
              )
            ),
          )
        )
      )
    );
  }

  Widget _getMainContainer(){
    if (isGameFinished){
      return _getGameFinishedContainer();
    } else if (isPlayerFinished){
      return _getPlayerFinishedContainer();
    } else {
      return Expanded(
        child: Container(
          child: _getPlayingMainContainer()
        ),
      );
    }   
  } 

  Widget _getMainContainerSmartphone(){
    if (isGameFinished){
      String resultText;
      if (game.player1Points! < game.player2Points!){
        resultText = 'verloren';
      } else if (game.player1Points! > game.player2Points!){
        resultText = 'gewonnen';
      } else {
        resultText = 'gespielt';
      }
      String text = 'Du hast ' + game.player2Points.toString() + ' : ' + game.player1Points.toString() + ' ' + resultText;
      return _getPlayerFinishedContainerSmartphone(text);
    } else if (isPlayerFinished){
      String text = 'Du hast ' + game.roundNumber.toString() + ' Runden gebraucht um das Memory zu lösen.\nWarte jetzt bis ' + game.player2.username + ' gespielt hat!';
      return _getPlayerFinishedContainerSmartphone(text);
    } else {
      return _getPlayingMainContainerSmartphone();
    }   
  } 

  Widget _getGameFinishedContainer(){
    String resultText;
    if (game.player1Points! < game.player2Points!){
      resultText = 'verloren';
    } else if (game.player1Points! > game.player2Points!){
      resultText = 'gewonnen';
    } else {
      resultText = 'gespielt';
    }
    String text = 'Du hast ' + game.player2Points.toString() + ' : ' + game.player1Points.toString() + ' ' + resultText;              
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: globalColors.appBarColor,
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22
                  ),
                )
            )
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor: Colors.white,
                        ),
                        onPressed:() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartScreen(), )), 
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Zurück zur Startseite",
                            style: TextStyle(
                              fontSize: 22
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor: Colors.white,
                        ),
                        onPressed:() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OneVSOneScreen(), )),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Erstelle ein neues Spiel",
                            style: TextStyle(
                              fontSize: 22
                            ),
                          ),
                        ),
                      )
                    )
                  ),
                ],
              )
            )
          ]
        )
      )
    );
  }

  Widget _getPlayerFinishedContainer(){
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: globalColors.appBarColor,
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  'Du hast ' + game.roundNumber.toString() + ' Runden gebraucht um das Memory zu lösen.\nWarte jetzt bis ' + game.player2.username + ' gespielt hat!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22
                  ),
                )
            )
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor: Colors.white,
                        ),
                        onPressed:() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartScreen(), )), 
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Zurück zur Startseite",
                            style: TextStyle(
                              fontSize: 22
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor: Colors.white,
                        ),
                        onPressed:() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OneVSOneScreen(), )),
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "Erstelle ein neues Spiel",
                            style: TextStyle(
                              fontSize: 22
                            ),
                          ),
                        ),
                      )
                    )
                  ),
                ],
              )
            )
          ]
        )
      )
    );
  }

  Widget _getPlayerFinishedContainerSmartphone(String text){
    return Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        height: 400,
        width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: globalColors.appBarColor,
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16
                  ),
                )
            )
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor: Colors.white,
                        ),
                        onPressed:() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartScreen(), )), 
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            "Startseite",
                            style: TextStyle(
                              fontSize: 16
                            ),
                          ),
                        ),
                      ),
                    )
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor: Colors.white,
                        ),
                        onPressed:() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OneVSOneScreen(), )),
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            "Neues Spiel",
                            style: TextStyle(
                              fontSize: 16
                            ),
                          ),
                        ),
                      )
                    )
                  ),
                ],
              )
            )
          ]
        )
      )
      )
    );
  }

  Widget _getPlayingMainContainer(){
    return Expanded(
      child: Container(
        child: Expanded(
          child:Column(
            children: [
              Expanded(
                child: _buildRow(1),
                flex: 1
              ),
              Expanded(
                child: _buildRow(2),
                flex: 1
              ),
              Expanded(
                child: _buildRow(3),
                flex: 1
              ),
              Expanded(
                child: _buildRow(4),
                flex: 1
              ),
            ]
          )
        )
      )
    );
  }

  Widget _getPlayingMainContainerSmartphone(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.5, vertical: 10),
      child: Column(
        children: [
          _buildRowSmartphone(1),
          _buildRowSmartphone(2),
          _buildRowSmartphone(3),
          _buildRowSmartphone(4),
          _buildRowSmartphone(5),
        ]
      )
    );
  }

  _buildRow(int rowNumber){
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: _getWidget(((rowNumber - 1) * 5)),
            flex: 1
          ),
          Expanded(
            child: _getWidget(((rowNumber - 1) * 5) + 1),
            flex: 1
          ),
          Expanded(
            child: _getWidget(((rowNumber - 1) * 5) + 2),
            flex: 1
          ),
          Expanded(
            child: _getWidget(((rowNumber - 1) * 5) + 3),
            flex: 1
          ),
          Expanded(
            child: _getWidget(((rowNumber - 1) * 5) + 4),
            flex: 1
          ),
        ],
      ),
    );
  }      

  _buildRowSmartphone(int rowNumber){
    return SizedBox(
      width: double.infinity,
      height: 80,
      child:Row(
        children: [
          Expanded(
            child: _getWidgetSmartphone(((rowNumber - 1) * 4)),
            flex: 1
          ),
          Expanded(
            child: _getWidgetSmartphone(((rowNumber - 1) * 4) + 1),
            flex: 1
          ),
          Expanded(
            child: _getWidgetSmartphone(((rowNumber - 1) * 4) + 2),
            flex: 1
          ),
          Expanded(
            child: _getWidgetSmartphone(((rowNumber - 1) * 4) + 3),
            flex: 1
          ),
        ],
      )
    );
  } 

    void _showResultDialog(String text, double textSize) { 
    showDialog( 
      context: context, 
      builder: (context) { 
        Future.delayed(Duration(seconds: 10), () { 
          Navigator.of(context).pop();
        }); 
        return AlertDialog( 
          content: SizedBox(
            height: 100,
            child: Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w200,
                  fontSize: textSize,
                  backgroundColor: Color.fromARGB(0, 0, 0, 0)
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  isRepeatingAnimation: true,
                  animatedTexts: [
                    ScaleAnimatedText(text),
                    ScaleAnimatedText(text),
                    ScaleAnimatedText(text),
                    ScaleAnimatedText(text),
                  ],
                ),
              ),
            )
          ), 
        ); 
      }, 
    ); 
  }

}