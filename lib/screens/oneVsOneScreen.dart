import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/games/classicGame/classicGame.dart';
import 'package:parla_italiano/games/generic/genericGame.dart';
import 'package:parla_italiano/games/memory/memoryGame.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/navigationBar.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/games/classicGame/classicGameHandler.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/models/gamesRepo.dart';
import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:parla_italiano/screens/classicGameScreen.dart';
import 'package:parla_italiano/screens/memoryScreen.dart';
import 'package:parla_italiano/widgets/newsWidgets.dart';
import 'package:parla_italiano/globals/gamesBibliothek.dart';

import 'package:carousel_slider/carousel_slider.dart';

class OneVSOneScreen extends StatefulWidget {

  const OneVSOneScreen({super.key});

  @override
  OneVSOneScreenState createState() => OneVSOneScreenState();
}

class OneVSOneScreenState extends State<OneVSOneScreen> {

  int currentPageIndex = 2;
                
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
          builder: ((context, constraints) {
            if (constraints.maxWidth > 1200){
              return OneVSOneScreenBig();
            } else {
              return OneVSOneScreenSmall();
            }
            
          })
        );
  }
}

class OneVSOneScreenBig extends StatefulWidget {

  const OneVSOneScreenBig({super.key});

  @override
  OneVSOneScreenStateBig createState() => OneVSOneScreenStateBig();
}

class OneVSOneScreenStateBig extends State<OneVSOneScreenBig> {

  int currentPageIndex = 2;

  String selectedValueGame = 'Klassisches Spiel';
  AppUser? _selectedOpponent;
  final _formKey = GlobalKey<FormState>();
  late Future<List<AppUser>> friends = fillFriends();
                

