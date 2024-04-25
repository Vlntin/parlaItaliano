import 'dart:js_util';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/navigationBar.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      appBar: CustomAppBar(),
    );
  }
}