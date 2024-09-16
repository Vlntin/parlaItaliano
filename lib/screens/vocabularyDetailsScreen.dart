import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;
import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:parla_italiano/globals/appBar.dart';
import 'package:parla_italiano/widgets.dart';
import 'package:parla_italiano/globals/navigationBar.dart';
import 'package:parla_italiano/handler/vocabularyHandler.dart';


class VocabularyDetailsScreen extends StatefulWidget {
  
  String? tablename;
  String? table_id;
  VocabularyDetailsScreen({super.key, this.tablename, this.table_id});
  

  @override
  VocabularyDetailsScreenState createState() => VocabularyDetailsScreenState(table_id: table_id, tablename: tablename);
}

class VocabularyDetailsScreenState extends State<VocabularyDetailsScreen> {

  String? table_id;
  String? tablename;
  VocabularyDetailsScreenState({required this.table_id, required this.tablename});
  late List<Vocabulary> vocabularylist = VocabularyHandler().getAllVocabularies(table_id!, tablename!);
  

  @override
  Widget build(BuildContext context){
    return PopScope(
    canPop: false,
    child: Scaffold(
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
                VocabularyListTileWidget(),
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
                      return VocabularyWidget(actualVocabulary.id, actualVocabulary.italian, actualVocabulary.german, actualVocabulary.additional)      
                      ;
                    }
                  )
                ),
                const SizedBox(height: 20),
              ],
            )
        )
      )
    )
  
    );

   
  } 

  List<Vocabulary> _getAllVocabularies(){
    for (VocabularyTable table in globalData.vocabularyRepo!.vocabularyTables){
      if (table.db_id == table_id || table.title == tablename){
        return  table.vocabularies;
      }
    }
    if (table_id == '0'){
      return globalData.vocabularyRepo!.favouritesTable.vocabularies;
    }
    return [];
  }
}