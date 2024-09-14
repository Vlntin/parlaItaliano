import 'dart:math';

import 'package:flutter/material.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/handler/vocabularyHandler.dart';
import 'package:parla_italiano/dbModels/DBtable.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;

import 'package:go_router/go_router.dart';

import 'package:parla_italiano/handler/speaker.dart';
import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:html';
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

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
    bool pressAttention = globalData.vocabularyRepo!.isVocabularyInFavorites(widget.id);
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
                          pressAttention ? globalData.vocabularyRepo!.deleteFavouriteVocabulary(widget.id) : globalData.vocabularyRepo!.addVocabularyToFavorites(widget.id, widget.italian, widget.german, widget.additional),
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
              onPressed:() => _createPDF(this.title, this.id, this.level)
            )
          ]
        ) 
      );
  }

  Future<void> _createPDF(String title, String id, int level) async {
    List<Vocabulary> vocabularies = VocabularyHandler().getAllVocabularies(id, title);

    PdfDocument document = PdfDocument();
    PdfPageTemplateElement header2 = PdfPageTemplateElement(
    Rect.fromLTWH(0, 0, document.pageSettings.size.width, 50));

    PdfCompositeField compositefields = PdfCompositeField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        text: '${title}(${level})');

    compositefields.draw(header2.graphics,
        Offset(220, 10 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));

    document.template.top = header2;

    PdfPageTemplateElement footer = PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, document.pageSettings.size.width, 40));

    PdfPageNumberField pageNumber = PdfPageNumberField(
      font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)));

    //Sets the number style for page number
    pageNumber.numberStyle = PdfNumberStyle.numeric;

    PdfPageCountField count = PdfPageCountField(
    font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
    brush: PdfSolidBrush(PdfColor(0, 0, 0)));

    //set the number style for page count
    count.numberStyle = PdfNumberStyle.numeric;

    PdfCompositeField compositeField = PdfCompositeField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        text: 'Seite {0} von {1}',
        fields: <PdfAutomaticField>[pageNumber, count]);
    compositeField.bounds = footer.bounds;

    compositeField.draw(footer.graphics,
      Offset(450, 20 - PdfStandardFont(PdfFontFamily.timesRoman, 19).height));

    document.template.bottom = footer;

    PdfGrid grid = PdfGrid();
    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = "italienisch";
    header.cells[1].value = "deutsch";
    header.cells[2].value = "zusätzliches";

    header.style = PdfGridCellStyle(
      backgroundBrush: PdfBrushes.lightGray,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );

    for (final vocabulary in vocabularies) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = vocabulary.italian;
      row.cells[1].value = vocabulary.german;
      row.cells[2].value = vocabulary.additional;
    }

    grid.style = PdfGridStyle(
      cellPadding: PdfPaddings(left: 10, right: 3, top: 4, bottom: 4),
      backgroundBrush: PdfBrushes.white,
      textBrush: PdfBrushes.black,
      font: PdfStandardFont(PdfFontFamily.timesRoman, 12),
    );

    grid.draw(
        page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));
    List<int> bytes = await document.save();

    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "parlaItaliano_${title}(${level}).pdf")
      ..click();

    document.dispose();
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
    if (vocabularyListLevel > globalData.user!.level){
      return Colors.grey[300];
    } else {
      return Colors.white;
    }
  }

  IconButton _getLockedUnlockedItem(int vocabularyListLevel, BuildContext context){
    if (vocabularyListLevel > globalData.user!.level){
      return IconButton(
        icon: Icon(Icons.lock),
        onPressed: (){
          if (vocabularyListLevel == globalData.user!.level + 1){
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
              onPressed:() {
                var startBool = _checkIfTestCanStart(context);
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

  bool _checkIfTestCanStart(BuildContext context) {
    String lastTest = globalData.user!.lastTestDate;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    return (lastTest != date.toString());
  }
}