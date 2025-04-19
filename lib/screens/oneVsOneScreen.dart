import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/games/GameType.dart';
import 'package:parla_italiano/games/classicGame/classicGame.dart';
import 'package:parla_italiano/games/frontendGame.dart';
import 'package:parla_italiano/games/memory/memoryGame.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/navigationBar.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/games/classicGame/classicGameHandler.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:parla_italiano/screens/classicGameScreen.dart';
import 'package:parla_italiano/screens/memoryScreen.dart';

import 'package:carousel_slider/carousel_slider.dart';

class OneVSOneScreen extends StatefulWidget {

  const OneVSOneScreen({super.key});

  @override
  OneVSOneScreenState createState() => OneVSOneScreenState();
}

class OneVSOneScreenState extends State<OneVSOneScreen> {

  int currentPageIndex = 2;
  String selectedValueGame = 'Klassisches Spiel';
  AppUser? _selectedOpponent;
  final _formKey = GlobalKey<FormState>();
  late Future<List<AppUser>> friends = fillFriends();
                
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        if (constraints.maxWidth > 1200){
          return getScalableOneVSOneScreen(22.0, context);
        } else if (constraints.maxWidth > 500) {
          return getScalableOneVSOneScreen(18.0, context);
        } else {
          return getSmartphoneOneVSOneScreen(context);
        }
      })
    );
  }                

  Scaffold getScalableOneVSOneScreen(double fontSize, BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(currentPageIndex),
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
                          '1 vs 1',
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
                        child: Text('Tritt hier gegen deine Freunde in 1 vs 1 Spielen an! Fordere sie heraus und zeig ihnen wie scheiße sie sind!'),
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
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        'Spielstände',
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: _getRunningGamesWidget(false)
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
                                        'Spielhistorie',
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: _getFinishedGamesWidget(false)
                                  )
                                ]
                              )
                            ),
                            
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
                              flex: 7,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                                child: Center(
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      height: 350,
                                      aspectRatio: 16/9,
                                      viewportFraction: 0.8,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 3),
                                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      enlargeFactor: 0.3,
                                      scrollDirection: Axis.horizontal,
                                    ),
                                    items: _getCaruselItems()
                                  )
                                ),
                              )
                              
                            ),

                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text(
                                                  'Neues Spiel',
                                                  style: TextStyle(
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                            ),
                            Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                                      child: Form(
                                        key: _formKey,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        'Spiel:',
                                                        style: TextStyle(
                                                          fontSize: fontSize - 2,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Expanded(
                                                      flex: 4,
                                                      child: DropdownButtonFormField<String>(
                                                        isDense: true,
                                                        isExpanded: true,
                                                        value: GameType.classicGame.info.title,
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            selectedValueGame = newValue!;
                                                          });
                                                        },
                                                        validator: (String? value) {
                                                          if (value == null || value.isEmpty) {
                                                            return 'Please select an option';
                                                          }
                                                          return null;
                                                        },
                                                        items: _getDropdownMenuItemsForGames(),
                                                      ),
                                                    )
                                                  ]
                                                )
                                              )
                                              
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        'Gegner:',
                                                        style: TextStyle(
                                                          fontSize: fontSize - 2,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Expanded(
                                                      flex: 4,
                                                      child: FutureBuilder(
                                                        future: friends, 
                                                        builder: (context, snapshot){
                                                          if(snapshot.connectionState == ConnectionState.done && !snapshot.hasError){
                                                            return DropdownButtonFormField<AppUser> (
                                                        isDense: true,
                                                        isExpanded: true,
                                                        value: snapshot.data![0],
                                                        onChanged: (AppUser? newValue) {
                                                          setState(() {
                                                            _selectedOpponent = newValue!;
                                                          });
                                                        },
                                                        validator: (AppUser? value) {
                                                          if (value == null ||  value.username == "---") {
                                                            return 'Wähle einen Gegner';
                                                          }
                                                          return null;
                                                        },
                                                        
                                                        items: snapshot.data!.map<DropdownMenuItem<AppUser>>((AppUser friend) {
                                                          return DropdownMenuItem<AppUser>(
                                                            value: friend,
                                                            child: Text(friend.username),
                                                          );
                                                        }).toList(),
                                                        
                                                      );
                                                          } else {
                                                            return Text ('Laden...');
                                                          }
                                                        }
                                                      )
                                                    )
                                                  ]
                                                )
                                              )
                                              
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                children: [
                                                  _getVocabularyLevelText(),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          if (_formKey.currentState!.validate() && selectedValueGame == GameType.classicGame.info.title)  {
                                                            var data = await _collectData(userData.user!.userID, _selectedOpponent!.userID, userData.user!.userID, [0, 0, 0], [0, 0, 0], 1, 3, 30);
                                                            ClassicGame game = ClassicGame(gameID: '1', player1: userData.user!, player2: _selectedOpponent!, actualPlayer: userData.user!, player1Points: [0, 0, 0], player2Points: [0, 0, 0], actualRound: 1, totalRounds: 3, vocabularies: data[9], italianToGerman: data[11], finished: false);                                                      
                                                            String id = await ClassicGameHandler().createGame(game);
                                                            game.gameID = id;
                                                            userData.gamesRepo!.addGame(FrontGame(game, GameType.classicGame));
                                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassicGameScreen(game: FrontGame(game, GameType.classicGame)), ));
                                                          } else if(_formKey.currentState!.validate() && selectedValueGame == GameType.memory.info.title){
                                                            List<Vocabulary> vocabs = [];
                                                            List<String> cardTexts = [];
                                                            VocabularyTable table = userData.vocabularyRepo!.vocabularyTables[0];
                                                            for (int i = 0; i < 10; i++){
                                                              vocabs.add(table.vocabularies[i]);
                                                              cardTexts.add(table.vocabularies[i].german);
                                                              cardTexts.add(table.vocabularies[i].italian);
                                                            }
                                                            MemoryGame memoryGame = MemoryGame(player1: userData.user!, player2: _selectedOpponent!, actualPlayer: userData.user!);
                                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemoryScreen(game: FrontGame(memoryGame, GameType.memory)) ));
                                                          }
                                                          userData.gamesRepo = userData.gamesRepo;
                                                          
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          alignment: Alignment.center,
                                                          backgroundColor: Colors.white,
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(5),
                                                          child: Text(
                                                            "Spielen",
                                                            style: TextStyle(
                                                              fontSize: fontSize - 2
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  )
                                                ],
                                              )
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
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

  Scaffold getSmartphoneOneVSOneScreen(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(currentPageIndex),
      appBar: CustomAppBarSmartphone(actualPageName: "1 vs 1"),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child:
            Column(
              children: [
                const SizedBox(height: 10),
                Text('Tritt hier gegen deine Freunde in 1 vs 1 Spielen an! Fordere sie heraus und zeig ihnen wie scheiße sie sind!'),
                Divider(
                  color: Colors.grey
                ),
                Text(
                  'Spielstände',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ),
                _getRunningGamesWidget(true),
                Divider(
                  color: Colors.grey
                ),
                Text(
                  'Spielhistorie',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ),
                _getFinishedGamesWidget(true),
                Divider(
                  color: Colors.grey
                ),
                Center(
                                    child: CarouselSlider(
                                      options: CarouselOptions(
                                        height: 350,
                                        aspectRatio: 16/9,
                                        viewportFraction: 0.8,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: true,
                                        autoPlayInterval: Duration(seconds: 3),
                                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        enlargeFactor: 0.3,
                                        scrollDirection: Axis.horizontal,
                                      ),
                                      items: _getCaruselItems()
                                    )
                ),
                Divider(
                  color: Colors.grey
                ),
                SizedBox(height: 10),
                Text(
                  'Neues Spiel',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      'Spiel:',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                        flex: 3,
                                                        child: DropdownButtonFormField<String>(
                                                          isDense: true,
                                                          isExpanded: true,
                                                          value: GameType.classicGame.info.title,
                                                          onChanged: (String? newValue) {
                                                            setState(() {
                                                              selectedValueGame = newValue!;
                                                            });
                                                          },
                                                          validator: (String? value) {
                                                            if (value == null || value.isEmpty) {
                                                              return 'Please select an option';
                                                            }
                                                            return null;
                                                          },
                                                          items: _getDropdownMenuItemsForGames(),
                                                        ),
                                                  )
                                            ]
                                                
                                          ),
                                          Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      'Gegner:',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Expanded(
                                                        flex: 3,
                                                        child: FutureBuilder(
                                                          future: friends, 
                                                          builder: (context, snapshot){
                                                            if(snapshot.connectionState == ConnectionState.done && !snapshot.hasError){
                                                              return DropdownButtonFormField<AppUser> (
                                                          isDense: true,
                                                          isExpanded: true,
                                                          value: snapshot.data![0],
                                                          onChanged: (AppUser? newValue) {
                                                            setState(() {
                                                              _selectedOpponent = newValue!;
                                                            });
                                                          },
                                                          validator: (AppUser? value) {
                                                            if (value == null ||  value.username == "---") {
                                                              return 'Wähle einen Gegner';
                                                            }
                                                            return null;
                                                          },
                                                          
                                                          items: snapshot.data!.map<DropdownMenuItem<AppUser>>((AppUser friend) {
                                                            return DropdownMenuItem<AppUser>(
                                                              value: friend,
                                                              child: Text(friend.username),
                                                            );
                                                          }).toList(),
                                                          
                                                        );
                                                            } else {
                                                              return Text ('Laden...');
                                                            }
                                                          }
                                                        )
                                                  )
                                            ]
                                                
                                          ),
                                          SizedBox(height: 10),
                                          Column(
                                                  children: [
                                                    _getVocabularyLevelText(),
                                                    Center(
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            if (_formKey.currentState!.validate() && selectedValueGame == GameType.classicGame.info.title)  {
                                                              var data = await _collectData(userData.user!.userID, _selectedOpponent!.userID, userData.user!.userID, [0, 0, 0], [0, 0, 0], 1, 3, 30);
                                                              ClassicGame game = ClassicGame(gameID: '1', player1: userData.user!, player2: _selectedOpponent!, actualPlayer: userData.user!, player1Points: [0, 0, 0], player2Points: [0, 0, 0], actualRound: 1, totalRounds: 3, vocabularies: data[9], italianToGerman: data[11], finished: false);                                                      
                                                              String id = await ClassicGameHandler().createGame(game);
                                                              game.gameID = id;
                                                              userData.gamesRepo!.addGame(FrontGame(game, GameType.classicGame));
                                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassicGameScreen(game: FrontGame(game, GameType.classicGame)), ));
                                                            } else if(_formKey.currentState!.validate() && selectedValueGame == GameType.memory.info.title){
                                                              List<Vocabulary> vocabs = [];
                                                              List<String> cardTexts = [];
                                                              VocabularyTable table = userData.vocabularyRepo!.vocabularyTables[0];
                                                              for (int i = 0; i < 10; i++){
                                                                vocabs.add(table.vocabularies[i]);
                                                                cardTexts.add(table.vocabularies[i].german);
                                                                cardTexts.add(table.vocabularies[i].italian);
                                                              }
                                                              MemoryGame memoryGame = MemoryGame(player1: userData.user!, player2: _selectedOpponent!, actualPlayer: userData.user!);
                                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemoryScreen(game: FrontGame(memoryGame, GameType.memory)) ));
                                                            }
                                                            userData.gamesRepo = userData.gamesRepo;
                                                            
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            alignment: Alignment.center,
                                                            backgroundColor: Colors.white,
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets.all(5),
                                                            child: Text(
                                                              "Spielen",
                                                              style: TextStyle(
                                                                fontSize: 18
                                                              ),
                                                            ),
                                                          ),
                                                      )
                                                    )
                                                  ],
                                                )
                    ]
                  )
                                        
                ),
                SizedBox(height: 50)
                                                  
                                              
                                              
              ],
            )
        )
      )
    );
  }

  List<DropdownMenuItem<String>> _getDropdownMenuItemsForGames(){
    List<DropdownMenuItem<String>> items = [];
    for (GameType gametype in GameType.values){
      items.add(
        DropdownMenuItem<String>(
          value: gametype.info.title,
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
                    child:Icon(gametype.info.icon),
                  ),
                )
              ),
              Expanded(
                flex: 8,
                child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    gametype.info.title
                  ),
                ),
              ),
            ]
          ),
        )
      );
    }
    return items;
  }

  List<Widget> _getCaruselItems(){
    List<Widget> widgets = [];
    for (GameType gametype in GameType.values){
      widgets.add(Text(gametype.info.title));
    }
    return widgets;
  }

  Widget _getVocabularyLevelText(){
    if (_selectedOpponent != null){
      if (_selectedOpponent!.userID != "" ){
        return Padding(
          padding:EdgeInsets.all(10),
          child: Center(
            child: Text('Das Spiel wird Vokabeln bis Level ${min(_selectedOpponent!.level, userData.user!.level)} beinhalten')
          )
        );
      }
    } 
    return Visibility(
      visible: false,
      child: Text('')
    );
  }

  _getRunningGamesWidget(bool smartphoneView){
    if(smartphoneView) {
      return Padding( 
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child:SizedBox(
          width: double.infinity,
          height: 300,                       
          child: _getRunningGamesContainer()
        ) 
      );
    } else {
      return Padding( 
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SizedBox.expand(                    
          child: _getRunningGamesContainer()
          ) 
      );
    }
  }

  Container _getRunningGamesContainer() {
    List<FrontGame> list = userData.gamesRepo!.games;
    if (list.length == 0) {
      return Container(
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
                child: Text('Du hast aktuell keine offenen Spiele. Fordere deine Freunde heraus!', textAlign: TextAlign.center, ),  
            )
          );
    } else {
      return Container(
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
                    //shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          title: list[index].getGameText(context),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                              onPressed: () => {
                                list[index].clickedOnPlaying(context, index)
                              }, 
                              icon: Icon(Icons.check),
                              tooltip: 'weiterspielen',
                              ),
                              IconButton(
                                onPressed: () => {

                                }, 
                                icon: Icon(Icons.close),
                                tooltip: 'aufgeben',
                              )
                            ],
                          )
                        )
                      );
                    }
                  )
                )
            );
    }
    
  }

  _getFinishedGamesWidget(bool isSmartphoneView) {
    if(isSmartphoneView){
      return Padding( 
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child:SizedBox(
          width: double.infinity,
          height: 300,                      
          child: _getFinishedGamesContainer()
        ) 
      );
    } else {
      return Padding( 
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SizedBox.expand(                      
          child: _getFinishedGamesContainer()
          ) 
      );
    }
  }

  Container _getFinishedGamesContainer() {
    List<FrontGame> list = userData.gamesRepo!.finishedGames;
    if(list.length == 0){
      return Container(
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
                child: Text('Du hast noch keine Spiele beendet. Spiele gegen Freunde um hier deine Historie zu sehen!', textAlign: TextAlign.center, ),  
            )
          );
    } else {
      return Container(
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
                    //shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          title: list[index].getFinishedGamesWidget()
                        )
                      );
                    }
                  )
                )
            );
    }
  }

  Future<List<AppUser>> fillFriends() async{
    List<AppUser> friends = [];
    List<String> friendsIDs = [];
    List<String> friendsRequestsSend = [];
    List<String> friendsRequestsReceived = [];
    List<String> friendsRequestsAccepted = [];
    List<String> friendsRequestsRejected = [];
    List<String> favouriteVocabulariesIDs = [];
    List<String> finishedGamesIDsNews = [];
    List<String> friendsLevelUpdate = [];
    late AppUser fakeUser = AppUser(userID: "", username: "---", level: 1, friendsIDs: friendsIDs, friendsRequestsSend: friendsRequestsSend, friendsRequestsReceived: friendsRequestsReceived, friendsRequestsAccepted: friendsRequestsAccepted, friendsRequestsRejected: friendsRequestsRejected, favouriteVocabulariesIDs: favouriteVocabulariesIDs, lastTestDate: "", finishedGamesIDsNews:  finishedGamesIDsNews, friendsLevelUpdate: friendsLevelUpdate);
                        
    friends.add(fakeUser);
    for (String friendsID in userData.user!.friendsIDs){
      AppUser user = await UserHandler().findUserByID(friendsID);
      friends.add(user);
    }
    await friends;
    return friends;
  }

  _collectData( player1ID, player2ID, actualPlayerID, player1Points, player2Points, actualRound, totalRounds, neededVocabularies) async{
    var data = [];
    Future<AppUser> player11 = UserHandler().findUserByID(player1ID);
    Future<AppUser> player22 = UserHandler().findUserByID(player2ID);
    Future<AppUser> actualPlayer2 = UserHandler().findUserByID(actualPlayerID);
    List<AppUser> results = await Future.wait([player11, player22, actualPlayer2]);
    List<String> questions = [];
    List<String> solutions = [];
    AppUser player1 = results[0];
    AppUser  player2 = results[1];
    AppUser  actualPlayer = results[2];
    int roundNumbers = totalRounds;
    List<Vocabulary> vocabularies = userData.vocabularyRepo!.generateVocabulariesTillLevel(player1.level < player2.level ? player1.level : player2.level, neededVocabularies);
    List<bool> italianToGerman = [];
    for (Vocabulary vocabulary in vocabularies){
      Random random = new Random();
      int randomNumber = random.nextInt(2);
      if (randomNumber == 0){
        questions.add(vocabulary.german);
        italianToGerman.add(false);
        solutions.add(vocabulary.italian);
      } else {
        italianToGerman.add(true);
        solutions.add(vocabulary.german);
        questions.add(vocabulary.italian);
      }
    }
    List<String> vocabulariesIDs = [];
    for(Vocabulary vocabulary in vocabularies){
      vocabulariesIDs.add(vocabulary.italian);
    }
    int  currentIndex = (actualRound - 1) * (neededVocabularies / roundNumbers).toInt();
    for (int i = 0; i < vocabularies.length; i++){
      Vocabulary vocabulary = vocabularies[i];
      bool italToGerman = italianToGerman[i];
        
      if (italToGerman){
        questions.add(vocabulary.italian);
        solutions.add(vocabulary.german);
      } else {
        questions.add(vocabulary.german);
        solutions.add(vocabulary.italian);
      }
        
    }
    data.add(player1);
    data.add(player2);
    data.add(actualPlayer);
    data.add(roundNumbers);
    data.add(vocabularies);
    data.add(neededVocabularies);
    data.add(currentIndex);
    data.add(solutions);
    data.add(questions);
    data.add(vocabularies);
    data.add(vocabulariesIDs);
    data.add(italianToGerman);
    return data;
  }
}