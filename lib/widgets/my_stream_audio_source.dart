import 'package:just_audio/just_audio.dart';

class MyStreamAudioSource extends StreamAudioSource {
  MyStreamAudioSource(this.audioData);
  final dynamic audioData;

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end = end ?? audioData.length;

    return StreamAudioResponse(
      sourceLength: audioData.length,
      contentLength: end! - start,
      offset: start,
      contentType: "audio/mpeg",
      stream: Stream.value(audioData.sublist(start, end)),
    );
  }
}
