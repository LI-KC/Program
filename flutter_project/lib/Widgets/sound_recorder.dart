import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_project/class/SleepRecord.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import '../class/FetchingDataHandler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

class SoundRecorder {
  Timer? timer;
  FlutterSoundRecorder? _audioRecorder = FlutterSoundRecorder();
  bool _isRecorderInitialised = false;
  List<SleepingRecord>? sleepRecordList;

  String result = '';

  String fileName = 'realWavAudio.wav';
  Directory? directory;
  String? path;

  SoundRecorder();

  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission denied');
    }

    directory = await getTemporaryDirectory();
    print(directory);
    path = directory!.path;

    await _audioRecorder!.openRecorder();
    _isRecorderInitialised = true;

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  void passInRecordList(List<SleepingRecord> sleepRecordList) {
    this.sleepRecordList = sleepRecordList;
  }

  List<SleepingRecord> returnRecordList() {
    return sleepRecordList!;
  }

  void dispose() {
    if (!_isRecorderInitialised) return;

    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    _isRecorderInitialised = false;
  }

  Future _record() async {
    if (!_isRecorderInitialised) return;

    await FetchingDataHandler.init();

    timer = Timer.periodic(
        // const Duration(seconds: 3),
        const Duration(seconds: 3), (Timer t) {
      // print('globalEventFlag: $globalEventFlag');
      FetchingDataHandler.fetchFrameType(sleepRecordList!);
      // FetchingDataHandler.fetchFrameType(sleepRecordList!, globalEventFlag);
      // changeGlobalEventFlag();asd
    });

    await _audioRecorder!.startRecorder(
      toFile: '$path/$fileName',
      // codec: Codec.pcm16WAV,
      codec: Codec.pcm16WAV,
      audioSource: AudioSource.microphone,
      numChannels: 1,
      sampleRate: 44100,
    );
  }

  Future _stop() async {
    if (!_isRecorderInitialised) return;
    timer?.cancel();
    // globalEventFlag = false;
    await _audioRecorder!.stopRecorder();

    print(path);

    var audio = File('$path/$fileName');
    // await flutterSoundHelper.pcmToWave(
    //   inputFile: '$path/$savePath',
    //   outputFile: '$path/myAudio.wav',
    //   numChannels: 1,
    //   sampleRate: 44100,
    // );

    var bytes = await audio.readAsBytes();
    // print('origin: ${a.cast().length} ${a.cast()}');

    // await File(
    //         '/data/user/0/com.example.flutter_project/app_flutter/flutter_assets/realAudio.wav')
    //     .writeAsBytes(bytes);
    // var realAudio = await File('$path/realAudio').readAsBytes();
    // print('realAudio: ${realAudio.cast().length} ${realAudio.cast()}');

    try {
      String uri = "http://37f1-202-125-194-14.ngrok.io//try";
      FormData data = FormData.fromMap({
        "file": await MultipartFile.fromBytes(
          bytes,
          filename: 'meReliCryLunJor.wav',
          contentType: MediaType('audio', 'wav'),
        ),
      });

      Dio dio = Dio(BaseOptions(
        contentType: "application/json",
      ));

      var response = await dio.post(uri, data: data);
      print(response);
      var resultArr = jsonDecode(response.data);

      //　TODO
    } catch (err) {
      print(err);
    }
  }

  Future toggleRecording() async {
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      await _stop();
    }
  }
}
