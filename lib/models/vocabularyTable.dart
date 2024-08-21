import 'package:parla_italiano/models/vocabulary.dart';

class VocabularyTable{
  String title;
  int level;
  String db_id;
  List<Vocabulary> vocabularies = [];

  VocabularyTable(this.title, this.level, this.db_id);

  void addVocabulary(Vocabulary vocabulary){
    this.vocabularies.add(vocabulary);
  }

  int getLength(){
    return this.vocabularies.length;
  }

}