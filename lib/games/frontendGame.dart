import 'package:flutter/material.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/games/GameType.dart';
import 'package:parla_italiano/games/generic/genericGame.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;
import 'package:parla_italiano/screens/classicGameScreen.dart';
import 'package:parla_italiano/screens/memoryScreen.dart';

class FrontGame {

  GenericGame _game;
  GameType gameType;

  FrontGame(this._game, this.gameType);

  String _getFinishedGamesText() {
    int totalPointsPlayer1 = _game.getPlayersTotalPoints()[0];
    int totalPointsPlayer2 = _game.getPlayersTotalPoints()[1];
    AppUser player1 = _game.getPlayers()[0];
    AppUser player2 = _game.getPlayers()[1];
    switch (gameType) {
      case GameType.classicGame:
        if (player1.userID == globalData.user!.userID){
          if ( totalPointsPlayer1 > totalPointsPlayer2){
            return 'Du hast gegen ${player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} gewonnen';
          } else if (totalPointsPlayer1 == totalPointsPlayer2){
            return 'Du hast gegen ${player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} gespielt';
          } else{
            return 'Du hast gegen ${player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} verloren';
          }
        } else {
          if ( totalPointsPlayer2 > totalPointsPlayer1){
            return 'Du hast gegen ${player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} gewonnen';
          } else if (totalPointsPlayer2 == totalPointsPlayer1){
            return 'Du hast gegen ${player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} gespielt';
          } else{
            return 'Du hast gegen ${player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} verloren';
          }
        }
      case GameType.memory:
        if (player1.userID == globalData.user!.userID){
          if ( totalPointsPlayer1 < totalPointsPlayer2){
            return 'Du hast gegen ${player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} gewonnen';
          } else if (totalPointsPlayer1 == totalPointsPlayer2){
            return 'Du hast gegen ${player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} gespielt';
          } else{
            return 'Du hast gegen ${player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} verloren';
          }
        } else {
          if ( totalPointsPlayer2 < totalPointsPlayer1){
            return 'Du hast gegen ${player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} gewonnen';
          } else if (totalPointsPlayer2 == totalPointsPlayer1){
            return 'Du hast gegen ${player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} gespielt';
          } else{
            return 'Du hast gegen ${player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} verloren';
          }
        }
    }
  }

  Widget getFinishedGamesWidget(){
    print('getFinishedGames widget');
    return Expanded(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.only(right: 10.0),
                decoration: new BoxDecoration(
                  border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.black)
                  )
                ),
                child:Icon(gameType.info.icon),
              ),
            )
          ),
          Expanded(
            flex: 8,
            child: Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                _getFinishedGamesText()
              ),
            ),
          ),
        ]
      ),
    );
  }

  Row getGameText(BuildContext context){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.only(right: 10.0),
              decoration: new BoxDecoration(
                border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.black)
                )
              ),
              child:Icon(this.gameType.info.icon),
            ),
          )
        ),
        Expanded(
          flex: 7,
          child: Container(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              'Spiele Runde ${_game.getActualRound()} gegen ${globalData.user!.userID == _game.getPlayers()[1].userID ?  _game.getPlayers()[0].username : _game.getPlayers()[1].username}'
            ),
          ),
        ),
      ]
    );
  }

  void clickedOnPlaying(BuildContext context, int index){
    switch (gameType) {
      case GameType.classicGame:
      print('brooooo');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassicGameScreen(game: this), ));
      case GameType.memory:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemoryScreen(game: this), ));
    }
  }

  GenericGame getGame(){
    return _game;
  }

}