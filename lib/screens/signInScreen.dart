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
        return getRightLayout(constraints.maxWidth);
      })
    );
  }

  Scaffold getRightLayout(double layoutWidth) {
    if (layoutWidth > 1200) {
      return getLayout(200, 100);
    } else if(layoutWidth > 500) {
      return getLayout(100, 50);
    } else {
        return getSmartphoneLayout();
    }
  }

  Scaffold getSmartphoneLayout() {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                        'Willkommen bei Parla Italiano',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Colors.black
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Dem besten Italienisch-Trainer of se world!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,

                        ),
                      ),
                      const SizedBox(height: 80),
                      getButtonsWidget(0),
                      const SizedBox(height: 20),
                      _getInputFields(true),
                      const SizedBox(height: 70),
                      getStartButton()
            ],
          )
          )
        
        ),
      ),
    );
  }

  Scaffold getLayout(double paddingHorizontal, double paddingVertical){
    return Scaffold(
      body: Padding(
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
                          child: getButtonsWidget(2)
                        )
                      ]
                    ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _getInputFields(false)
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
    );
  }

  Widget _getInputFields(bool mobileScreen){
    if (mobileScreen) {
      if (signInSelected){
        return Column(children: [
          _getInputField(_controllerEmail, _errorMessage, 'E-Mail eingeben!', 'E-Mail'),
          const SizedBox(width: 20),
          _getInputField(_controllerPassword, _errorMessage, 'Passwort eingeben!', 'Passwort')
        ]);
      } else {
        return Column(children: [
          _getInputField(_controllerEmail, _errorMessage, 'E-Mail eingeben!', 'E-Mail'),
          const SizedBox(width: 20),
          _getInputField(_controllerPassword, _errorMessage, 'Passwort eingeben!', 'Passwort'),
          const SizedBox(width: 20),
          _getInputField(_controllerUsername, _errorMessageUserName, 'Benutzername eingeben!', 'Benutzername'),
        ]);
      }
    } else {
      if (signInSelected){
        return Row(children: [
          Expanded(
            child: _getInputField(_controllerEmail, _errorMessage, 'E-Mail eingeben!', 'E-Mail')
          ),
          const SizedBox(width: 30),
          Expanded(
            child: _getInputField(_controllerPassword, _errorMessage, 'Passwort eingeben!', 'Passwort')
          ),
        ]);
      } else {
        return Row(children: [
          Expanded(
            child: _getInputField(_controllerEmail, _errorMessage, 'E-Mail eingeben!', 'E-Mail')
          ),
          const SizedBox(width: 30),
          Expanded(
            child: _getInputField(_controllerPassword, _errorMessage, 'Passwort eingeben!', 'Passwort')
          ),
          const SizedBox(width: 30),
          Expanded(
            child: _getInputField(_controllerUsername, _errorMessageUserName, 'Benutzername eingeben!', 'Benutzername')
          ),
        ]);
      }
    }
    
  }

  TextFormField _getInputField (TextEditingController controller, String? errorText, String validatorText, String hintText) {
    return TextFormField(
      cursorColor: Colors.black,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorText;
        }
          return null;
      },
    );
  }

  getButtonsWidget(int leftAndRightPadding){
    if (signInSelected){
      return Row(
      children: [
        Expanded(
          flex: 1,
          child: Row(
            children: [
              Expanded(
                flex: leftAndRightPadding,
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
                flex: 1,
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
                flex: leftAndRightPadding,
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
                flex: leftAndRightPadding,
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
                flex: 1,
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
                flex: leftAndRightPadding,
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