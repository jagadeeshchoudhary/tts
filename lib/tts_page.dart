import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tts/msg_data.dart';

class TtsPage extends StatefulWidget {
  const TtsPage({super.key});

  @override
  State<TtsPage> createState() => _TtsPageState();
}

class _TtsPageState extends State<TtsPage> {
  FlutterTts flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  @override
  void initState() {
    super.initState();
    ttsInstance();
    _initSpeech();
  }

  void ttsInstance() async {
    await flutterTts.setSharedInstance(true);
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    _lastWords = '';
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    txtData.add({'text': _lastWords, 'bot': false});
    await flutterTts.speak(
      'Danke, I understand that you ask $_lastWords',
      focus: true,
    );
    await _speechToText.stop();
    txtData.add({
      'text': 'Danke, I understand that you ask $_lastWords',
      'bot': true,
    });
    setState(() {
      _lastWords = '';
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text to Speech')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: txtData.length,
              itemBuilder: (context, index) {
                final message = txtData[index];
                return ListTile(
                  title: Align(
                    alignment: message['bot'] as bool
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: message['bot'] as bool
                            ? Colors.grey[300]
                            : Colors.blue[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(message['text'].toString()),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            _speechToText.isListening
                ? _lastWords
                : _speechEnabled
                ? 'Tap the microphone to start listening...'
                : 'Speech not available',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: ElevatedButton(
              onPressed: _speechToText.isNotListening
                  ? _startListening
                  : _stopListening,
              child: Icon(
                _speechToText.isNotListening
                    ? Icons.play_circle_fill_outlined
                    : Icons.stop_circle_outlined,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
