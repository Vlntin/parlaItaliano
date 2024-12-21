import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/games/GameType.dart';
import 'package:parla_italiano/games/classicGame/classicGame.dart';
import 'package:parla_italiano/games/frontendGame.dart';
import 'package:parla_italiano/games/generic/genericGame.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/navigationBar.dart';
import 'package:parla_italiano/globals/globalData.dart' as UserDataGlobals;
import 'package:parla_italiano/games/classicGame/classicGameHandler.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/routes.dart' as routes;
import 'package:parla_italiano/screens/oneVsOneScreen.dart';
import 'package:parla_italiano/screens/start_screen.dart';
import 'package:parla_italiano/widgets/classicGameWidgets.dart';
import 'package:parla_italiano/constants/texts.dart' as ruleTexts;
import 'package:parla_italiano/widgets/rulesDialogBuilder.dart' as rulesBuilder;

import 'package:confetti/confetti.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ClassicGameScreen extends StatefulWidget {

  FrontGame game;
  ClassicGameScreen({super.key, required this.game});

  @override
  _ClassicGameScreenState createState() => _ClassicGameScreenState(frontGame: game);
}

class _ClassicGameScreenState extends State<ClassicGameScreen> {

  FrontGame frontGame;
  late String? gameID = frontGame.getGame().gameID;
  int currentPageIndex = 2;
  _ClassicGameScreenState({required this.frontGame});
  late ClassicGame game = frontGame.getGame() as ClassicGame;

  final _formKey = GlobalKey<FormState>();
  final _controllerAnswer = TextEditingController();

  List<WrongWordResponse> _wrongWords = [];

  //initialized in initialie method
  bool _gameStarted = false;
  bool _gameFinished = false;
  late int _roundNumber = game!.actualRound;
  late bool _player1IsActualPlayer = game!.player1.userID == game!.actualPlayer.userID;
  double _finishedWordsPercent = 0.0;
  double _usedTime = 0.0;
  bool _timerStopped = false;

  late Widget bigScreen = getBigScreen();
  late Widget smallScreen = getSmallScreen();

  late ConfettiController _controllerCenter;

  GenericGame? _findRigthGame(){
    return frontGame.getGame();
  }

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


