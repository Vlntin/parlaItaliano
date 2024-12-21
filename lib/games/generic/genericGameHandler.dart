import 'package:parla_italiano/games/frontendGame.dart';
import 'package:parla_italiano/games/generic/DBgeneric.dart';
import 'package:parla_italiano/games/generic/genericGame.dart';

abstract class GenericGameHandler{
  
  Future<bool> setDefault(FrontGame game);
  Future<String> createGame(GenericGame game);
  Future<DBgenericGame> findGameByID(String id);
  void deleteGame(String gameID);
  void updateGameStats(GenericGame game);
  Stream<List<DBgenericGame>> readGames();
  Future<List<List<GenericGame>>> startConfiguration(List<DBgenericGame> dbgames);

}