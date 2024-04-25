import 'package:flutter/material.dart';
import 'dart:js_util';
import 'package:flutter/rendering.dart';
import 'package:parla_italiano/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/globals/userData.dart' as userData;


class CustomNavigationBar extends StatefulWidget {

  CustomNavigationBar();

  @override
  CustomNavigationBarState createState() => CustomNavigationBarState();
}

class CustomNavigationBarState extends State<CustomNavigationBar> {


  Widget build(BuildContext context){
    return NavigationBar(
        backgroundColor: Color.fromRGBO(248, 225, 174, 1),
        onDestinationSelected: (int index) {
          setState(() {
            userData.naviBarIndex = index;
            if (userData.naviBarIndex == 0){
              context.go('/startScreen');
            }
            if (userData.naviBarIndex == 1){
              context.go('/vocabularyListsScreen');
            }
          });
        },
        indicatorColor: const Color.fromARGB(255, 238, 232, 216),
        selectedIndex: userData.naviBarIndex,
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
}