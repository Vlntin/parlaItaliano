import 'package:parla_italiano/models/vocabulary.dart';

class VocabularyTable{
  String title;
  int level;
  List<Vocabulary> vocabularies = [];

  VocabularyTable(this.title, this.level);

  void addVocabulary(Vocabulary vocabulary){
    this.vocabularies.add(vocabulary);
  }

  int getLength(){
    return this.vocabularies.length;
  }

}