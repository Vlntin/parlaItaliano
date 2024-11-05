import 'package:parla_italiano/games/generic/genericGame.dart';
import 'package:parla_italiano/globals/globalData.dart' as gd;

class GamesRepo{

  List<GenericGame> games = [];
  List<GenericGame> finishedGames = [];

  GamesRepo(this.games, this.finishedGames);

  void addGame(GenericGame game){
    games.add(game);
  }

  updateGameState(dynamic newGame){
    for (dynamic game in games){
      if (game.gameID == newGame.gameID){
        games.remove(game);
        if (newGame.actualPlayer == gd.user! && !newGame.finished){
          games.add(newGame);
        }
        if (newGame.finished && (newGame.player1.userID == gd.user!.userID || newGame.player2.userID == gd.user!.userID)){
          finishedGames.add(newGame);
        }
      }
    }
  }
}