import 'package:flutter/material.dart';
import 'package:parla_italiano/handler/vocabularyHandler.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;

import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/screens/vocabularyDetailsScreen.dart';
import 'dart:convert';
import 'dart:html';
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:parla_italiano/routes.dart' as routes;

abstract class ListWidget extends StatelessWidget {
  ListWidget(this.amountOfWords, this.level, this.title, {super.key});

  final int amountOfWords;
  final int level;
  final String title;
  /**
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: _getTileColor(this.level),
      leading: Text('${this.amountOfWords.toString()} Wörter', textAlign: TextAlign.center,),
      title: 
        Padding(
          padding: EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _getLevelIcon(this.level),
                        SizedBox(width: 3,),
                        _getLevelText(this.level)
                      ]
                  ),
                ),
                Expanded(
                  child: Text ('${this.title}', textAlign: TextAlign.center,),
                  flex: 8
                ),
              ],
            )
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getTrainingStartItem(this.level, context),
            //SizedBox(width: 14),
            _getLockedUnlockedItem(this.level, context),
            //SizedBox(width: 14), 
            IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Vokabeln anschauen',
              onPressed:() {
                if (this.level <= globalData.user!.level){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VocabularyDetailsScreen(tablename: this.title, table_level: this.level ,), ));
                  //routes.navigate('/startScreen');
                  //context.pushNamed('vocabularies_details', pathParameters: {'tablename': this.title, 'table_level': this.level.toString()});
                  //context.goNamed('vocabularies_details', pathParameters: {'tablename': this.title, 'table_level': this.level.toString()}); 
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Level noch nicht freigeschalten!'))
                  );
                }
              }
            ),
            //SizedBox(width: 14),
            IconButton(
              icon: Icon(Icons.download),
              tooltip: 'PDF generieren',
              onPressed:() {
                if (this.level <= globalData.user!.level){
                  _createPDF(this.title, this.level);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Level noch nicht freigeschalten!'))
                  );
                }
              }
            )
          ]
        ) 
      );
  }
  */

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: _getTileColor(this.level),
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 3.0,
        children: [
          Text('${this.amountOfWords.toString()} Wörter', textAlign: TextAlign.center,),
          Text('${this.level == 0 ? "Favoriten" : "Level " + this.level.toString()}', textAlign: TextAlign.left,),
        ],
      ),
      title: Expanded(
        child: Text (
          '${this.title}', 
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12
          ),
        ),
      ),
      trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.download),
              tooltip: 'PDF generieren',
              onPressed:() {
                if (this.level <= globalData.user!.level){
                  _createPDF(this.title, this.level);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Level noch nicht freigeschalten!'))
                  );
                }
              }
            )
          ]
      ),
      onTap: () {
        if (this.level <= globalData.user!.level){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VocabularyDetailsScreen(tablename: this.title, table_level: this.level ,), ));
                  //routes.navigate('/startScreen');
                  //context.pushNamed('vocabularies_details', pathParameters: {'tablename': this.title, 'table_level': this.level.toString()});
                  //context.goNamed('vocabularies_details', pathParameters: {'tablename': this.title, 'table_level': this.level.toString()}); 
        } else if (this.level == globalData.user!.level + 1) {
          routes.dialogBuilder(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Level noch nicht freigeschalten!'))
          );
        }
      },
    );
  }

  Future<void> _createPDF(String title, int level) async {
    List<Vocabulary> vocabularies = VocabularyHandler().getAllVocabulariesFromLevel(level);

    PdfDocument document = PdfDocument();
    PdfPageTemplateElement header2 = PdfPageTemplateElement(
    Rect.fromLTWH(0, 0, document.pageSettings.size.width, 50));

    PdfCompositeField compositefields = PdfCompositeField(
        font: PdfStandardFont(PdfFontFamily.timesRoman, 19),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        text: '${title} ${level !=0 ? '(' + level.toString() + ')' : ''}');

    compositefields.draw(header2.graphics,
        Offset(220, 10 - PdfStandardFont(PdfFontFamily.timesRoman, 11).height));

    document.template.top = header2;

    PdfPageTemplateElement footer = PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, document.pageSettings.size.width, 40));

    PdfPageNumberField pageNumber = PdfPageNumberField(
      font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
      brush: PdfSolidBrush(PdfColor(0, 0, 0)));

    pageNumber.numberStyle = PdfNumberStyle.numeric;

    PdfPageCountField count = PdfPageCountField(
    font: PdfStandardFont(PdfFontFamily.timesRoman, 10),
    brush: PdfSolidBrush(PdfColor(0, 0, 0)));

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
      ..setAttribute("download", "parlaItaliano_${title}_(${level}).pdf")
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

  Widget _getTrainingStartItem(int vocabularyListLevel, BuildContext context) {
    if (vocabularyListLevel == globalData.user!.level + 1){
      return IconButton(
        icon: Icon(Icons.fitness_center),
        tooltip: 'Training starten',
        onPressed: (){
          routes.dialogBuilder(context);
        },
      );
    } else {
      return Visibility(
        maintainSize: false, 
        maintainAnimation: false,
        maintainState: false,
        visible: false, 
        child: IconButton(
          icon: Icon(Icons.fitness_center),
          tooltip: 'Training starten',
          onPressed: (){
            routes.dialogBuilder(context);
          },
        )
      );
    }
  }

  IconButton _getLockedUnlockedItem(int vocabularyListLevel, BuildContext context){
    if (vocabularyListLevel > globalData.user!.level){
      return IconButton(
        icon: Icon(Icons.lock),
        tooltip: 'noch nicht freigeschaltet',
        onPressed: (){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Level noch nicht freigeschalten!'))
          );
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.done_rounded),
        tooltip: 'freigeschaltet',
        onPressed: (){
        },
      );
    }
  }

  bool _checkIfTestCanStart(BuildContext context) {
    String lastTest = globalData.user!.lastTestDate;
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    return (lastTest != date.toString());
  }

}

