import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/screens/ugoScreen.dart';
import 'package:parla_italiano/dbModels/DBtable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parla_italiano/widgets.dart';
import 'package:parla_italiano/dbModels/DBvocabulary.dart';
import 'package:parla_italiano/handler/vocabularyHandler.dart';

class ScreenOne extends StatefulWidget {
  String? id;
  String? tableName;
  ScreenOne({super.key, this.id, this.tableName});

  @override
  ScreenOneState createState() => ScreenOneState();
}

class ScreenOneState extends State<ScreenOne> {

  final _formKey = GlobalKey<FormState>();
  final _controllerGerman = TextEditingController();
  final _controllerItalian = TextEditingController();
  final _controllerAdditional = TextEditingController();
  final _vocabularyHandler = VocabularyHandler();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(children: [
              const SizedBox(height: 18),
              Text(setText((widget.tableName)),
                    style: TextStyle(
                    fontSize: 26,
                    color: Colors.black87,
                  )),
            const SizedBox(width: 38),   
            ElevatedButton(
              onPressed: () => context.go('/'), 
              child: const Text('Zurück zur Vokabelübersicht')
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,),
            const SizedBox(height: 18),
              const Divider(
              color: Colors.black
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const Text('Neue Vokabel erstellen',
                    style: TextStyle(
                    fontSize: 28,
                    color: Colors.black87,
                  ),),
                  const SizedBox(height: 8),
                Row(children: [
                const SizedBox(width: 8),
                Expanded(
                    child: TextFormField(
                  controller: _controllerItalian,
                  decoration: const InputDecoration(hintText: 'italienisch'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'italienisch fehlt';
                    }
                    return null;
                  },
                )),
                const SizedBox(width: 8),
                Expanded(
                    child: TextFormField(
                  controller: _controllerGerman,
                  decoration: const InputDecoration(hintText: 'deutsch'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'deutsch fehlt';
                    }
                    return null;
                  },
                )),
                const SizedBox(width: 8),
                Expanded(
                    child: TextFormField(
                  controller: _controllerAdditional,
                  decoration: const InputDecoration(hintText: 'zusätzliches'),
                )),
                const SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final italian = _controllerItalian.text;
                        final german = _controllerGerman.text;
                        final additional = _controllerAdditional.text;
                        _vocabularyHandler.createVocabulary(italian: italian, german: german, additonal: additional, id: widget.id!);
                        _controllerItalian.clear();
                        _controllerGerman.clear();
                        _controllerAdditional.clear();
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 4),
                        Text('Vokabel erstellen'),
                      ],
                )),
                const SizedBox(width: 8),
              ]),
              ],)),
              const SizedBox(height: 18),
              const Divider(
              color: Colors.black
              ),
              const Text('Vorhandene Vokabeln',
                    style: TextStyle(
                    fontSize: 28,
                    color: Colors.black87,
                  ),),
              VocabularyListTileWidget(),
            StreamBuilder(
                stream: _vocabularyHandler.readVocabularies(), 
                builder: (context, snapshot) {
                  if (snapshot.hasData){
                    final vocabularies = snapshot.data!;
                    final filtered_vocabularies = filterVocabularies(vocabularies);
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: filtered_vocabularies.length,
                      itemBuilder: (context, index){
                        return ListTile(
                          title: VocabularyWidget(filtered_vocabularies[index].id, filtered_vocabularies[index].italian, filtered_vocabularies[index].german, filtered_vocabularies[index].additional),
                          trailing: Row(children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.border_color),
                              onPressed:() => context.goNamed('screen_one', pathParameters: {'id': filtered_vocabularies[index].id})),
                            SizedBox(width: 14),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed:() {
                                final docUser = FirebaseFirestore.instance
                                  .collection('vocabularies')
                                  .doc(filtered_vocabularies[index].id);
                                docUser.delete();
                              })
                          ], mainAxisSize: MainAxisSize.min,));
                          
                      });
                  } else {
                    return Text('Something went wrong');
                  }
                }),
          ],
        ), physics: ScrollPhysics(),),
    );
  }
  Widget buildTables(DBTables table) => ListTile(
    leading: CircleAvatar(child:Text('${table.level}')),
    title: Text(table.title));

  List<DBVocabulary> filterVocabularies(List<DBVocabulary> vocabularies){
    List<DBVocabulary> filtered_vocabularies = [];
    for (DBVocabulary vocabulary in vocabularies){
      if (vocabulary.table_id == widget.id) {
        filtered_vocabularies.add(vocabulary);
      }
    }
    return filtered_vocabularies;
  }
}

String setText(String? id){
 String a = 'a';
  if (id != null){
    a = id;
  }
  return a;
}