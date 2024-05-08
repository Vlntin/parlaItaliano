import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parla_italiano/globals/vocabularyRepository.dart' as repository;
import 'package:parla_italiano/models/appUser.dart';
import 'package:parla_italiano/models/DBtable.dart';
import 'package:parla_italiano/models/DBvocabulary.dart';
import 'package:parla_italiano/handler/vocabularyHandler.dart';
import 'package:parla_italiano/globals/vocabularyRepository.dart' as vocabularyRepo;
import 'package:parla_italiano/globals/userData.dart' as userData;

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
    vocabularyHandler.startConfiguration(vocabularyList!, tableList!);
    vocabularyRepo.fillFavouriteTable();
  } 

  void _loadGameData(){

  }

  void _loadUserData(AppUser appUser){
    userData.user = appUser;
  }

  void loadData(AppUser appUser){
    _loadUserData(appUser);
    _loadVocabularyData();
    _loadGameData();
  }
}