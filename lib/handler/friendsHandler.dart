import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/handler/userHandler.dart' as userHandler;
import 'package:parla_italiano/dbModels/appUser.dart';

//Bei Änderungen von User müssen diese direkt in Firebase UND globalUser gespeichert werden, 
//damit nur am Anfang die Userdaten geladen werden müssen und danach nichtmehr. Also nur EIN MAL aus DB lesen!
// ADD und UPDATE erwünscht, GET nicht!

class FriendsHandler {

  FriendsHandler();

  void sendFriendRequest(String username) async{
    await for (List<AppUser> list in userHandler.UserHandler().readUsers()){
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

  void addFriendRequestRecieved(String iDToSendARequest) async {
    List<String> actualRequestsRecieved = [];
    await for (List<AppUser> list in userHandler.UserHandler().readUsers()){
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

  void addFriendRequestSend(String iDToSendARequest) async {
    List<String> actualRequestsSend = [];
    await for (List<AppUser> list in userHandler.UserHandler().readUsers()){
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

  void acceptFriendRequest(String friendRequestID) async {
    //remove request
    userData.user!.friendsRequestsReceived.remove(friendRequestID);
    userData.user!.friendsIDs.add(friendRequestID);
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: userData.user!.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'friendsRequestsRecieved': userData.user!.friendsRequestsReceived});
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'friendsIDS': userData.user!.friendsIDs});

    List<String> actualFriends = [];
    List<String> requestsSend = [];
    List<String> accepted = [];
    await for (List<AppUser> list in userHandler.UserHandler().readUsers()){
      for (AppUser user in list){
        if (user.userID == friendRequestID){
          actualFriends = user.friendsIDs;
          requestsSend = user.friendsRequestsSend;
          accepted = user.friendsRequestsAccepted;
        }
      }
      break;
    }
    await actualFriends;
    await requestsSend;
    await accepted;
    actualFriends.add(userData.user!.userID);
    requestsSend.remove(userData.user!.userID);
    accepted.add(userData.user!.userID);
    var requestingQuery = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: friendRequestID).get();
    var firestoreInstanceId2 = requestingQuery.docs.first.id;
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId2).update({'friendsRequestsSend': requestsSend});
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId2).update({'friendsIDS': actualFriends});
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId2).update({'friendsRequestsAccepted': accepted});
  }

  void rejectFriendRequest(String friendRequestID) async {
    //remove request
    userData.user!.friendsRequestsReceived.remove(friendRequestID);
    var query = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: userData.user!.userID).get();
    var firestoreInstanceId = query.docs.first.id;
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId).update({'friendsRequestsRecieved': userData.user!.friendsRequestsReceived});


    List<String> requestsSend = [];
    List<String> rejected = [];
    await for (List<AppUser> list in userHandler.UserHandler().readUsers()){
      for (AppUser user in list){
        if (user.userID == friendRequestID){
          requestsSend = user.friendsRequestsSend;
          rejected = user.friendsRequestsRejected;
        }
      }
      break;
    }
    await requestsSend;
    await rejected;
    requestsSend.remove(userData.user!.userID);
    rejected.add(userData.user!.userID);
    var requestingQuery = await FirebaseFirestore.instance.collection('users').where('userID', isEqualTo: friendRequestID).get();
    var firestoreInstanceId2 = requestingQuery.docs.first.id;
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId2).update({'friendsRequestsSend': requestsSend});
    FirebaseFirestore.instance.collection('users').doc(firestoreInstanceId2).update({'friendsRequestsRejected': rejected});
  }

}