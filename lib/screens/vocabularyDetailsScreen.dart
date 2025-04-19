import 'package:flutter/material.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;
import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/widgets.dart';
import 'package:parla_italiano/globals/navigationBar.dart';
import 'package:parla_italiano/handler/vocabularyHandler.dart';


class VocabularyDetailsScreen extends StatefulWidget {
  
  String? tablename;
  int? table_level;
  VocabularyDetailsScreen({super.key, this.tablename, this.table_level});
  

  @override
  VocabularyDetailsScreenState createState() => VocabularyDetailsScreenState(table_level: table_level, tablename: tablename);
}

class VocabularyDetailsScreenState extends State<VocabularyDetailsScreen> {

  int? table_level;
  String? tablename;
  VocabularyDetailsScreenState({required this.table_level, required this.tablename});
  late List<Vocabulary> vocabularylist = VocabularyHandler().getAllVocabulariesFromLevel(table_level!);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return getRightLayout(constraints.maxWidth);
      })
    );
  }

  Scaffold getRightLayout(double layoutWidth) {
    if (layoutWidth > 500) {
      return _getDesktopLayout(context);
    } else {
      return _getSmartphoneLayout(context);
    }
  }
  
  Scaffold _getDesktopLayout(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(1),
      appBar: CustomAppBar(),
        body: Container(
          decoration: new BoxDecoration(
            color: Colors.purple,
            gradient: new LinearGradient(
              colors: [Colors.green, Colors.white, Colors.red],
              //begin: Alignment.topLeft,
              //end: Alignment.topRight,
            ),
          ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child:
            Column(
              children: [
                const SizedBox(height: 10),
                Row(children: [
                        Expanded(
                          flex: 15,
                          child: Center(                   
                            child: Text(
                              '${widget.tablename}',
                              style: TextStyle(
                                fontSize: 26,
                                color: Colors.black87,
                              )
                            ),
                          ),
                        ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,),
                const SizedBox(height: 10),
                const Divider(
                  color: Colors.black
                ),
                const SizedBox(height: 10),
                VocabularyListTileWidgetDesktop(),
                const Divider(
                  color: Colors.black,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: this.vocabularylist.length,
                    itemBuilder: (context, index){
                      Vocabulary actualVocabulary = this.vocabularylist[index];
                      return VocabularyWidgetDesktop(actualVocabulary.italian, actualVocabulary.german, actualVocabulary.additional);      
                      ;
                    }
                  )
                ),
                const SizedBox(height: 20),
              ],
            )
        )
      )
    );   
  } 

  Scaffold _getSmartphoneLayout(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(1),
      appBar: CustomAppBarSmartphone(actualPageName: "Vokabeln"),
        body: Container(
          decoration: new BoxDecoration(
            color: Colors.purple,
            gradient: new LinearGradient(
              colors: [Colors.green, Colors.white, Colors.red],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child:
            Column(
              children: [
                const SizedBox(height: 10),
                Row(children: [
                        Expanded(
                          flex: 15,
                          child: Center(                   
                            child: Text(
                              '${widget.tablename}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              )
                            ),
                          ),
                        ),
                ],
                mainAxisAlignment: MainAxisAlignment.center),
                const Divider(
                  color: Colors.black
                ),
                VocabularyListTileWidgetSmartphone(),
                const Divider(
                  color: Colors.black,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: this.vocabularylist.length,
                    itemBuilder: (context, index){
                      Vocabulary actualVocabulary = this.vocabularylist[index];
                      return VocabularyWidgetSmartphone(actualVocabulary.italian, actualVocabulary.german, actualVocabulary.additional);      
                      ;
                    }
                  )
                ),
                const SizedBox(height: 20),
              ],
            )
        )
      )
    );
  }

  List<Vocabulary> _getAllVocabularies(){
    for (VocabularyTable table in globalData.vocabularyRepo!.vocabularyTables){
      if (table.level == table_level || table.title == tablename){
        return  table.vocabularies;
      }
    }
    if (table_level== 0){
      return globalData.vocabularyRepo!.favouritesTable.vocabularies;
    }
    return [];
  }
}