import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parla_italiano/globals/vocabularyRepository.dart' as repository;
import 'package:parla_italiano/globals/userData.dart' as userData;
import 'package:parla_italiano/models/appUser.dart';

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

  Future<String> getUsersLastTest() async {
    await for (List<AppUser> list in readUsers()){
      for (AppUser user in list){
        if (user.userID == userData.user!.userID){
          return user.lastTestDate;
        }
      }
    }
    return "";
  }

  void updateTestDate() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: userData.user!.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'lastTestDate': date.toString()});
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

  Future createUser({required userID, required username, required level, required friendsIDs, required friendsIDsRequests, required favouriteVocabulariesIDs, required lastTestDate}) async{
    var users = FirebaseFirestore.instance.collection('users').doc();
    final json = {
      'userID': userID,
      'username': username,
      'level': level,
      'friendsIDs': friendsIDs,
      'friendsIDsRequests': friendsIDsRequests,
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
  
}