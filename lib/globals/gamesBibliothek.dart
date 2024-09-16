import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GamesBibliothek{

  late List<GameInfo> games = _createGames();

  List<GameInfo> _createGames(){
    List<GameInfo> games = [];
    games.add(GameInfo("Speedrunde", 1, AssetImage("images/ABMQ2581.JPG")));
    games.add(GameInfo("1/12", 3, AssetImage("images/BFWA0922.JPG")));
    games.add(GameInfo("Vokabelfußball", 1, AssetImage("images/BSRO2840.JPG")));
    return games;
  }
}

class GameInfo{

  String title;
  int roundNumbers;
  AssetImage img;

  GameInfo(this.title, this.roundNumbers, this.img);

}

