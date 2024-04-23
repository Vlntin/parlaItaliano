import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _formKey = GlobalKey<FormState>();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

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
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        print('No user found for that email.');
                                      } else if (e.code == 'wrong-password') {
                                        print('Wrong password provided for that user.');
                                      }
                                    };
                                    if (FirebaseAuth.instance.currentUser != null){
                                      //initialisiere Nutzerdaten
                                      context.go('/ugoScreen');
                                    } else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Anmeldung hat nicht geklappt'))
                                      );
                                    }
                                    _controllerEmail.clear();
                                    _controllerPassword.clear();
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
                                    final email = _controllerEmail.text;
                                    final password = _controllerPassword.text;
                                    try {
                                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: email,
                                        password: password
                                      );
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        print('No user found for that email.');
                                      } else if (e.code == 'wrong-password') {
                                        print('Wrong password provided for that user.');
                                      }
                                    };
                                    if (FirebaseAuth.instance.currentUser != null){
                                      //initialisiere Nutzerdaten
                                      context.go('/ugoScreen');
                                    } else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Anmeldung hat nicht geklappt'))
                                      );
                                    }
                                    _controllerEmail.clear();
                                    _controllerPassword.clear();
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
    String? _getUserEmail(){
      String? email = 'nothing2';
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        email = user.email;
      } else {
        email = 'nothing';      
      };
      return email;
    }
  
}