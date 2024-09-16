import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/navigationBar.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/handler/userHandler.dart';
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
  String selectedValueGame = '';
  String selectedValueFriend = "";
  late List<String> news = [];
  final _formKey = GlobalKey<FormState>();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  late Future<List<AppUser>> friends = fillFriends();

  List<AppUser> friendss = [];                  

  @override
  Widget build(BuildContext context) {
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
                                    child: _getNewsWidget()
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
                              flex: 8,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      height: 400,
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
                                    items: GamesBibliothek().games.map((i) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return Container(
                                            width: MediaQuery.of(context).size.width,
                                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: i.img,
                                                opacity: 0.8,
                                                fit: BoxFit.fitWidth,
                                              )
                                            ),
                                            child: Text(i.title, style: TextStyle(fontSize: 16.0),)
                                          );
                                        },
                                      );
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
                                    flex: 8,
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
                                                    Expanded(
                                                      flex: 5,
                                                      child: DropdownButtonFormField<String>(
                                                        isDense: true,
                                                        isExpanded: true,
                                                        value: GamesBibliothek().games[0].title,
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
                                                        items: GamesBibliothek().games.map<DropdownMenuItem<String>>((GameInfo game) {
                                                          return DropdownMenuItem<String>(
                                                            value: game.title,
                                                            child: Text(game.title),
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
                                                    Expanded(
                                                      flex: 5,
                                                      /** 
                                                      child: DropdownButtonFormField<String> (
                                                        isDense: true,
                                                        isExpanded: true,
                                                        value: "jggkghfjfhg",
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            selectedValueFriend = newValue!;
                                                          });
                                                        },
                                                        validator: (String? value) {
                                                          if (value == null || value.isEmpty) {
                                                            return 'Please select an option';
                                                          }
                                                          return null;
                                                        },
                                                        
                                                        items: friendss.map<DropdownMenuItem<String>>((AppUser friend) {
                                                          return DropdownMenuItem<String>(
                                                            value: friend.username,
                                                            child: Text(friend.username),
                                                          );
                                                        }).toList(),
                                                        
                                                      ),
                                                      */
                                                      child: FutureBuilder(
                                                        future: friends, 
                                                        builder: (context, snapshot){
                                                          if(snapshot.connectionState == ConnectionState.done && !snapshot.hasError){
                                                            return DropdownButtonFormField<String> (
                                                        isDense: true,
                                                        isExpanded: true,
                                                        value: snapshot.data![0].username,
                                                        onChanged: (String? newValue) {
                                                          setState(() {
                                                            selectedValueFriend = newValue!;
                                                          });
                                                        },
                                                        validator: (String? value) {
                                                          if (value == null || value.isEmpty) {
                                                            return 'Please select an option';
                                                          }
                                                          return null;
                                                        },
                                                        
                                                        items: snapshot.data!.map<DropdownMenuItem<String>>((AppUser friend) {
                                                          return DropdownMenuItem<String>(
                                                            value: friend.username,
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
                                              flex: 1,
                                              child: Center(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // Validate the entire form
                                                    if (_formKey.currentState!.validate()) {
                                                      // Code to handle valid form
                                                    }
                                                  },
                                                  child: Text(
                                                    'Start',
                                                    style: TextStyle(
                                                      fontSize: 20.0,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            )
                                            
                                            
                                            // ... Additional form fields
                                            
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
                      return Text(news[index]);
                    }
                  )
                )
            )
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
    late AppUser fakeUser = AppUser(userID: "", username: "---", level: 1, friendsIDs: friendsIDs, friendsRequestsSend: friendsRequestsSend, friendsRequestsReceived: friendsRequestsReceived, friendsRequestsAccepted: friendsRequestsAccepted, friendsRequestsRejected: friendsRequestsRejected, favouriteVocabulariesIDs: favouriteVocabulariesIDs, lastTestDate: "");
                        
    friends.add(fakeUser);
    for (String friendsID in userData.user!.friendsIDs){
      AppUser user = await UserHandler().findUserByID(friendsID);
      friends.add(user);
      
    }
    await friends;
    fillFriendss(friends);
    return friends;
  }

  void fillFriendss(List<AppUser> friends){
    for (AppUser frien in friends){
      this.friendss.add(frien);
    }

  }
}
/** 
class DropdownMenuExample extends StatefulWidget {

  List<GamesBibliothek>? games;
  DropdownMenuExample({super.key, this.games});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState(games: games);
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  List<GamesBibliothek> games;
  _DropdownMenuExampleState({required this.games});
  String dropdownValue = "---";

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: "---",
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: games.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
*/