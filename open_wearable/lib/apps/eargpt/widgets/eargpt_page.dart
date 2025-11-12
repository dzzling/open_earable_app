import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_ai/firebase_ai.dart';

class EargptPage extends StatefulWidget {
  const EargptPage({Key? key}) : super(key: key);

  @override
  State<EargptPage> createState() => _EargptPageState();
}

class _EargptPageState extends State<EargptPage> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  bool _isRecording = false;
  String? _audioPath;

  Future<void> _startRecording() async {
    print("Starting recording...");
    if (await _recorder.hasPermission()) {
      await _recorder.start(const RecordConfig(),
          path: './temp/audio.m4a'); // Dummy path for web
      setState(() {
        _isRecording = true;
      });
      print(_audioPath);
    }
  }

  Future<void> _stopRecording() async {
    print("Stopping recording...");
    if (_isRecording) {
      final path = await _recorder.stop(); // Blob while on web
      setState(() {
        _isRecording = false;
        _audioPath = path;
      });
      print("Recording stopped. File saved at: $path");
    }
  }

  Future<void> _playRecording() async {
    print("Playing recording from path: $_audioPath");
    if (_audioPath != null) {
      await _player.play(UrlSource(
          _audioPath!)); // Use temporarily UrlSource instead of DeviceFileSource
    }
    print("Playback finished.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startRecording,
              child: Text('Record'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _stopRecording,
              child: Text('Stop'),
            ),
            const SizedBox(height: 20),
            if (_audioPath != null)
              ElevatedButton(
                onPressed: _playRecording,
                child: const Text('Play'),
              ),
          ],
        ),
      ),
    );
  }
}
