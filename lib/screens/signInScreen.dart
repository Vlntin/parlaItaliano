import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/models/appUser.dart';
import 'package:parla_italiano/globals/userData.dart' as UserDataGlobals;
import 'package:parla_italiano/handler/startLoader.dart';

import 'package:parla_italiano/screens/start_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _formKey = GlobalKey<FormState>();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  
  final _usernameFormKey = GlobalKey<FormState>();
  final _controllerUsername = TextEditingController();

  final _userHandler = UserHandler();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal: 200, vertical: 80),
          child: Center(
            child: Column(
            children: <Widget>[ 
              Center(
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
              const SizedBox(height: 80),  
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text('Starte jetzt',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controllerEmail,
                          decoration: const InputDecoration(hintText: 'E-Mail'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'E-Mail eingeben du Hund!';
                            }
                            return null;
                          },
                        )
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: TextFormField(
                          controller: _controllerPassword,
                          decoration: const InputDecoration(hintText: 'Passwort'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Passwort eingeben du Hund!';
                            }
                            return null;
                          },
                        )
                      ),
                    ]),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              const SizedBox(width: 50,),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:Color.fromRGBO(248, 225, 174, 1),
                                  ),
                                onPressed: () async {
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
                                        StartLoader().loadData(appUser!);
                                        //context.goNamed('/startScreen', pathParameters: {'firstTime': 'true'});
                                        //Navigator.pushReplacementNamed(context, '/ugoScreen');
                                        //Navigator.of(context).popUntil((route) => route.isFirst);
                                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StartScreen()));
                                        print('a');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StartScreen(),
                                          ),
                                        );
                                        /** 
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StartScreen(),
                                          ),
                                        );
                                        */
                                        //Navigator.of(context).pop();
                                        //print('b');
                                        /** 
                                        Navigator
                                          .of(context)
                                          .pushReplacement(
                                            MaterialPageRoute(
                                              builder: (BuildContext context) => StartScreen()
                                          )
                                        );
                                        print('c');
                                        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StartScreen()));
                                        print('blub');
                                        context.go('/startScreen');
                                        */
                                        //Navigator.pushNamedAndRemoveUntil(context, "/startScreen", (r) => false);
                                        //Navigator.of(context)
                                        //  .pushNamedAndRemoveUntil('/startScreen', (Route<dynamic> route) => false);
                                      }
                                      
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Anmeldung hat nicht geklappt'))
                                        );
                                      } else if (e.code == 'wrong-password') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Anmeldung hat nicht geklappt'))
                                        );
                                      }
                                    };
                                  }
                                },
                                child: const Text(
                                  'Anmelden',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              ),
                              ),
                              const SizedBox(width: 50,),
                            ],)
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              const SizedBox(width: 50,),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:Color.fromRGBO(248, 225, 174, 1),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      _dialogBuilder(context);
                                    }
                                  },
                                  child: const Text(
                                    'Registrieren',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                ),
                              ),
                              const SizedBox(width: 50,),
                            ],)
                        ),
                      ]
                    ) 
                  ]
                )
              )  
            ],
          )
          )
        ),
      ),
    );
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
                  controller: _controllerUsername,
                  decoration: const InputDecoration(hintText: 'Benutzername'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return  'Benutzername eingeben du Hund!';
                    }
                      return null;
                  },
                ) 
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
                      List<String> favouriteVocabulariesIDs= [];
                      print('a');
                      _userHandler.createUser(userID: user!.uid, username: username, level: 1, friendsIDs: friendsIDs, friendsRequestsSend: friendsRequestsSend, friendsRequestsRecieved: friendsRequestsReceived, favouriteVocabulariesIDs: favouriteVocabulariesIDs, lastTestDate: '');
                      print('b');
                      UserDataGlobals.user = AppUser(userID: user.uid, username: username, level: 1, friendsIDs: friendsIDs, friendsRequestsSend: friendsRequestsSend, friendsRequestsReceived: friendsRequestsReceived, favouriteVocabulariesIDs: favouriteVocabulariesIDs, lastTestDate: "");
                      print(UserDataGlobals.user);
                      context.go('/ugoScreen');
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
}