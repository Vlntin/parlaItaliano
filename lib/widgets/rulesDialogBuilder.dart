
import 'package:flutter/material.dart';
import 'package:parla_italiano/constants/colors.dart' as colors;


Future<void> dialogBuilderRules(BuildContext context, String rules) {
    return showDialog<void>(
      
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.black, width: 2.0)),
          backgroundColor: Colors.white,
          title: const Text('Regeln', textAlign: TextAlign.center,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                rules,
              ),
            ]
          ),
          actions: <Widget>[
            Flexible(
                child: Center(
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      backgroundColor: colors.popUpButtonColor
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5), 
                      child:const Text(
                        'weiterspielen',
                        style: TextStyle(
                          color: Colors.black
                        ),
                      ),
                    ),
                    onPressed: ()  {
                      Navigator.of(context).pop(false);
                    }
                  )
                )
            )
          ],
        );
      },
    );
  }