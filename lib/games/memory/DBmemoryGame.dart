import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parla_italiano/games/generic/DBgeneric.dart';

class DBmemoryGame implements DBgenericGame{

  int gameCategory;
  String actualPlayerID;
  String gameID;
  String player1ID;
  int player1Points;
  String player2ID;
  int player2Points;
  List<String> vocabulariesIDs;
  bool finished;
  String timeStamp;

  DBmemoryGame({required this.gameCategory, required this.actualPlayerID, required this.gameID, required this.player1ID, required this.player1Points, required this.player2ID, required this.player2Points, required this.vocabulariesIDs, required this.finished, required this.timeStamp});

  Map<String, dynamic> toJson() => {
    'gameCategory': gameCategory,
    'actualPlayerID': actualPlayerID,
    'player1ID': player1ID,
    'player1Points': player1Points,
    'player2ID': player2ID,
    'player2Points': player2Points,
    'vocabularyIDs': vocabulariesIDs,
    'finished': finished,
    'timeStamp': ''
  };

  static DBmemoryGame fromJson(QueryDocumentSnapshot<Map<String, dynamic>> doc){
    Map<String, dynamic> json = doc.data();
    var vocablaryIDsJson = json['vocabularyIDs'];
    List<String> vocabularyIDs =[];
    for (String element in vocablaryIDsJson){
      vocabularyIDs.add(element);
    }
    String actualPlayerID = json['actualPlayerID'];
    String player1ID = json['player1ID'];
    String player2ID = json['player2ID'];
    int player1Points = json['player1Points'];
    int player2Points = json['player2Points'];
    String gameID = json['gameID'];
    bool finished = json['finished'];
    String timeStamp = json['timeStamp'];
    int gameCategory = json['gameCategory'];

    DBmemoryGame game = DBmemoryGame(gameCategory: gameCategory, gameID: gameID, player1ID: player1ID, player2ID: player2ID, actualPlayerID: actualPlayerID, player1Points: player1Points, player2Points: player2Points, vocabulariesIDs: vocabularyIDs, finished: finished, timeStamp: timeStamp);
    return game;
  }
}