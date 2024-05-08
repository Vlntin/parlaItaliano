import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/navigationBar.dart';

class StartScreen extends StatefulWidget {

  //String? firstTime;
  StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context){
    //  Navigator.of(context).popUntil((route) { print(route.settings.name); return false; });
    //Navigator.of(context)
    //                                      .pushNamedAndRemoveUntil('/startScreen', (Route<dynamic> route) => false);
    //Navigator.pushNamedAndRemoveUntil(context, "/startScreen", (r) => false);
    //check();
    //_checkFirst();
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      appBar: CustomAppBar(),
    );
  }
  /** 
  void _checkFirst(){
    if(widget.firstTime == 'true'){
      while (context.canPop() == true) {
        context.pop();
      }
      context.pushReplacement('/startScreen');
    }
  }
  */

  void check(){
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => StartScreen()));
  }
}