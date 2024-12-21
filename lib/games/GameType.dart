import 'package:parla_italiano/games/classicGame/classicGameHandler.dart';
import 'package:parla_italiano/games/gamesInfo.dart';
import 'package:flutter/material.dart';
import 'package:parla_italiano/games/memory/memoryGameHandler.dart';

enum GameType {
  classicGame,
  memory;

  static Map<GameType, GameInfo> gameInfoMap = {
    GameType.classicGame: GameInfo('Klassisches Spiel', Icons.sports, ClassicGameHandler()),
    GameType.memory: GameInfo('Memory', Icons.memory, MemoryGameHandler()),
  };

  GameInfo get info => gameInfoMap[this]!;
}