  @override
  Widget build(BuildContext context) {
    return PopScope(
    canPop: false,
    child: Scaffold(
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
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: _getRunningGamesWidget()
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
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: _getFinishedGamesWidget()
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
                                    items: GamesBibliothek(context).games.map((i) {
                                      return i.infoBoxBig;
                                    }).toList(),
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
                                                    fontSize: 22.0,
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
                                                          fontSize: 20.0,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Expanded(
                                                      flex: 4,
                                                      child: DropdownButtonFormField<String>(
                                                        isDense: true,
                                                        isExpanded: true,
                                                        value: GamesBibliothek(context).releasedGames[0].title,
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
                                                        items: GamesBibliothek(context).releasedGames.map<DropdownMenuItem<String>>((GameInfo game) {
                                                          return DropdownMenuItem<String>(
                                                            value: game.title,
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
                                                                      child:Icon(game.icon),
                                                                    ),
                                                                  )
                                                                ),
                                                                Expanded(
                                                                  flex: 8,
                                                                  child: Container(
                                                                      padding: EdgeInsets.only(left: 10.0),
                                                                      child: Text(
                                                                        game.title
                                                                      ),
                                                                    ),
                                                                ),
                                                              ]
                                                            ),
                                                          );
                                                        }).toList(),
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
                                                          fontSize: 20.0,
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
                                                          if (_formKey.currentState!.validate() && selectedValueGame == GamesBibliothek(context).releasedGames[0].title)  {
                                                            var data = await _collectData(userData.user!.userID, _selectedOpponent!.userID, userData.user!.userID, [0, 0, 0], [0, 0, 0], 1, 3, 30);
                                                            ClassicGame game = ClassicGame(gameID: '1', player1: userData.user!, player2: _selectedOpponent!, actualPlayer: userData.user!, player1Points: [0, 0, 0], player2Points: [0, 0, 0], actualRound: 1, totalRounds: 3, vocabularies: data[9], italianToGerman: data[11], finished: false);                                                      
                                                            String id = await ClassicGameHandler().createGame(game);
                                                            game.gameID = id;
                                                            userData.gamesRepo!.addGame(game);
                                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassicGameScreen(gameID: game.gameID), ));
                                                          } else if(_formKey.currentState!.validate() && selectedValueGame == GamesBibliothek(context).releasedGames[1].title){
                                                            List<Vocabulary> vocabs = [];
                                                            List<String> cardTexts = [];
                                                            VocabularyTable table = userData.vocabularyRepo!.vocabularyTables[0];
                                                            for (int i = 0; i < 10; i++){
                                                              vocabs.add(table.vocabularies[i]);
                                                              cardTexts.add(table.vocabularies[i].german);
                                                              cardTexts.add(table.vocabularies[i].italian);
                                                            }
                                                            MemoryGame memoryGame = MemoryGame(player1: userData.user!, player2: _selectedOpponent!, actualPlayer: userData.user!);
                                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemoryScreen(game: memoryGame) ));
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
    )
    );
  }

  Widget _getVocabularyLevelText(){
    if (_selectedOpponent != null){
      if (_selectedOpponent!.userID != "" ){
        return Expanded(
          flex: 1,
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

  _getRunningGamesWidget(){
    List<dynamic> list = userData.gamesRepo!.games;
    if(list.length == 0){
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
                child: Text('Du hast aktuell keine offenen Spiele. Fordere deine Freunde heraus!', textAlign: TextAlign.center, ),  
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
                    //shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          title: list[index] is ClassicGame
                          ? Row(
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
                                                                      child:Icon(GamesBibliothek(context).games.firstWhere((element) => element.gameCategory == 0).icon),
                                                                    ),
                                                                  )
                                                                ),
                                                                Expanded(
                                                                  flex: 7,
                                                                  child: Container(
                                                                      padding: EdgeInsets.only(left: 10.0),
                                                                      child: Text(
                                                                        'Spiele Runde ${list[index].actualRound} gegen ${userData.user!.userID == list[index].player2.userID ? list[index].player1.username : list[index].player2.username}'
                                                                      ),
                                                                    ),
                                                                ),
                                                              ]
                                                            )
                          : Row(
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
                                                                      child:Icon(GamesBibliothek(context).games.firstWhere((element) => element.gameCategory == 1).icon),
                                                                    ),
                                                                  )
                                                                ),
                                                                Expanded(
                                                                  flex: 7,
                                                                  child: Container(
                                                                      padding: EdgeInsets.only(left: 10.0),
                                                                      child: Text(
                                                                        'Spiele gegen ${userData.user!.userID == list[index].player2.userID ? list[index].player1.username : list[index].player2.username}'
                                                                      ),
                                                                    ),
                                                                ),
                                                              ]
                                                            ),


                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                              onPressed: () => {
                                list[index] is ClassicGame
                                ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassicGameScreen(gameID: userData.gamesRepo!.games[index].gameID), ))
                                : Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemoryScreen(game: userData.gamesRepo!.games[index]), ))
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
            )
          )
        ) 
      );
    }
    
  }

  _getFinishedGamesWidget(){
    List<dynamic> list = userData.gamesRepo!.finishedGames;
    if(list.length == 0){
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
                child: Text('Du hast noch keine Spiele beendet. Spiele gegen Freunde um hier deine Historie zu sehen!', textAlign: TextAlign.center, ),  
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
                    //shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          title: _getFinishedGamesText(list[index])
                        )
                      );
                    }
                  )
                )
            )
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
      for (GameInfo info in GamesBibliothek(context).games){
        if (info.gameCategory == 1){
          icon = info.icon;
        }
      }
    } else {
      totalPointsPlayer1 = game.player1Points.reduce((value, element) => value + element);
      totalPointsPlayer2 = game.player2Points.reduce((value, element) => value + element);
      for (GameInfo info in GamesBibliothek(context).games){
        if (info.gameCategory == 0){
          icon = info.icon;
        }
      }
    }
    String text;
    if (game is MemoryGame){
      if (game.player1.userID == userData.user!.userID){
        if ( totalPointsPlayer1 < totalPointsPlayer2){
          text = 'Du hast gegen ${game.player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} gewonnen';
        } else if (totalPointsPlayer1 == totalPointsPlayer2){
          text = 'Du hast gegen ${game.player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} gespielt';
        } else{
          text = 'Du hast gegen ${game.player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} verloren';
        }
      } else {
        if ( totalPointsPlayer2 < totalPointsPlayer1){
          text = 'Du hast gegen ${game.player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} gewonnen';
        } else if (totalPointsPlayer2 == totalPointsPlayer1){
          text = 'Du hast gegen ${game.player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} gespielt';
        } else{
          text = 'Du hast gegen ${game.player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} verloren';
        }
      }
    } else {
      if (game.player1.userID == userData.user!.userID){
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


class OneVSOneScreenSmall extends StatefulWidget {

  const OneVSOneScreenSmall({super.key});

  @override
  OneVSOneScreenStateSmall createState() => OneVSOneScreenStateSmall();
}

class OneVSOneScreenStateSmall extends State<OneVSOneScreenSmall> {

  int currentPageIndex = 2;

  String selectedValueGame = 'Klassisches Spiel';
  AppUser? _selectedOpponent;
  final _formKey = GlobalKey<FormState>();
  late Future<List<AppUser>> friends = fillFriends();
                

  @override
  Widget build(BuildContext context) {
    return PopScope(
    canPop: false,
    child: Scaffold(
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: _getRunningGamesWidget()
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    )
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: _getFinishedGamesWidget()
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
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                                    items: GamesBibliothek(context).games.map((i) {
                                      return i.infoBoxSmall;
                                    }).toList(),
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
                                                    fontSize: 18.0,
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
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Expanded(
                                                      flex: 4,
                                                      child: DropdownButtonFormField<String>(
                                                        isDense: true,
                                                        isExpanded: true,
                                                        value: GamesBibliothek(context).releasedGames[0].title,
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
                                                        items: GamesBibliothek(context).releasedGames.map<DropdownMenuItem<String>>((GameInfo game) {
                                                          return DropdownMenuItem<String>(
                                                            value: game.title,
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
                                                                      child:Icon(game.icon),
                                                                    ),
                                                                  )
                                                                ),
                                                                Expanded(
                                                                  flex: 8,
                                                                  child: Container(
                                                                      padding: EdgeInsets.only(left: 10.0),
                                                                      child: Text(
                                                                        game.title
                                                                      ),
                                                                    ),
                                                                ),
                                                              ]
                                                            ),
                                                          );
                                                        }).toList(),
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
                                                          fontSize: 16.0,
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
                                                          if (_formKey.currentState!.validate() && selectedValueGame == GamesBibliothek(context).releasedGames[0].title)  {
                                                            var data = await _collectData(userData.user!.userID, _selectedOpponent!.userID, userData.user!.userID, [0, 0, 0], [0, 0, 0], 1, 3, 30);
                                                            ClassicGame game = ClassicGame(gameID: '1', player1: userData.user!, player2: _selectedOpponent!, actualPlayer: userData.user!, player1Points: [0, 0, 0], player2Points: [0, 0, 0], actualRound: 1, totalRounds: 3, vocabularies: data[9], italianToGerman: data[11], finished: false);                                                      
                                                            String id = await ClassicGameHandler().createGame(game);
                                                            game.gameID = id;
                                                            userData.gamesRepo!.addGame(game);
                                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassicGameScreen(gameID: game.gameID), ));
                                                          } else if(_formKey.currentState!.validate() && selectedValueGame == GamesBibliothek(context).releasedGames[1].title){
                                                            List<Vocabulary> vocabs = [];
                                                            List<String> cardTexts = [];
                                                            VocabularyTable table = userData.vocabularyRepo!.vocabularyTables[0];
                                                            for (int i = 0; i < 10; i++){
                                                              vocabs.add(table.vocabularies[i]);
                                                              cardTexts.add(table.vocabularies[i].german);
                                                              cardTexts.add(table.vocabularies[i].italian);
                                                            }
                                                            MemoryGame memoryGame = MemoryGame(player1: userData.user!, player2: _selectedOpponent!, actualPlayer: userData.user!);
                                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MemoryScreen(game: memoryGame) ));
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
                                                              fontSize: 16
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
    )
    );
  }

  Widget _getVocabularyLevelText(){
    if (_selectedOpponent != null){
      if (_selectedOpponent!.userID != "" ){
        return Expanded(
          flex: 1,
          child: Center(
            child: Text(
              'Das Spiel wird Vokabeln bis Level ${min(_selectedOpponent!.level, userData.user!.level)} beinhalten',
              style: TextStyle(
                fontSize: 12
              ),
            )
          )
        );
      }
    } 
    return Visibility(
      visible: false,
      child: Text('')
    );
  }

  _getRunningGamesWidget(){
    List<dynamic> list = userData.gamesRepo!.games;
    if(list.length == 0){
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
                child: Text('Du hast aktuell keine offenen Spiele. Fordere deine Freunde heraus!', textAlign: TextAlign.center, ),  
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
                    //shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          title: list[index] is ClassicGame
                          ? Row(
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
                                                                      child:Icon(GamesBibliothek(context).games.firstWhere((element) => element.gameCategory == 0).icon),
                                                                    ),
                                                                  )
                                                                ),
                                                                Expanded(
                                                                  flex: 7,
                                                                  child: Container(
                                                                      padding: EdgeInsets.only(left: 10.0),
                                                                      child: Text(
                                                                        'Spiele Runde ${list[index].actualRound} gegen ${userData.user!.userID == list[index].player2.userID ? list[index].player1.username : list[index].player2.username}'
                                                                      ),
                                                                    ),
                                                                ),
                                                              ]
                                                            )
                          : Row(
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
                                                                      child:Icon(GamesBibliothek(context).games.firstWhere((element) => element.gameCategory == 1).icon),
                                                                    ),
                                                                  )
                                                                ),
                                                                Expanded(
                                                                  flex: 7,
                                                                  child: Container(
                                                                      padding: EdgeInsets.only(left: 10.0),
                                                                      child: Text(
                                                                        'Spiele gegen ${userData.user!.userID == list[index].player2.userID ? list[index].player1.username : list[index].player2.username}'
                                                                      ),
                                                                    ),
                                                                ),
                                                              ]
                                                            ),


                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                              onPressed: () => { 
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClassicGameScreen(gameID: userData.gamesRepo!.games[index].gameID), ))
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
            )
          )
        ) 
      );
    }
    
  }

  _getFinishedGamesWidget(){
    List<dynamic> list = userData.gamesRepo!.finishedGames;
    if(list.length == 0){
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
                child: Text('Du hast noch keine Spiele beendet. Spiele gegen Freunde um hier deine Historie zu sehen!', textAlign: TextAlign.center, ),  
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
                    //shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (context, index){
                      return Card(
                        child: ListTile(
                          title: _getFinishedGamesText(list[index])
                        )
                      );
                    }
                  )
                )
            )
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
      for (GameInfo info in GamesBibliothek(context).games){
        if (info.gameCategory == 1){
          icon = info.icon;
        }
      }
    } else {
      totalPointsPlayer1 = game.player1Points.reduce((value, element) => value + element);
      totalPointsPlayer2 = game.player2Points.reduce((value, element) => value + element);
      for (GameInfo info in GamesBibliothek(context).games){
        if (info.gameCategory == 0){
          icon = info.icon;
        }
      }
    }
    String text;
    if (game is MemoryGame){
      if (game.player1.userID == userData.user!.userID){
        if ( totalPointsPlayer1 < totalPointsPlayer2){
          text = 'Du hast gegen ${game.player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} gewonnen';
        } else if (totalPointsPlayer1 == totalPointsPlayer2){
          text = 'Du hast gegen ${game.player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} gespielt';
        } else{
          text = 'Du hast gegen ${game.player2.username} ${totalPointsPlayer1} : ${totalPointsPlayer2} verloren';
        }
      } else {
        if ( totalPointsPlayer2 < totalPointsPlayer1){
          text = 'Du hast gegen ${game.player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} gewonnen';
        } else if (totalPointsPlayer2 == totalPointsPlayer1){
          text = 'Du hast gegen ${game.player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} gespielt';
        } else{
          text = 'Du hast gegen ${game.player1.username} ${totalPointsPlayer2} : ${totalPointsPlayer1} verloren';
        }
      }
    } else {
      if (game.player1.userID == userData.user!.userID){
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