import 'package:parla_italiano/globals/globalData.dart' as userData;
import 'package:parla_italiano/adminScreens/vocabulary.dart';
import 'package:parla_italiano/adminScreens/vocabularyTable.dart';

import 'dart:math';


class VocabRepo{

  List<VocabTable> vocabularyTables = [];

  VocabRepo(this.vocabularyTables);

  List<Vocab> findVocabulariesByIDs(List<String> ids){
    List<Vocab> vocabularies = [];
    for (String id in ids){
      for (VocabTable table in vocabularyTables){
        for (Vocab vocabulary in table.vocabularies){
          if (vocabulary.id == id){
            vocabularies.add(vocabulary);
            break;
          }
        }
      }
    }
    return vocabularies;
  }

  List<Vocab> selectOldVocabularies(int amountOfWords, int currentLevel){
    List<Vocab> vocabularyListForTest = [];
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
        List<Vocab> vocabularies = selectVocabulariesOfTable(counter, vocabularyTables.firstWhere((element) => element.level == i).vocabularies);
        for (Vocab vocabulary in vocabularies){
          vocabularyListForTest.add(vocabulary);
        }
      }
    }
    return vocabularyListForTest;
  }

  List<Vocab> selectVocabulariesOfTable(int amountOfWords, List<Vocab> vocabularies){
    List<Vocab> vocabularyListForTest = [];
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

  List<Vocab> createTestVocabularies(){
    int actualUserLevel = userData.user!.level;
    VocabTable actualLevelTable = vocabularyTables.firstWhere((element) => element.level == actualUserLevel);
    List<Vocab> vocabularyListForTest = [];
    if (actualUserLevel == 1){
      vocabularyListForTest = selectVocabulariesOfTable(20, actualLevelTable.vocabularies);
    } else {
      vocabularyListForTest = selectVocabulariesOfTable(10, actualLevelTable.vocabularies);
      List<Vocab> oldVocabularies = selectOldVocabularies(10, actualUserLevel);
      for(Vocab vocabulary in oldVocabularies){
        vocabularyListForTest.add(vocabulary);
      }
    }
    //vocabularyListForTest.shuffle();
    return vocabularyListForTest;
  }

  List<Vocab> generateVocabulariesTillLevel(int lowestLevel, int amount){
    List<Vocab> allVocabularies = [];
    for (VocabTable table in vocabularyTables){
      if (table.level <= lowestLevel){
        for (Vocab vocabulary in table.vocabularies){
          allVocabularies.add(vocabulary);
        }
      }
    }
    List<Vocab> allSelectedVocabularies = selectVocabulariesOfTable(amount, allVocabularies);
    return allSelectedVocabularies;
  }

  List<Vocab> getVocabulariesFromID(String id) {
    for (VocabTable table in vocabularyTables){
      if (table.db_id == id){
        return table.vocabularies;
      }
    }
    return [];
  }
}