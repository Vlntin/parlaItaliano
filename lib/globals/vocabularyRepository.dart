library vocabularyRepository;

import 'package:parla_italiano/globals/userData.dart' as userData;
import 'package:parla_italiano/handler/userHandler.dart';
import 'package:parla_italiano/models/appUser.dart';



List<VocabularyTable> vocabularyTables = [];
VocabularyTable favouritesTable = VocabularyTable('Meine Favoriten', 0, '0');

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

class Vocabulary{
  String german;
  String italian;
  String additional;
  String id;

  Vocabulary(this.german, this.italian, this.additional, this.id);

  String getGerman(){
    return this.german;
  }

  String getItaliann(){
    return this.italian;
  }

  String getAdditional(){
    return this.additional;
  }

}

class VocabularyTable{
  String title;
  int level;
  String db_id;
  List<Vocabulary> vocabularies = [];

  VocabularyTable(this.title, this.level, this.db_id );

  void addVocabulary(Vocabulary vocabulary){
    this.vocabularies.add(vocabulary);
  }

  int getLength(){
    return this.vocabularies.length;
  }

}




