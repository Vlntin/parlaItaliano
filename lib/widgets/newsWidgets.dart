
import 'package:flutter/material.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/games/classicGame/classicGame.dart';
import 'package:parla_italiano/games/generic/genericGame.dart';
import 'package:parla_italiano/games/memory/memoryGame.dart';
import 'package:parla_italiano/globals/gamesBibliothek.dart';

import 'package:parla_italiano/handler/friendsHandler.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;

class NewsWidget extends StatefulWidget{

  NewsWidget({super.key});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();

}
class _NewsWidgetState extends State<NewsWidget> {

  @override
  Widget build(BuildContext context) {
    return Text('j');
  }
}

class FriendsRequestWidget extends NewsWidget {

  FriendsRequestWidget(this.friend, {super.key});

  AppUser friend;
  bool visibilityBool = true;

  @override
  State<FriendsRequestWidget> createState() => _FriendsRequestWidgetState();

}
class _FriendsRequestWidgetState extends State<FriendsRequestWidget> {

  @override
  Widget build(BuildContext context) {
    if (widget.visibilityBool){
      return Card(
        child: ListTile(
          title: Text('${widget.friend.username} hat dir eine Freundschaftsanfrage geschickt'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
              children:[
                IconButton(
                  icon: Icon(Icons.done_rounded),
                  tooltip: 'akzeptieren',
                  onPressed:() {
                    setState((){
                      FriendsHandler().acceptFriendRequest(widget.friend.userID);
                      widget.visibilityBool = false;
                    });
                  }
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  tooltip: 'ablehnen',
                  onPressed:() {
                    setState((){
                      FriendsHandler().rejectFriendRequest(widget.friend.userID);
                      widget.visibilityBool = false;
                    });
                  }
                ),
              ]
            )
        )
      );
    } else {
      return Visibility(
        visible: false,
        child: Card(
        child: ListTile(
          title: Text(''),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'löschen',
            onPressed:() {
              setState((){
                widget.visibilityBool = false;
              });
            }
          ),
        )
      )
      );
    }
    
  }
}

class FriendsRequestAcceptedWidget extends NewsWidget {

  FriendsRequestAcceptedWidget(this.friend, {super.key});

  AppUser friend;
  var visibilityBool = true;

  @override
  State<FriendsRequestAcceptedWidget> createState() => _FriendsRequestAcceptedWidgetState();

}
class _FriendsRequestAcceptedWidgetState extends State<FriendsRequestAcceptedWidget> {

  @override
  Widget build(BuildContext context) {
    if (widget.visibilityBool){
      return Card(
        child: ListTile(
          title: Text('${widget.friend.username} hat deine Freundschaftsanfrage angenommen'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'löschen',
            onPressed:() {
              setState((){
                UserHandler().deleteFriendsRequestsAccepted(widget.friend.userID);
                widget.visibilityBool = false;
              });
            }
          ),
        )
      );
    } else {
      return Visibility(
        visible: false,
        child: Card(
        child: ListTile(
          title: Text(''),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'löschen',
            onPressed:() {
              setState(){
                widget.visibilityBool = false;
              };
            }
          ),
        )
      )
      );
    }
  }
}

class FriendsRequestRejectedWidget extends NewsWidget {

  FriendsRequestRejectedWidget(this.friend, {super.key});

  AppUser friend;
  var visibilityBool = true;

  @override
  State<FriendsRequestRejectedWidget> createState() => _FriendsRequestRejectedWidgetState();

}
class _FriendsRequestRejectedWidgetState extends State<FriendsRequestRejectedWidget> {

  @override
  Widget build(BuildContext context) {
    if (widget.visibilityBool){
      return Card(
        child: ListTile(
          title: Text('${widget.friend.username} hat deine Freundschaftsanfrage abgelehnt'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'löschen',
            onPressed:() {
              setState((){
                UserHandler().deleteFriendsRequestsRejected(widget.friend.userID);
                widget.visibilityBool = false;
              });
            }
          ),
        )
      );
    } else {
      return Visibility(
        visible: false,
        child: Card(
        child: ListTile(
          title: Text(''),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'löschen',
            onPressed:() {
              setState(){
                widget.visibilityBool = false;
              };
            }
          ),
        )
      )
      );
    }
  }
}

class FriendsLevelUpdatetWidget extends NewsWidget {

  FriendsLevelUpdatetWidget(this.friendsName, this.newLevel, {super.key});

  final String friendsName;
  final int newLevel;
  bool visibilityBool = true;

  @override
  State<FriendsLevelUpdatetWidget> createState() => _FriendsLevelUpdatetWidgetState();

}
class _FriendsLevelUpdatetWidgetState extends State<FriendsLevelUpdatetWidget> {

