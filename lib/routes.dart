import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/handler/startLoader.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/models/appUser.dart';

import 'screens/ugoScreen.dart';
import 'screen_one.dart';
import 'screens/start_screen.dart';
import 'screens/vocabularyListScreen.dart';
import 'screens/vocabularyDetailsScreen.dart';
import 'screens/signInScreen.dart';
import 'screens/testScreen.dart';
import 'package:parla_italiano/globals/userData.dart' as uD;

final _router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) async {// your logic to check if user is authenticated
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null){
      return '/';
    } else {
      AppUser? appUser = await UserHandler().findUserByID(user!.uid);
      StartLoader().loadData(appUser!);
      return null;
    }
   },
  routes: [
    GoRoute(path: '/ugoScreen', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/startScreen',
      builder: (context, state) => StartScreen(),
    ),
    GoRoute(
      path: '/vocabularyListsScreen', 
      builder: (context, state) => const VocabularyListsScreen(),
    ),
    GoRoute(
      path: '/', 
      builder: (context, state) => const SignInScreen(),

    ),
    GoRoute(path: '/screen_one/:id/:tablename', name:'screen_one', builder: (context, state) => ScreenOne(id: state.pathParameters['id'], tableName: state.pathParameters['tablename']),),
    GoRoute(path: '/vocabularies_details/:tablename/:table_id', name:'vocabularies_details', builder: (context, state) => VocabularyDetailsScreen(tablename: state.pathParameters['tablename'], table_id: state.pathParameters['table_id']),),
    GoRoute(
      path: '/vocabularies_test', 
      builder: (context, state) => VocabularyTestScreen(),
      onExit: (BuildContext context) async {
        var response = await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Möchtest du diese Seite verlassen?'),
              actions: <Widget>[
                TextButton(
                  child: const Text('nein, weiterspielen'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('ja, verlassen'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );
        return response ?? false;
      } 
    )
  ]
);

GoRouter createRouter() {
  return _router;
}

buildAlertDialog(BuildContext context){
  return AlertDialog(
            title: const Text('Do you want to exit this page?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Go Back'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('Confirm'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
}