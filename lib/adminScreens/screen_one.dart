import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/adminScreens/ugoScreen.dart';
import 'package:parla_italiano/dbModels/DBtable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:parla_italiano/widgets.dart';
import 'package:parla_italiano/dbModels/DBvocabulary.dart';
import 'package:parla_italiano/handler/vocabularyHandler.dart';
import 'package:parla_italiano/constants/colors.dart' as colors;
import 'package:parla_italiano/globals/globalData.dart' as globalData;

class ScreenOne extends StatefulWidget {
  String? id;
  String? tableName;
  ScreenOne({super.key, this.id, this.tableName});
  late List<Vocabulary> vocabularies = globalData.vocabularyRepo!.getVocabulariesFromID(this.id!);

  @override
  ScreenOneState createState() => ScreenOneState();
}

class ScreenOneState extends State<ScreenOne> {

  final _formKey = GlobalKey<FormState>();
  final _nameFormKey = GlobalKey<FormState>();
  final _controllerGerman = TextEditingController();
  final _controllerItalian = TextEditingController();
  final _controllerAdditional = TextEditingController();
  final _controllerNewName = TextEditingController();
  final _vocabularyHandler = VocabularyHandler();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Form(
              key: _nameFormKey,
              child: 
            Row(children: [
              ElevatedButton(
                onPressed: () => context.go('/ugoScreen'), 
                child: const Text('Zurück zur Vokabelübersicht')
              ),
            const SizedBox(width: 30), 
            
                  Expanded(
                    child: TextFormField(
                  controller: _controllerNewName,
                  decoration: const InputDecoration(hintText: 'neuer Name'),
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'gib einen neuen Namen ein';
                    }
                    return null;
                  },
                )),
                const SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () async {
                      if (_nameFormKey.currentState!.validate()) {
                        await _vocabularyHandler.changeTableName(widget.id!, _controllerNewName.text, context);
                        setState(() {
                          widget.tableName = _controllerNewName.text;
                        });
                        _controllerNewName.clear();
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.border_color),
                        SizedBox(width: 4),
                        Text('Name ändern'),
                      ],
                )),
                
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            ),
            ),
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
                        _controllerItalian.clear();
                        _controllerGerman.clear();
                        _controllerAdditional.clear();
                        if (await _vocabularyHandler.createVocabulary(italian: italian, german: german, additional: additional, id: widget.id!)){
                          setState(() {
                            widget.vocabularies;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Diese Vokabel gibt es schon')));
                        }
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
              Text(
                    setText((widget.tableName)),
                    style: TextStyle(
                    fontSize: 28,
                    color: Colors.black87,
                  ),),
             ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text('italienisch', style: TextStyle(fontWeight: FontWeight.bold)),
                flex: 1,
              ),
              Expanded(
                child: Text('deutsch', style: TextStyle(fontWeight: FontWeight.bold)),
                flex: 1,
              ),
              Expanded(
                child: Text('zusätzliches', style: TextStyle(fontWeight: FontWeight.bold),),
                flex: 1,
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
              children:[
                Visibility(
                  child: IconButton(
                    icon: Icon(Icons.change_circle),
                    tooltip: 'umsortieren',
                    onPressed:() {
                      
                    }
                  ),
                  visible: false,
                  maintainSize: true, 
                  maintainAnimation: true,
                  maintainState: true,
                ),
                Visibility(
                  child: IconButton(
                    icon: Icon(Icons.change_circle),
                    tooltip: 'umsortieren',
                    onPressed:() {
                      
                    }
                  ),
                  visible: false,
                  maintainSize: true, 
                  maintainAnimation: true,
                  maintainState: true,
                ),
                Visibility(
                  child: IconButton(
                    icon: Icon(Icons.change_circle),
                    tooltip: 'umsortieren',
                    onPressed:() {
                      
                    }
                  ),
                  visible: false,
                  maintainSize: true, 
                  maintainAnimation: true,
                  maintainState: true,
                )
              ]
            )
          
          
        ),
              
              ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.vocabularies.length,
                      itemBuilder: (context, index){
                        return VocabWidget(widget.vocabularies[index], widget.vocabularies);
                          
                      }
              )
                      
                  
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

class VocabWidget extends StatefulWidget {

  VocabWidget(this.vocab, this.vocabTable, {super.key});

  Vocabulary vocab;
  List<Vocabulary> vocabTable;
  bool visibilityBool = true;

  @override
  State<VocabWidget> createState() => _VocabWidgetState();

}
class _VocabWidgetState extends State<VocabWidget> {

