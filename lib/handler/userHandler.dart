import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/handler/vocabularyHandler.dart';
import 'package:parla_italiano/adminScreens/vocabularyTable.dart';
import 'package:parla_italiano/dbModels/appUser.dart';

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

  void updateFinishedGamesIDsNews(AppUser user, String gameID) async {
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: user.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    user.finishedGamesIDsNews.add(gameID);
    await FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'finishedGamesIDsNews': user.finishedGamesIDsNews});
  }

  void addLevelUpdateNews(AppUser user) async {
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: user.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    user.friendsLevelUpdate.add(userData.user!.userID);
    await FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'friendsLevelUpdate': user.friendsLevelUpdate});
  }

  void deletFinishedGamesIDsNews(String gameID) async {
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: userData.user!.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    userData.user!.finishedGamesIDsNews.remove(gameID);
    await FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'finishedGamesIDsNews': userData.user!.finishedGamesIDsNews});
  }

  void deleteFriendsRequestsAccepted(String friendID) async {
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: userData.user!.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    userData.user!.friendsRequestsAccepted.remove(friendID);
    await FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'friendsRequestsAccepted': userData.user!.friendsRequestsAccepted});
  }

  void deleteFriendsRequestsRejected(String friendID) async {
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: userData.user!.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    userData.user!.friendsRequestsRejected.remove(friendID);
    await FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'friendsRequestsRejected': userData.user!.friendsRequestsRejected});
  }

  void deleteFriendsLevelUpdate(String friendID) async {
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: userData.user!.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    userData.user!.friendsLevelUpdate.remove(friendID);
    await FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'friendsLevelUpdate': userData.user!.friendsLevelUpdate});
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

  Future createUser({
    required userID, 
    required username, 
    level = 1, 
    friendsIDs = const <String>[], 
    friendsRequestsSend = const <String>[], 
    friendsRequestsRecieved = const <String>[], 
    friendsRequestsAccepted = const <String>[], 
    friendsRequestsRejected = const <String>[], 
    favouriteVocabulariesIDs = const <String>[], 
    lastTestDate = '', 
    finishedGamesIDsNews = const <String>[], 
    friendsLevelUpdate = const <String>[]
  }) 
  async{
    var users = FirebaseFirestore.instance.collection('users').doc();
    final json = {
      'userID': userID,
      'username': username,
      'level': level,
      'friendsIDS': friendsIDs,
      'friendsRequestsSend': friendsRequestsSend,
      'friendsRequestsRecieved': friendsRequestsRecieved,
      'friendsRequestsAccepted': friendsRequestsAccepted,
      'friendsRequestsRejected': friendsRequestsRejected,
      'favouriteVocabulariesIDs': favouriteVocabulariesIDs,
      'lastTestDate' : lastTestDate,
      'finishedGamesIDsNews': finishedGamesIDsNews,
      'friendsLevelUpdate': friendsLevelUpdate
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

  Future<AppUser> findUserByID(String uid) async {
    AppUser? appUser;
    await for (List<AppUser> list in readUsers()){
      for (AppUser user in list){
        if (user.userID == uid){
          appUser = user;
        }
      }
      break;
    }
    return await appUser!;
  }

  Future<String> findUserNameByID(String uid) async {
    AppUser? appUser;
    await for (List<AppUser> list in readUsers()){
      for (AppUser user in list){
        if (user.userID == uid){
          appUser = user;
        }
      }
      break;
    }
    return appUser!.username;
  }

  Future<bool> logoutUser() async{
    await FirebaseAuth.instance.signOut();
    userData.user = null;
    userData.vocabularyRepo = null;
    /** 
    userData.vocabularyRepo!.favouritesTable = VocabularyTable('Meine Favoriten', 0, '0');
    userData.vocabularyRepo!.vocabularyTables = [];
    */
    return true;
  }

  Future<AppUser?> registerNewUser(String name, String email, String password) async{
    if (await isUsernameNotUsed(name)){
      //registrieren
      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        //anmelden
        try {
          final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password
          );
          final user = credential.user;
          createUser(userID: user!.uid, username: name);
          AppUser appUser = AppUser(userID: user.uid, username: name);
          userData.user = appUser;
          return appUser;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {} 
          else if (e.code == 'wrong-password') {}
        };
      } on FirebaseAuthException catch (e) {
        throw Exception('Registrierung fehlgeschlagen');
      }
    } else {
      throw Exception('Benutzername schon vergeben');
    }

  }
  
}