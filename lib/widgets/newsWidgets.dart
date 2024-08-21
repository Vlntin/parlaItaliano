import 'package:flutter/material.dart';

import 'package:parla_italiano/handler/friendsHandler.dart';
import 'package:parla_italiano/screens/start_screen.dart';
import 'package:parla_italiano/screens/start_screen.dart';

class NewsWidget extends StatefulWidget{

  const NewsWidget({super.key});

  @override
  State<NewsWidget> createState() => _NewsWidgetState();

}
class _NewsWidgetState extends State<NewsWidget> {

  @override
  Widget build(BuildContext context) {
    return Center();
  }
}

class FriendsRequestWidget extends NewsWidget {

  FriendsRequestWidget(this.friendsName, {super.key});

  final String friendsName;
  bool visibilityBool = true;

  @override
  State<FriendsRequestWidget> createState() => _FriendsRequestWidgetState();

}
class _FriendsRequestWidgetState extends State<FriendsRequestWidget> {

  @override
  Widget build(BuildContext context) {
    if (widget.visibilityBool){
      return Padding(
              padding: EdgeInsets.all(0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        '${widget.friendsName} hat dir eine Freundschaftsanfrage geschickt',
                        style:TextStyle(
                          fontSize: 15,
                        )
                      ) ,
                    ),
                    Expanded(
                      flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                              flex:1,
                              child:IconButton(
                                icon: Icon(Icons.done_rounded),
                                alignment: AlignmentDirectional.centerStart,
                                onPressed: (){
                                  FriendsHandler().acceptFriendRequest(widget.friendsName);
                                  setState((){
                                    widget.visibilityBool = false;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(Icons.close),
                                alignment: AlignmentDirectional.centerEnd,
                                onPressed: (){
                                  FriendsHandler().rejectFriendRequest(widget.friendsName);
                                  setState(){
                                    widget.visibilityBool = false;
                                  };
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                )
          );
    } else {
      return Center();
    }
    
  }
}

class FriendsRequestAcceptedWidget extends NewsWidget {

  FriendsRequestAcceptedWidget(this.friendsName, {super.key});

  final String friendsName;
  var visibilityBool = true;

  @override
  State<FriendsRequestAcceptedWidget> createState() => _FriendsRequestAcceptedWidgetState();

}
class _FriendsRequestAcceptedWidgetState extends State<FriendsRequestAcceptedWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  '${widget.friendsName} hat deine Freundschaftsanfrage angenommen',
                  style:TextStyle(
                    fontSize: 15,
                  )
                ),
              ),
              Expanded(
                flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.delete),
                    alignment: AlignmentDirectional.centerEnd,
                    onPressed: (){
                      setState(){
                        widget.visibilityBool = false;
                      };
                    },
                  ),
                )
            ],
          )
    );
  }
}

class FriendsLevelUpdatetWidget extends StatefulWidget {

  const FriendsLevelUpdatetWidget(this.friendsName, this.newLevel, {super.key});

  final String friendsName;
  final int newLevel;

  @override
  State<FriendsLevelUpdatetWidget> createState() => _FriendsLevelUpdatetWidgetState();

}
class _FriendsLevelUpdatetWidgetState extends State<FriendsLevelUpdatetWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Center(
                  child: Text(
                    '${widget.friendsName} ist in Level ${widget.newLevel.toString()} aufgestiegen',
                    style:TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ) ,
              ),
              Expanded(
                flex: 1,
                child: Center() ,
              ),
            ],
          )
    );
  }
}