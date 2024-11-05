
import 'package:flutter/material.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:parla_italiano/constants/texts.dart' as texts;
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
  int currentPageIndex = 1;
  List<VocabularyTable> tableList = globalData.vocabularyRepo!.vocabularyTables;
  final _vocabularyHandler = VocabularyHandler();
  int actualLexis = globalData.vocabularyRepo!.calculateLexis(globalData.user!.level);
  int maxLexis = globalData.vocabularyRepo!.calculatemaximalLexis();
  double proportionalLexis = globalData.vocabularyRepo!.calculateLexis(globalData.user!.level) / globalData.vocabularyRepo!.calculatemaximalLexis();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        if (constraints.maxWidth > 1200){
          return VocabularyListsScreenBig();
        } else {
          return VocabularyListsScreenSmall();
        }
        
      })
    );
  }
}

class VocabularyListsScreenBig extends StatefulWidget {
  const VocabularyListsScreenBig({super.key});

  @override
  _VocabularyListsScreenStateBig createState() => _VocabularyListsScreenStateBig();
}

class _VocabularyListsScreenStateBig extends State<VocabularyListsScreenBig> {
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
        padding: const EdgeInsets.only(right:25, left:25, top: 0, bottom: 25),
        child:
        Column(
          children: [
            Expanded(
                flex: 1,
                child:
                  Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'Vokabelübersicht',
                          style: TextStyle(
                            fontSize: 22.0,
                          fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text('Hier findest du alle Vokabellisten. Alle freigeschalteten Listen kannst du hier anschauen, als PDF speichern und innerhalb der Favoriten eine neue Liste erstellen.'),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.grey
              ),
            Expanded(
              flex: 4,
              child: Row ( 
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Column(
                          children: [
                            Card(
                              child: ListWidget(globalData.vocabularyRepo!.favouritesTable.vocabularies.length, globalData.vocabularyRepo!.favouritesTable.level, globalData.vocabularyRepo!.favouritesTable.title),                              
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: tableList.length,
                                itemBuilder: (context, index){
                                  return Card(
                                    child: ListWidget(tableList[index].vocabularies.length, tableList[index].level, tableList[index].title),
                                  );  
                                }
                              )
                            ),
                          ],
                        )
                      )
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: LinearProgressIndicator(
                                  value: proportionalLexis,
                                  backgroundColor: Colors.white,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(248, 225, 174, 1)),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  minHeight: 20,
                                ),
                            )
                            ),
                            Expanded(
                              flex: 8,
                              child: SizedBox.expand(                      
                                  child: Container(
                                    alignment:  Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.5
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: Color.fromARGB(255, 233, 233, 233),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(texts.vocabularyListExplanations, textAlign: TextAlign.center, ), 
                                      ) 
                                    )
                                  )
                                
                              )
                            )
                          ],
                        )
                      )
                    )
                  ),
                ]
              ), 
            )
          ]
        )        
      ) 
    );
  }
}

class VocabularyListsScreenSmall extends StatefulWidget {
  const VocabularyListsScreenSmall({super.key});

  @override
  _VocabularyListsScreenStateSmall createState() => _VocabularyListsScreenStateSmall();
}

class _VocabularyListsScreenStateSmall extends State<VocabularyListsScreenSmall> {
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
        padding: const EdgeInsets.only(right:25, left:25, top: 0, bottom: 25),
        child:
        Column(
          children: [
            Expanded(
                flex: 1,
                child:
                  Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'Vokabelübersicht',
                          style: TextStyle(
                            fontSize: 22.0,
                          fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text('Hier findest du alle Vokabellisten. Alle freigeschalteten Listen kannst du hier anschauen, als PDF speichern und innerhalb der Favoriten eine neue Liste erstellen.'),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: Colors.grey
              ),
            Expanded(
              flex: 4,
              child: Column ( 
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'aktueller Wortschatz:', 
                                      style: TextStyle(
                                        fontSize: 16
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
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 20),
                                      child: LinearProgressIndicator(
                                        value: proportionalLexis,
                                        backgroundColor: Colors.white,
                                        valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(248, 225, 174, 1)),
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        minHeight: 20,
                                      ),
                                    )
                                  ),
                                ]
                              )
                            ),
                            flex: 1
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: SizedBox.expand(                      
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
                                      padding: EdgeInsets.all(20),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Text(texts.vocabularyListExplanations, textAlign: TextAlign.center, ), 
                                      ) 
                                    )
                                  )
                                
                              ),
                            flex: 3
                          )
                        ],
                      )
                    )
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Column(
                          children: [
                            Card(
                              child: ListWidget(globalData.vocabularyRepo!.favouritesTable.vocabularies.length, globalData.vocabularyRepo!.favouritesTable.level, globalData.vocabularyRepo!.favouritesTable.title),                              
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: tableList.length,
                                itemBuilder: (context, index){
                                  return Card(
                                    child: ListWidget(tableList[index].vocabularies.length, tableList[index].level, tableList[index].title),
                                  );  
                                }
                              )
                            ),
                          ],
                        )
                      )
                    )
                  ),
                ]
              ), 
            )
          ]
        )        
      ) 
    );
  }
}