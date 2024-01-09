import "dart:convert";
import "dart:io";
import "dart:typed_data";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;

Future synthesizeVoice(String text) async {
  String dynamicUrl =
      "https://d0a5-240b-c020-401-d255-d446-849e-d77e-7c9c.ngrok-free.app"; //ここのアドレスがエンジンを立ち上げ直す毎に変わるよ！！
  String url = '$dynamicUrl/audio_query?text=$text&speaker=32';

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
    debugPrint("レスポンス帰ってきてる？");
    var body = json.decode(response.body);
    var audioQuery = body;

    debugPrint("ここまでおっけー？");
    var synthesisResponse = await http.post(
      Uri.https(
        "d0a5-240b-c020-401-d255-d446-849e-d77e-7c9c.ngrok-free.app",
        "/synthesis",
        {
          "speaker": "32", //speakerのvalueを変更することで話者を変更
        },
      ),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: json.encode(audioQuery),
    );

    debugPrint("if文おわり");
    debugPrint("ステータスコードは：${synthesisResponse.statusCode}");

    if (synthesisResponse.statusCode == 200) {
      debugPrint("200きてる？");
      final data = synthesisResponse.bodyBytes;
      // debugPrint("$data");
      debugPrint('音声生成成功!');
      return data;
    } else {
      debugPrint('音声生成失敗: ${synthesisResponse.reasonPhrase}');
    }
  } else {
    debugPrint('クエリ生成失敗: ${response.reasonPhrase}');
  }
}
