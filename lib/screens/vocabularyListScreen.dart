import 'dart:js_util';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:parla_italiano/dbModels/DBtable.dart';
import 'package:parla_italiano/dbModels/DBvocabulary.dart';
import 'package:parla_italiano/handler/vocabularyHandler.dart';
import 'package:parla_italiano/widgets.dart';
import 'package:parla_italiano/globals/navigationBar.dart';

class VocabularyListsScreen extends StatefulWidget {
  const VocabularyListsScreen({super.key});

  @override
  _VocabularyListsScreenState createState() => _VocabularyListsScreenState();
}

class _VocabularyListsScreenState extends State<VocabularyListsScreen> {
  //List<DBVocabulary> vocabularylist = [];
  //List<DBTables> tableList = [];
  List<VocabularyTable> tableList = globalData.vocabularyRepo!.vocabularyTables;
  final _vocabularyHandler = VocabularyHandler();
  int actualLexis = globalData.vocabularyRepo!.calculateLexis(globalData.user!.level);
  int maxLexis = globalData.vocabularyRepo!.calculatemaximalLexis();
  double proportionalLexis = globalData.vocabularyRepo!.calculateLexis(globalData.user!.level) / globalData.vocabularyRepo!.calculatemaximalLexis();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(1),
      appBar: CustomAppBar(),
      body:
      Padding(
        padding: const EdgeInsets.all(25),
        child:
        Column(children: [
            Expanded(
              flex: 10,
              child: Row ( children: [
                Expanded(
                  flex: 6,
                  child: Center(
                    child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Vorhandene Vokabellisten:', 
                              style: TextStyle(
                                fontSize: 20
                              ) 
                            )
                          ),
                          Expanded(
                            flex: 1,
                            child: Card(
                                child: ListWidget(globalData.vocabularyRepo!.favouritesTable.vocabularies.length, globalData.vocabularyRepo!.favouritesTable.level, globalData.vocabularyRepo!.favouritesTable.title, globalData.vocabularyRepo!.favouritesTable.db_id),                              
                            )
                          ),
                        ],
                      )
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              'aktueller Wortschatz:', 
                              style: TextStyle(
                                fontSize: 18
                              ) 
                            )
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${actualLexis}/${maxLexis}',
                              style: TextStyle(
                                fontSize: 16,
                              )
                            )
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              height: 15,
                              child: LinearProgressIndicator(
                                value: proportionalLexis,
                                backgroundColor: Colors.white,
                                valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(248, 225, 174, 1)),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ) 
                          ),
                        ],
                      )
                    )
                  )
                ),
              ],)
            ),
            Expanded(
              flex: 50,
              child:Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            //physics: NeverScrollableScrollPhysics(),
                            itemCount: tableList.length,
                            itemBuilder: (context, index){
                              return Card(
                                child: ListWidget(tableList[index].vocabularies.length, tableList[index].level, tableList[index].title, tableList[index].db_id),
                              );  
                            }
                          )
                  ),
                  Expanded(
                    flex: 1,
                    child:Padding( 
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child:SizedBox.expand(                      
                        child: Container(
                          alignment:  Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.5
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Color.fromARGB(255, 233, 233, 233),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text('Hier befinden sich alle Vokabellisten, sortiert nach ihrem Level. Tabellen mit einem Schloss sind noch nicht freigeschalten, wofür man erst den Test erfolgreich bestehen muss. Diesen kannst du durch Klicken auf das Schloss starten. Das Überspringen von Leveln ist jedoch nicht möglich. Über die Lupe kannst du dir die Vokabeln zu dem Thema anschauen und lernen. Außerdem lässt sich so eine eigene Vokabelliste erstellen, indem einzelne Vokabeln aus verschiedenen Themen jeweils ausgewählt werden, wodurch automatisch eine Tabelle mit den Favoriten erstellt wird. Über den Pfeil kannst du dir eine PDF-Datei der Vokabeln erstellen lassen, sodass du auch bequem offline lernen kannst!', textAlign: TextAlign.center, ),  
                        )
                          )
                      ) 
                    )                 
                  )
                ]
              ),   //physics: ScrollPhysics(),))]]),  
            )
        ])        
      ) 
    );
  }
}