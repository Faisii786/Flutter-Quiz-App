import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quiz_app/Model/quiz_model.dart';

class ApiClass {
  String url = 'https://opentdb.com/api.php?amount=20&category=9';

  Future<QuizModel> fetchData() async {
    final response = await http.get(Uri.parse(url));
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return QuizModel.fromJson(body);
    }
    throw Exception("Error");
  }
}
