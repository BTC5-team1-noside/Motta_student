import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:student/screens/game_screen.dart';
import "dart:convert";
import 'package:intl/intl.dart';

Future<List<Map<String, dynamic>>> getStudents(DateTime? selectedDate) async {
  final formatDate = DateFormat("yyyy-MM-dd");
  DateTime currentDate = selectedDate ?? DateTime.now();
  final formattedDate = formatDate.format(currentDate);
  final url = Uri.https("motta-9dbb2df4f6d7.herokuapp.com",
      "/api/v1/teacher/home/history", {"date": "2024-01-18"});
  // final url = Uri.https("motta-9dbb2df4f6d7.herokuapp.com",
  //     "/api/v1/teacher/home/history", {"date": formattedDate});

  try {
    final res = await http.get(url);
    final data = await json.decode(res.body);
    debugPrint("うまくいってます！");

    final List<Map<String, dynamic>> studentNames =
        List<Map<String, dynamic>>.from(
            data["studentsHistory"].map((student) => student));
    // debugPrint(studentNames.toString());

    return studentNames;
  } catch (error) {
    debugPrint("エラーです！");
    throw Future.error("エラーが発生しました: $error");
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: getStudents(DateTime.now()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('エラー: ${snapshot.error}');
              } else if (snapshot.data == null) {
                return const Text('データがありません');
              } else {
                final List<Map<String, dynamic>> data = snapshot.data!;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final el = data[index];
                    return GestureDetector(
                        onTap: () {
                          debugPrint("student_idは？${el["student_id"]}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  // GameScreen(student_id: el["student_id"]),
                                  GameScreen(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: el["checkedInventory"]
                                ? Colors.green.withOpacity(0.6)
                                : Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: el["checkedInventory"]
                                  ? [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                        child: Image.asset(
                                          // 'assets/images/stamps/char1.PNG', // 画像のファイルパスに置き換える
                                          'assets/images/stamps/char${el["character_id"]}.PNG', // 画像のファイルパスに置き換える
                                          width: 200,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade500
                                              .withOpacity(0),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Text(
                                          el["student_name"]
                                              .toString(), // character_id //student_name
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ]
                                  : [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          topRight: Radius.circular(10.0),
                                        ),
                                        child: Image.asset(
                                          // 'assets/images/stamps/char1.PNG', // 画像のファイルパスに置き換える
                                          'assets/images/stamps/char${el["character_id"]}.PNG', // 画像のファイルパスに置き換える
                                          width: 200,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        width: 200,
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade500
                                              .withOpacity(0),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        child: Text(
                                          el["student_name"]
                                              .toString(), // character_id //student_name
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ]),
                        ));

                    return null;
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
