
import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/navigationBar.dart';
import 'package:parla_italiano/globals/vocabularyRepository.dart' as vocabularyRepository;
import 'package:parla_italiano/globals/vocabularyRepository.dart';
import 'package:parla_italiano/globals/userData.dart' as userData;
import 'package:parla_italiano/handler/userHandler.dart';

import '../widgets.dart';
import 'dart:math';
import 'package:flutter_tts/flutter_tts.dart';

class VocabularyTestScreen extends StatefulWidget {

  final List<Vocabulary> vocabularies = vocabularyRepository.createTestVocabularies();

  @override
  _VocabularyTestScreenState createState() => _VocabularyTestScreenState();
}

class _VocabularyTestScreenState extends State<VocabularyTestScreen> {

  final _formKey = GlobalKey<FormState>();
  final _controllerAnswer = TextEditingController();

  int currentPageIndex = 3;
  int _vocabularyIndex = 0;
  int _mistakes = 0;
  int _correct = 0;
  double _perecentageOfWrongAnswers = 0.0;
  
  /**
   * 0: deutsch -> italienisch
   * 1: deutsch -> italienisch
   * 2: italienisch -> deutsch
   * 3: voice -> deutsch
   */
  int _translationDirectionClassificator = new Random().nextInt(4);
  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
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
              flex: 8,
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
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
                          padding: EdgeInsets.all(5),
                          child: Center(
                            child: Column(
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Padding( 
                                    padding: EdgeInsets.symmetric(horizontal: 12),
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
                                                decoration: const InputDecoration(
                                                  hintText: 'Übersetzung'),
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
                                  flex: 5,
                                  child: Center(
                                    child: ElevatedButton(
                                      child: Text('überprüfen'),
                                      onPressed: () => {
                                        setState(() => _validateAnswer(_controllerAnswer.text)),
                                        }, 
                                    )
                                  )
                                ),
                              ],
                            )
                          )
                        )
                      )
                    ),
                    //progress bar
                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox()
                            ),
                            Flexible(
                              flex: 2,
                              child: Center(
                                child: LinearProgressIndicator(
                                  value: this._vocabularyIndex / 20,
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(248, 225, 174, 1)),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  minHeight: 30,
                                ),
                              )
                            ),
                            Flexible(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'Korrekt: ${this._correct}',
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                ) 
                              )
                            ),
                            Flexible(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'Fehler: ${this._mistakes}',
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                )
                              )
                            ),
                            Flexible(
                              flex: 2,
                              child: Center(
                                child: LinearProgressIndicator(
                                  value: _perecentageOfWrongAnswers,
                                  backgroundColor: Colors.green,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  minHeight: 30,
                                ),
                              )
                            ),
                            Expanded(
                              flex: 1,
                              child: SizedBox()
                            )
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
            Flexible(
              flex: 2,
              child: Center(
                child: Text(
                'Es gelten folgende Regeln: \nMan darf nur ein mal pro Tag zum Test antreten \nEs sind immer 20 Wörter, von denen 19 richtig übersetzt werden müssen \n 10 Wörter werden zufällig aus dem aktuellen Level gewählt und 10 weiter aus den anderen Leveln',
                )
              )
            ),
          ]
        )
      )
    );
  }

  void _validateAnswer(String answer){
    if (_translationDirectionClassificator == 0 || _translationDirectionClassificator == 1){
      if (answer == widget.vocabularies[_vocabularyIndex].italian){
        _correct = _correct + 1;
      } else {
        _mistakes = _mistakes + 1;
      }
    } else {
      if (answer == widget.vocabularies[_vocabularyIndex].german){
        _correct = _correct + 1;
      } else {
        _mistakes = _mistakes + 1;
      }
    }
    _controllerAnswer.clear();
    _perecentageOfWrongAnswers = _mistakes/ (_mistakes + _correct);
    if (_vocabularyIndex == 19){
      _finishQuiz();
    } else {
    _vocabularyIndex = _vocabularyIndex + 1;
    _translationDirectionClassificator = new Random().nextInt(4);

    }
  }

  void _finishQuiz(){
    if (_mistakes <= 30){
      UserHandler().updateUserLevel();
      _dialogBuilderPassed(context);
    } else {
      _dialogBuilderNotPassed(context);
    }
  }

  _getWidget(){
    if (_translationDirectionClassificator == 2){
      return Text(
        widget.vocabularies[_vocabularyIndex].italian,
        style: TextStyle(
          fontSize: 20,
        )
      );
    } else if (_translationDirectionClassificator == 3){
      return IconButton(
        icon: Icon(Icons.mic),
        onPressed:() async {
          FlutterTts flutterTts = FlutterTts(); 
          flutterTts.setLanguage('it-IT');
          flutterTts.setSpeechRate(1.0); 
          flutterTts.setVolume(1.0); 
          flutterTts.setPitch(1.0);
          await flutterTts.speak(widget.vocabularies[_vocabularyIndex].italian);
        }
      );
    } else {
      return Text(
        widget.vocabularies[_vocabularyIndex].german,
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
              const Text(
                'Leider waren von den 20 Wörtern  Wörter falsch, sodass du den Test nicht bestanden hast.\nProbiere es morgen erneut!',
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
              const Text(
                'Glückwunsch! Du hast von 20 Wörtern Wörter richtig übersetzt, sodass du nun in Level  bist!\nSchau dir direkt die neuen Vokabeln an!',
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
}