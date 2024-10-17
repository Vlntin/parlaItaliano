import 'package:flutter/material.dart';
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:parla_italiano/constants/colors.dart' as colors;

final _router = createRouter();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const App());
}

class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp.router(
      routerConfig: _router, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          background: Colors.white, 
          error: Colors.red,
          seedColor: Colors.black,
        ).copyWith(
            primary: Colors.black,
        ),
        //onTertiary: Colors.orange,
        //onPrimary: Colors.blue
        scaffoldBackgroundColor: colors.appGreen,
        primaryColor: Colors.black,
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black
          ),
          bodySmall: TextStyle(
            color: Colors.black
          ),
          labelLarge: TextStyle(
            color: Colors.black
          )
        )
      ),
    );
  }
}


