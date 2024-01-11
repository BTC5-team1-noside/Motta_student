import "dart:convert";
import "dart:io";
import "dart:typed_data";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:just_audio/just_audio.dart";
import "package:student/widgets/my_stream_audio_source.dart";

List<int> speakerArr = [32, 70, 54, 51, 42];

Future synthesizeVoice({required String text, required int studentId}) async {
  int speakerIndex = (studentId % 5 == 0 ? 5 : studentId % 5) - 1;
  String dynamicUrl =
      "https://d0a5-240b-c020-401-d255-d446-849e-d77e-7c9c.ngrok-free.app"; //ここのアドレスがエンジンを立ち上げ直す毎に変わるよ！！
  String url =
      '$dynamicUrl/audio_query?text=$text&speaker=${speakerArr[speakerIndex]}';

  final response = await http.post(
    Uri.parse(url),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: json.encode({
      'text': text,
    }),
  );
  if (response.statusCode == 200) {
    var body = json.decode(response.body);
    var audioQuery = body;
    var synthesisResponse = await http.post(
      Uri.https(
        "d0a5-240b-c020-401-d255-d446-849e-d77e-7c9c.ngrok-free.app",
        "/synthesis",
        {
          "speaker": "${speakerArr[speakerIndex]}", //speakerのvalueを変更することで話者を変更
        },
      ),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode(audioQuery),
    );
    if (synthesisResponse.statusCode == 200) {
      final data = synthesisResponse.bodyBytes;
      return data;
    } else {
      debugPrint('apis line43: 音声生成失敗: ${synthesisResponse.reasonPhrase}');
    }
  } else {
    debugPrint('apis line46: クエリ生成失敗: ${response.reasonPhrase}');
  }
}

void playVoiceFromData(
    {required dynamic data, required AudioPlayer audioPlayer}) async {
  final source = MyStreamAudioSource(data);
  await audioPlayer.setAudioSource(source);
  audioPlayer.play();
}

void postConfirmDate({String date = "2023-12-01", int studentId = 1}) async {
  final url = Uri.https(
      "motta-9dbb2df4f6d7.herokuapp.com", "/api/v1/student/confirms-history");
  final reqBodyDate = {
    "date": date,
    "student_id": "$studentId",
  };
  final reqBodyDateJson = json.encode(reqBodyDate);
  try {
    // data fetching
    await http.post(url,
        headers: {"Content-Type": "application/json"}, body: reqBodyDateJson);
  } catch (error) {
    debugPrint(error.toString());
  }
}

Future<List<dynamic>> getCalendarData(
    {String date = "2023-01-01", int studentId = 1}) async {
  final url = Uri.https(
      "motta-9dbb2df4f6d7.herokuapp.com", "/api/v1/student/confirms-history", {
    "student_id": "$studentId",
    "date": date,
  });
  try {
    final response =
        await http.get(url, headers: {"Content-Type": "application/json"});
    final data = json.decode(response.body);

    return data;
  } catch (error) {
    debugPrint(error.toString());
    return [];
  }
}

Future<List<Map<String, dynamic>>> getStudents(DateTime? selectedDate) async {
  final url = Uri.https("motta-9dbb2df4f6d7.herokuapp.com",
      "/api/v1/teacher/home/history", {"date": "2024-01-22"});

  // final formatDate = DateFormat("yyyy-MM-dd");
  // DateTime currentDate = selectedDate ?? DateTime.now();
  // final formattedDate = formatDate.format(currentDate);
  // final url = Uri.https("motta-9dbb2df4f6d7.herokuapp.com",
  //     "/api/v1/teacher/home/history", {"date": formattedDate});

  try {
    final res = await http.get(url);
    final data = await json.decode(res.body);
    final List<Map<String, dynamic>> studentNames =
        List<Map<String, dynamic>>.from(
            data["studentsHistory"].map((student) => student));
    return studentNames;
  } catch (error) {
    debugPrint("student_login line28:エラーです！");
    throw Future.error("エラーが発生しました: $error");
  }
}
