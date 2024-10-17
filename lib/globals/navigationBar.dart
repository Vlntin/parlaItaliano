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

  CustomNavigationBar(this.givenIndex);

  int givenIndex;

  @override
  CustomNavigationBarState createState() => CustomNavigationBarState();
}

class CustomNavigationBarState extends State<CustomNavigationBar> {

  int prevIndex = 0;

  Widget build(BuildContext context){
    return NavigationBar(
        selectedIndex: widget.givenIndex,
        backgroundColor: Color.fromRGBO(248, 225, 174, 1),
        onDestinationSelected: (int index) {
          setState(() async {
            print('prev ${prevIndex}');
            print('giv ${widget.givenIndex}');
            if (widget.givenIndex == 0){
              if (prevIndex == 3){
                bool leave = await _onExit();
                if (leave){
                  prevIndex = widget.givenIndex ;
                  widget.givenIndex = index;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartScreen(), ));
                }
              } else {
                prevIndex = widget.givenIndex ;
                widget.givenIndex = index;
                context.push('/startScreen');
              }
            }
            if (widget.givenIndex == 1){
              if (prevIndex == 3){
                bool leave = await _onExit();
                if (leave){
                  prevIndex = widget.givenIndex ;
                  widget.givenIndex = index;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VocabularyListsScreen(),));
                }
              } else {
                prevIndex = widget.givenIndex ;
                widget.givenIndex = index;
                context.push('/vocabularyListsScreen');
              }
            }
            if (widget.givenIndex == 2){
              if (prevIndex == 3){
                bool leave = await _onExit();
                if (leave){
                  prevIndex = widget.givenIndex ;
                  widget.givenIndex = index;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OneVSOneScreen(),));
                }
              } else {
                prevIndex = widget.givenIndex ;
                widget.givenIndex = index;
                context.push('/oneVsOneScreen');
              }
            }
            if (widget.givenIndex == 3){
              print(1);
              bool start = await routes.dialogBuilder(context);
              print(start);
              if (start){
                prevIndex = widget.givenIndex ;
                widget.givenIndex = index;
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => new VocabularyTestScreen(),
                  ),
                );
              } else {
                widget.givenIndex = prevIndex;
              }
              prevIndex = widget.givenIndex ;
              widget.givenIndex = index;
              routes.dialogBuilder(context);
            }
          });
        },
        indicatorColor: const Color.fromARGB(255, 238, 232, 216),
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Startseite',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.menu_book),
            icon: Icon(Icons.menu_book_outlined),
            label: 'Vokabelübersicht',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.rocket_launch),
            icon: Icon(Icons.rocket_launch_outlined),
            label: '1 vs 1',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.fitness_center),
            icon: Icon(Icons.fitness_center_outlined),
            label: 'Training',
          ),
        ],
      );
  }

  _onExit() async{
    if (routes.canTestBeLeaved){
      routes.canTestBeLeaved = false;
      return true;
    } else {
      print('blub else');
      return await routes.buildLeaveDialog(context);
    }
  }
}