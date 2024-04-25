import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parla_italiano/models/DBtable.dart';
import 'package:parla_italiano/globals/userData.dart' as userData;
import 'package:parla_italiano/globals/vocabularyRepository.dart' as vocabularyRepo;

import 'package:go_router/go_router.dart';

import 'package:flutter_tts/flutter_tts.dart';

class VocabularyWidget extends StatefulWidget {
  const VocabularyWidget(this.id, this.italian, this.german, this.additional, this.isTitleLine, {super.key});

  final String additional;
  final String italian;
  final String german;
  final bool isTitleLine;
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
                    style: _getTextStyle(widget.isTitleLine)
                  ),
                ) ,
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    widget.german,
                    style: _getTextStyle(widget.isTitleLine)
                  ),
                ) ,
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    widget.additional,
                    style: _getTextStyle(widget.isTitleLine)
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
                      //if (isTitleLine){
                      //  <Widget>[Text('')],
                      //} else {
                      //  <Widget>[
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
                              FlutterTts flutterTts = FlutterTts(); 
                              flutterTts.setLanguage('it-IT');
                              flutterTts.setSpeechRate(1.0); 
                              flutterTts.setVolume(1.0); 
                              flutterTts.setPitch(1.0);
                              await flutterTts.speak(widget.italian);
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

  _getTextStyle(bool isTitleLine){
    if (isTitleLine){
      return TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold
      );
    } else {
      return TextStyle(
        fontSize: 12,
      );
    }
  }
  /** 
  _getRightColumn(bool isTitleline, String vocabularyId, String german, String italian, String additional){
    bool pressAttention = vocabularyRepo.isVocabularyInFavorites(vocabularyId);
    if (isTitleLine){
      return <Widget>[Text('')];
    } else if (pressAttention) {
      return <Widget>[
          IconButton(
            icon: pressAttention ? Icon(Icons.star_sharp) : Icon(Icons.star_border),
            onPressed: () => {
              pressAttention ? vocabularyRepo.deleteFavouriteVocabulary(vocabularyId) : vocabularyRepo.addVocabularyToFavorites(vocabularyId, italian, german, additional),
              pressAttention = !pressAttention
            },
          ),
          IconButton(
          icon: Icon(Icons.mic),
          onPressed:() async {
            FlutterTts flutterTts = FlutterTts(); 
            flutterTts.setLanguage('it-IT');
            flutterTts.setSpeechRate(1.0); 
            flutterTts.setVolume(1.0); 
            flutterTts.setPitch(1.0);
            await flutterTts.speak(italian);
          }
        )];
    } 
    else {
      return <Widget>[
          IconButton(
            icon: Icon(Icons.star_border),
            onPressed: () => {
              vocabularyRepo.addVocabularyToFavorites(vocabularyId, italian, german, additional)
              
            },
          ),
          IconButton(
          icon: Icon(Icons.mic),
          onPressed:() async {
            FlutterTts flutterTts = FlutterTts(); 
            flutterTts.setLanguage('it-IT');
            flutterTts.setSpeechRate(1.0); 
            flutterTts.setVolume(1.0); 
            flutterTts.setPitch(1.0);
            await flutterTts.speak(italian);
          }
        )];
    }
    
  }
  */
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
                        Icon (Icons.emoji_events, ),
                        SizedBox(width: 4,),
                        Text ('${this.level.toString()}', textAlign: TextAlign.start,)
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
                            trailing:
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 14),
                                  _getLockedUnlockedItem(this.level),
                                  SizedBox(width: 14), 
                                  IconButton(
                                    icon: Icon(Icons.search),
                                    tooltip: 'Vokabeln anschauen',
                                    onPressed:() => context.goNamed('vocabularies_details', pathParameters: {'tablename': this.title, 'table_id': this.id})),
                                  SizedBox(width: 14),
                                  IconButton(
                                    icon: Icon(Icons.download),
                                    tooltip: 'PDF generieren',
                                    onPressed:() {
                                      //final docUser = FirebaseFirestore.instance
                                      //  .collection('tables')
                                      //  .doc(tableList[index].id);
                                      //docUser.delete();
                                      //_vocabularyHandler.deleteVocabularyIdsByTableId(tableList[index].id, vocabularylist);
                                    }
                                  )
                              ]) 
                          );
  }

  Color? _getTileColor(int vocabularyListLevel){
    if (vocabularyListLevel > userData.level){
      return Colors.grey[300];
    } else {
      return Colors.white;
    }
  }

  IconButton _getLockedUnlockedItem(int vocabularyListLevel){
    if (vocabularyListLevel > userData.level){
      return IconButton(
        icon: Icon(Icons.lock),
        onPressed: (){},);
    } else {
      return IconButton(
        icon: Icon(Icons.done_rounded),
        onPressed: (){},);
    }
  }

}

