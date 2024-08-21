import 'dart:js_util';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/dbModels/DBtable.dart';

class AppUser {
  String userID;
  String username;
  int level;
  List<String> friendsIDs;
  List<String> friendsRequestsSend;
  List<String> friendsRequestsReceived;
  List<String> friendsRequestsAccepted;
  List<String> friendsRequestsRejected;
  List<String> favouriteVocabulariesIDs;
  String lastTestDate;
  
  AppUser({required this.userID, required this.username, required this.level, required this.friendsIDs, required this.friendsRequestsSend, required this.friendsRequestsReceived, required this.friendsRequestsAccepted, required this.friendsRequestsRejected, required this.favouriteVocabulariesIDs, required this.lastTestDate});

  void printerMethod(){
    print(userID);
    print(username);
    print(level);
    print(friendsIDs);
    print(friendsRequestsSend);
    print(friendsRequestsReceived);
    print(favouriteVocabulariesIDs);
    print(lastTestDate);
  }

  Map<String, dynamic> toJson() => {
    'userID': userID,
    'username': username,
    'level': level,
    'friendsIDS': friendsIDs,
    'friendsRequestsSend': friendsRequestsSend,
    'friendsRequestsReceived': friendsRequestsReceived,
    'friendsRequestsAccepted': friendsRequestsAccepted,
    'friendsRequestsRejected': friendsRequestsRejected,
    'favouriteVocabulariesIDs': favouriteVocabulariesIDs,
    'lastTestDate': lastTestDate
  };

  static AppUser fromJson(QueryDocumentSnapshot<Map<String, dynamic>> doc){
    Map<String, dynamic> json = doc.data();

    var friendsIdsJson = json['friendsIDS'];
    List<String> friendsIds =[];
    for (String element in friendsIdsJson){
      friendsIds.add(element);
    }
    var friendsIdsRequestsJson = json['friendsRequestsSend'];
    List<String> friendsRequestsSend =[];
    for (String element in friendsIdsRequestsJson){
      friendsRequestsSend.add(element);
    }
    var friendsRequestsReceivedJson = json['friendsRequestsRecieved'];
    List<String> friendsRequestsReceived =[];
    for (String element in friendsRequestsReceivedJson){
      friendsRequestsReceived.add(element);
    }
    var friendsRequestsAcceptedJson = json['friendsRequestsAccepted'];
    List<String> friendsRequestsAccepted =[];
    for (String element in friendsRequestsAcceptedJson){
      friendsRequestsAccepted.add(element);
    }
    var friendsRequestsRejectedJson = json['friendsRequestsRejected'];
    List<String> friendsRequestsRejected =[];
    for (String element in friendsRequestsRejectedJson){
      friendsRequestsRejected.add(element);
    }
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
      friendsRequestsSend: friendsRequestsSend,
      friendsRequestsReceived: friendsRequestsReceived,
      friendsRequestsAccepted: friendsRequestsAccepted,
      friendsRequestsRejected: friendsRequestsRejected,
      favouriteVocabulariesIDs: favouriteVocabulariesIDs,
      lastTestDate: json['lastTestDate']
    );
    return user;
  } 

  Future<bool> hasFriendWithUserName(String userName) async {
    for (String id in this.friendsIDs){
      var user = await UserHandler().findUserByID(id);
      if (user != null){
        if(user.username == userName){
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> hasAlreadySendAnRequest(String checkingUserName) async{
    for (String id in this.friendsRequestsSend){
      var user = await UserHandler().findUserByID(id);
      if (user != null){
        if(user.username == checkingUserName){
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> hasAlreadyReceivedAnRequest(String checkingUserName) async{
    for (String id in this.friendsRequestsReceived){
      var user = await UserHandler().findUserByID(id);
      if (user != null){
        if(user.username == checkingUserName){
          return true;
        }
      }
    }
    return false;
  }
}