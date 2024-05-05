import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/models/DBtable.dart';

class AppUser {
  String userID;
  String username;
  int level;
  List<String> friendsIDs;
  List<String> friendsIDsRequests;
  List<String> favouriteVocabulariesIDs;
  String lastTestDate;
  
  AppUser({required this.userID, required this.username, required this.level, required this.friendsIDs, required this.friendsIDsRequests, required this.favouriteVocabulariesIDs, required this.lastTestDate});

  Map<String, dynamic> toJson() => {
    'userID': userID,
    'username': username,
    'level': level,
    'friendsIDs': friendsIDs,
    'friendsIDsRequests': friendsIDsRequests,
    'favouriteVocabulariesIDs': favouriteVocabulariesIDs,
    'lastTestDate': lastTestDate
  };

  static AppUser fromJson(QueryDocumentSnapshot<Map<String, dynamic>> doc){
    Map<String, dynamic> json = doc.data();
    var friendsIdsJson = json['friendsIDs'];
    List<String> friendsIds =[];
    for (String element in friendsIdsJson){
      friendsIds.add(element);
    }
    var friendsIdsRequestsJson = json['friendsIDsRequests'];
    List<String> friendsIdsRequests =[];
    for (String element in friendsIdsRequestsJson){
      friendsIdsRequests.add(element);
    }
    print(json);
    var favouriteVocabulariesIDsJson = json['favouriteVocabulariesIDs'];
    List<String> favouriteVocabulariesIDs =[];
    for (String element in favouriteVocabulariesIDsJson){
      favouriteVocabulariesIDs.add(element);
    }
    AppUser user = AppUser(
      userID: json['userID'],
      username: json['username'],
      level: json['level'],
      friendsIDs: friendsIds,
      friendsIDsRequests: friendsIdsRequests,
      favouriteVocabulariesIDs: favouriteVocabulariesIDs,
      lastTestDate: json['lastTestDate']
    );
    return user;
  } 
}