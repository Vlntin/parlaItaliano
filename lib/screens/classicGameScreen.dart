import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/games/classicGame.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/navigationBar.dart';
import 'package:parla_italiano/globals/globalData.dart' as UserDataGlobals;
import 'package:parla_italiano/handler/gameHandler.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/routes.dart' as routes;
import 'package:parla_italiano/widgets/classicGameWidgets.dart';
import 'package:parla_italiano/constants/texts.dart' as ruleTexts;
import 'package:parla_italiano/widgets/rulesDialogBuilder.dart' as rulesBuilder;

import 'package:confetti/confetti.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ClassicGameScreen extends StatefulWidget {

  String? gameID;
  ClassicGameScreen({super.key, this.gameID});

  @override
  _ClassicGameScreenState createState() => _ClassicGameScreenState(gameID: gameID);
}

class _ClassicGameScreenState extends State<ClassicGameScreen> {

  String? gameID;
  int currentPageIndex = 2;
  _ClassicGameScreenState({required this.gameID});
  late ClassicGame? game = _findRigthGame();

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

  late ConfettiController _controllerCenter;

  ClassicGame? _findRigthGame(){
    for (ClassicGame game in UserDataGlobals.gamesRepo!.games){
      if (game.gameID == gameID){
        return game;
      }
    }
    return null;
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
                child: // manually specify the colors to be used
      Padding(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 40),
        child: Column(
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
                            child : _getMainContainer()
                          )
                        )
                      )
                    ), 
                    Flexible(
                      flex: 3,
                      child: ClassicGamePointBoardWidget(game!)
                    )
                  ]
                )
              )
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
    print('finishQuiz');
    _timerStopped = true;
    routes.canTestBeLeaved = true;
    _wrongWords = game!.getFalseWordsInRound();
    _gameFinished = true;
    if (game!.setNextRound()){
      setState(() {
        GameHandler().updateGameStats(game!);
        UserDataGlobals.gamesRepo!.updateGameState(game!);
      });
    } else {
      setState(() {
        GameHandler().updateGameStats(game!);
        UserDataGlobals.gamesRepo!.updateGameState(game!);
        UserHandler().updateFinishedGamesIDsNews(game!.player1, game!.gameID);
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
  }

  _getWidget(){
      return Text(
        game!.questions[game!.currentIndex],
        style: TextStyle(
          fontSize: 20,
        )
      );
  }    

  void _updateProgress(){
    const oneSec = const Duration(seconds: 1);
    new Timer.periodic(oneSec, (Timer t) { 
      setState(() {
        _usedTime += 1/60;
        if(_usedTime  >= 1.0 || _timerStopped){
          t.cancel();
          _finishQuiz();
        }
      });
    });
  }   

  Widget _getMainContainer(){
    if (!_gameStarted){
      return _getStartMainContainer();
    }
    if (_gameFinished){
      return _getFinishedMainContainer();
    }
    else {
      return _getPlayingMainContainer();
    }
  } 

  Widget _getStartMainContainer(){
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
                    fontSize: 22
                  ),
                ),
              ),
              onPressed: () {
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
                    fontSize: 22
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

  Widget _getFinishedMainContainer(){
    return Column(
      children: [                               
        Flexible(
          flex: 1,
          child: Center(
            child: Text(
              "Du hast in dieser Runde ${_player1IsActualPlayer ? game!.player1Points[_roundNumber - 1] : game!.player2Points[_roundNumber - 1]} von ${game!.neededVocabularies / game!.totalRounds} Punkten geholt. Folgende Wörter hast du falsch übersetzt:",
              style: TextStyle(
                fontSize: 20
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
          child: _getFinishedGameButtons()
        ),      
      ]
    );
  }

  Widget _getPlayingMainContainer(){
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
                        child: _getWidget()
                      )
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: TextFormField(
                        controller: _controllerAnswer,
                        decoration: InputDecoration(
                          hintText: 'Übersetzung',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Passwort eingeben du Hund!';
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
          flex: 4,
          child: Center(
            child: ElevatedButton(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  'überprüfen',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                  ),
                ),
              ),
              onPressed: () => {
                setState(() {
                  _finishedWordsPercent = _finishedWordsPercent + ( 1 / (game!.neededVocabularies / game!.totalRounds));
                  game!.validateAnswer(_controllerAnswer.text);
                  _controllerAnswer.clear();
                  if(!game!.setNextWord()){
                    _timerStopped = true;
                  }
                }) 
              }, 
            )
          )
        ),
        Flexible(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Center()
              ),
              Flexible(
                flex: 1,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.bottomRight,
                    backgroundColor: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(5),
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
            ]
          )
        )
      ],
    );
  }     

  Widget _getFinishedGameButtons(){
    if (game!.actualPlayer.userID == UserDataGlobals.user!.userID && game!.actualRound <= game!.totalRounds){
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
                      onPressed:() => context.go('/startScreen'), 
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Zurück zur Startseite",
                          style: TextStyle(
                            fontSize: 18
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
                      onPressed:() => context.go('/oneVsOneScreen'),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Erstelle ein neues Spiel",
                          style: TextStyle(
                            fontSize: 18
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
                      onPressed: () {
                        _initialize();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Starte nächste Runde",
                          style: TextStyle(
                            fontSize: 18
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
                      onPressed:() => context.go('/startScreen'), 
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Zurück zur Startseite",
                          style: TextStyle(
                            fontSize: 18
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
                      onPressed:() => context.go('/oneVsOneScreen'),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Erstelle ein neues Spiel",
                          style: TextStyle(
                            fontSize: 18
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

  void _initialize(){
    _gameStarted = true;
    _gameFinished = false;
    _finishedWordsPercent = 0.0;
    _timerStopped = false;
    _usedTime = 0.0;
    _roundNumber = game!.actualRound;
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
            height: 70,
            child: Center(
              child: DefaultTextStyle(
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w200,
                  fontSize: 50,
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