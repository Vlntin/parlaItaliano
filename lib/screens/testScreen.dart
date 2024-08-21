
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/navigationBar.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/handler/userHandler.dart';

import 'package:parla_italiano/handler/speaker.dart';
import 'package:parla_italiano/dbModels/test.dart';
import 'package:parla_italiano/routes.dart' as routes;

class VocabularyTestScreen extends StatefulWidget {

  final Test test = Test();

  @override
  _VocabularyTestScreenState createState() => _VocabularyTestScreenState();
}

class _VocabularyTestScreenState extends State<VocabularyTestScreen> {

  final _formKey = GlobalKey<FormState>();
  final _controllerAnswer = TextEditingController();

  @override
  Widget build(BuildContext context){
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
                                                child: _getWidget()
                                              )
                                            ),
                                            const SizedBox(width: 30),
                                            Expanded(
                                              child: TextFormField(
                                                controller: _controllerAnswer,
                                                decoration: InputDecoration(
                                                  hintText: 'Übersetzung',
                                                  /** 
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(25.0),
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(25.0),
                                                    borderSide: BorderSide(
                                                      color: Colors.red,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  */
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
                                      //style: ElevatedButton.styleFrom(
                                      //  minimumSize: Size(20, 20),
                                      //),
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
                                          _controllerAnswer.clear();
                                          widget.test.validateAnswer(_controllerAnswer.text);
                                          if (widget.test.isTestFinished()){
                                            _finishQuiz();
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
                                            _dialogBuilderRules(context);
                                          },
                                        )
                                      )
                                    ]
                                  )
                                )
                              ],
                            )
                          )
                        )
                      )
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

  void _finishQuiz(){
    routes.canTestBeLeaved = true;
    if (widget.test.getAmountOfCorrectWords() >= widget.test.getAmountOfNeededCorrects()){
      UserHandler().updateUserLevel();
      _dialogBuilderPassed(context);
    } else {
      _dialogBuilderNotPassed(context);
    }
  }

  _getWidget(){
    int _translationDirectionClassificator = widget.test.getTranslationDirectionClassificator();
    if (_translationDirectionClassificator == 2){
      return Text(
        widget.test.getActualItalianWord(),
        style: TextStyle(
          fontSize: 20,
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
          fontSize: 20,
        )
      );
    }
  }

  Future<void> _dialogBuilderNotPassed(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Testergebnis'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Leider waren von den ${widget.test.getAmountsOfPlayingWord()} Wörtern ${widget.test.getAmountOfWrongWords()} Wörter falsch, sodass du den Test nicht bestanden hast.\nProbiere es morgen erneut!',
              ),
            ]
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Zurück zur Startseite'),
              onPressed: ()  {
                context.go('/startScreen');
              }                    
            ),
          ],
        );
      },
    );
  }    

  Future<void> _dialogBuilderPassed(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Testergebnis'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Glückwunsch! Du hast von ${widget.test.getAmountsOfPlayingWord()} Wörtern ${widget.test.getAmountOfCorrectWords()} Wörter richtig übersetzt, sodass du nun in Level ${userData.user!.level}  bist!\nSchau dir direkt die neuen Vokabeln an!',
              ),
            ]
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Zurück zur Startseite'),
              onPressed: ()  {
                context.go('/startScreen');
              }                    
            ),
          ],
        );
      },
    );
  }

  Future<void> _dialogBuilderRules(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Regeln'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Es gelten folgende Regeln: \nMan darf nur ein mal pro Tag zum Test antreten. \nEs sind immer ${widget.test.getAmountsOfPlayingWord()} Wörter, von denen ${widget.test.getAmountOfNeededCorrects()} richtig übersetzt werden müssen. \n10 Wörter werden zufällig aus dem aktuellen Level gewählt und 10 weiter aus den anderen Leveln.',
              ),
            ]
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('weiterspielen'),
              onPressed: ()  {
                Navigator.of(context).pop(false);
              }                    
            ),
          ],
        );
      },
    );
  }     
}