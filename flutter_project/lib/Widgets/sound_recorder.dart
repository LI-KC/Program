import 'dart:async';
import 'package:flutter_project/class/SleepRecord.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import '../class/FetchingDataHandler.dart';

const savePath = 'audio_example';

class SoundRecorder {
  Timer? timer;

  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialised = false;

  bool get isRecording => _audioRecorder!.isRecording;

  List<SleepingRecord>? sleepRecordList;
  SoundRecorder();

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission denied');
    }

    await _audioRecorder!.openAudioSession();
    _isRecorderInitialised = true;
  }

  void passInRecordList(List<SleepingRecord> sleepRecordList) {
    this.sleepRecordList = sleepRecordList;
  }

  List<SleepingRecord> returnRecordList() {
    return sleepRecordList!;
  }

  void dispose() {
    if (!_isRecorderInitialised) return;

    _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  Future _record() async {
    if (!_isRecorderInitialised) return;

    await FetchingDataHandler.init();
    timer = Timer.periodic(
      // const Duration(seconds: 3),
      const Duration(seconds: 1),
      (Timer t) => FetchingDataHandler.fetchFrameType(sleepRecordList!),
    );

    await _audioRecorder!.startRecorder(toFile: savePath);
  }

  Future _stop() async {
    if (!_isRecorderInitialised) return;
    timer?.cancel();
    await _audioRecorder!.stopRecorder();
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}
