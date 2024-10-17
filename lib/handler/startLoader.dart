import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parla_italiano/dbModels/DBclassicGame.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/dbModels/DBtable.dart';
import 'package:parla_italiano/dbModels/DBvocabulary.dart';
import 'package:parla_italiano/games/classicGame.dart';
import 'package:parla_italiano/handler/gameHandler.dart';
import 'package:parla_italiano/handler/vocabularyHandler.dart';
import 'package:parla_italiano/models/gamesRepo.dart';
import 'package:parla_italiano/models/vocabularyRepo.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;
//import 'package:parla_italiano/vocabularies/handler.dart';

class StartLoader {

  StartLoader();

  
  Future<void> _loadVocabularyData() async{
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
  
  /** 
  void _loadVocabularyData2(BuildContext context) async{
    VocabularyHandler vocabularyHandler = VocabularyHandler();
    await vocabularyHandler.writeTXT();
    print('a');
    List<VocabularyTable> vocabularyTables = await vocabularyHandler.startConfiguration(context);
    print('b');
    VocabularyRepo repo = VocabularyRepo(vocabularyTables, VocabularyTable('Meine Favoriten', 0, '0'));
    repo.fillFavouriteTable();
    userData.vocabularyRepo = repo;
  } 
  */

  Future<bool> _loadGameData() async{
    List<DBclassicGame>? dbgames;
    await for (List<DBclassicGame> list in GameHandler().readGames()){
      dbgames = list;
      break;
    }
    List<List<ClassicGame>> games = await GameHandler().startConfiguration(dbgames!);
    GamesRepo repo = GamesRepo(games[0], games[1]);
    userData.gamesRepo = repo;
    return true;
  }

  void _loadUserData(AppUser appUser) async{
    userData.user = appUser;
  }


  Future<bool> loadData(AppUser appUser, BuildContext context) async {
    _loadUserData(appUser);
    await _loadVocabularyData();
    //_loadVocabularyData2(context);
    //bool loaded = await _loadGameData();
    //userData.news = await userData.createNews();
    //print('Länge:${userData.news.length}');
    //return loaded;
    return true;
  }
}