  @override
  Widget build(BuildContext context) {
    if (widget.visibilityBool){
      return Card(
        child: ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text(widget.vocab.italian),
                flex: 1,
              ),
              Expanded(
                child: Text(widget.vocab.german),
                flex: 1,
              ),
              Expanded(
                child: Text(widget.vocab.additional),
                flex: 1,
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
              children:[
                IconButton(
                  icon: Icon(Icons.change_circle),
                  tooltip: 'umsortieren',
                  onPressed:() async {
                    if(await buildChangeLevelDialog(context, widget.vocab)){
                      setState(() {
                        widget.visibilityBool = false;                      
                      });
                    }
                  }
                ),
                IconButton(
                  icon: Icon(Icons.border_color),
                  tooltip: 'bearbeiten',
                  onPressed:() async {
                    await buildModifyDialog(context, widget.vocab);
                  }
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  tooltip: 'löschen',
                  onPressed:() async {
                    if (await buildDeleteDialog(context, widget.vocab)){
                      setState(() {
                        widget.visibilityBool = false;
                        widget.vocabTable.remove(widget.vocab);
                        VocabularyHandler().deleteVocabularyById(widget.vocab.id);
                      });
                    }
                  }
                ),
              ]
            )
          
          
        )
      );
    } else {
      return Visibility(
        visible: false,
        child: Card(
        child: ListTile(
          title: Text(''),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'löschen',
            onPressed:() {
              setState((){
                widget.visibilityBool = false;
              });
            }
          ),
        )
      )
      );
    }
    
  }

  Future<bool> buildDeleteDialog(BuildContext context, Vocabulary vocab) async {
    var response = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black, width: 2.0)),
              backgroundColor: Colors.white,
              title: const Text('Möchtest du diese Vokabel löschen?', textAlign: TextAlign.center,),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      '${setText((vocab.italian))} -> ${vocab.german}',
                    ),
                  ),
                ]
              ),
              actions: <Widget>[
                Center(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.center,
                              backgroundColor: colors.popUpButtonColor
                            ),
                            onPressed:() {
                              Navigator.of(context).pop(false);
                            }, 
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text('nein'),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.center,
                              backgroundColor: colors.popUpButtonColor
                            ),
                            onPressed:() {
                              Navigator.of(context).pop(true);
                            },
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text('ja'),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                )
              ],             
            );
          },
        );
    return response ?? false;
  }

  buildModifyDialog(BuildContext context, Vocabulary vocab) async {
    final _formKey = GlobalKey<FormState>();
    final _controllerGerman = TextEditingController();
    final _controllerItalian = TextEditingController();
    final _controllerAdditional = TextEditingController();
    var response = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black, width: 2.0)
              ),
              backgroundColor: Colors.white,
              title: const Text('Möchtest du diese Vokabel ändern?', textAlign: TextAlign.center,),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Flexible(
                      child: TextFormField(
                      controller: _controllerItalian,
                      decoration: InputDecoration(hintText: (vocab.italian != null ? vocab.italian : 'italienisch')),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'italienisch fehlt';
                        }
                        return null;
                      },
                    )),
                    const SizedBox(height: 8),
                    Flexible(
                      child: TextFormField(
                        controller: _controllerGerman,
                        decoration: InputDecoration(hintText: (vocab.german != null ? vocab.german : 'deutsch')),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'deutsch fehlt';
                          }
                          return null;
                        },
                      )
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: TextFormField(
                        controller: _controllerAdditional,
                        decoration: InputDecoration(hintText: (vocab.additional != null || vocab.additional == '' ? vocab.additional : 'zusätzliches')),
                      )
                    ),
                    const SizedBox(height: 8),
                  ]
                ),
              ),
              actions: <Widget>[
                Center(
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.center,
                              backgroundColor: colors.popUpButtonColor
                            ),
                            onPressed:() async {
                              if (_formKey.currentState!.validate()) {
                                final italian = _controllerItalian.text;
                                final german = _controllerGerman.text;
                                final additional = _controllerAdditional.text;
                                if (await VocabularyHandler().changeVocabulary(italian: italian, german: german, additional: additional, vocabulary: widget.vocab)){
                                  setState(() {
                                    _controllerItalian.clear();
                                    _controllerGerman.clear();
                                    _controllerAdditional.clear();
                                    Navigator.of(context).pop(true);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Diese Vokabel gibt es schon')));
                                }
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Text('ändern'),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                )
              ],             
            );
          },
        );
    return response ?? false;
  }

  buildChangeLevelDialog(BuildContext context, Vocabulary vocab) async {
    var response = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.black, width: 2.0)
              ),
              backgroundColor: Colors.white,
              title: const Text('Zu welchem Level verschieben?', textAlign: TextAlign.center,),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      height: 300,
                      width: 400,
                      child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: globalData.vocabularyRepo!.vocabularyTables.length,
                          itemBuilder: (context, index){
                            return Card(
                              child: ListTile(
                                leading: Text('Level ${globalData.vocabularyRepo!.vocabularyTables[index].level.toString()}'),
                                title: Text(globalData.vocabularyRepo!.vocabularyTables[index].title),
                                trailing: IconButton(
                                  icon: Icon(Icons.check),
                                  tooltip: 'hierhin verschieben',
                                  onPressed:() {
                                    setState(() {
                                      VocabularyHandler().moveVocabularyToTable(widget.vocab, globalData.vocabularyRepo!.vocabularyTables[index]);
                                      Navigator.of(context).pop(true);
                                    });
                                  },
                                ),
                              ), 
                            );
                          }
                        )
                      ),
                    ),      
                  ),
                ]
              ),         
            );
          },
        );
        return response ?? false;
  }
}