class ListWidgetDesktop extends ListWidget {

  final int amountOfWords;
  final int level;
  final String title;
  
  ListWidgetDesktop(this.amountOfWords, this.level, this.title) : super(amountOfWords, level, title);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: _getTileColor(this.level),
      leading: Text('${this.amountOfWords.toString()} Wörter', textAlign: TextAlign.center,),
      title: 
        Padding(
          padding: EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _getLevelIcon(this.level),
                        SizedBox(width: 3,),
                        _getLevelText(this.level)
                      ]
                  ),
                ),
                Expanded(
                  child: Text ('${this.title}', textAlign: TextAlign.center,),
                  flex: 8
                ),
              ],
            )
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getTrainingStartItem(this.level, context),
            SizedBox(width: 14),
            _getLockedUnlockedItem(this.level, context),
            SizedBox(width: 14), 
            IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Vokabeln anschauen',
              onPressed:() {
                if (this.level <= globalData.user!.level){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VocabularyDetailsScreen(tablename: this.title, table_level: this.level ,), ));
                  //routes.navigate('/startScreen');
                  //context.pushNamed('vocabularies_details', pathParameters: {'tablename': this.title, 'table_level': this.level.toString()});
                  //context.goNamed('vocabularies_details', pathParameters: {'tablename': this.title, 'table_level': this.level.toString()}); 
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Level noch nicht freigeschalten!'))
                  );
                }
              }
            ),
            SizedBox(width: 14),
            IconButton(
              icon: Icon(Icons.download),
              tooltip: 'PDF generieren',
              onPressed:() {
                if (this.level <= globalData.user!.level){
                  _createPDF(this.title, this.level);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Level noch nicht freigeschalten!'))
                  );
                }
              }
            )
          ]
        ) 
      );
  }

}

class ListWidgetSmartphone extends ListWidget {

  final int amountOfWords;
  final int level;
  final String title;
  
  ListWidgetSmartphone(this.amountOfWords, this.level, this.title) : super(amountOfWords, level, title);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: _getTileColor(this.level),
      leading: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 3.0,
        children: [
          Text('${this.amountOfWords.toString()} Wörter', textAlign: TextAlign.center,),
          Text('${this.level == 0 ? "Favoriten" : "Level " + this.level.toString()}', textAlign: TextAlign.left,),
        ],
      ),
      title: Expanded(
        child: Text (
          '${this.title}', 
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12
          ),
        ),
      ),
      trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.download),
              tooltip: 'PDF generieren',
              onPressed:() {
                if (this.level <= globalData.user!.level){
                  _createPDF(this.title, this.level);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Level noch nicht freigeschalten!'))
                  );
                }
              }
            )
          ]
      ),
      onTap: () {
        if (this.level <= globalData.user!.level){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => VocabularyDetailsScreen(tablename: this.title, table_level: this.level ,), ));
                  //routes.navigate('/startScreen');
                  //context.pushNamed('vocabularies_details', pathParameters: {'tablename': this.title, 'table_level': this.level.toString()});
                  //context.goNamed('vocabularies_details', pathParameters: {'tablename': this.title, 'table_level': this.level.toString()}); 
        } else if (this.level == globalData.user!.level + 1) {
          routes.dialogBuilder(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Level noch nicht freigeschalten!'))
          );
        }
      },
    );
  }

}