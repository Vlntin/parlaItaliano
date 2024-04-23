library vocabularyRepository;
List<VocabularyTable> vocabularyTables = [];

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

class Vocabulary{
  String german;
  String italian;
  String additional;

  Vocabulary(this.german, this.italian, this.additional);

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




