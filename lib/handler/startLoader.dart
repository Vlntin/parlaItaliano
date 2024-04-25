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

class StartLoader {

  StartLoader();

  void loadUserData(){

  }

  void loadVocabularyData() async{
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

  void loadGameData(){

  }
}