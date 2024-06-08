import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:medpocket/src/app_state/AppState.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_state/URL.dart';

final http.Client client = http.Client();
String baseUrl = URL().baseUrl;

Future<dynamic> brandSearch(String query) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/brands/search');
  final response = await client.post(url, body: {"query": query},headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}
Future<dynamic> brandSearchByCompany(String company) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/brands/search/company/$company');
  final response = await client.get(url,headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> brandSearchByGeneric(String generic) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/brands/search/generic/$generic');
  final response = await client.get(url,headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}
