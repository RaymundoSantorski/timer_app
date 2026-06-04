import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> playRestAudio() async {
    await _audioPlayer.play(AssetSource('sounds/rest.wav'));
  }

  static Future<void> playWorkAudio() async {
    await _audioPlayer.play(AssetSource('sounds/work.wav'));
  }

  static Future<void> playCompletedAudio() async {
    await _audioPlayer.play(AssetSource('sounds/end.wav'));
  }
}
