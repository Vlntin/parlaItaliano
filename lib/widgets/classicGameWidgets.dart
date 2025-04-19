import 'package:flutter/material.dart';
import 'package:parla_italiano/games/classicGame/classicGame.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;
import 'dart:ui';
import 'package:parla_italiano/constants/colors.dart' as colors;

class WrongWordWidget extends StatefulWidget {

  double fontSize;

  WrongWordWidget(this.wrongWord,this.fontSize, {super.key});

  final WrongWordResponse wrongWord;

  @override
  WrongWordWidgetState createState() => WrongWordWidgetState(wrongWord: wrongWord);
}

class WrongWordWidgetState extends State<WrongWordWidget> {

  final WrongWordResponse wrongWord;
  WrongWordWidgetState({required this.wrongWord});

  late bool _selectedForFavorites = globalData.vocabularyRepo!.isVocabularyInFavorites(wrongWord.vocabulary.italian);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Color.fromARGB(0, 0, 0, 0),
      title: 
        Padding(
          padding: EdgeInsets.all(0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    style: TextStyle(
                      fontSize: widget.fontSize
                    ),
                    wrongWord.fromItalianToGerman ? wrongWord.vocabulary.italian : wrongWord.vocabulary.german
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left:1, right: 1),
                  
                  child: Text(
                    style: TextStyle(
                      fontSize: widget.fontSize
                    ),
                    wrongWord.fromItalianToGerman ? wrongWord.vocabulary.german : wrongWord.vocabulary.italian
                    ))
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    style: TextStyle(
                      fontSize: widget.fontSize
                    ),
                    wrongWord.givenRepsone
                  )
                ),
              ],
            )
        ),
        trailing: IconButton(
              icon: _selectedForFavorites ? Icon(Icons.star_sharp) : Icon(Icons.star_border),
                onPressed: () => {
                  _selectedForFavorites ? globalData.vocabularyRepo!.deleteFavouriteVocabulary(wrongWord.vocabulary.italian) : globalData.vocabularyRepo!.addVocabularyToFavorites(wrongWord.vocabulary.italian, wrongWord.vocabulary.german, wrongWord.vocabulary.additional),
                  setState(() => _selectedForFavorites = !_selectedForFavorites)
                },
              ),
      );
  }
}

class WrongWordWidgetHeadline extends StatelessWidget {

  double fontSize;
  WrongWordWidgetHeadline(this.fontSize, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: colors.appBarColor,
      title: 
        Padding(
          padding: EdgeInsets.all(0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    style: TextStyle(
                      fontSize: fontSize
                    ),
                    "Frage:"
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    style: TextStyle(
                      fontSize: fontSize
                    ),
                    "Lösung:"
                    )
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    style: TextStyle(
                      fontSize: fontSize
                    ),
                    "Antwort:"
                  )
                ),
              ],
            )
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            
            Opacity(
              opacity: 0.0,
              child: IconButton(
                  icon: Icon(Icons.star_sharp),
                  onPressed: () => {},
                ),
              )
            
          ]
        )
        
      );
  }
}

class ClassicGamePointBoardWidget extends StatefulWidget{

  final ClassicGame game;
  final double fontSize;
  final bool isSmarphoneView;
  ClassicGamePointBoardWidget(this.game, this.fontSize, this.isSmarphoneView, {super.key});

  @override
  ClassicGamePointBoardWidgetState createState() => ClassicGamePointBoardWidgetState(game: game);
}

class ClassicGamePointBoardWidgetState extends State<ClassicGamePointBoardWidget> {

  final ClassicGame game;

  ClassicGamePointBoardWidgetState({required this.game});

