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







          /** 
          bool leave = true;
          if (index == 3){
            print('if 3');
            leave = await routes.dialogBuilder(context);
          } else if (widget.givenIndex == 3) {
            print('if2 3');
            leave = await _onExit();
          }
          print(leave);
          setState(() {
            if (index != 3){
              print('index setted');
              widget.givenIndex = index;      
            }
            
            print('prev ${prevIndex}');
            print('giv ${widget.givenIndex}');
            if (index == 1){
              setState(() {
                widget.givenIndex = index; 
              });
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VocabularyListsScreen(), ));
            }
            if (index == 3){
              if(await  routes.dialogBuilder(context))
              setState(() {
                widget.givenIndex = index; 
              });
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VocabularyListsScreen(), ));
            }
              
            if (widget.givenIndex == 1){
              if (prevIndex == 3){
                if (leave){
                  prevIndex = widget.givenIndex ;
                  widget.givenIndex = index;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VocabularyListsScreen(),));
                }
              } else {
                prevIndex = widget.givenIndex ;
                widget.givenIndex = index;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VocabularyListsScreen(),));
                //context.push('/vocabularyListsScreen');
              }
            }
            if (widget.givenIndex == 2){
              if (prevIndex == 3){
                if (leave){
                  prevIndex = widget.givenIndex ;
                  widget.givenIndex = index;
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OneVSOneScreen(),));
                }
              } else {
                prevIndex = widget.givenIndex ;
                widget.givenIndex = index;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OneVSOneScreen(),));
              }
            }
            if (widget.givenIndex == 3){
              if (leave){
                print('leave');
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
          */
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
            selectedIcon: Icon(Icons.upgrade),
            icon: Icon(Icons.upgrade_outlined),
            label: 'Test',
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