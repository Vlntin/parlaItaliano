import 'dart:js_util';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/globals/userData.dart' as userData;
import 'package:parla_italiano/globals/vocabularyRepository.dart' as repository;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parla_italiano/handler/DBtable.dart';
import 'package:parla_italiano/screen_one.dart';
import 'package:parla_italiano/handler/DBvocabulary.dart';
import 'package:parla_italiano/handler/vocabularyHandler.dart';
import 'package:parla_italiano/widgets.dart';

class VocabularyListsScreen extends StatefulWidget {
  const VocabularyListsScreen({super.key});

  @override
  _VocabularyListsScreenState createState() => _VocabularyListsScreenState();
}

class _VocabularyListsScreenState extends State<VocabularyListsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllerTitle = TextEditingController();
  final _controllerLevel = TextEditingController();
  List<DBVocabulary> vocabularylist = [];
  List<DBTables> tableList = [];
  final _vocabularyHandler = VocabularyHandler();
  bool _vocabularyListLocked = true;
  int actualLexis = repository.calculateLexis(userData.level);
  int maxLexis = repository.calculatemaximalLexis();
  double proportionalLexis = repository.calculateLexis(userData.level) / repository.calculatemaximalLexis();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body:
      Padding(
        padding: const EdgeInsets.all(16),
        child:
        Column(children: [
            Expanded(
              flex: 10,
              child: Row ( children: [
                Expanded(
                  flex: 6,
                  child: Center(
                    child: const Text(
                      'Vorhandene Vokabellisten',
                      style: TextStyle(
                      fontSize: 28,
                      color: Colors.black87,
                      )
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
            StreamBuilder(
              stream: _vocabularyHandler.readVocabularies(), 
              builder: (context, snapshot) {
                if (snapshot.hasData){
                  vocabularylist = snapshot.data!;
                  return Text('');
                } else {
                  return Text('');
                }
              }
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
                            itemCount: repository.vocabularyTables.length,
                            itemBuilder: (context, index){
                              return Card(
                                child: ListWidget(repository.vocabularyTables[index].vocabularies.length, repository.vocabularyTables[index].level, repository.vocabularyTables[index].title, repository.vocabularyTables[index].db_id),
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
            ),    
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    TextButton(
                      child: Text('zu Start screen'),
                      onPressed:() => context.go('/startScreen')
                    ),
                  ]
              )
            )
        ])        
      ) 
    );
  }

}

/**ListTile(
                            ${if tableList[index].level > userData.level:};
                            tileColor: Colors.red[200],
                            leading: Text('${_vocabularyHandler.calculateAmounts(tableList[index].id, vocabularylist).toString()} Wörter', textAlign: TextAlign.center,),
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
                                        Text ('${tableList[index].level.toString()}', textAlign: TextAlign.start,)
                                      ]),
                                    ),
                                    Expanded(
                                      child: Text ('${tableList[index].title}', textAlign: TextAlign.center,),
                                      flex: 10),
                                  ],
                                )
                              ),
                            trailing:
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 10),
                                  Icon(Icons.done_outlined),
                                  SizedBox(width: 10), 
                                  IconButton(
                                    icon: Icon(Icons.search),
                                    tooltip: 'Vokabeln anschauen',
                                    onPressed:() => context.goNamed('screen_one', pathParameters: {'id': tableList[index].id, 'tablename': tableList[index].title})),
                                  SizedBox(width: 10),
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
                          )*/