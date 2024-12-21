
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/navigationBar.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/constants/texts.dart' as texts;
import 'package:parla_italiano/constants/colors.dart' as colors;
import 'package:parla_italiano/handler/userHandler.dart';

import 'package:parla_italiano/handler/speaker.dart';
import 'package:parla_italiano/games/test.dart';
import 'package:parla_italiano/routes.dart' as routes;
import 'package:parla_italiano/screens/start_screen.dart';
import 'package:parla_italiano/widgets/rulesDialogBuilder.dart' as rulesBuilder;



class VocabularyTestScreen extends StatefulWidget {

  final Test test = Test();

  @override
  _VocabularyTestScreenState createState() => _VocabularyTestScreenState();
}

class _VocabularyTestScreenState extends State<VocabularyTestScreen> {

  final _formKey = GlobalKey<FormState>();
  final _controllerAnswer = TextEditingController();

  bool _gameFinished = false;
  bool _testPassed = false;
  String testLevel = (userData.user!.level + 1).toString();

  late Widget bigScreen = getBigScreen();
  late Widget smallScreen = getSmallScreen();

  Widget getBigScreen(){
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(3),
      appBar: CustomAppBar(), 
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Text(
                'Test zum Levelaufstieg für Level $testLevel',
                style: TextStyle(
                  fontSize: 22,
                )
              )
            ),
            Expanded(
              flex: 1,
              child: SizedBox()
            ),
            Flexible(
              flex: 10,
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    // korrekt
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox()
                            ),
                            Flexible(
                              flex: 6,
                              child: Center(
                                child: RotatedBox(
                                  quarterTurns: -1,
                                  child: LinearProgressIndicator(
                                    value: widget.test.getPercentageOfCorrectAnswers(),
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    minHeight: 30,
                                  ),
                                )
                              )
                            ),
                            Flexible(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'Richtig: ${widget.test.getAmountOfCorrectWords()}',
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                )
                              )
                            ),
                          ],
                        )
                      )
                    ),
                    //ital deutsch und enter
                    Flexible(
                      flex: 5,
                      child: _gameFinished ? _getFinishedContainer(22) : _getMainContainer(20)
                    ),
                    //false 
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox()
                            ),
                            Flexible(
                              flex: 6,
                              child: Center(
                                child: RotatedBox(
                                  quarterTurns: -1,
                                  child: LinearProgressIndicator(
                                    value: widget.test.getPercentageOfWrongAnswers(),
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    minHeight: 30,
                                  ),
                                )
                              )
                            ),
                            Flexible(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'Fehler: ${widget.test.getAmountOfWrongWords()}',
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                )
                              )
                            ),
                          ],
                        )
                      )
                    )
                  ]
                )
              )
            ),
            Expanded(
              flex: 1,
              child: SizedBox()
            ),
            //prograss bar
            Flexible(
              flex: 2,
              child: Center(
                child: LinearProgressIndicator(
                  value: widget.test.getAmountOfFinishedWords() / widget.test.getAmountsOfPlayingWord(),
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 58, 58, 58)),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  minHeight: 30,
                ),
              )
            ),
          ]
        )
      )
  );
  }

  Widget getSmallScreen(){
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(3),
      appBar: CustomAppBar(), 
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Text(
                'Test zum Levelaufstieg für Level ${userData.user!.level + 1}',
                style: TextStyle(
                  fontSize: 22,
                )
              )
            ),
            Expanded(
              flex: 1,
              child: SizedBox()
            ),
            Flexible(
              flex: 10,
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    // korrekt
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox()
                            ),
                            Flexible(
                              flex: 6,
                              child: Center(
                                child: RotatedBox(
                                  quarterTurns: -1,
                                  child: LinearProgressIndicator(
                                    value: widget.test.getPercentageOfCorrectAnswers(),
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    minHeight: 30,
                                  ),
                                )
                              )
                            ),
                            Flexible(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'Richtig: ${widget.test.getAmountOfCorrectWords()}',
                                  style: TextStyle(
                                    fontSize: 16
                                  ),
                                )
                              )
                            ),
                          ],
                        )
                      )
                    ),
                    //ital deutsch und enter
                    Flexible(
                      flex: 5,
                      child: _gameFinished ? _getFinishedContainer(18) : _getMainContainer(16)
                    ),
                    //false 
                    Flexible(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox()
                            ),
                            Flexible(
                              flex: 6,
                              child: Center(
                                child: RotatedBox(
                                  quarterTurns: -1,
                                  child: LinearProgressIndicator(
                                    value: widget.test.getPercentageOfWrongAnswers(),
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    minHeight: 30,
                                  ),
                                )
                              )
                            ),
                            Flexible(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'Fehler: ${widget.test.getAmountOfWrongWords()}',
                                  style: TextStyle(
                                    fontSize: 16
                                  ),
                                )
                              )
                            ),
                          ],
                        )
                      )
                    )
                  ]
                )
              )
            ),
            Expanded(
              flex: 1,
              child: SizedBox()
            ),
            //prograss bar
            Flexible(
              flex: 2,
              child: Center(
                child: LinearProgressIndicator(
                  value: widget.test.getAmountOfFinishedWords() / widget.test.getAmountsOfPlayingWord(),
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 58, 58, 58)),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  minHeight: 30,
                ),
              )
            ),
          ]
        )
      )
  );
}
  
  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
          builder: ((context, constraints) {
            if (constraints.maxWidth > 1200){
              return bigScreen;
            } else {
              return smallScreen;
            }
            
          })
        );
  }
  
  Future<bool> _finishQuiz() async {
    routes.canTestBeLeaved = true;
    if (widget.test.getAmountOfCorrectWords() >= widget.test.getAmountOfNeededCorrects()){
      UserHandler().updateUserLevel();
      for (String friendID in userData.user!.friendsIDs){
        AppUser friend = await UserHandler().findUserByID(friendID);
        UserHandler().addLevelUpdateNews(friend);
      }
      _testPassed = true;
    } else {
      _testPassed = false;
    }
    _gameFinished = true;
    return true;
  }

  _getFinishedContainer(double fontsize){
    String text1;
    String text2;
    if(_testPassed){
      text1 = 'Glückwunsch! Du hast von ${widget.test.getAmountsOfPlayingWord()} Wörtern ${widget.test.getAmountOfCorrectWords()} Wörter richtig übersetzt!';
      text2 = 'Damit bist du jetzt in Level ${userData.user!.level}. Schau dir die neuen Vokabeln an!';
    } else {
      text1 = 'Du hast von ${widget.test.getAmountsOfPlayingWord()} Wörtern ${widget.test.getAmountOfCorrectWords()} Wörter richtig übersetzt!';
      text2 = 'Damit bleibst du in Level ${userData.user!.level}. Probiere es morgen nochmal!';
    }
    return Container(
      alignment:  Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.5
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: colors.appBarColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              Flexible(
                flex: 1,
                child: Padding( 
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      text1,
                      style: TextStyle(
                        fontSize: fontsize
                      ),
                    )
                  )
                )
              ),
              Flexible(
                flex: 1,
                child: Padding( 
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Text(
                      text2,
                      style: TextStyle(
                        fontSize: fontsize
                      ),
                    )
                  )
                )
              ),
              Flexible(
                flex: 1,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      alignment: Alignment.center,
                    ),
                    onPressed:() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartScreen(), )),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Zurück zur Startseite",
                        style: TextStyle(
                          fontSize: fontsize
                        ),
                      ),
                    ),
                  ),
                )
              )
            ],
          )
        )
      )
    );
  }

  _getMainContainer(double fontsize){
    return Container(
      alignment:  Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.5
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: colors.appBarColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
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
                              child: _getWidget(fontsize)
                            )
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: TextFormField(
                              controller: _controllerAnswer,
                              decoration: InputDecoration(
                                hintText: 'Übersetzung',
                              ),
                              onFieldSubmitted: (value) async {
                                widget.test.validateAnswer(_controllerAnswer.text);
                                  _controllerAnswer.clear();
                                  if (widget.test.isTestFinished()){
                                    await _finishQuiz();
                                  }
                                setState(() {
                                  bigScreen = getBigScreen();
                                  smallScreen = getSmallScreen();
                                });
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
                          fontSize: fontsize,
                          color: Colors.black
                        ),
                      ),
                    ),
                    onPressed: () async {
                      widget.test.validateAnswer(_controllerAnswer.text);
                      _controllerAnswer.clear();
                      if (widget.test.isTestFinished()){
                        await _finishQuiz();
                      }
                      setState(() {
                        bigScreen = getBigScreen();
                        smallScreen = getSmallScreen();
                      }); 
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
                          rulesBuilder.dialogBuilderRules(context, texts.testRules);
                        },
                      )
                ) 
                  
              )
            ],
          )
        )
      )
    );
  }

  _getWidget(double fontsize){
    int _translationDirectionClassificator = widget.test.getTranslationDirectionClassificator();
    if (_translationDirectionClassificator == 2){
      return Text(
        widget.test.getActualItalianWord(),
        style: TextStyle(
          fontSize: fontsize,
        )
      );
    } else if (_translationDirectionClassificator == 3){
      return IconButton(
        icon: Icon(Icons.mic),
        onPressed:() async {
          VoiceSpeaker().speakItalianWord(widget.test.getActualItalianWord());
        }
      );
    } else {
      return Text(
        widget.test.getActualGermanWord(),
        style: TextStyle(
          fontSize: fontsize,
        )
      );
    }
  }
   
}




