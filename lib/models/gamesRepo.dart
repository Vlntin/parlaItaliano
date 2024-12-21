import 'package:parla_italiano/games/frontendGame.dart';
import 'package:parla_italiano/globals/globalData.dart' as gd;

class GamesRepo{

  List<FrontGame> games = [];
  List<FrontGame> finishedGames = [];

  GamesRepo(this.games, this.finishedGames);

  void addGame(FrontGame game){
    games.add(game);
  }

  void updateGameState(FrontGame newGame){
    print('in update');
    for (FrontGame game in games){
      if (game.getGame().gameID == newGame.getGame().gameID){
        games.remove(game);
        print('removed');
        if (newGame.getGame().getActualPlayer() == gd.user! && !newGame.getGame().isFinished()){
          games.add(newGame);
          print('game added');
        }
        if (newGame.getGame().isFinished() && (newGame.getGame().getPlayers()[0].userID == gd.user!.userID || newGame.getGame().getPlayers()[1].userID == gd.user!.userID)){
          finishedGames.add(newGame);
          print('finished game added');
        }
      }
    }
  }
}