import 'package:flutter_tts/flutter_tts.dart';

class VoiceSpeaker{



  void speakItalianWord(String word) async {
    FlutterTts flutterTts = FlutterTts(); 
    flutterTts.setLanguage('it-IT');
    flutterTts.setSpeechRate(1.0); 
    flutterTts.setVolume(1.0); 
    flutterTts.setPitch(1.0);
    await flutterTts.speak(word);
  }
}