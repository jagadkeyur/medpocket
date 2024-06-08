import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_state/URL.dart';

final http.Client client = http.Client();
String baseUrl = URL().baseUrl;

Future<dynamic> getProfile() async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/users/profile');
  final response = await client.get(url,headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> updateProfile(data) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/users/profile');
  final response = await client.post(url,body: data,headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}