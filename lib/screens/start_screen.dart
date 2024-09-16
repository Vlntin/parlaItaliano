
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/navigationBar.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/widgets/newsWidgets.dart';

class StartScreen extends StatefulWidget {

  const StartScreen({super.key});

  @override
  StartScreenState createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {

  late List<NewsWidget> news = _createNews();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(0),
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child:
          Column(
            children: [
              Expanded(
                flex: 1,
                child:
                  Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'Startseite',
                          style: TextStyle(
                            fontSize: 22.0,
                          fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text('Lerne themenbezogene Vokabeln, steige durch erfolgreiche Test auf, um neue Vokabeln freizuschalten. Mess dich dabei mit deinen Freunden in spannenden Online-Duellen'),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.grey
              ),
              Expanded(
                flex: 4,
                child: 
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  'News',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ),
                            Expanded(
                              flex: 5,
                              child: _getNewsWidget()
                            )
                          ],
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.grey
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  'Navigation',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                  fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ),
                            Expanded(
                              flex: 5,
                              child: Center(
                                child: Text(
                                  'Navigation',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                                  ),
                                ),
                              )
                            ),
                          ],
                        )
                      )
                    ],
                  )
              )
            ]
          )
      )
    );
  }

  _getNewsWidget(){
    if(news.length == 0){
      return Padding( 
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child:SizedBox.expand(                      
          child: Container(
            alignment:  Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.5
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color.fromARGB(255, 233, 233, 233),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
                child: Text('Es gibt aktuell keine News für dich. Hier werden dir Levelaufstiege deiner Freunde, Freundschaftsanfragen und Änderungen der Online-Spielstände angezeigt.', textAlign: TextAlign.center, ),  
            )
          )
        ) 
      );
    } else {
      return Padding( 
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SizedBox.expand(                      
          child: Container(
            alignment:  Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.5
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color.fromARGB(255, 233, 233, 233),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
                child:Flexible(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    //shrinkWrap: true,
                    itemCount: news.length,
                    itemBuilder: (context, index){
                      return news[index];
                    }
                  )
                )
            )
          )
        ) 
      );
    }
    
  }

  List<FriendsRequestWidget> _getAllFriendsRequests() {
    List<FriendsRequestWidget> requests = [];
    /** 
    for (String id in userData.user!.friendsRequestsReceived){
      String appuser = await UserHandler().findUserNameByID(id);
      await appuser;
      requests.add(appuser);
    }
    */
    for (String id in userData.user!.friendsRequestsReceived){
      requests.add(FriendsRequestWidget(id));
    }
    return requests;
  }

  List<FriendsRequestAcceptedWidget> _getAllFriendsAccepted() {
    List<FriendsRequestAcceptedWidget> friendRequests = [];
    /** 
    for (String id in userData.user!.friendsRequestsReceived){
      String appuser = await UserHandler().findUserNameByID(id);
      await appuser;
      requests.add(appuser);
    }
    */
    for (String id in userData.user!.friendsRequestsAccepted){
      friendRequests.add(FriendsRequestAcceptedWidget(id));
    }
    return friendRequests;
  }

  _createNews(){
    List<NewsWidget> news = [];
    List<FriendsRequestWidget> friendRequests = _getAllFriendsRequests();
    for (FriendsRequestWidget element in friendRequests){
      news.add(element);
    }

    List<FriendsRequestAcceptedWidget> friendAccepts = _getAllFriendsAccepted();
    for (FriendsRequestAcceptedWidget element in friendAccepts){
      news.add(element);
    }
    return news;
  }
}