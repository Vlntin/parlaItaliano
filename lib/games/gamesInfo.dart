import 'package:flutter/material.dart';
import 'package:parla_italiano/games/generic/genericGameHandler.dart';

class GameInfo {

  GameInfo(this.title, this.icon, this.gameHandler);

  String title;
  IconData icon;
  GenericGameHandler gameHandler;

}