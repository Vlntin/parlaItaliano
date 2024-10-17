import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parla_italiano/dbModels/DBclassicGame.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/games/classicGame.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;

class GameHandler {

  GameHandler();

  Stream<List<DBclassicGame>> readGames() => FirebaseFirestore.instance
    .collection('games')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => DBclassicGame.fromJson(doc)).toList());

  
  void updateGameStats(ClassicGame game) async {
    //DateTime now = new DateTime.now();
    //DateTime date = new DateTime(now.year, now.month, now.day);
    FirebaseFirestore.instance.collection('games').doc(game.gameID).update({'actualPlayerID': game.actualPlayer.userID});
    FirebaseFirestore.instance.collection('games').doc(game.gameID).update({'actualRound': game.actualRound});
    FirebaseFirestore.instance.collection('games').doc(game.gameID).update({'player1Points': game.player1Points});
    FirebaseFirestore.instance.collection('games').doc(game.gameID).update({'player2Points': game.player2Points});
    FirebaseFirestore.instance.collection('games').doc(game.gameID).update({'finished': game.finished});
  }

  Future<String> createGame({required String actualPlayerID, required int actualRound, required List<bool> italianToGerman, required String player1ID, required List<int> player1Points, required String player2ID, required List<int> player2Points, required int roundNumbers, required List<String> vocabularyIDs, required bool finished}) async{
    var games = FirebaseFirestore.instance.collection('games').doc();
    final json = {
      'actualPlayerID': actualPlayerID,
      'actualRound': actualRound,
      'italianToGerman': italianToGerman,
      'player1ID': player1ID,
      'player1Points': player1Points,
      'player2ID': player2ID,
      'player2Points': player2Points,
      'totalRounds': roundNumbers,
      'vocabularyIDs': vocabularyIDs,
      'gameID': games.id,
      'finished': finished
    };
    await games.set(json);
    return games.id;
  }

  
  Future<DBclassicGame> findGameByID(String id) async {
    DBclassicGame? searchedGame;
    await for (List<DBclassicGame> list in readGames()){
      for (DBclassicGame game in list){
        if (game.gameID == id){
          searchedGame = game;
        }
      }
      break;
    }
    return await searchedGame!;
  }

  Future<List<List<ClassicGame>>> startConfiguration(List<DBclassicGame> dbgames) async {
    List<ClassicGame> games = [];
    List<ClassicGame> finishedGames = [];
    for (DBclassicGame dbgame in dbgames){
      if (dbgame.actualPlayerID == globalData.user!.userID || (dbgame.finished && (dbgame.player1ID == globalData.user!.userID)) || (dbgame.finished && (dbgame.player1ID == globalData.user!.userID))){
        AppUser player1 = await UserHandler().findUserByID(dbgame.player1ID);
        AppUser player2 = await UserHandler().findUserByID(dbgame.player2ID);
        AppUser actualPlayer = globalData.user!;
        List<Vocabulary> vocabularies = globalData.vocabularyRepo!.findVocabulariesByIDs(dbgame.vocabulariesIDs);
        ClassicGame game = ClassicGame(gameID: dbgame.gameID, player1: player1, player2: player2, actualPlayer: actualPlayer, player1Points: dbgame.player1Points, player2Points: dbgame.player2Points, actualRound: dbgame.actualRound, totalRounds: dbgame.totalRounds, vocabularies: vocabularies, italianToGerman: dbgame.italianToGerman, finished: dbgame.finished);
        game.finished ? finishedGames.add(game) : games.add(game);
      }
    }
    return await [games, finishedGames];
  }

}