
import 'package:flutter/material.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/games/GameType.dart';

abstract class GenericGame{

  String? gameID;
  GameType? gameType;

  List<int> getPlayersTotalPoints();
  List<AppUser> getPlayers();
  int getActualRound();
  AppUser getActualPlayer();
  bool isFinished();

  //Widget getFinishedGameText(BuildContext context);
  //Row getGameText(BuildContext context);

}