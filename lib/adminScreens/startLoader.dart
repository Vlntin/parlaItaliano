import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:parla_italiano/adminScreens/vocabulary.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/adminScreens/DBtable.dart';
import 'package:parla_italiano/adminScreens/DBvocabulary.dart';
import 'package:parla_italiano/adminScreens/vocabHandler.dart';
import 'package:parla_italiano/adminScreens/vocabularyRepo.dart';
import 'package:parla_italiano/adminScreens/vocabularyTable.dart';
import 'package:parla_italiano/adminScreens/globalData.dart' as userData;
import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:path_provider/path_provider.dart';

class StartLoader {

  StartLoader();

  Future<void> _loadVocabularyDataAdmin() async{
    VocabHandler vocabularyHandler = VocabHandler();
    List<DBTables>? tableList;
    List<DBVocabulary>? vocabularyList;
    await for (List<DBTables> list in await vocabularyHandler.readTables()){
      tableList = list;
      break;
    }
    await for (List<DBVocabulary> list in await vocabularyHandler.readVocabularies()){
      vocabularyList = list;
      break;
    }
    List<VocabTable> vocabularyTables = vocabularyHandler.startConfiguration(vocabularyList!, tableList!);
    VocabRepo repo = VocabRepo(vocabularyTables);
    userData.vocabularyRepo = repo;

     
    for (VocabTable table in vocabularyTables){
      print(table.title);
      for (Vocab vocab in table.vocabularies){
        print(vocab.italian + ',' + vocab.german + ',' + vocab.additional);
      }
    }
    
  } 

  void _loadUserData(AppUser appUser) async{
    userData.user = appUser;
  }


  Future<bool> loadData(AppUser appUser, BuildContext context) async {
    _loadUserData(appUser);
    await _loadVocabularyDataAdmin();
    return true;
  }
}