

import 'package:cloud_firestore/cloud_firestore.dart';

class DBclassicGame{

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

  DBclassicGame({required this.actualPlayerID, required this.actualRound, required this.gameID, required this.italianToGerman, required this.player1ID, required this.player1Points, required this.player2ID, required this.player2Points, required this.totalRounds, required this.vocabulariesIDs, required this.finished });


  
  Map<String, dynamic> toJson() => {
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
    print('from json');
    Map<String, dynamic> json = doc.data();
    print('vocab');
    var vocablaryIDsJson = json['vocabularyIDs'];
    List<String> vocabularyIDs =[];
    for (String element in vocablaryIDsJson){
      vocabularyIDs.add(element);
    }
    print('italtogerman');
    var italianToGermanJson = json['italianToGerman'];
    List<bool> italianToGerman =[];
    for (bool element in italianToGermanJson){
      italianToGerman.add(element);
    }
    print('1points');
    var player1PointsJson = json['player1Points'];
    List<int> player1Points =[];
    for (int element in player1PointsJson){
      player1Points.add(element);
    }
    print('2points');
    var player2PointsJson = json['player2Points'];
    List<int> player2Points =[];
    for (int element in player2PointsJson){
      player2Points.add(element);
    }
    print('1id');
    String actualPlayerID = json['actualPlayerID'];
    print('actualround');
    int actualRound = json['actualRound'];
    print('1id');
    String player1ID = json['player1ID'];
    print('2id');
    String player2ID = json['player2ID'];
    print('totalrounds');
    int totalRounds = json['totalRounds'];
    String gameID = json['gameID'];
    bool finished = json['finished'];
    DBclassicGame game = DBclassicGame(gameID: gameID, player1ID: player1ID, player2ID: player2ID, actualPlayerID: actualPlayerID, player1Points: player1Points, player2Points: player2Points, actualRound: actualRound, totalRounds: totalRounds, vocabulariesIDs: vocabularyIDs, italianToGerman: italianToGerman, finished: finished);
    print('finish json');
    return game;
  }
}