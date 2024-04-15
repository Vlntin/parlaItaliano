import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parla_italiano/handler/table.dart';
import 'package:parla_italiano/handler/vocabulary.dart';
import 'package:flutter/material.dart';

class VocabularyHandler {

  VocabularyHandler();

  deleteVocabularyIdsByTableId(String tableId, List<Vocabulary> vocabularylist){
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
  
}
