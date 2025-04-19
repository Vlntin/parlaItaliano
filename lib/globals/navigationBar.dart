import 'package:flutter/material.dart';
import 'dart:js_util';
import 'package:flutter/rendering.dart';
import 'package:parla_italiano/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/routes.dart' as routes;
import 'package:parla_italiano/screens/oneVsOneScreen.dart';
import 'package:parla_italiano/screens/start_screen.dart';
import 'package:parla_italiano/screens/testScreen.dart';
import 'package:parla_italiano/screens/vocabularyListScreen.dart';


class CustomNavigationBar extends StatefulWidget {

  int givenIndex;
  String startSideLabel = "Startseite";
  String vocabulariesLabel = "Vokabeln";
  String vsLabel = "1 vs 1";
  String testLabel = "Test";

  CustomNavigationBar(this.givenIndex);

  @override
  CustomNavigationBarState createState() => CustomNavigationBarState();
}

class CustomNavigationBarState extends State<CustomNavigationBar> {


  Widget build(BuildContext context){
    int prevIndex = 0;
    return NavigationBar(
      selectedIndex: widget.givenIndex,
      backgroundColor: Color.fromRGBO(248, 225, 174, 1),
      onDestinationSelected: (int index) async {
        bool canBeSwitched = false;
        if(widget.givenIndex == 3){
          if (index !=3 && await _onExit()){
            canBeSwitched = true;
          }
        }
        if (widget.givenIndex != 3){
          canBeSwitched = true;
        }
        if (index == 0 && canBeSwitched){
              setState(() {
                widget.givenIndex = index; 
              });
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartScreen(), ));
        }
        if (index == 1 && canBeSwitched){
              setState(() {
                widget.givenIndex = index; 
              });
              //Navigator.popUntil(context, ModalRoute.withName("/screen2"));
              //routes.navigate('/startScreen');
              //context.go('/vocabularyListsScreen');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VocabularyListsScreen(), ));
        }
        if (index == 2 && canBeSwitched){
              setState(() {
                widget.givenIndex = index; 
              });
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OneVSOneScreen(), ));
        }
        if (index == 3 && canBeSwitched){
              if(await  routes.dialogBuilder(context)){
                setState(() {
                widget.givenIndex = index; 
              });
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VocabularyTestScreen(), ));
              }
        }
        },
        //indicatorColor: const Color.fromARGB(255, 238, 232, 216),
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: widget.startSideLabel,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.menu_book),
            icon: Icon(Icons.menu_book_outlined),
            label: widget.vocabulariesLabel,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.rocket_launch),
            icon: Icon(Icons.rocket_launch_outlined),
            label: widget.vsLabel,
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.upgrade),
            icon: Icon(Icons.upgrade_outlined),
            label: widget.testLabel,
          ),
        ],
      );
  }

  _onExit() async{
    if (routes.canTestBeLeaved){
      routes.canTestBeLeaved = false;
      return true;
    } else {
      return await routes.buildLeaveDialog(context);
    }
  }
}