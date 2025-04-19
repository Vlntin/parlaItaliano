import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parla_italiano/games/GameType.dart';
import 'package:parla_italiano/games/classicGame/DBclassicGame.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/games/classicGame/classicGame.dart';
import 'package:parla_italiano/games/frontendGame.dart';
import 'package:parla_italiano/games/generic/DBgeneric.dart';
import 'package:parla_italiano/games/generic/genericGame.dart';
import 'package:parla_italiano/games/generic/genericGameHandler.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;

class ClassicGameHandler implements GenericGameHandler {

  ClassicGameHandler();

  @override
  Stream<List<DBgenericGame>> readGames() => FirebaseFirestore.instance
    .collection('classicGames')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => DBclassicGame.fromJson(doc)).toList());

  @override
  void updateGameStats(GenericGame genericGame) async {
    ClassicGame game = genericGame as ClassicGame;
    print(game.actualPlayer);
    print(game.gameID);
    if (game.finished){
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);
      String timeStamped = date.toString();
      FirebaseFirestore.instance.collection('classicGames').doc(game.gameID).update({'timeStamp': timeStamped});
    } else {
      //globalData.gamesRepo!.games.add(FrontGame(game, GameType.classicGame));
    }
    FirebaseFirestore.instance.collection('classicGames').doc(game.gameID).update({'actualPlayerID': game.actualPlayer.userID});
    FirebaseFirestore.instance.collection('classicGames').doc(game.gameID).update({'actualRound': game.actualRound});
    FirebaseFirestore.instance.collection('classicGames').doc(game.gameID).update({'player1Points': game.player1Points});
    FirebaseFirestore.instance.collection('classicGames').doc(game.gameID).update({'player2Points': game.player2Points});
    FirebaseFirestore.instance.collection('classicGames').doc(game.gameID).update({'finished': game.finished});
  }

  @override
  Future<bool> setDefault(FrontGame frontGame) async {
    ClassicGame game = frontGame.getGame() as ClassicGame;
    int actualRound = game.actualRound;
    String actualPlayerID = game.actualPlayer.userID;
    bool finished = game.finished;
    String timeStamped = '';
    if (game.actualPlayer.userID == game.player2.userID && actualRound == 3){
      finished = true;
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);
      timeStamped = date.toString();
    }else if (actualRound % 2 == 0){
      game.actualPlayer.userID == game.player2.userID ? actualPlayerID = game.player1.userID : actualRound = game.actualRound + 1;
    } else {
      game.actualPlayer.userID == game.player1.userID ? actualPlayerID = game.player2.userID : actualRound = game.actualRound + 1;
    }
    FirebaseFirestore.instance.collection('classicGames').doc(game.gameID).update({'actualPlayerID': actualPlayerID});
    FirebaseFirestore.instance.collection('classicGames').doc(game.gameID).update({'actualRound': actualRound});
    globalData.gamesRepo!.games.remove(game);
    if (finished){
      globalData.gamesRepo!.games.remove(frontGame);
      globalData.gamesRepo!.finishedGames.add(frontGame);
      FirebaseFirestore.instance.collection('classicGames').doc(game.gameID).update({'finished': finished});
      FirebaseFirestore.instance.collection('classicGames').doc(game.gameID).update({'timeStamp': timeStamped});
    } else {
      if (actualPlayerID != globalData.user!.userID){
        globalData.gamesRepo!.games.remove(frontGame);
      }
    }
    return true;

  }

  @override
  Future<String> createGame(GenericGame genericGame) async{
    ClassicGame game = genericGame as ClassicGame;
    var games = FirebaseFirestore.instance.collection('classicGames').doc();
    final json = {
      'gameCategory': 0,
      'actualPlayerID': game.actualPlayer.userID,
      'actualRound': game.actualRound,
      'italianToGerman': game.italianToGerman,
      'player1ID': game.player1.userID,
      'player1Points': game.player1Points,
      'player2ID': game.player2.userID,
      'player2Points': game.player2Points,
      'totalRounds': game.totalRounds,
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
    var query = await FirebaseFirestore.instance.collection('classicGames').where('gameID', isEqualTo: gameID).get();
    var firestoreInstanceId = query.docs.first.id;
    await FirebaseFirestore.instance.collection('classicGames').doc(firestoreInstanceId).delete();
  }

  @override
  Future<List<List<GenericGame>>> startConfiguration(List<DBgenericGame> dbgamess) async {
    List<GenericGame> games = [];
    List<GenericGame> finishedGames = [];
    List<DBclassicGame> dbgames = dbgamess as List<DBclassicGame>;
    for (DBclassicGame dbgame in dbgames){
      if (dbgame.actualPlayerID == globalData.user!.userID || (dbgame.finished && (dbgame.player1ID == globalData.user!.userID)) || (dbgame.finished && (dbgame.player1ID == globalData.user!.userID))){
        if (dbgame.finished){
          DateTime now = new DateTime.now();
          DateTime date = new DateTime(now.year, now.month, now.day);
          DateTime gameTimeStamp = DateTime.parse(dbgame.timeStamp.toString());

          Duration difference = gameTimeStamp.difference(date);

          if (difference.inDays > -7) {
            AppUser player1 = await UserHandler().findUserByID(dbgame.player1ID);
            AppUser player2 = await UserHandler().findUserByID(dbgame.player2ID);
            AppUser actualPlayer = globalData.user!;
            List<Vocabulary> vocabularies = globalData.vocabularyRepo!.findVocabulariesByItalians(dbgame.vocabulariesIDs);
            ClassicGame game = ClassicGame(gameID: dbgame.gameID, player1: player1, player2: player2, actualPlayer: actualPlayer, player1Points: dbgame.player1Points, player2Points: dbgame.player2Points, actualRound: dbgame.actualRound, totalRounds: dbgame.totalRounds, vocabularies: vocabularies, italianToGerman: dbgame.italianToGerman, finished: dbgame.finished);
            finishedGames.add(game);
          } else {
            String player1ID = dbgame.player1ID;
            String player2ID = dbgame.player2ID;
            deleteGame(dbgame.gameID);
            UserHandler().deletFinishedGamesIDsNews(dbgame.gameID, player1ID);
            UserHandler().deletFinishedGamesIDsNews(dbgame.gameID, player2ID);
          }
        } else {
            AppUser player1 = await UserHandler().findUserByID(dbgame.player1ID);
            AppUser player2 = await UserHandler().findUserByID(dbgame.player2ID);
            AppUser actualPlayer = globalData.user!;
            List<Vocabulary> vocabularies = globalData.vocabularyRepo!.findVocabulariesByItalians(dbgame.vocabulariesIDs);
            ClassicGame game = ClassicGame(gameID: dbgame.gameID, player1: player1, player2: player2, actualPlayer: actualPlayer, player1Points: dbgame.player1Points, player2Points: dbgame.player2Points, actualRound: dbgame.actualRound, totalRounds: dbgame.totalRounds, vocabularies: vocabularies, italianToGerman: dbgame.italianToGerman, finished: dbgame.finished);
            games.add(game);
         }
      }
    }
    return await [games, finishedGames];
  }

}