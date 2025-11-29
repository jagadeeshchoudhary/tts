import 'package:flutter/material.dart';
import 'package:tts/tts_page.dart';

void main() {
  runApp(const TTS());
}

class TTS extends StatelessWidget {
  const TTS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const TtsPage(),
    );
  }
}
