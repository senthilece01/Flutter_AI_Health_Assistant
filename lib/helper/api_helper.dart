import 'dart:convert';
import 'package:http/http.dart' as http;

import 'constants.dart';

class APIHelper {
  static const apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$GEMINI_API_KEY';

  static Future<http.Response> callGoogleAPI(String message) async {
    return http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {
                "text":
                    "You are a health assistant chatbot named AI Health Assistant. \ If a user says 'hi', 'hello', or similar, reply with a friendly greeting. \If the user asks your name, say 'I'm AI Health Assistant'. \For any health questions, give advice and solutions in simple language. \Always include a disclaimer that you're not a licensed doctor and recommend visiting a real doctor for serious issues."
              }
            ]
          },
          {
            "role": "user",
            "parts": [
              {"text": message}
            ]
          }
        ]
      }),
    );
  }
}