  Widget getBigScreen(){
    return Column(
          children: [
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: Text(
                        'Klassisches Spiel, Runde ${_roundNumber}',
                        style: TextStyle(
                          fontSize: 22,
                        )
                      )
                    )
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        '',
                        style: TextStyle(
                          fontSize: 22,
                        )
                      )
                    )
                  )
                ],
              )
            ),
            Expanded(
              flex: 1,
              child: SizedBox()
            ),
            Flexible(
              flex: 12,
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: Container(
                        alignment:  Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.5
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromRGBO(248, 225, 174, 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child : _getMainContainer(20, 18)
                          )
                        )
                      )
                    ), 
                    Flexible(
                      flex: 3,
                      child: ClassicGamePointBoardWidget(game!, 18)
                    )
                  ]
                )
              )
            )
          ]
    );
  }

  Widget getSmallScreen(){
    return Column(
          children: [
            Flexible(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: Text(
                        'Klassisches Spiel, Runde ${_roundNumber}',
                        style: TextStyle(
                          fontSize: 22,
                        )
                      )
                    )
                  ),
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Text(
                        '',
                        style: TextStyle(
                          fontSize: 22,
                        )
                      )
                    )
                  )
                ],
              )
            ),
            Expanded(
              flex: 1,
              child: SizedBox()
            ),
            Flexible(
              flex: 12,
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: Container(
                        alignment:  Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.5
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromRGBO(248, 225, 174, 1),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child : _getMainContainer(18, 16)
                          )
                        )
                      )
                    ), 
                    Flexible(
                      flex: 3,
                      child: ClassicGamePointBoardWidget(game!, 16)
                    )
                  ]
                )
              )
            )
          ]
    );
  }

  @override
  Widget build(BuildContext context){
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
                  flex: 15,
                  child: LayoutBuilder(
                    builder: ((context, constraints) {
                      if (constraints.maxWidth > 1200){
                        return bigScreen;
                      } else {
                        return smallScreen;
                      }
                  
                    })
                  
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox()
                ),
                Flexible(
                  flex: 2,
                  child: _getBottomProgressIndicator('Antworten:', _finishedWordsPercent, AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 58, 58, 58)))
                ),
                Flexible(
                  flex: 2,
                  child: _getBottomProgressIndicator('Zeit:', _usedTime, AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 255, 0, 0)))
                ),
              ]
            )
          )
        )
      )
    );
  }

  Widget _getBottomProgressIndicator(String text, double percent, AlwaysStoppedAnimation<Color> color ){
    return  Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      text,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: LinearProgressIndicator(
                        value: percent,
                        backgroundColor: Colors.white,
                        valueColor: color,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        minHeight: 30,
                      ),
                    )
                  )
                ],
              );
  }

  void _finishQuiz(){
    print('finish quiz');
    setState(() {
      _timerStopped = true;
      routes.canTestBeLeaved = true;
      _wrongWords = game!.getFalseWordsInRound();
      _gameFinished = true;
      if (game!.setNextRound()){
        setState(() {
          ClassicGameHandler().updateGameStats(game!);
          UserDataGlobals.gamesRepo!.updateGameState(frontGame);
        });
      } else {
        print('else statement');
        setState(() {
          ClassicGameHandler().updateGameStats(game!);
          UserDataGlobals.gamesRepo!.updateGameState(frontGame);
          UserHandler().updateFinishedGamesIDsNews(game!.player1, game!.gameID!);
          if (game!.player2Points.reduce((value, element) => value + element) > game!.player1Points.reduce((value, element) => value + element)){
          _controllerCenter.play();
          _showResultDialog('Sieger');
          } else if (game!.player2Points.reduce((value, element) => value + element) == game!.player1Points.reduce((value, element) => value + element)){
          _showResultDialog('Unentschieden');
          } else {
            _showResultDialog('Loooooser');
          }
        });
      }
      smallScreen = getSmallScreen();
      bigScreen = getBigScreen();
    });
    
  }

  _getWidget(double fontSize){
      return Text(
        game.questions[game.currentIndex],
        style: TextStyle(
          fontSize: fontSize,
        )
      );
  }    

  void _updateProgress(){
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) { 
      setState(() {
        bigScreen = bigScreen;
        smallScreen = smallScreen;
        _usedTime += 1/60;
        if(_usedTime  >= 1.0 || _timerStopped){
          print('found');
          t.cancel();
          _finishQuiz();
        }
      });
    });
  }   

  Widget _getMainContainer(double fontSizeText, double fontSizeBtns){
    if (!_gameStarted){
      return _getStartMainContainer(fontSizeText);
    }
    if (_gameFinished){
      return _getFinishedMainContainer(fontSizeText - 2, fontSizeBtns);
    }
    else {
      return _getPlayingMainContainer(fontSizeText);
    }
  } 

  Widget _getStartMainContainer(double fontSize){
    return Column(
      children: [                                
        Flexible(
          flex: 1,
          child: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                backgroundColor: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "START",
                  style: TextStyle(
                    fontSize: fontSize
                  ),
                ),
              ),
              onPressed: () async {
                await ClassicGameHandler().setDefault(frontGame);
                _initialize();
              },
            )
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
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  "Regeln",
                  style: TextStyle(
                    fontSize: fontSize
                  ),
                ),
              ),
              onPressed: () {
                rulesBuilder.dialogBuilderRules(context, ruleTexts.classicGameRules);
              },
            )
          )
        ),
      ],
    );
  }

  Widget _getFinishedMainContainer(double fontSizeText, double fontSizeBtns){
    return Column(
      children: [                               
        Flexible(
          flex: 1,
          child: Center(
            child: Text(
              "Du hast ${_player1IsActualPlayer ? game!.player1Points[_roundNumber - 1] : game!.player2Points[_roundNumber - 1]} von ${game!.neededVocabularies / game!.totalRounds} Punkten geholt. Folgende Wörter hast du falsch übersetzt:",
              style: TextStyle(
                fontSize: fontSizeText
              )
            )
          )
        ),
        Flexible(
          flex: 1,
          child: WrongWordWidgetHeadline()
        ),
        Expanded(
          flex: 5,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: _wrongWords.length,
            itemBuilder: (context, index){
              return Card(
                child: WrongWordWidget(_wrongWords[index]),
              );
            }
          )
        ),
        Expanded(
          flex: 1,
          child: _getFinishedGameButtons(fontSizeBtns - 2)
        ),      
      ]
    );
  }

  Widget _getPlayingMainContainer(double fontSize){
    return Column(
      children: [                                
        Flexible(
          flex: 4,
          child: Padding( 
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:SizedBox.expand(  
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: _getWidget(fontSize)
                      )
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: TextFormField(
                        controller: _controllerAnswer,
                        decoration: InputDecoration(
                          hintText: 'Übersetzung',
                        ),
                        onFieldSubmitted: (value) {
                          setState(() {
                            _finishedWordsPercent = _finishedWordsPercent + ( 1 / (game!.neededVocabularies / game!.totalRounds));
                            game!.validateAnswer(_controllerAnswer.text);
                            _controllerAnswer.clear();
                            if(!game!.setNextWord()){
                              _timerStopped = true;
                              print('timer setted');
                            }
                            bigScreen = getBigScreen();
                            smallScreen = getSmallScreen();
                          }) ;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'gib ein Wort ein';
                          }
                            return null;
                        },
                      )
                    ),
                  ],
                )
              )
            ) 
          )
        ),
        Flexible(
          flex: 3,
          child: Center(
            child: ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  'überprüfen',
                  style: TextStyle(
                    fontSize: fontSize,
                    color: Colors.black
                  ),
                ),
              ),
              onPressed: () => {
                setState(() {
                  _finishedWordsPercent = _finishedWordsPercent + ( 1 / (game.neededVocabularies / game.totalRounds));
                  game.validateAnswer(_controllerAnswer.text);
                  _controllerAnswer.clear();
                  if(!game.setNextWord()){
                    _timerStopped = true;
                  }
                  bigScreen = getBigScreen();
                  smallScreen = getSmallScreen();
                }) 
              }, 
            )
          )
        ),
        
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child:  ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.bottomRight,
                          backgroundColor: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child:Icon(
                            Icons.question_mark_outlined,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          rulesBuilder.dialogBuilderRules(context, ruleTexts.classicGameRules);
                        },
                      )
                ) 
                  
              )
            
      ],
    );
  }     

  Widget _getFinishedGameButtons(double fontSize){
    if (game!.actualPlayer.userID == UserDataGlobals.user!.userID && game!.actualRound <= game!.totalRounds && !game.finished){
      return Center(
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
                            fontSize: fontSize
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
                      onPressed:() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OneVSOneScreen(), ))
                                                          ,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Erstelle ein neues Spiel",
                          style: TextStyle(
                            fontSize: fontSize
                          ),
                        ),
                      ),
                    )
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
                      onPressed: () async {
                        await ClassicGameHandler().setDefault(FrontGame(game, GameType.classicGame));
                        _initialize();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Starte nächste Runde",
                          style: TextStyle(
                            fontSize: fontSize
                          ),
                        ),
                      ),
                    )
                  )
                )
              ],
      )
    );
    } else {
return Center(
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
                            fontSize: fontSize
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
                            fontSize: fontSize
                          ),
                        ),
                      ),
                    )
                  )
                ),
                
              ],
      )
    );
    }
    
  }

  void _initialize() {
    setState(() {
      _gameStarted = true;
      _gameFinished = false;
      _finishedWordsPercent = 0.0;
      _timerStopped = false;
      _usedTime = 0.0;
      _roundNumber = game!.actualRound;
      bigScreen = getBigScreen();
      smallScreen = getSmallScreen();
    });
    _updateProgress();
  }

  void _showResultDialog(String text) { 
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
                  fontSize: 60,
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