  @override
  Widget build(BuildContext context) {
    if (widget.isSmarphoneView) {
      return Column(
        children: [
          SizedBox(height: 10),
          Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    game.player1.username,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  )
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Text(
                    game.player1Points[0].toString(),
                    style: TextStyle(
                      fontSize: 16
                    ),
                  )
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Text(
                    game.player1Points[1].toString(),
                    style: TextStyle(
                      fontSize: 16
                    ),
                  )
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Text(
                    game.player1Points[2].toString(),
                    style: TextStyle(
                      fontSize: 16
                    ),
                  )
                ),
                VerticalDivider(
                  color: Colors.black,
                  //indent: 20,
                  //endIndent: 20,
                  width: 3,
                  thickness: 2,
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    (game.player1Points[0] + game.player1Points[1] +  game.player1Points[2]).toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
                
              ]
          ),
          SizedBox(height: 10),
          Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    game.player2.username,
                    style: TextStyle(
                      fontSize: 16
                    ),
                  )
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Text(
                    game.player2Points[0].toString(),
                    style: TextStyle(
                      fontSize: 16
                    ),
                  )
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Text(
                    game.player2Points[1].toString(),
                    style: TextStyle(
                      fontSize: 16
                    ),
                  )
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: Text(
                    game.player2Points[2].toString(),
                    style: TextStyle(
                      fontSize: 16
                    ),
                  )
                ),
                VerticalDivider(
                  color: Colors.black,
                  indent: 20,
                  endIndent: 20,
                  width: 3,
                  thickness: 2,
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    (game.player2Points[0] + game.player2Points[1] +  game.player2Points[2]).toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ),
                SizedBox(height: 10),
              ]
          ),
        ]
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            //left point side
            Expanded(
              flex: 10,
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "",
                          style: TextStyle(
                            fontSize: widget.fontSize
                          ),
                        )
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Runde 1:",
                          style: TextStyle(
                            fontSize: widget.fontSize
                          ),
                        )
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Runde 2:",
                          style: TextStyle(
                            fontSize: widget.fontSize
                          ),
                        )
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Runde 3:",
                          style: TextStyle(
                            fontSize: widget.fontSize
                          ),
                        )
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Gesamt:",
                          style: TextStyle(
                            fontSize: widget.fontSize
                          ),
                        )
                      )
                    ),
                  ]
                )
              )
            ), 
            //player 1 stats                   
            Expanded(
              flex: 20,
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          game.player1.username,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        )
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child:RotatedBox(
                                quarterTurns: -2,
                                child: SizedBox(
                                  height: 25,
                                  child: LinearProgressIndicator(
                                    value: game.player1Points[0] / (game.neededVocabularies / game.totalRounds),
                                    backgroundColor: Color.fromARGB(0, 0, 0, 0),
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[100]!),
                                    //borderRadius: BorderRadius.only(topRight : Radius.circular(10), bottomRight: Radius.circular(10)),
                                  ),
                                )
                              ),
                            ),
                            Align(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  game.player1Points[0].toString(),
                                  style: TextStyle(
                                    fontSize: widget.fontSize
                                  ), 
                                ), 
                              ),
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        )
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child:RotatedBox(
                              quarterTurns: -2,
                              child: SizedBox(
                                height: 25,
                                child: LinearProgressIndicator(
                                  value: game.player1Points[1] / (game.neededVocabularies / game.totalRounds),
                                  backgroundColor: Color.fromARGB(0, 0, 0, 0),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[100]!),
                                  //borderRadius: BorderRadius.only(topRight : Radius.circular(10), bottomRight: Radius.circular(10)),
                                ),
                              )
                            ),
                          ),
                          Align(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                game.player1Points[1].toString(),
                                style: TextStyle(
                                  fontSize: widget.fontSize
                                ), 
                              ), 
                            ),
                            alignment: Alignment.centerRight,
                          ),
                        ],
                        )
                      )              
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child:RotatedBox(
                                quarterTurns: -2,
                                child: SizedBox(
                                  height: 25,
                                  child: LinearProgressIndicator(
                                    value: game.player1Points[2] / (game.neededVocabularies / game.totalRounds),
                                    backgroundColor: Color.fromARGB(0, 0, 0, 0),
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[100]!),
                                    //borderRadius: BorderRadius.only(topRight : Radius.circular(10), bottomRight: Radius.circular(10)),
                                  ),
                                )
                              ),
                            ),
                            Align(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  game.player1Points[2].toString(),
                                  style: TextStyle(
                                    fontSize: widget.fontSize
                                  ), 
                                ), 
                              ),
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        )
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child:RotatedBox(
                                quarterTurns: -2,
                                child: SizedBox(
                                  height: 25,
                                  child: LinearProgressIndicator(
                                    value: (game.player1Points[0] + game.player1Points[1] + game.player1Points[2]) / game.neededVocabularies,
                                    backgroundColor: Color.fromARGB(0, 0, 0, 0),
                                    valueColor: _getTotalBarColor(1),
                                    //borderRadius: BorderRadius.only(topRight : Radius.circular(10), bottomRight: Radius.circular(10)),
                                  ),
                                )
                              ),
                            ),
                            Align(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  (game.player1Points[0] + game.player1Points[1] + game.player1Points[2]).toString(),
                                  style: TextStyle(
                                    fontSize: widget.fontSize,
                                    color: Colors.white
                                  ), 
                                ), 
                              ),
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        )
                      )
                    ),               
                  ],
                )
              )
            ),
            VerticalDivider(
              color: Colors.black,
              indent: 20,
              endIndent: 20,
              width: 3,
              thickness: 3,
            ),
            //player2 stats
            Expanded(
              flex: 20,
              child: Center(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          game.player2.username,
                          style: TextStyle(
                            fontSize: 18
                          ),
                        )
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child:SizedBox(
                                height: 25,
                                child: LinearProgressIndicator(
                                  value: game.player2Points[0] / (game.neededVocabularies / game.totalRounds),
                                  backgroundColor: Color.fromARGB(0, 0, 0, 0),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[100]!),
                                  //borderRadius: BorderRadius.only(topRight : Radius.circular(10), bottomRight: Radius.circular(10)),
                                ),
                              ),
                            ),
                            Align(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  game.player2Points[0].toString(),
                                  style: TextStyle(
                                    fontSize: widget.fontSize
                                  ), 
                                ), 
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ],
                        )
                      )                 
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child:SizedBox(
                                height: 25,
                                child: LinearProgressIndicator(
                                  value: game.player2Points[1] / (game.neededVocabularies / game.totalRounds),
                                  backgroundColor: Color.fromARGB(0, 0, 0, 0),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[100]!),
                                  //borderRadius: BorderRadius.only(topRight : Radius.circular(10), bottomRight: Radius.circular(10)),
                                ),
                              ),
                            ),
                            Align(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  game.player2Points[1].toString(),
                                  style: TextStyle(
                                    fontSize: widget.fontSize
                                  ), 
                                ), 
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ],
                        )
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child:SizedBox(
                                height: 25,
                                child: LinearProgressIndicator(
                                  value: game.player2Points[2] / (game.neededVocabularies / game.totalRounds),
                                  backgroundColor: Color.fromARGB(0, 0, 0, 0),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[100]!),
                                  //borderRadius: BorderRadius.only(topRight : Radius.circular(10), bottomRight: Radius.circular(10)),
                                ),
                              ),
                            ),
                            Align(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  game.player2Points[2].toString(),
                                  style: TextStyle(
                                    fontSize: widget.fontSize
                                  ), 
                                ), 
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ],
                        )
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child:SizedBox(
                                height: 25,
                                child: LinearProgressIndicator(
                                  value: (game.player2Points[0] + game.player2Points[1] + game.player2Points[2]) / game.neededVocabularies,
                                  backgroundColor: Color.fromARGB(0, 0, 0, 0),
                                  valueColor: _getTotalBarColor(2),
                                  //borderRadius: BorderRadius.only(topRight : Radius.circular(10), bottomRight: Radius.circular(10)),
                                ),
                              ),
                            ),
                            Align(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  (game.player2Points[0] + game.player2Points[1] + game.player2Points[2]).toString(),
                                  style: TextStyle(
                                    fontSize: widget.fontSize,
                                    color: Colors.white
                                  ), 
                                ), 
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ],
                        )
                      )
                    ),
                  ],
                )
              )
            ),
          ],
        )
      );
    }
  }

  AlwaysStoppedAnimation<Color> _getTotalBarColor(int playerNumber){
    if (playerNumber == 1){
      if (game.player1Points.reduce((value, element) => value + element) > game.player2Points.reduce((value, element) => value + element)){
        return AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 2, 79, 0)!);
      } else if (game.player1Points.reduce((value, element) => value + element) < game.player2Points.reduce((value, element) => value + element)){
        return AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 136, 0, 0)!);
      } else {
        return AlwaysStoppedAnimation<Color>(Colors.blue[100]!);
      }
    } else {
      if (game.player1Points.reduce((value, element) => value + element) > game.player2Points.reduce((value, element) => value + element)){
        return AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 136, 0, 0)!);
      } else if (game.player1Points.reduce((value, element) => value + element) < game.player2Points.reduce((value, element) => value + element)){
        return AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 2, 79, 0)!);
      } else {
        return AlwaysStoppedAnimation<Color>(Colors.blue[100]!);
      }
    }
  }
}