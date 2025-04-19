
import 'package:flutter/material.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;

import 'package:parla_italiano/handler/speaker.dart';
import 'dart:ui';

abstract class VocabularyWidget extends StatefulWidget {
  const VocabularyWidget(this.italian, this.german, this.additional, {super.key});

  final String additional;
  final String italian;
  final String german;
}

abstract class VocabularyListTileWidget extends StatefulWidget {

}

class VocabularyWidgetDesktop extends VocabularyWidget {
  const VocabularyWidgetDesktop(this.italian, this.german, this.additional, {super.key}): super(italian, german, additional);

  final String additional;
  final String italian;
  final String german;

  @override
  State<VocabularyWidgetDesktop> createState() => _VocabularyWidgetStateDesktop();
}
class _VocabularyWidgetStateDesktop extends State<VocabularyWidgetDesktop> {

  bool pressAttention = false;
  
  @override
  Widget build(BuildContext context) {
    bool pressAttention = globalData.vocabularyRepo!.isVocabularyInFavorites(widget.italian);
    return Padding(
        padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
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
                flex: 1,
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
                flex: 1,
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
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: pressAttention ? Icon(Icons.star_sharp) : Icon(Icons.star_border),
                        onPressed: () => {
                          pressAttention ? globalData.vocabularyRepo!.deleteFavouriteVocabulary(widget.italian) : globalData.vocabularyRepo!.addVocabularyToFavorites(widget.italian, widget.german, widget.additional),
                          setState(() => pressAttention = !pressAttention)
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed:() async {
                          VoiceSpeaker().speakItalianWord(widget.italian);
                        }
                      ),
                    ]
                  ),
                ) , 
                )            
            ],
          )
    );
  }
}

class VocabularyListTileWidgetDesktop extends VocabularyListTileWidget {

  @override
  State<VocabularyListTileWidgetDesktop> createState() => _VocabularyListTileWidgetStateDesktop();

}
class _VocabularyListTileWidgetStateDesktop extends State<VocabularyListTileWidgetDesktop> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Italienisch',
                    style:TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ) ,
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Deutsch',
                    style:TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ) ,
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Zusätzliches',
                    style:TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ) ,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                  child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.star_sharp),
                        onPressed: () => {},
                      ),
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed:() async {}
                      ),
                    ]
                  ),
                ) , 
                  )
                )
            ],
          )
    );
  }
}

class VocabularyWidgetSmartphone extends VocabularyWidget {
  const VocabularyWidgetSmartphone(this.italian, this.german, this.additional, {super.key}): super(italian, german, additional);

  final String additional;
  final String italian;
  final String german;

  @override
  State<VocabularyWidgetSmartphone> createState() => _VocabularyWidgetStateSmartphone();
}
class _VocabularyWidgetStateSmartphone extends State<VocabularyWidgetSmartphone> {

  bool pressAttention = false;
  
  @override
  Widget build(BuildContext context) {
    bool pressAttention = globalData.vocabularyRepo!.isVocabularyInFavorites(widget.italian);
    return Padding(
        padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
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
                flex: 1,
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
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: pressAttention ? Icon(Icons.star_sharp) : Icon(Icons.star_border),
                        onPressed: () => {
                          pressAttention ? globalData.vocabularyRepo!.deleteFavouriteVocabulary(widget.italian) : globalData.vocabularyRepo!.addVocabularyToFavorites(widget.italian, widget.german, widget.additional),
                          setState(() => pressAttention = !pressAttention)
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed:() async {
                          VoiceSpeaker().speakItalianWord(widget.italian);
                        }
                      ),
                    ]
                  ),
                ) , 
                )            
            ],
          )
    );
  }
}

class VocabularyListTileWidgetSmartphone extends VocabularyListTileWidget {

  @override
  State<VocabularyListTileWidgetSmartphone> createState() => _VocabularyListTileWidgetStateSmartphone();

}
class _VocabularyListTileWidgetStateSmartphone extends State<VocabularyListTileWidgetSmartphone> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Italienisch',
                    style:TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ) ,
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    'Deutsch',
                    style:TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ) ,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Visibility(
                  visible: false,
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                  child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.star_sharp),
                        onPressed: () => {},
                      ),
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed:() async {}
                      ),
                    ]
                  ),
                ) , 
                  )
                )
            ],
          )
    );
  }
}