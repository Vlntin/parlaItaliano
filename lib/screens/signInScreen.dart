import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/globals/globalData.dart' as UserDataGlobals;
import 'package:parla_italiano/handler/startLoader.dart';

import 'package:parla_italiano/screens/start_screen.dart';
import 'package:parla_italiano/widgets/personalizedTextformField.dart';

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
                    _getInputFields(),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StartScreen(),
                                          ),
                                        );
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

  Widget _getInputFields(){
    return Row(children: [
                      Expanded(
                        child: PersonalizedTextformField(
                          controller: _controllerEmail,
                          hintText: 'E-Mail',
                          newValidator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'E-Mail eingeben!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: PersonalizedTextformField(
                          controller: _controllerPassword,
                          hintText: 'Passwort',
                          newValidator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Passwort eingeben!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ]);
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
                child: PersonalizedTextformField(
                  controller: _controllerUsername,
                  hintText: 'Benutzername',
                  newValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return  'Benutzername eingeben!';
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
                      List<String> friendsRequestsAccepted = [];
                      List<String> friendsRequestsRejected = [];
                      List<String> favouriteVocabulariesIDs= [];
                      _userHandler.createUser(userID: user!.uid, username: username, level: 1, friendsIDs: friendsIDs, friendsRequestsSend: friendsRequestsSend, friendsRequestsRecieved: friendsRequestsReceived, friendsRequestsAccepted: friendsRequestsAccepted, friendsRequestsRejected: friendsRequestsRejected, favouriteVocabulariesIDs: favouriteVocabulariesIDs, lastTestDate: '');
                      UserDataGlobals.user = AppUser(userID: user.uid, username: username, level: 1, friendsIDs: friendsIDs, friendsRequestsSend: friendsRequestsSend, friendsRequestsReceived: friendsRequestsReceived, friendsRequestsAccepted: friendsRequestsAccepted, friendsRequestsRejected: friendsRequestsRejected, favouriteVocabulariesIDs: favouriteVocabulariesIDs, lastTestDate: "");
                      if (await _userHandler.findUserByID(user!.uid) != null){
                        AppUser? appUser = await _userHandler.findUserByID(user!.uid);
                        StartLoader().loadData(appUser);
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
}