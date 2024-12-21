import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/games/GameType.dart';
import 'package:parla_italiano/games/frontendGame.dart';
import 'package:parla_italiano/games/generic/DBgeneric.dart';
import 'package:parla_italiano/games/generic/genericGame.dart';
import 'package:parla_italiano/games/generic/genericGameHandler.dart';
import 'package:parla_italiano/games/memory/DBmemoryGame.dart';
import 'package:parla_italiano/games/memory/memoryGame.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;

class MemoryGameHandler implements GenericGameHandler {

  MemoryGameHandler();

  @override
  Stream<List<DBgenericGame>> readGames() => FirebaseFirestore.instance
    .collection('memoryGames')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => DBmemoryGame.fromJson(doc)).toList());
  
  @override
  void updateGameStats(GenericGame genericGame) async {
    MemoryGame game = genericGame as MemoryGame;
    if (game.finished!){
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);
      String timeStamped = date.toString();
      FirebaseFirestore.instance.collection('memoryGames').doc(game.gameID).update({'timeStamp': timeStamped});
    } else {
      //globalData.gamesRepo!.games.add(FrontGame(genericGame, GameType.memory));
    }
    FirebaseFirestore.instance.collection('memoryGames').doc(game.gameID).update({'actualPlayerID': game.actualPlayer.userID});
    FirebaseFirestore.instance.collection('memoryGames').doc(game.gameID).update({'player1Points': game.player1Points});
    FirebaseFirestore.instance.collection('memoryGames').doc(game.gameID).update({'player2Points': game.player2Points});
    FirebaseFirestore.instance.collection('memoryGames').doc(game.gameID).update({'finished': game.finished});
  }

  //not neccessary becaus only one round. If player leaves, then is it halt so xD
  @override
  Future<bool> setDefault(FrontGame game) async {
    return true;
  }

  @override
  Future<String> createGame(GenericGame genericGame) async {
    MemoryGame game = genericGame as MemoryGame;
    var games = FirebaseFirestore.instance.collection('memoryGames').doc();
    final json = {
      'gameCategory': 1,
      'actualPlayerID': game.actualPlayer.userID,
      'player1ID': game.player1.userID,
      'player1Points': game.player1Points,
      'player2ID': game.player2.userID,
      'player2Points': game.player2Points,
      'vocabularyIDs': game.getVocabularyIDs(),
      'gameID': games.id,
      'finished': game.finished,
      'timeStamp': ''
    };
    await games.set(json);
    return games.id;
  }

  @override
  Future<DBgenericGame> findGameByID(String id) async {
    DBgenericGame? searchedGame;
    await for (List<DBgenericGame> list in readGames()){
      for (DBgenericGame game in list){
        if (game.gameID == id){
          searchedGame = game;
        }
      }
      break;
    }
    return await searchedGame!;
  }

  @override
  void deleteGame(String gameID) async {
    var query = await FirebaseFirestore.instance.collection('memoryGames').where('gameID', isEqualTo: gameID).get();
    var firestoreInstanceId = query.docs.first.id;
    await FirebaseFirestore.instance.collection('memoryGames').doc(firestoreInstanceId).delete();
  }

  @override
  Future<List<List<GenericGame>>> startConfiguration(List<DBgenericGame> dbgamess) async {
    List<GenericGame> games = [];
    List<GenericGame> finishedGames = [];
    List<DBmemoryGame> dbgames= dbgamess as List<DBmemoryGame>;
    for (dynamic dbgame in dbgames){
      if (dbgame.actualPlayerID == globalData.user!.userID || (dbgame.finished && (dbgame.player1ID == globalData.user!.userID)) || (dbgame.finished && (dbgame.player1ID == globalData.user!.userID))){
        if (dbgame.finished){
          DateTime now = new DateTime.now();
          DateTime date = new DateTime(now.year, now.month, now.day);
          DateTime gameTimeStamp = DateTime.parse(dbgame.timeStamp.toString());

          Duration difference = gameTimeStamp.difference(date);

          if (difference.inDays < 7){
            AppUser player1 = await UserHandler().findUserByID(dbgame.player1ID);
            AppUser player2 = await UserHandler().findUserByID(dbgame.player2ID);
            AppUser actualPlayer = globalData.user!;
            List<Vocabulary> vocabularies = globalData.vocabularyRepo!.findVocabulariesByItalians(dbgame.vocabulariesIDs);
            MemoryGame game = MemoryGame(gameID: dbgame.gameID, player1: player1, player2: player2, actualPlayer: actualPlayer, player1Points: dbgame.player1Points, player2Points: dbgame.player2Points, vocabularies: vocabularies, finished: dbgame.finished);
            finishedGames.add(game);
          } else {
            deleteGame(dbgame.gameID);
            UserHandler().deletFinishedGamesIDsNews(dbgame.gameID);
          }
        } else {
            AppUser player1 = await UserHandler().findUserByID(dbgame.player1ID);
            AppUser player2 = await UserHandler().findUserByID(dbgame.player2ID);
            AppUser actualPlayer = globalData.user!;
            List<Vocabulary> vocabularies = globalData.vocabularyRepo!.findVocabulariesByItalians(dbgame.vocabulariesIDs);
            MemoryGame game = MemoryGame(gameID: dbgame.gameID, player1: player1, player2: player2, actualPlayer: actualPlayer, player1Points: dbgame.player1Points, player2Points: dbgame.player2Points, vocabularies: vocabularies, finished: dbgame.finished);
            games.add(game);
         }
      }
    }
    return await [games, finishedGames];
  }

}