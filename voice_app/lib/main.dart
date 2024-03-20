import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(VoiceTranslatorApp());
}

class VoiceTranslatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VoiceTranslatorScreen(),
    );
  }
}

class VoiceTranslatorScreen extends StatefulWidget {
  @override
  _VoiceTranslatorScreenState createState() => _VoiceTranslatorScreenState();
}

class _VoiceTranslatorScreenState extends State<VoiceTranslatorScreen> {
  stt.SpeechToText _speechToText = stt.SpeechToText();
  FlutterTts _flutterTts = FlutterTts();

  String _text = '';
  bool _isListening = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Translator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isListening ? CircularProgressIndicator() : Icon(Icons.mic),
            SizedBox(height: 20),
            Text(_text),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isListening ? null : _startListening,
              child: Text('Start Listening'),
            ),
            SizedBox(height: 10), 
            ElevatedButton(
              onPressed: _isListening ? _stopListening : null,
              child: Text('Stop Listening'),
            ),
            SizedBox(height: 10), 
            ElevatedButton(
              onPressed: _text.isEmpty ? null : _speakText,
              child: Text('Speak Text'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startListening() async {
    bool available = await _speechToText.initialize();
    if (available) {
      _speechToText.listen(
        onResult: (result) {
          setState(() {
            _text = result.recognizedWords;
          });
        },
      );
      setState(() {
        _isListening = true;
      });
    } else {
      print('The user has denied the use of speech recognition.');
    }
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  Future<void> _speakText() async {
    await _flutterTts.setLanguage('hi-IN'); 
    await _flutterTts.speak(_text);
  }
}






