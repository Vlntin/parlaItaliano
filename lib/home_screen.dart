import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/handler/table.dart';
import 'package:parla_italiano/screen_one.dart';
import 'package:parla_italiano/handler/vocabulary.dart';
import 'package:parla_italiano/handler/vocabularyHandler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controllerTitle = TextEditingController();
  final _controllerLevel = TextEditingController();
  List<Vocabulary> vocabularylist = [];
  List<Tables> tableList = [];
  final _vocabularyHandler = VocabularyHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:
              SingleChildScrollView(child:
              Column(children: [
              Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Text('Generelle Idee:',
                    style: TextStyle(
                    fontSize: 28,
                    color: Colors.red,
                  ),),
                  const SizedBox(height: 8),
                  const Text('Zu jedem Thema gibt es eine Tabelle mit Wörtern. Jeder Tabelle gehört ein Level an. Die Level repräsentieren nicht die Schwierigkeit,sondern eher die Reihenfolge, in der die Vokabeln gelernt werden sollen. Man beginnt also mit den Vokabeln auf Level 1. Ein Level kann aus mehreren Tabellen bestehen. Eine Tabelle besteht dann aus den eigentlichen Vokabeln. Jede Vokabel muss natürlich eine deutsche und eine italienische Übersetzung haben. Es gibt auch noch ein zusätzliches Feld, wo due eintragen kannst, was du sinnvoll findest. Du kannst es aber auch leer lassen. Bitte achte darauf, dass jedes Level insgesamt 150 bis 250 Wörter besitzt.Wenn eine Vokabel oder eine gesamte Tabelle gelöscht ist, gibt es kein Backup, also nicht aus Versehen auf den Mülleimer klicken!',
                    style: TextStyle(
                    color: Colors.black87,
                  ),),
                  const SizedBox(height: 18),
                  const Divider(
                  color: Colors.black
                  ),
                  const Text('Neue Vokabelliste erstellen',
                    style: TextStyle(
                    fontSize: 28,
                    color: Colors.black87,
                  ),),
                  const SizedBox(height: 8),
                Row(children: [
                const SizedBox(width: 8),
                Expanded(
                    child: TextFormField(
                  controller: _controllerTitle,
                  decoration: const InputDecoration(hintText: 'Name der Tabelle eingeben'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Gib den Namen der Tabelle an';
                    }
                    return null;
                  },
                )),
                const SizedBox(width: 8),
                Expanded(
                    child: TextFormField(
                  controller: _controllerLevel,
                  decoration: const InputDecoration(hintText: 'Level eingeben'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Gib der Tabelle ein Level';
                    }
                    return null;
                  },
                )),
                const SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final title = _controllerTitle.text;
                        final level = int.parse(_controllerLevel.text);
                        _vocabularyHandler.createTable(title: title, level: level);
                        _controllerTitle.clear();
                        _controllerLevel.clear();
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 4),
                        Text('Tabelle erstellen'),
                      ],
                )),
                const SizedBox(width: 8),
              ]),
              ],)),
              const SizedBox(height: 18),
              const Divider(
              color: Colors.black
              ),
              const Text('Vorhandene Vokabellisten',
                    style: TextStyle(
                    fontSize: 28,
                    color: Colors.black87,
                  ),),
              StreamBuilder(
                stream: _vocabularyHandler.readVocabularies(), 
                builder: (context, snapshot) {
                  if (snapshot.hasData){
                    vocabularylist = snapshot.data!;
                    return Text('');
                  } else {
                    return Text('');
                  }
                }),
                SingleChildScrollView(child: 
              StreamBuilder(
                stream: _vocabularyHandler.readTables(), 
                builder: (context, snapshot) {
                  if (snapshot.hasData){
                    tableList = snapshot.data!;
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: tableList.length,
                      itemBuilder: (context, index){
                        return Card(child:
                        ListTile(
                          leading: Text('Level ${tableList[index].level.toString()}'),
                          title: Row(children: [
                            Text(tableList[index].title, textAlign: TextAlign.center,),
                            SizedBox(width: 30),
                            Text('${_vocabularyHandler.calculateAmounts(tableList[index].id, vocabularylist).toString()} Wörter', textAlign: TextAlign.center,),
                          ], mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,),
                          trailing: Row(children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.border_color),
                              onPressed:() => context.goNamed('screen_one', pathParameters: {'id': tableList[index].id, 'tablename': tableList[index].title})),
                            SizedBox(width: 14),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed:() {
                                final docUser = FirebaseFirestore.instance
                                  .collection('tables')
                                  .doc(tableList[index].id);
                                docUser.delete();
                                _vocabularyHandler.deleteVocabularyIdsByTableId(tableList[index].id, vocabularylist);
                              })
                          ], mainAxisSize: MainAxisSize.min,))); 
                      });
                  } else {
                    return Text('Something went wrong');
                  }
                }),
                physics: ScrollPhysics(),),
                ],
              
              ), physics: ScrollPhysics(),));
  }
/*
  deleteVocabularyIdsByTableId(String tableId){
    for (Vocabulary vocabulary in vocabularylist){
      if (vocabulary.table_id == tableId){
        final docUser = FirebaseFirestore.instance
                                  .collection('vocabularies')
                                  .doc(vocabulary.id);
        docUser.delete();
      }
    }
  }

  Stream<List<Vocabulary>> readVocabularies() => FirebaseFirestore.instance
    .collection('vocabularies')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => Vocabulary.fromJson(doc)).toList());

  Widget buildTables(Tables table) => ListTile(
    leading: CircleAvatar(child:Text('${table.level}')),
    title: Text(table.title));

  Stream<List<Tables>> readTables() => FirebaseFirestore.instance
    .collection('tables')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => Tables.fromJson(doc)).toList());

  Future createTable({required String title, required int level}) async{
    var tables = FirebaseFirestore.instance.collection('tables').doc();
    final json = {
            'title': title,
            'level': level,
          };
    await tables.set(json);
  }

  int calculateAmounts(String tableId, List<Vocabulary> vocabularylist){
    int amount = 0;
    for (Vocabulary vocabulary in vocabularylist){
      if (vocabulary.table_id == tableId){
        amount = amount + 1;
      }
    }
    return amount;
  }
*/
}