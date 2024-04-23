import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/globals/appBar.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(width: 38),   
            ElevatedButton(
              onPressed: () => context.go('/'), 
              child: const Text('Zurück zur Seite für Ugo')
              ),
            const SizedBox(width: 38),  
            ElevatedButton(
            onPressed: () => context.go('/vocabularyListsScreen'), 
            child: const Text('Zur Vokabelübersicht')
            )
          ],
        ), physics: ScrollPhysics(),),
    );
  }
}