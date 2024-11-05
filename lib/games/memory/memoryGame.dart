
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/games/generic/genericGame.dart';
import 'package:parla_italiano/games/memory/memoryGameHandler.dart';
import 'package:parla_italiano/globals/globalData.dart' as globalData;
import 'package:parla_italiano/models/vocabulary.dart';

class MemoryGame extends GenericGame{

  String? gameID;
  AppUser player1;
  AppUser player2;
  AppUser actualPlayer;
  int? player1Points;
  int? player2Points;
  bool? finished;
  List<Vocabulary>? vocabularies = [];
  List<String> cardTexts = [];

  List<Vocabulary> finishedVocabularies = [];
  List<Vocabulary> notFinishedVocabularies = [];
  int roundNumber = 1;
  bool playerFinished = false;
  MemoryGameHandler handler = MemoryGameHandler();

  MemoryGame({this.gameID, required this.player1, required this.player2, required this.actualPlayer, this.player1Points, this.player2Points, this.finished, this.vocabularies}) {
    print('gameID');
    print(gameID);
    print(vocabularies);
    if (gameID == null){
      //generate gameID
      gameID = '2';
      player1Points = 0;
      player2Points = 0;
      finished = false;
      int lowerLevelOfPlayers = (player1.level > player2.level) ? player2.level : player1.level;
      vocabularies = globalData.vocabularyRepo!.generateVocabulariesTillLevel(lowerLevelOfPlayers, 10);
    }
    for (Vocabulary vocabulary in vocabularies!){
      notFinishedVocabularies.add(vocabulary);
      cardTexts.add(vocabulary.german);
      cardTexts.add(vocabulary.italian);
    }
  }

  bool validateAnswer(String text1, String text2){
    for (Vocabulary vocabulary in notFinishedVocabularies){
      if ((vocabulary.german == text1 && vocabulary.italian == text2) || (vocabulary.german == text2 && vocabulary.italian == text1)){
        finishedVocabularies.add(vocabulary);
        notFinishedVocabularies.remove(vocabulary);
        return true;
      }
    }
    roundNumber = roundNumber + 1;
    return false;
  }

  bool isPlayerFinished(){
    if (notFinishedVocabularies.isEmpty){
      if(actualPlayer.userID == player1.userID){
        player1Points = roundNumber;
      } else {
        player2Points = roundNumber;
      }
      playerFinished = true;
      return true;
    } else {
      roundNumber = roundNumber + 1;
      return false;
    }
  }
    
  bool isGameFinished(){
    if (actualPlayer.userID == player2.userID){
      finished = true;
      handler.updateGameStats(this);
      return true;
    } else {
      actualPlayer = player2;
      handler.createGame(this);
      return false;
    }
  }

  bool isCardSolved(int cardNumber){
    String cardText = cardTexts[cardNumber];
    for (Vocabulary vocabulary in finishedVocabularies){
      if (vocabulary.italian == cardText || vocabulary.german == cardText){
        return true;
      }
    }
    return false;
  }

  List<Vocabulary> getAllVocabularies(){
    return vocabularies!;
  }

  List<Vocabulary> getFinishedVocabularies(){
    return finishedVocabularies;
  }

  List<Vocabulary> getNotFinishedVocabularies(){
    return notFinishedVocabularies;
  }

  AppUser getPlayer1(){
    return player1;
  }

  AppUser getPlayer2(){
    return player2;
  }

  AppUser getActualPlayer(){
    return actualPlayer;
  }

  List<String> getCardTexts(){
    return cardTexts;
  }

  List<String> getVocabularyIDs(){
    List<String> ids = [];
    for(Vocabulary vocabulary in vocabularies!){
      ids.add(vocabulary.italian);
    }
    print(ids);
    return ids;
  }

  
}
