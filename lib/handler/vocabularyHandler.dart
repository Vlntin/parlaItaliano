
import 'package:parla_italiano/adminScreens/DBtable.dart';
import 'package:parla_italiano/adminScreens/DBvocabulary.dart';
import 'package:flutter/material.dart';

import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;

class VocabularyHandler {

  VocabularyHandler();

  Widget buildTables(DBTables table) => ListTile(
    leading: CircleAvatar(child:Text('${table.level}')),
    title: Text(table.title));

  int calculateAmounts(String tableId, List<DBVocabulary> vocabularylist){
    int amount = 0;
    for (DBVocabulary vocabulary in vocabularylist){
      if (vocabulary.table_id == tableId){
        amount = amount + 1;
      }
    }
    return amount;
  }

  List<Vocabulary> getAllVocabulariesFromLevel(int table_level){
    for (VocabularyTable table in globalData.vocabularyRepo!.vocabularyTables){
      if (table.level == table_level){
        return  table.vocabularies;
      }
    }
    if (table_level == 0){
      return globalData.vocabularyRepo!.favouritesTable.vocabularies;
    }
    return [];
  }
  
}
