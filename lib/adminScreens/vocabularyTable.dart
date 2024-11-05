import 'package:parla_italiano/adminScreens/vocabulary.dart';

class VocabTable{
  String title;
  int level;
  String db_id;
  List<Vocab> vocabularies = [];

  VocabTable(this.title, this.level, this.db_id);

  void addVocabulary(Vocab vocabulary){
    this.vocabularies.add(vocabulary);
  }

  int getLength(){
    return this.vocabularies.length;
  }

}