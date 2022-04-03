import 'dart:async';
import 'package:flutter_project/class/SleepRecord.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../class/FetchingDataHandler.dart';

const savePath = 'audio_example';

class SoundRecorder {
  Timer? timer;
  bool eventFlag = false;

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

    gyroscopeEvents.listen((GyroscopeEvent event) {
      var _gyroscopeValues = <double>[event.x, event.y, event.z]
          .reduce((value, element) => value + element.abs());
      if (_gyroscopeValues != 0) {
        eventFlag = true;
      }

      timer = Timer.periodic(
          // const Duration(seconds: 3),
          const Duration(seconds: 1), (Timer t) {
        FetchingDataHandler.fetchFrameType(sleepRecordList!, eventFlag);
        eventFlag = false;
      });
    });

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
