
import 'package:flutter/material.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/games/frontendGame.dart';

import 'package:parla_italiano/handler/friendsHandler.dart';
import 'package:parla_italiano/handler/userHandler.dart';

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
          title: Container(
            padding: EdgeInsets.only(left: 0),
            child: Wrap(
              children: [ 
                Text(
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  '${widget.friend.username} hat dir eine Freundschaftsanfrage geschickt',
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),
              ]
            ),
          ),
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
          title: Container(
            padding: EdgeInsets.only(left: 0),
            child: Wrap(
              children: [ 
                Text(
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  '${widget.friend.username} hat deine Freundschaftsanfrage angenommen',
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),
              ]
            ),
          ),
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
          title: Container(
            padding: EdgeInsets.only(left: 0),
            child: Wrap(
              children: [ 
                Text(
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  '${widget.friend.username} hat deine Freundschaftsanfrage abgelehnt',
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),
              ]
            ),
          ),
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
          title: Container(
            padding: EdgeInsets.only(left: 0),
            child: Wrap(
              children: [ 
                Text(
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  '${widget.friendsName} ist in Level ${widget.newLevel.toString()} aufgestiegen',
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),
              ]
            ),
          ),
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
  FrontGame game;
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
          title: widget.game.getFinishedGamesWidget(),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'löschen',
            onPressed:() => {
              setState((){
                List<AppUser> playerIDs = widget.game.getGame().getPlayers();
                UserHandler().deletFinishedGamesIDsNews(widget.game.getGame().gameID!, playerIDs[0].userID);
                UserHandler().deletFinishedGamesIDsNews(widget.game.getGame().gameID!, playerIDs[1].userID);
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
          title: widget.game.getFinishedGamesWidget(),
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
          title: Container(
            padding: EdgeInsets.only(left: 0),
            child: Wrap(
              children: [ 
                Text(
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  '${widget.friend.username} ist in Level ${widget.friend.level} aufgestiegen',
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),
              ]
            ),
          ),
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
