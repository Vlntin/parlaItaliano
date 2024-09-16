import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/dbModels/DBtable.dart';
import 'package:parla_italiano/dbModels/DBvocabulary.dart';
import 'package:parla_italiano/handler/vocabularyHandler.dart';
import 'package:parla_italiano/models/vocabularyRepo.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;

class StartLoader {

  StartLoader();

  void _loadVocabularyData() async{
    VocabularyHandler vocabularyHandler = VocabularyHandler();
    List<DBTables>? tableList;
    List<DBVocabulary>? vocabularyList;
    await for (List<DBTables> list in vocabularyHandler.readTables()){
      tableList = list;
      break;
    }
    await for (List<DBVocabulary> list in vocabularyHandler.readVocabularies()){
      vocabularyList = list;
      break;
    }
    List<VocabularyTable> vocabularyTables = vocabularyHandler.startConfiguration(vocabularyList!, tableList!);
    VocabularyRepo repo = VocabularyRepo(vocabularyTables, VocabularyTable('Meine Favoriten', 0, '0'));
    repo.fillFavouriteTable();
    userData.vocabularyRepo = repo;
  } 

  void _loadGameData(){

  }

  void _loadUserData(AppUser appUser) async{
    userData.user = appUser;
    userData.user!.printerMethod();
  }

  void loadData(AppUser appUser){
    _loadUserData(appUser);
    _loadVocabularyData();
    _loadGameData();
  }
}