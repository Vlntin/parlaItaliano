import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';

import 'dart:math';


class VocabularyRepo{

  List<VocabularyTable> vocabularyTables = [];
  VocabularyTable favouritesTable = VocabularyTable('Meine Favoriten', 0, '0');

  VocabularyRepo(this.vocabularyTables, this.favouritesTable);

  int calculateLexis(int actualLevel){
    int lexis = 0;
    for (VocabularyTable table in vocabularyTables){
      if (table.level < actualLevel){
        lexis = lexis + table.vocabularies.length;
      } else {
        break;
      }
    }
    return lexis;
  }

  int calculatemaximalLexis(){
    int lexis = 0;
    for (VocabularyTable table in vocabularyTables){
      lexis = lexis + table.vocabularies.length;
    }
    return lexis;
  }

  void fillFavouriteTable(){
    AppUser currentUser = userData.user!;
    for(String wordId in currentUser.favouriteVocabulariesIDs){
      for (VocabularyTable vocabularytable in vocabularyTables){
        for (Vocabulary vocabulary in vocabularytable.vocabularies){
          if (vocabulary.id == wordId){
            favouritesTable.vocabularies.add(Vocabulary(vocabulary.german, vocabulary.italian, vocabulary.additional, vocabulary.id));
          }
        }
      }
    }
  }

  void deleteFavouriteVocabulary(String vocabularyId){
    for (Vocabulary vocabulary in favouritesTable.vocabularies){
      if (vocabulary.id == vocabularyId){
        favouritesTable.vocabularies.remove(vocabulary);
      }
    }
    UserHandler().deleteFavouriteIds(vocabularyId);
  }

  void addVocabularyToFavorites(String vocabularyId, String italian, String german, String additional){
    favouritesTable.vocabularies.add(Vocabulary(german, italian, additional, vocabularyId));
    UserHandler().addFavouriteIds(vocabularyId);
  }

  bool isVocabularyInFavorites(String vocabularyId){
    for (Vocabulary vocabulary in favouritesTable.vocabularies){
      if (vocabulary.id == vocabularyId){
        return true;
      }
    }
    return false;
  }

  List<Vocabulary> selectOldVocabularies(int amountOfWords, int currentLevel){
    List<Vocabulary> vocabularyListForTest = [];
    List<int> selectedLevelIndizes = [];
    while (selectedLevelIndizes.length < amountOfWords){
      Random random = new Random();
      int randomNumber = random.nextInt(currentLevel - 1)+1;
      selectedLevelIndizes.add(randomNumber);
    }
    selectedLevelIndizes.sort();
    for (var i = 1; i < currentLevel; i++) {
      int counter = 0;
      for(int levelIndex in selectedLevelIndizes){
        if (i == levelIndex){
          counter = counter + 1;
        }
      }
      if (counter > 0){
        List<Vocabulary> vocabularies = selectVocabulariesOfTable(counter, vocabularyTables.firstWhere((element) => element.level == i));
        for (Vocabulary vocabulary in vocabularies){
          vocabularyListForTest.add(vocabulary);
        }
      }
    }
    return vocabularyListForTest;
  }

  List<Vocabulary> selectVocabulariesOfTable(int amountOfWords, VocabularyTable vocabularyTable){
    List<Vocabulary> vocabularyListForTest = [];
    int amountOfSelectedWords = 0;
    List<int> selectedWordIndizes = [];
    while (amountOfSelectedWords < amountOfWords){
      Random random = new Random();
      int randomNumber = random.nextInt(vocabularyTable.vocabularies.length);
      if (!selectedWordIndizes.contains(randomNumber)){
        selectedWordIndizes.add(randomNumber);
        amountOfSelectedWords = amountOfSelectedWords + 1;
      }
    }
    for (int index in selectedWordIndizes){
      vocabularyListForTest.add(vocabularyTable.vocabularies[index]);
    }
    return vocabularyListForTest;
  }

  List<Vocabulary> createTestVocabularies(){
    int actualUserLevel = userData.user!.level;
    VocabularyTable actualLevelTable = vocabularyTables.firstWhere((element) => element.level == actualUserLevel);
    List<Vocabulary> vocabularyListForTest = [];
    if (actualUserLevel == 1){
      vocabularyListForTest = selectVocabulariesOfTable(20, actualLevelTable);
    } else {
      vocabularyListForTest = selectVocabulariesOfTable(10, actualLevelTable);
      List<Vocabulary> oldVocabularies = selectOldVocabularies(10, actualUserLevel);
      for(Vocabulary vocabulary in oldVocabularies){
        vocabularyListForTest.add(vocabulary);
      }
    }
    //vocabularyListForTest.shuffle();
    return vocabularyListForTest;
  }

}