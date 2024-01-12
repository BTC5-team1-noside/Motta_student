import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:student/screens/game_screen.dart';
import "dart:convert";
import 'package:intl/intl.dart';
import 'package:student/widgets/apis.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 50,
            child: Text(
              "1がつ 22にち（げつ）",
              style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 95, 95, 95)),
            ),
          ),
          const Divider(
            color: Color.fromARGB(255, 205, 205, 205),
            thickness: 2.0,
          ),
          Container(
            padding: const EdgeInsets.only(left: 50, right: 50),
            height: MediaQuery.of(context).size.height - 95,
            width: double.infinity,
            // color: const Color.fromARGB(255, 246, 246, 230),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                    ),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final el = data[index];
                      debugPrint("$el");
                      return GestureDetector(
                        onTap: () {
                          // debugPrint("student_idは？${el["student_id"]}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GameScreen(studentId: el["student_id"]),
                              // GameScreen(),
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
                                          'assets/images/stamps/char${el["character_id"]}.PNG',
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
                                          'assets/images/stamps/char${el["character_id"]}.PNG',
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
                                          el["student_name"].toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ]),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      )),
    );
  }
}
