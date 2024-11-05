import 'dart:async';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parla_italiano/games/classicGame/DBclassicGame.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/games/classicGame/classicGame.dart';
import 'package:parla_italiano/games/classicGame/classicGameHandler.dart';
import 'package:parla_italiano/games/generic/DBgeneric.dart';
import 'package:parla_italiano/games/generic/genericGame.dart';
import 'package:parla_italiano/games/generic/genericGameHandler.dart';
import 'package:parla_italiano/globals/gamesBibliothek.dart';
import 'package:parla_italiano/handler/vocabularyHandler.dart';
import 'package:parla_italiano/models/gamesRepo.dart';
import 'package:parla_italiano/models/vocabularyRepo.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';
import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;

class StartLoader {

  StartLoader();
  
  Future<bool> _loadVocabularyData() async{
    List<VocabularyTable> vocabularyTables = [];
    for(int i = 1; i < 8; i++){
      vocabularyTables.add(await _createVocabularyTableLevel(i));
    }
    VocabularyRepo repo = VocabularyRepo(vocabularyTables, VocabularyTable('Meine Favoriten', 0));
    repo.fillFavouriteTable();
    userData.vocabularyRepo = repo;
    return true;
  } 

  Future<VocabularyTable> _createVocabularyTableLevel(int level) async{
    final rawData = await rootBundle.loadString("assets/level${level.toString()}.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    VocabularyTable table = VocabularyTable(listData[0][0], level);
    for (int i = 1; i < listData.length; i++){
      Vocabulary vocabulary = Vocabulary(listData[i][1], listData[i][0], listData[i][2]);
      table.addVocabulary(vocabulary);
    }
    return table;
  }

  Future<bool> _loadGameData() async{
    print('start loader');
    List<GenericGame> runningGames = [];
    List<GenericGame> finishedGames = [];
    for (GameInfoCompromised entry in userData.gamesBibliothek.games){
      print('entry');
      GenericGameHandler handler = entry.handler;
      print('handler');
      await for (List<DBgenericGame> list in handler.readGames()){
        print('in read games');
        List<List<GenericGame>> games = await handler.startConfiguration(list);
        for (GenericGame game in games[0]){
          runningGames.add(game);
        }
        for (GenericGame game in games[1]){
          finishedGames.add(game);
        }
        print('Länge running games');
        print(runningGames.length);
        break;
      }
    }
    print('after await');
    GamesRepo repo = GamesRepo(runningGames, finishedGames);
    print('repo');
    userData.gamesRepo = repo;
    print('repo2');
    return true;
  }

  void _loadUserData(AppUser appUser) async{
    userData.user = appUser;
  }


  Future<bool> loadData(AppUser appUser, BuildContext context) async {
    _loadUserData(appUser);
    await _loadVocabularyData();
    bool loaded = await _loadGameData();
    userData.news = await userData.createNews();
    return loaded;
  }
}