  @override
  Widget build(BuildContext context) {
    if( widget.visibilityBool){
      return Card(
        child: ListTile(
          title: Text('${widget.friendsName} ist in Level ${widget.newLevel.toString()} aufgestiegen'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'löschen',
            onPressed:() {
              setState((){
                widget.visibilityBool = false;
              });
            }
          ),
        )
      );
    } else {
      return Center();
    }
  }
}

class GameFinishedWidget extends NewsWidget {

  GameFinishedWidget(this.game, {super.key});
  GenericGame game;
  var visibilityBool = true;

  @override
  State<GameFinishedWidget> createState() => _GameFinishedWidgetState();

}
class _GameFinishedWidgetState extends State<GameFinishedWidget> {

  @override
  Widget build(BuildContext context) {
    if (widget.visibilityBool){
      return Card(
        child: ListTile(
          title: _getFinishedGamesText(widget.game),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'löschen',
            onPressed:() => {
              setState((){
                UserHandler().deletFinishedGamesIDsNews(widget.game.gameID!);
                widget.visibilityBool = false;
              }),
            }
          ),
        )
      );
    } else {
      return Visibility(
        visible: false,
        child: Card(
        child: ListTile(
          title: _getFinishedGamesText(widget.game),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'löschen',
            onPressed:() {
              setState(){
                widget.visibilityBool = false;
              };
            }
          ),
        )
      )
      );
    }
  }

  Widget _getFinishedGamesText(dynamic game){
    int totalPointsPlayer1;
    int totalPointsPlayer2;
    IconData icon = Icons.add;
    if (game is MemoryGame){
      totalPointsPlayer1 = game.player1Points!;
      totalPointsPlayer2 = game.player2Points!;
      print('memory game if');
      for (GameInfo info in GamesBibliothek(context).games){
        if (info.gameCategory == 1){
          icon = info.icon;
        }
      }
    } else {
      totalPointsPlayer1 = game.player1Points.reduce((value, element) => value + element);
      totalPointsPlayer2 = game.player2Points.reduce((value, element) => value + element);
      print('classic game else');
      for (GameInfo info in GamesBibliothek(context).games){
        if (info.gameCategory == 0){
          icon = info.icon;
        }
      }
    }
    String text;
    if (game.player1.userID == globalData.user!.userID){
      if ( totalPointsPlayer1 > totalPointsPlayer2){
        text = 'Du hast gegen ${game.player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} gewonnen';
      } else if (totalPointsPlayer1 == totalPointsPlayer2){
        text = 'Du hast gegen ${game.player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} gespielt';
      } else{
        text = 'Du hast gegen ${game.player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} verloren';
      }
    } else {
      if ( totalPointsPlayer2 > totalPointsPlayer1){
        text = 'Du hast gegen ${game.player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} gewonnen';
      } else if (totalPointsPlayer2 == totalPointsPlayer1){
        text = 'Du hast gegen ${game.player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} gespielt';
      } else{
        text = 'Du hast gegen ${game.player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} verloren';
      }
    }
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
                                                                              right: new BorderSide(width: 1.0, color: Colors.black))),
                                                                      child:Icon(icon),
                                                                    ),
                                                                  )
                                                                ),
                                                                Expanded(
                                                                  flex: 8,
                                                                  child: Container(
                                                                      padding: EdgeInsets.only(left: 10.0),
                                                                      child: Text(
                                                                        text
                                                                      ),
                                                                    ),
                                                                ),
                                                              ]
                                                            ),
    );
  }
}


class FriendsLevelUpdateWidget extends NewsWidget {

  FriendsLevelUpdateWidget(this.friend, {super.key});

  AppUser friend;
  var visibilityBool = true;

  @override
  State<FriendsLevelUpdateWidget> createState() => _FriendsLevelUpdateWidgetState();

}
class _FriendsLevelUpdateWidgetState extends State<FriendsLevelUpdateWidget> {

  @override
  Widget build(BuildContext context) {
    if (widget.visibilityBool){
      return Card(
        child: ListTile(
          title: Text('${widget.friend.username} ist in Level ${widget.friend.level} aufgestiegen'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'löschen',
            onPressed:() {
              setState((){
                UserHandler().deleteFriendsLevelUpdate(widget.friend.userID);
                widget.visibilityBool = false;
              });
            }
          ),
        )
      );
    } else {
      return Visibility(
        visible: false,
        child: Card(
        child: ListTile(
          title: Text(''),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'löschen',
            onPressed:() {
              setState(){
                widget.visibilityBool = false;
              };
            }
          ),
        )
      )
      );
    }
  }
}
