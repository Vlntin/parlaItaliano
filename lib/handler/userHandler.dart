import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parla_italiano/globals/vocabularyRepository.dart' as repository;
import 'package:parla_italiano/globals/userData.dart' as userData;
import 'package:parla_italiano/handler/vocabularyHandler.dart';
import 'package:parla_italiano/models/appUser.dart';

//Bei Änderungen von User müssen diese direkt in Firebase UND globalUser gespeichert werden, 
//damit nur am Anfang die Userdaten geladen werden müssen und danach nichtmehr. Also nur EIN MAL aus DB lesen!
// ADD und UPDATE erwünscht, GET nicht!

class UserHandler {

  UserHandler();

  Stream<List<AppUser>> readUsers() => FirebaseFirestore.instance
    .collection('users')
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => AppUser.fromJson(doc)).toList());

  void addFavouriteIds(String id) async {
    List<String> actualFavorites = [];
    await for (List<AppUser> list in readUsers()){
      for (AppUser user in list){
        if (user.userID == userData.user!.userID){
          actualFavorites = user.favouriteVocabulariesIDs;
        }
      }
      break;
    }
    await actualFavorites;
    actualFavorites.add(id);
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: userData.user!.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'favouriteVocabulariesIDs': actualFavorites});
  }

  void updateUserLevel() async {
    userData.user!.level = userData.user!.level + 1;
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: userData.user!.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'level': userData.user!.level});
  }

  void updateTestDate() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    userData.user!.lastTestDate = date.toString();
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: userData.user!.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'lastTestDate': date.toString()});
  }

  void addFriendRequestSend(String iDToSendARequest) async {
    List<String> actualRequestsSend = [];
    await for (List<AppUser> list in readUsers()){
      for (AppUser user in list){
        if (user.userID == userData.user!.userID){
          actualRequestsSend = user.friendsRequestsSend;
        }
      }
      break;
    }
    await actualRequestsSend;
    actualRequestsSend.add(iDToSendARequest);
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: userData.user!.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'friendsRequestsSend': actualRequestsSend});
  }

  void addFriendRequestRecieved(String iDToSendARequest) async {
    List<String> actualRequestsRecieved = [];
    await for (List<AppUser> list in readUsers()){
      for (AppUser user in list){
        if (user.userID == iDToSendARequest){
          actualRequestsRecieved = user.friendsRequestsReceived;
        }
      }
      break;
    }
    await actualRequestsRecieved;
    actualRequestsRecieved.add(userData.user!.userID);
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: iDToSendARequest).get();
    var firestoreInstanceId = query.docs.first.id;
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'friendsRequestsRecieved': actualRequestsRecieved});
  }

  void deleteFavouriteIds(String id) async {
    List<String> actualFavorites = [];
    await for (List<AppUser> list in readUsers()){
      for (AppUser user in list){
        if (user.userID == userData.user!.userID){
          actualFavorites = user.favouriteVocabulariesIDs;
        }
      }
      break;
    }
    await actualFavorites;
    actualFavorites.remove(id);
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: userData.user!.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'favouriteVocabulariesIDs': actualFavorites});
  }

  Future createUser({required userID, required username, required level, required friendsIDs, required friendsRequestsSend, required friendsRequestsRecieved, required favouriteVocabulariesIDs, required lastTestDate}) async{
    var users = FirebaseFirestore.instance.collection('users').doc();
    final json = {
      'userID': userID,
      'username': username,
      'level': level,
      'friendsIDs': friendsIDs,
      'friendsRequestsSend': friendsRequestsSend,
      'friendsRequestsRecieved': friendsRequestsRecieved,
      'favouriteVocabulariesIDs': favouriteVocabulariesIDs,
      'lastTestDate' : lastTestDate
      };
    await users.set(json);
  }

  Future<bool> isUsernameNotUsed(String checkinguserName) async {
    bool used = true;
    await for (List<AppUser> list in readUsers()){
      for (AppUser user in list){
        if (user.username == checkinguserName){
          used = false;
        }
      }
      break;
    }
    return await used;
  }

  Future<AppUser?> findUserByID(String uid) async {
    AppUser? appUser;
    await for (List<AppUser> list in readUsers()){
      for (AppUser user in list){
        if (user.userID == uid){
          appUser = user;
        }
      }
      break;
    }
    return await appUser;
  }

  Future<bool> logoutUser() async{
    await FirebaseAuth.instance.signOut();
    userData.user = null;
    repository.favouritesTable = repository.VocabularyTable('Meine Favoriten', 0, '0');
    repository.vocabularyTables = [];
    return true;
  }

  void sendFriendRequest(String username) async{
    await for (List<AppUser> list in readUsers()){
      for (AppUser user in list){
        if (user.username == username){
          userData.user!.friendsRequestsSend.add(user.userID);
          this.addFriendRequestSend(user.userID);
          this.addFriendRequestRecieved(user.userID);
        }
      }
      break;
    }
  }
  
}