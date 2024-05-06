import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/models/DBtable.dart';
import 'package:parla_italiano/globals/userData.dart' as userData;
import 'package:parla_italiano/globals/vocabularyRepository.dart' as vocabularyRepo;

import 'package:go_router/go_router.dart';

import 'package:parla_italiano/handler/speaker.dart';

class VocabularyWidget extends StatefulWidget {
  const VocabularyWidget(this.id, this.italian, this.german, this.additional, {super.key});

  final String additional;
  final String italian;
  final String german;
  final String id;

  @override
  State<VocabularyWidget> createState() => _VocabularyWidgetState();
}
class _VocabularyWidgetState extends State<VocabularyWidget> {

  bool pressAttention = false;
  
  @override
  Widget build(BuildContext context) {
    bool pressAttention = vocabularyRepo.isVocabularyInFavorites(widget.id);
    return Padding(
        padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    widget.italian,
                    style: TextStyle(
                      fontSize: 12,
                    )
                  ),
                ) ,
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    widget.german,
                    style: TextStyle(
                      fontSize: 12,
                    )
                  ),
                ) ,
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    widget.additional,
                    style: TextStyle(
                      fontSize: 12,
                    )
                  ),
                ) ,
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: pressAttention ? Icon(Icons.star_sharp) : Icon(Icons.star_border),
                        onPressed: () => {
                          pressAttention ? vocabularyRepo.deleteFavouriteVocabulary(widget.id) : vocabularyRepo.addVocabularyToFavorites(widget.id, widget.italian, widget.german, widget.additional),
                          setState(() => pressAttention = !pressAttention)
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed:() async {
                          VoiceSpeaker().speakItalianWord(widget.italian);
                        }
                      )
                    ]
                  ),
                ) ,             
              ),
            ],
          )
    );
  }
}

class VocabularyListTileWidget extends StatefulWidget {

  @override
  State<VocabularyListTileWidget> createState() => _VocabularyListTileWidgetState();

}
class _VocabularyListTileWidgetState extends State<VocabularyListTileWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    'italienisch',
                    style:TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ) ,
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    'deutsch',
                    style:TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ) ,
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    'zusätzliches',
                    style:TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ) ,
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Center(),            
              ),
            ],
          )
    );
  }
}

class ListWidget extends StatelessWidget {
  ListWidget(this.amountOfWords, this.level, this.title, this.id, {super.key});

  final int amountOfWords;
  final int level;
  final String title;
  final String id;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: _getTileColor(this.level),
      leading: Text('${this.amountOfWords.toString()} Wörter', textAlign: TextAlign.center,),
      title: 
        Padding(
          padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _getLevelIcon(this.level),
                        SizedBox(width: 4,),
                        _getLevelText(this.level)
                      ]
                  ),
                ),
                Expanded(
                  child: Text ('${this.title}', textAlign: TextAlign.center,),
                  flex: 10
                ),
              ],
            )
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 14),
            _getLockedUnlockedItem(this.level, context),
            SizedBox(width: 14), 
            IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Vokabeln anschauen',
              onPressed:() => context.goNamed('vocabularies_details', pathParameters: {'tablename': this.title, 'table_id': this.id})
            ),
            SizedBox(width: 14),
            IconButton(
              icon: Icon(Icons.download),
              tooltip: 'PDF generieren',
              onPressed:() {}
            )
          ]
        ) 
      );
  }

  Icon _getLevelIcon(int vocabularyListLevel){
    if (vocabularyListLevel == 0){
      return Icon(Icons.star_sharp);
    } else {
      return Icon(Icons.emoji_events);
    }
  }

  Text _getLevelText(int vocabularyListLevel){
    if (vocabularyListLevel == 0){
      return Text("");
    } else {
      return Text('${vocabularyListLevel.toString()}', textAlign: TextAlign.start,);
    }
  }

  Color? _getTileColor(int vocabularyListLevel){
    if (vocabularyListLevel > userData.user!.level){
      return Colors.grey[300];
    } else {
      return Colors.white;
    }
  }

  IconButton _getLockedUnlockedItem(int vocabularyListLevel, BuildContext context){
    if (vocabularyListLevel > userData.user!.level){
      return IconButton(
        icon: Icon(Icons.lock),
        onPressed: (){
          if (vocabularyListLevel == userData.user!.level + 1){
            _dialogBuilder(context);
          }
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.done_rounded),
        onPressed: (){},
      );
    }
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text('Nächstes Level freischalten')
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
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Starten'),
              onPressed:() async {
                var startBool = await _checkIfTestCanStart(context);
                if (startBool){
                  UserHandler().updateTestDate();
                  context.go('/vocabularies_test');
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Du hast heute schon einen Test gestartet'))
                  );
                }
                //to delete:
                context.go('/vocabularies_test');
              }
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Schließen'),
              onPressed:() => Navigator.pop(context)
            ),
          ],
        );
      },
    );
  }

  Future<bool> _checkIfTestCanStart(BuildContext context) async{
    String lastTest = await UserHandler().getUsersLastTest();
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    return (lastTest != date.toString());
  }
}