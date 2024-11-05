
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/navigationBar.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/widgets/newsWidgets.dart';

enum ChangeCategory {brandNew, change, bugfix}

class VersionChange{

  ChangeCategory category;
  String text;

  VersionChange(this.category, this.text);

}

class StartScreen extends StatefulWidget {

  const StartScreen({super.key});

  @override
  StartScreenState createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen> {

  List<NewsWidget> news =  userData.news;
  int currentPageIndex = 0;
  List<String> startingSteps = ['Das ist die Startseite. Hier findest du jederzeit alle Neuigkeiten über deine Freunde, Spiele oder die letzten Updates', 'Schicke Freundesanfragen über das Icon in der Titelleiste. Nur so kannst du später gegen deine Freunde antreten', 'In der Vokabelübersicht findet du alle aktuellen Vokabeln. Lerne sie und erstelle zusätzlich deine eigene Favoritenliste', 'Durch Tests kannst du Level aufsteigen und neue Vokabeln freischalten. Du kannst sie aber nur ein mal am Tag starten', 'Starte im 1 vs 1 spannende Spiele gegen alle deine Freunde und findet so heraus, wer noch besser Vokabeln lernen muss', 'Lets go und viel Spaß!'];
  List<VersionChange> versionChanges =[
    VersionChange(ChangeCategory.brandNew, 'Level 1 - Level ${userData.vocabularyRepo!.vocabularyTables.length} wurden hinzugefügt'),
    VersionChange(ChangeCategory.brandNew, 'Klassisches Spiel wurde hinzugefügt'),
    VersionChange(ChangeCategory.brandNew, 'Memory wurde hinzugefügt'),
    VersionChange(ChangeCategory.brandNew, 'Testsystem wurde hinzugefügt'),
    VersionChange(ChangeCategory.brandNew, 'Freundesystem wurde hinzugefügt'),
  ];

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
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        'Version 1.0',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: _getVersionUpdatesWidget()
                                  )
                                ]
                              )
                            ),
                             Divider(
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
                                        'Starthilfe',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: _getStartWidget()
                                  )
                                ]
                              )
                            ),
                            
                          ],
                        ),
                      ),
                    ],
                  )
              )
            ]
          )
      )
      
    );
  }

  _getStartStepsCard(int stepNumber, String stepText){
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(right: 15.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(width: 1.0, color: Colors.black))),
                  child: Text(
                    stepNumber.toString(),
                    style: TextStyle(
                      fontSize: 12
                    ),
                  ),
                ),
              )
            ),
            Expanded(
              flex: 14,
              child: Container(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    stepText,
                    style: TextStyle(
                      fontSize: 12
                    ),
                  ),
                ),
            ),
          ],
        ),
      )
    );
  }

  _getStartWidget(){
    return Padding( 
        padding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 30),
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
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                //shrinkWrap: true,
                itemCount: startingSteps.length,
                itemBuilder: (context, index){
                  return _getStartStepsCard(index + 1, startingSteps[index]);
                }
              )
            )
          )
        ) 
      );
  }

   _getUpdateChangesCard(VersionChange change){
    IconData matchingIcon = Icons.bug_report;
    if (change.category == ChangeCategory.brandNew){
      matchingIcon = Icons.present_to_all;
    } else if (change.category == ChangeCategory.change){
      matchingIcon = Icons.change_circle;
    }
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: Icon(matchingIcon)
              )
            ),
            Expanded(
              flex: 10,
              child: Container(
                  padding: EdgeInsets.only(left: 0),
                  child: Text(
                    change.text,
                    style: TextStyle(
                      fontSize: 12
                    ),
                  ),
                ),
            ),
          ],
        ),
      )
    );
  }

  _getVersionUpdatesWidget(){
    return Padding( 
        padding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 30),
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
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                //shrinkWrap: true,
                itemCount: versionChanges.length,
                itemBuilder: (context, index){
                  return _getUpdateChangesCard(versionChanges[index]);
                }
              )
            )
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
      );
    }
    
  }
}