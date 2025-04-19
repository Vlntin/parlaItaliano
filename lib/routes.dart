import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/handler/userHandler.dart';
//import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/screens/classicGameScreen.dart';
import 'package:parla_italiano/screens/oneVsOneScreen.dart';

import 'adminScreens/ugoScreen.dart';
import 'adminScreens/screen_one.dart';
import 'screens/start_screen.dart';
import 'screens/vocabularyListScreen.dart';
import 'screens/vocabularyDetailsScreen.dart';
import 'screens/signInScreen.dart';
import 'screens/testScreen.dart';
import 'package:parla_italiano/globals/globalData.dart' as uD;
import 'package:parla_italiano/constants/colors.dart' as colors;

bool canTestBeLeaved = false;

final _router = GoRouter(
  redirect: (BuildContext context, GoRouterState state) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    if (user == null){
      return '/';
    } else {
      //AppUser? appUser = await UserHandler().findUserByID(user!.uid);
      //StartLoader().loadData(appUser!);
      return null;
    }
   },
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/ugoScreen', 
      builder: (context, state) => const HomeScreen()
    ),
    GoRoute(
      path: '/', 
      builder: (context, state) => const SignInScreen(),

    ),
    GoRoute(
      path: '/startScreen',
      builder: (context, state) => const StartScreen(),
    ),
    GoRoute(
      path: '/vocabularyListsScreen', 
      builder: (context, state) => const VocabularyListsScreen(),
    ),
    GoRoute(
      path: '/oneVsOneScreen', 
      builder: (context, state) => const OneVSOneScreen(),
    ),
    
    GoRoute(
      path: '/vocabularies_test', 
      builder: (context, state) => VocabularyTestScreen(), 
      /**    
      onExit: (BuildContext context) async {
        if (routes.canTestBeLeaved){
          routes.canTestBeLeaved = false;
          return true;
        } else {
          return await buildLeaveDialog(context);
        }
      }
      */ 
    ),   
    GoRoute(
      path: '/signInScreen', 
      builder: (context, state) => const SignInScreen(),

    ),
    GoRoute(
      path: '/screen_one/:id/:tablename', 
      name:'screen_one', 
      builder: (context, state) => ScreenOne(id: state.pathParameters['id'], tableName: state.pathParameters['tablename']),
    ),
    GoRoute(
      path: '/vocabularies_details/:tablename/:table_level', 
      name:'vocabularies_details', 
      builder: (context, state) => VocabularyDetailsScreen(tablename: state.pathParameters['tablename'], table_level: int.tryParse(state.pathParameters['table_level']!)),
    ),
  ]
);

void clearAndNavigate(String path) {
  while (_router.canPop() == true) {
    _router.pop();
  }
  _router.pushReplacement(path);
}

void navigate(String path){
  _router.push(path);
}

void navigateAlternative(String path){
  _router.replace(path);
}

GoRouter createRouter() {
  return _router;
}

buildLeaveDialog(BuildContext context) async {
    var response = await showDialog<bool>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black, width: 2.0)),
              backgroundColor: Colors.white,
              title: const Text('Möchtest du diese Seite verlassen?', textAlign: TextAlign.center,),
              actions: <Widget>[
                Center(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.center,
                              backgroundColor: colors.popUpButtonColor
                            ),
                            onPressed:() {
                              Navigator.of(context).pop(false);
                            }, 
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                'nein'
                                ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.center,
                              backgroundColor: colors.popUpButtonColor
                            ),
                            onPressed:() {
                              Navigator.of(context).pop(true);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text('ja'),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                )
              ],             
            );
          },
        );
    return response ?? false;
}

Future<bool> dialogBuilder(BuildContext context) async {
  var response = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.black, width: 2.0)
          ),
          title: const Center(
            child: Text(
              'Nächstes Level freischalten',
              textAlign: TextAlign.center,
            )
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: const Text(
                  'Du kannst nur einen Test pro Tag absolvieren. Möchtest du diesen jetzt starten?',
                ),
              ),
            ]
          ),
          actions: <Widget>[
            Center(
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor: colors.popUpButtonColor
                        ),
                        onPressed:() {
                          var startBool = _checkIfTestCanStart(context);
                          if (startBool){
                            UserHandler().updateTestDate();
                            Navigator.of(context).pop(true);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VocabularyTestScreen(), ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Du hast heute schon einen Test gestartet'))
                            );
                          }                          
                        }, 
                        child: Padding(
                          padding: EdgeInsets.all(1),
                          child: Text("Starten"),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          alignment: Alignment.center,
                          backgroundColor: colors.popUpButtonColor
                        ),
                        onPressed:() {
                          Navigator.of(context).pop(false);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(1),
                          child: Text("Schließen"),
                        ),
                      ),
                    ),
                  )
                ],
              )
            )
          ],
        );
      },
    );
    return response ?? true;
  }

   bool _checkIfTestCanStart(BuildContext context) {
    String lastTest = uD.user!.lastTestDate;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    return (lastTest != date.toString());
  }