import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:medpocket/src/app_state/AppState.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_state/URL.dart';

final http.Client client = http.Client();
String baseUrl = URL().baseUrl;

Future<dynamic> getOrders(bool is_received) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/order${is_received?'/receive':''}');
  final response = await client.get(url, headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> placeOrder() async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/order/generate');
  final response = await client.get(url, headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> getOrderById(int orderId) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/order/$orderId');
  final response = await client.get(url, headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> getOrderStatus() async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/order/status');
  final response = await client.get(url, headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> updateOrder(dynamic data,int orderId) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/order/$orderId');
  final response = await client.post(url,body: data, headers: {
    "Authorization":"Bearer ${prefs.get("token")}"
  });
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

