import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parla_italiano/games/generic/DBgeneric.dart';

class DBclassicGame implements DBgenericGame{

  int gameCategory;
  String actualPlayerID;
  int actualRound;
  String gameID;
  List<bool> italianToGerman;
  String player1ID;
  List<int> player1Points;
  String player2ID;
  List<int> player2Points;
  int totalRounds;
  List<String> vocabulariesIDs;
  bool finished;
  String timeStamp;

  DBclassicGame({required this.gameCategory, required this.actualPlayerID, required this.actualRound, required this.gameID, required this.italianToGerman, required this.player1ID, required this.player1Points, required this.player2ID, required this.player2Points, required this.totalRounds, required this.vocabulariesIDs, required this.finished, required this.timeStamp});

  Map<String, dynamic> toJson() => {
    'gameCategory': gameCategory,
    'actualPlayerID': actualPlayerID,
    'actualRound': actualRound,
    'italianToGerman': italianToGerman,
    'player1ID': player1ID,
    'player1Points': player1Points,
    'player2ID': player2ID,
    'player2Points': player2Points,
    'totalRounds': totalRounds,
    'vocabularyIDs': vocabulariesIDs,
    'finished': finished
  };

  static DBclassicGame fromJson(QueryDocumentSnapshot<Map<String, dynamic>> doc){
    Map<String, dynamic> json = doc.data();
    var vocablaryIDsJson = json['vocabularyIDs'];
    List<String> vocabularyIDs =[];
    for (String element in vocablaryIDsJson){
      vocabularyIDs.add(element);
    }
    var italianToGermanJson = json['italianToGerman'];
    List<bool> italianToGerman =[];
    for (bool element in italianToGermanJson){
      italianToGerman.add(element);
    }
    var player1PointsJson = json['player1Points'];
    List<int> player1Points =[];
    for (int element in player1PointsJson){
      player1Points.add(element);
    }
    var player2PointsJson = json['player2Points'];
    List<int> player2Points =[];
    for (int element in player2PointsJson){
      player2Points.add(element);
    }
    String actualPlayerID = json['actualPlayerID'];
    int actualRound = json['actualRound'];
    String player1ID = json['player1ID'];
    String player2ID = json['player2ID'];
    int totalRounds = json['totalRounds'];
    String gameID = json['gameID'];
    bool finished = json['finished'];
    String timeStamp = json['timeStamp'];
    int gameCategory = json['gameCategory'];
    DBclassicGame game = DBclassicGame(gameCategory: gameCategory, gameID: gameID, player1ID: player1ID, player2ID: player2ID, actualPlayerID: actualPlayerID, player1Points: player1Points, player2Points: player2Points, actualRound: actualRound, totalRounds: totalRounds, vocabulariesIDs: vocabularyIDs, italianToGerman: italianToGerman, finished: finished, timeStamp: timeStamp);
    return game;
  }
}