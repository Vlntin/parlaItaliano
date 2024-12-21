import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/handler/startLoader.dart';
import 'package:parla_italiano/adminScreens/startLoader.dart' as startLoaderAdmin;

import 'package:parla_italiano/screens/start_screen.dart';
import 'package:parla_italiano/adminScreens/ugoScreen.dart';

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
        return (constraints.maxWidth > 1200) ? getLayout(200, 100) : getLayout(100, 50);
      })
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
                    if (_formKey.currentState!.validate()) {
                      if (signInSelected){
                        _tryToSignIn();
                      } else {
                        _tryToRegister();
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

  Future _tryToSignIn() async{
    final email = _controllerEmail.text;
    final password = _controllerPassword.text;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      final user = credential.user;
      if (await _userHandler.findUserByID(user!.uid) != null){
        AppUser? appUser = await _userHandler.findUserByID(user.uid); 
        _controllerEmail.clear();
        _controllerPassword.clear();
        if (appUser!.username == 'admin' || appUser.username == 'admin2' || appUser.username == 'admin3'){
          await startLoaderAdmin.StartLoader().loadData(appUser, context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => new HomeScreen(),
            ),
          );
        } else {
          await StartLoader().loadData(appUser, context);
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

  Future _tryToRegister() async {
    final eMail = _controllerEmail.text;
    final password = _controllerPassword.text;
    final username = _controllerUsername.text;
    try {
      AppUser? user = await _userHandler.registerNewUser(username, eMail, password);
      if (user != null){
        await StartLoader().loadData(user, context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartScreen(),
          ),
        );
      }
    } catch(e){
      if (e.toString() == 'Exception: Registrierung fehlgeschlagen'){
        setState((){
          _errorMessage = 'Registrierung fehlgeschlagen';
        });
      } else if (e.toString() == 'Exception: Benutzername schon vergeben'){
        setState((){
          _errorMessageUserName = 'Benutzername schon vergeben';
        }); 
      }
    }                        
  }
  
}