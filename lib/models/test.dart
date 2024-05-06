import 'package:parla_italiano/globals/vocabularyRepository.dart' as vocabularyRepository;
import 'package:parla_italiano/globals/vocabularyRepository.dart';
import 'dart:math';

class Test{

  final List<Vocabulary> vocabularies = vocabularyRepository.createTestVocabularies();
  int _amountOfPlayingWords = 20;
  int _neededCorrectAnswers = 19;
  int _vocabularyIndex = 0;
  int _mistakes = 0;
  int _correct = 0;
  double _percentageOfWrongAnswers = 0.0;
  double _percentageOfCorrectAnswers = 0.0;
  int _finished_words = 0;

  /**
   * 0: deutsch -> italienisch
   * 1: deutsch -> italienisch
   * 2: italienisch -> deutsch
   * 3: voice -> deutsch
   */
  int _translationDirectionClassificator = new Random().nextInt(4);

  void validateAnswer(String answer){
    _finished_words = _finished_words + 1;
    if (_translationDirectionClassificator == 0 || _translationDirectionClassificator == 1){
      if (answer == vocabularies[_vocabularyIndex].italian){
        _correct = _correct + 1;
      } else {
        _mistakes = _mistakes + 1;
      }
    } else {
      if (answer == vocabularies[_vocabularyIndex].german){
        _correct = _correct + 1;
      } else {
        _mistakes = _mistakes + 1;
      }
    }
    _percentageOfWrongAnswers = _mistakes / _amountOfPlayingWords;
    _percentageOfCorrectAnswers = _correct/ _amountOfPlayingWords;
  }

  bool isTestFinished(){
    if (_vocabularyIndex < (_amountOfPlayingWords - 1)){
      _vocabularyIndex = _vocabularyIndex + 1;
      _translationDirectionClassificator = new Random().nextInt(4);
      return false;
    } else {
      return true;
    }
  }

  int getAmountsOfPlayingWord(){
    return _amountOfPlayingWords;
  }

  int getAmountOfFinishedWords(){
    return _finished_words;
  }

  double getPercentageOfWrongAnswers(){
    return _percentageOfWrongAnswers;
  }

  double getPercentageOfCorrectAnswers(){
    return _percentageOfCorrectAnswers;
  }

  int getAmountOfCorrectWords(){
    return _correct;
  }

  int getAmountOfWrongWords(){
    return _mistakes;
  }

  int getAmountOfNeededCorrects(){
    return _neededCorrectAnswers;
  }

  int getTranslationDirectionClassificator(){
    return _translationDirectionClassificator;
  }

  String getActualGermanWord(){
    return vocabularies[_vocabularyIndex].german;
  }

  String getActualItalianWord(){
    return vocabularies[_vocabularyIndex].italian;
  }

}