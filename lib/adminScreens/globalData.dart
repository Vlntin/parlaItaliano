library globalData;

import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/games/classicGame/classicGame.dart';
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/models/gamesRepo.dart';
import 'package:parla_italiano/adminScreens/vocabularyRepo.dart';
import 'package:parla_italiano/widgets/newsWidgets.dart';


AppUser? user;
VocabRepo? vocabularyRepo;
GamesRepo? gamesRepo;
List<NewsWidget> news = [];


  Future<List<FriendsRequestWidget>> _getAllFriendsRequests() async {
    List<FriendsRequestWidget> requests = [];
    List<AppUser> friends = [];
    for (String id in user!.friendsRequestsReceived){
      AppUser appuser = await UserHandler().findUserByID(id);
      await appuser;
      friends.add(appuser);
    }
    
    for (AppUser friend in friends){
      requests.add(FriendsRequestWidget(friend));
    }
    return requests;
  }

  Future<List<FriendsRequestAcceptedWidget>> _getAllFriendsAccepted() async {
    List<FriendsRequestAcceptedWidget> friendRequests = [];
    List<AppUser> friends = [];
    for (String id in user!.friendsRequestsAccepted){
      AppUser appuser = await UserHandler().findUserByID(id);
      await appuser;
      friends.add(appuser);
    }
    
    for (AppUser friend in friends){
      friendRequests.add(FriendsRequestAcceptedWidget(friend));
    }
    return friendRequests;
  }

  Future<List<FriendsRequestRejectedWidget>> _getAllFriendsRejected() async {
    List<FriendsRequestRejectedWidget> friendRequests = [];
    List<AppUser> friends = [];
    for (String id in user!.friendsRequestsRejected){
      AppUser appuser = await UserHandler().findUserByID(id);
      await appuser;
      friends.add(appuser);
    }
    
    for (AppUser friend in friends){
      friendRequests.add(FriendsRequestRejectedWidget(friend));
    }
    return friendRequests;
  }

  Future<List<FriendsLevelUpdateWidget>> _getAllFriendsLevelUpdate() async {
    List<FriendsLevelUpdateWidget> friendUpdates = [];
    List<AppUser> friends = [];
    for (String id in user!.friendsLevelUpdate){
      AppUser appuser = await UserHandler().findUserByID(id);
      await appuser;
      friends.add(appuser);
    }
    
    for (AppUser friend in friends){
      friendUpdates.add(FriendsLevelUpdateWidget(friend));
    }
    return friendUpdates;
  }

  List<GameFinishedWidget> _getAllFinishedGamesIDs() {
    List<GameFinishedWidget> finishedGames = [];
    for (String id in user!.finishedGamesIDsNews){
      for (dynamic game in gamesRepo!.finishedGames){
        if (game.gameID == id){
          GameFinishedWidget widget = GameFinishedWidget(game);
          finishedGames.add(widget);
        }
      }
    }
    return finishedGames;
  }

  Future<List<NewsWidget>> createNews() async {
    List<NewsWidget> newsList = [];
    List<GameFinishedWidget> finishedGames = _getAllFinishedGamesIDs();
    for (GameFinishedWidget element in finishedGames){
      newsList.add(element);
    }

    List<FriendsRequestWidget> friendRequests = await _getAllFriendsRequests();
    for (FriendsRequestWidget element in friendRequests){
      newsList.add(element);
    }

    List<FriendsRequestAcceptedWidget> friendAccepts = await _getAllFriendsAccepted();
    for (FriendsRequestAcceptedWidget element in friendAccepts){
      newsList.add(element);
    }

    List<FriendsRequestRejectedWidget> friendRejected = await _getAllFriendsRejected();
    for (FriendsRequestRejectedWidget element in friendRejected){
      newsList.add(element);
    }

    List<FriendsLevelUpdateWidget> friendUpdates = await _getAllFriendsLevelUpdate();
    for (FriendsLevelUpdateWidget element in friendUpdates){
      newsList.add(element);
    }

    return newsList;
  }
