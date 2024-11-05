

import 'package:parla_italiano/games/generic/DBgeneric.dart';
import 'package:parla_italiano/games/generic/genericGame.dart';

abstract class GenericGameHandler{
  
  Future<bool> setDefault(game);
  Future<String> createGame(game);
  Future<DBgenericGame> findGameByID(String id);
  void _deleteGame(String gameID);
  void updateGameStats(game);
  Stream<List<DBgenericGame>> readGames();
  Future<List<List<GenericGame>>> startConfiguration(List<dynamic> dbgames);

}