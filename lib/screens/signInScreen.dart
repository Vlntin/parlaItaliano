import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/globals/globalData.dart' as UserDataGlobals;
import 'package:parla_italiano/adminScreens/globalData.dart' as AdminGlobals;
import 'package:parla_italiano/handler/startLoader.dart';
import 'package:parla_italiano/adminScreens/startLoader.dart' as startLoaderAdmin;

import 'package:parla_italiano/screens/start_screen.dart';
import 'package:parla_italiano/adminScreens/ugoScreen.dart';
import 'package:parla_italiano/routes.dart' as routes;

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {


  bool signInSelected = true;
  final _formKey = GlobalKey<FormState>();
  final _controllerEmail = TextEditingController();
  String? _errorMessage = null;
  String? _errorMessageUserName = null;
  final _controllerPassword = TextEditingController();
  
  final _usernameFormKey = GlobalKey<FormState>();
  final _controllerUsername = TextEditingController();

  final _userHandler = UserHandler();

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(
      builder: ((context, constraints) {
        if (constraints.maxWidth > 1200){
          return getLayout(200, 100);
        } else {
          return getLayout(100, 50);
        }
        
      }
      )
    );

  }

  getLayout(double paddingHorizontal, double paddingVertical){
    return Scaffold(
      body: Expanded(
          child:Padding(
            padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
            child: Center(
            child: Column(
            children: <Widget>[ 
              Expanded(
                flex: 2,
                child: Center(
                child: Column(
                  children: [
                    const Text(
                      'Willkommen bei Parla Italiano',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 2,),
                    const Text(
                      'Dem besten Italienisch-Trainer of se world!',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black
                      ),
                    ),
                  ]
                )
              ),
              ),
              
              const SizedBox(height: 20),
              Expanded(
                flex: 6,
                child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: getButtonsWidget()
                        )
                      ]
                    ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _getInputFields()
                    ),
                    Expanded(
                      flex: 1,
                      child: getStartButton()
                    ),
                  ]
                )
              ),
              ),
              Expanded(
                flex: 1,
                child: Text(''),
              ),
            ],
          )
          )
          )
    )
    );
  }

  Widget _getInputFields(){
    if (signInSelected){
      return Row(children: [
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: _controllerEmail,
                          decoration: InputDecoration(
                            hintText: 'E-Mail',
                            errorText: _errorMessage,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'E-Mail eingeben!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: _controllerPassword,
                          decoration: InputDecoration(
                            hintText: 'Passwort',
                            errorText: _errorMessage,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Passwort eingeben!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ]);
    } else {
      return Row(children: [
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: _controllerEmail,
                          decoration: InputDecoration(
                            hintText: 'E-Mail',
                            errorText: _errorMessage,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'E-Mail eingeben!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: _controllerPassword,
                          decoration: InputDecoration(
                            hintText: 'Passwort',
                            errorText: _errorMessage,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Passwort eingeben!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: TextFormField(
                          cursorColor: Colors.black,
                          controller: _controllerUsername,
                          decoration: InputDecoration(
                            hintText: 'Benutzername',
                            errorText: _errorMessageUserName,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Benutzername eingeben!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ]);
    }
  }
  
  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Benutzername eingeben'),
          content: Column(
            children: [
              const Text(
                'Bitte gib einen Benutzernamen ein, mit dem dich deine Freunde finden können:',
              ),
              Form(
                key: _usernameFormKey,
                child: TextFormField(
                          cursorColor: Colors.black,
                          controller: _controllerEmail,
                          decoration: InputDecoration(
                            hintText: 'Benutzername',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Benutzername eingeben!';
                            }
                            return null;
                          },
                        ),
              ),
            ]
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Starten'),
              onPressed: () async {
                if (_usernameFormKey.currentState!.validate() && await _userHandler.isUsernameNotUsed(_controllerUsername.text)) {
                  final eMail = _controllerEmail.text;
                  final password = _controllerPassword.text;
                  final username = _controllerUsername.text;
                  //registrieren
                  try {
                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: eMail,
                      password: password,
                    );
                    //anmelden
                    try {
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: eMail,
                        password: password
                      );
                      final user = credential.user;
                      //user zu firestore liste hinzufügen
                      List<String> friendsIDs = [];
                      List<String> friendsRequestsSend = [];
                      List<String> friendsRequestsReceived = [];
                      List<String> friendsRequestsAccepted = [];
                      List<String> friendsRequestsRejected = [];
                      List<String> favouriteVocabulariesIDs= [];
                      List<String> finishedGamesIDsNews = [];
                      List<String> friendsLevelUpdate =[];
                      print(1);
                      _userHandler.createUser(userID: user!.uid, username: username, level: 1, friendsIDs: friendsIDs, friendsRequestsSend: friendsRequestsSend, friendsRequestsRecieved: friendsRequestsReceived, friendsRequestsAccepted: friendsRequestsAccepted, friendsRequestsRejected: friendsRequestsRejected, favouriteVocabulariesIDs: favouriteVocabulariesIDs, lastTestDate: '', finishedGamesIDsNews: finishedGamesIDsNews, friendsLevelUpdate: friendsLevelUpdate);
                      print(2);
                      UserDataGlobals.user = AppUser(userID: user.uid, username: username, level: 1, friendsIDs: friendsIDs, friendsRequestsSend: friendsRequestsSend, friendsRequestsReceived: friendsRequestsReceived, friendsRequestsAccepted: friendsRequestsAccepted, friendsRequestsRejected: friendsRequestsRejected, favouriteVocabulariesIDs: favouriteVocabulariesIDs, lastTestDate: "", finishedGamesIDsNews: finishedGamesIDsNews, friendsLevelUpdate: friendsLevelUpdate);
                      print(3);
                      if (await _userHandler.findUserByID(user!.uid) != null){
                        AppUser? appUser = await _userHandler.findUserByID(user!.uid);
                        await StartLoader().loadData(appUser, context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => StartScreen(),
                                            ),
                                          );
                      }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {} 
                        else if (e.code == 'wrong-password') {}
                      };
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {} 
                    else if (e.code == 'email-already-in-use') {}
                  } catch (e) {}
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Benutzername entweder leer oder schon vergeben!'))
                  );
                }
              }                    
            ),
          ],
        );
      },
    );
  }

  getButtonsWidget(){
    if (signInSelected){
      return Row(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('')
              ),
              Expanded(
                flex: 10,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color.fromRGBO(248, 225, 174, 1),
                    side: BorderSide(
                      color: Colors.black
                    )
                  ),
                  onPressed: () {
                  },
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Text(
                      'Anmelden',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )
                  )
                ),
              ),
              Expanded(
                flex: 1,
                child: Text('')
              ),
            ],
          )
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('')
              ),
              Expanded(
                flex: 10,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color.fromARGB(255, 228, 224, 224),
                  ),
                  onPressed: () {
                    setState(() {
                      signInSelected = false;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Text(
                      'Registrieren',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )
                  )
                ),
              ),
              Expanded(
                flex: 1,
                child: Text('')
              ),
            ],
          )
        ),
      ]
    );
  } else {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('')
              ),
              Expanded(
                flex: 10,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color.fromARGB(255, 228, 224, 224),
                  ),
                  onPressed: () {
                    setState(() {
                      signInSelected = true;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Text(
                      'Anmelden',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )
                  )
                ),
              ),
              Expanded(
                flex: 1,
                child: Text('')
              ),
            ],
          )
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('')
              ),
              Expanded(
                flex: 10,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color.fromRGBO(248, 225, 174, 1),
                    side: BorderSide(
                      color: Colors.black
                    )
                  ),
                  onPressed: () {
                  },
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Text(
                      'Registrieren',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )
                  )
                ),
              ),
              Expanded(
                flex: 1,
                child: Text('')
              ),
            ],
          )
        ),
      ]
    );
  }
    
  }     

  getStartButton(){
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text('')
              ),
              Expanded(
                flex: 8,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color.fromRGBO(248, 225, 174, 1),
                    side: BorderSide(
                      color: Colors.black
                    )
                  ),
                  onPressed: () async {
                    if (signInSelected){
                      if (_formKey.currentState!.validate()) {
                                    final email = _controllerEmail.text;
                                    final password = _controllerPassword.text;
                                    try {
                                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: email,
                                        password: password
                                      );
                                      final user = credential.user;
                                      if (await _userHandler.findUserByID(user!.uid) != null){
                                        AppUser? appUser = await _userHandler.findUserByID(user!.uid); 
                                        _controllerEmail.clear();
                                        _controllerPassword.clear();
                                        if (appUser!.username == 'admin' || appUser!.username == 'admin2' || appUser!.username == 'admin3'){
                                          await startLoaderAdmin.StartLoader().loadData(appUser!, context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => new HomeScreen(),
                                            ),
                                          );
                                        } else {
                                          await StartLoader().loadData(appUser!, context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => new StartScreen(),
                                            ),
                                          );
                                          
                                        }
                                        
                                      } 
                                    } on FirebaseAuthException catch (e) {
                                      setState(() {
                                          _errorMessage = 'Anmeldung fehlgeschlagen';
                                        });
                                    };
                                  }
                    } else {
                      if (await _formKey.currentState!.validate()) {
                        if (await _userHandler.isUsernameNotUsed(_controllerUsername.text)) {
                          final eMail = _controllerEmail.text;
                          final password = _controllerPassword.text;
                          final username = _controllerUsername.text;
                          //registrieren
                          try {
                            final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: eMail,
                              password: password,
                            );
                            //anmelden
                            try {
                              final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: eMail,
                                password: password
                              );
                              final user = credential.user;
                              //user zu firestore liste hinzufügen
                              List<String> friendsIDs = [];
                              List<String> friendsRequestsSend = [];
                              List<String> friendsRequestsReceived = [];
                              List<String> friendsRequestsAccepted = [];
                              List<String> friendsRequestsRejected = [];
                              List<String> favouriteVocabulariesIDs= [];
                              List<String> finishedGamesIDsNews = [];
                              List<String> friendsLevelUpdate =[];
                              _userHandler.createUser(userID: user!.uid, username: username, level: 1, friendsIDs: friendsIDs, friendsRequestsSend: friendsRequestsSend, friendsRequestsRecieved: friendsRequestsReceived, friendsRequestsAccepted: friendsRequestsAccepted, friendsRequestsRejected: friendsRequestsRejected, favouriteVocabulariesIDs: favouriteVocabulariesIDs, lastTestDate: '', finishedGamesIDsNews: finishedGamesIDsNews, friendsLevelUpdate: friendsLevelUpdate);
                              UserDataGlobals.user = AppUser(userID: user.uid, username: username, level: 1, friendsIDs: friendsIDs, friendsRequestsSend: friendsRequestsSend, friendsRequestsReceived: friendsRequestsReceived, friendsRequestsAccepted: friendsRequestsAccepted, friendsRequestsRejected: friendsRequestsRejected, favouriteVocabulariesIDs: favouriteVocabulariesIDs, lastTestDate: "", finishedGamesIDsNews: finishedGamesIDsNews, friendsLevelUpdate: friendsLevelUpdate);
                              if (await _userHandler.findUserByID(user!.uid) != null){
                                AppUser? appUser = await _userHandler.findUserByID(user!.uid);
                                await StartLoader().loadData(appUser, context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => StartScreen(),
                                                    ),
                                                  );
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {} 
                              else if (e.code == 'wrong-password') {}
                            };
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              _errorMessage = 'Registrierung fehlgeschlagen';
                            });
                          }
                        } else {
                          setState(() {
                            _errorMessageUserName = 'Benutzername schon vergeben';
                          });
                        }
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Starte jetzt!',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22
                      ),
                    )
                  )
                ),
              ),
              Expanded(
                flex: 2,
                child: Text('')
              ),
            ],
          )
        ),
      ]
    );
  }
  

}

