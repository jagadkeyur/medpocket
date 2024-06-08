import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:medpocket/src/app_state/AppState.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_state/URL.dart';

final http.Client client = http.Client();
String baseUrl = URL().baseUrl;

Future<dynamic> productSearchByBrand(String brand) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/product/search-by-brand');
  final response = await client.post(url, body: {"brand": brand},headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}
Future<dynamic> productById(int id) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/product/$id');
  final response = await client.get(url, headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}
Future<dynamic> productByContent(String content) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/product/content/$content');
  final response = await client.get(url, headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> addToCart(data) async {
  debugPrint("data $data");
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/product/cart');
  final response = await client.post(url,body: data, headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> getCart() async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/product/cart');
  final response = await client.get(url, headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> deleteCart(int cartId) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/product/cart/$cartId');
  final response = await client.delete(url, headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}
