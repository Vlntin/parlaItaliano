

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parla_italiano/adminScreens/DBtable.dart';
import 'package:parla_italiano/adminScreens/DBvocabulary.dart';
import 'package:flutter/material.dart';

import 'package:parla_italiano/adminScreens/vocabulary.dart';
import 'package:parla_italiano/adminScreens/vocabularyTable.dart';
import 'package:parla_italiano/adminScreens/globalData.dart' as globalData;

class VocabHandler {

  VocabHandler();

  List<VocabTable> startConfiguration(List<DBVocabulary> dbVocabularies, List<DBTables> dbTables){
    List<VocabTable> vocabularyTables = [];
    for (DBTables table in dbTables){
      VocabTable newTable = VocabTable(table.title, table.level, table.id);
      vocabularyTables.add(newTable);
    }
    for (DBVocabulary vocabulary in dbVocabularies){
      Vocab newVocabulary = Vocab(vocabulary.german, vocabulary.italian, vocabulary.additional, vocabulary.id);
      for (VocabTable table in vocabularyTables){
        if (table.db_id == vocabulary.table_id){
          table.addVocabulary(newVocabulary);
          break;
        }
      }
    }
    vocabularyTables.sort((a, b) => a.level.compareTo(b.level));
    return vocabularyTables;
  }

  deleteVocabularyById(String vocabID){
    final docUser = FirebaseFirestore.instance
      .collection('vocabularies')
      .doc(vocabID);
    docUser.delete();
  }

  Stream<List<DBVocabulary>> readVocabularies() => FirebaseFirestore.instance
    .collection('vocabularies')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => DBVocabulary.fromJson(doc)).toList());

  Widget buildTables(DBTables table) => ListTile(
    leading: CircleAvatar(child:Text('${table.level}')),
    title: Text(table.title));

  Stream<List<DBTables>> readTables() => FirebaseFirestore.instance
    .collection('tables')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => DBTables.fromJson(doc)).toList());
  
  Future<bool> createVocabulary({required String italian, required String german, required String additional, required String id}) async{
    bool isAlreadyUsedWord = false;
    for (VocabTable table in globalData.vocabularyRepo!.vocabularyTables){
      for (Vocab vocab in table.vocabularies){
        if (vocab.german == german || vocab.italian == italian){
          isAlreadyUsedWord = true;
          break;
        }
      }
    }
    if (isAlreadyUsedWord){
      return false;
    } else {
      var vocabularies = FirebaseFirestore.instance.collection('vocabularies').doc();
      final json = {
              'italian': italian,
              'german': german,
              'additional': additional,
              'table_id': id,
            };
      await vocabularies.set(json);
      String newVocabID = vocabularies.id;
      Vocab newVocab = Vocab(german, italian, additional, newVocabID);
      for (VocabTable table in globalData.vocabularyRepo!.vocabularyTables){
        if (table.db_id == id){
          table.vocabularies.add(newVocab);
        }
      }
      return true;
    }
  } 

  Future<bool> changeVocabulary({required String italian, required String german, required String additional, required Vocab vocabulary}) async{
    bool isAlreadyUsedWord = false;
    for (VocabTable table in globalData.vocabularyRepo!.vocabularyTables){
      for (Vocab vocab in table.vocabularies){
        if ((vocab.german == german || vocab.italian == italian) && vocab.id != vocabulary.id){
          isAlreadyUsedWord = true;
          break;
        }
      }
    }
    if (isAlreadyUsedWord){
      return false;
    } else {
      var query = await FirebaseFirestore.instance.collection('vocabularies').where('german', isEqualTo: vocabulary.german).get();
      var firestoreInstanceId = query.docs.first.id;
      FirebaseFirestore.instance.collection('vocabularies').doc(firestoreInstanceId).update({'german': german, 'italian': italian, 'additional': additional});
      for (VocabTable table in globalData.vocabularyRepo!.vocabularyTables){
        for (Vocab vocab in table.vocabularies){
          if (vocab.id == vocabulary.id){
            vocab.german = german;
            vocab.italian = italian;
            vocab.additional = additional;
            break;
          }
        }
      }
      return true;
    }
  }

  void moveVocabularyToTable(Vocab vocab, VocabTable table) async{
    for (VocabTable vocabularyTable in globalData.vocabularyRepo!.vocabularyTables){
      if (vocabularyTable.vocabularies.contains(vocab)){
        vocabularyTable.vocabularies.remove(vocab);
      }
      if (vocabularyTable.db_id == table.db_id){
        vocabularyTable.addVocabulary(vocab);
      }
    }
    var query = await FirebaseFirestore.instance.collection('vocabularies').where('german', isEqualTo: vocab.german).get();
    var firestoreInstanceId = query.docs.first.id;
    FirebaseFirestore.instance.collection('vocabularies').doc(firestoreInstanceId).update({'table_id': table.db_id});
      
  }

  changeTableName(String id, newName, BuildContext context) async {
    int level = 0;
    for (VocabTable table in globalData.vocabularyRepo!.vocabularyTables){
      if (table.db_id == id){
        table.title = newName;
        level = table.level;
      }
    }
    var query = await FirebaseFirestore.instance.collection('tables').where('level', isEqualTo: level).get();
    var firestoreInstanceId = query.docs.first.id;
    FirebaseFirestore.instance.collection('tables').doc(firestoreInstanceId).update({'title': newName});
  }
  
}