import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/dbModels/appUser.dart';
import 'package:parla_italiano/models/vocabulary.dart';
import 'package:parla_italiano/models/vocabularyTable.dart';

import 'dart:math';


class VocabularyRepo{

  List<VocabularyTable> vocabularyTables = [];
  VocabularyTable favouritesTable = VocabularyTable('Meine Favoriten', 0);

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
          if (vocabulary.italian == wordId){
            favouritesTable.vocabularies.add(Vocabulary(vocabulary.german, vocabulary.italian, vocabulary.additional));
          }
        }
      }
    }
  }

  List<Vocabulary> findVocabulariesByItalians(List<String> italians){
    List<Vocabulary> vocabularies = [];
    for (String italian in italians){
      for (VocabularyTable table in vocabularyTables){
        for (Vocabulary vocabulary in table.vocabularies){
          if (vocabulary.italian == italian){
            vocabularies.add(vocabulary);
            break;
          }
        }
      }
    }
    return vocabularies;
  }

  void deleteFavouriteVocabulary(String italian){
    for (Vocabulary vocabulary in favouritesTable.vocabularies){
      if (vocabulary.italian == italian){
        favouritesTable.vocabularies.remove(vocabulary);
      }
    }
    UserHandler().deleteFavouriteIds(italian);
  }

  void addVocabularyToFavorites(String italian, String german, String additional){
    favouritesTable.vocabularies.add(Vocabulary(german, italian, additional));
    UserHandler().addFavouriteIds(italian);
  }

  bool isVocabularyInFavorites(String italian){
    for (Vocabulary vocabulary in favouritesTable.vocabularies){
      if (vocabulary.italian == italian){
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
        List<Vocabulary> vocabularies = selectVocabulariesOfTable(counter, vocabularyTables.firstWhere((element) => element.level == i).vocabularies);
        for (Vocabulary vocabulary in vocabularies){
          vocabularyListForTest.add(vocabulary);
        }
      }
    }
    return vocabularyListForTest;
  }

  List<Vocabulary> selectVocabulariesOfTable(int amountOfWords, List<Vocabulary> vocabularies){
    List<Vocabulary> vocabularyListForTest = [];
    int amountOfSelectedWords = 0;
    List<int> selectedWordIndizes = [];
    while (amountOfSelectedWords < amountOfWords){
      Random random = new Random();
      int randomNumber = random.nextInt(vocabularies.length);
      if (!selectedWordIndizes.contains(randomNumber)){
        selectedWordIndizes.add(randomNumber);
        amountOfSelectedWords = amountOfSelectedWords + 1;
      }
    }
    for (int index in selectedWordIndizes){
      vocabularyListForTest.add(vocabularies[index]);
    }
    return vocabularyListForTest;
  }

  List<Vocabulary> createTestVocabularies(){
    int actualUserLevel = userData.user!.level;
    VocabularyTable actualLevelTable = vocabularyTables.firstWhere((element) => element.level == actualUserLevel);
    List<Vocabulary> vocabularyListForTest = [];
    if (actualUserLevel == 1){
      vocabularyListForTest = selectVocabulariesOfTable(20, actualLevelTable.vocabularies);
    } else {
      vocabularyListForTest = selectVocabulariesOfTable(10, actualLevelTable.vocabularies);
      List<Vocabulary> oldVocabularies = selectOldVocabularies(10, actualUserLevel);
      for(Vocabulary vocabulary in oldVocabularies){
        vocabularyListForTest.add(vocabulary);
      }
    }
    //vocabularyListForTest.shuffle();
    return vocabularyListForTest;
  }

  List<Vocabulary> generateVocabulariesTillLevel(int lowestLevel, int amount){
    List<Vocabulary> allVocabularies = [];
    for (VocabularyTable table in vocabularyTables){
      if (table.level <= lowestLevel){
        for (Vocabulary vocabulary in table.vocabularies){
          allVocabularies.add(vocabulary);
        }
      }
    }
    List<Vocabulary> allSelectedVocabularies = selectVocabulariesOfTable(amount, allVocabularies);
    return allSelectedVocabularies;
  }

  List<Vocabulary> getVocabulariesFromLevel(int level) {
    for (VocabularyTable table in vocabularyTables){
      if (table.level == level){
        return table.vocabularies;
      }
    }
    return [];
  }
}