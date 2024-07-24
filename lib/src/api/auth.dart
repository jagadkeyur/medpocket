import 'dart:convert';
import 'package:context_holder/context_holder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:medpocket/src/app_state/URL.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final http.Client client = http.Client();
String baseUrl = URL().baseUrl;

Future<dynamic> auth(String mobileNumber, String deviceId) async {
  Uri url = Uri.parse('$baseUrl/api/v1/users/login');
  final response = await client
      .post(url, body: {"phone": mobileNumber, "device_id": deviceId});
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> signup(data) async {
  Uri url = Uri.parse('$baseUrl/api/v1/users/register');
  final response = await client.post(url, body: data);
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> verify(
    String mobileNumber, String otp, String deviceId, String fcmToken) async {
  if (kDebugMode) {
    print("response mobile $mobileNumber $otp");
  }
  Uri url = Uri.parse('$baseUrl/api/v1/users/verify');
  final response = await client.post(url, body: {
    "phone": mobileNumber,
    "otp": otp,
    "device_id": deviceId,
    "fcm_token": fcmToken,
  });
  if (kDebugMode) {
    print("response ${response.body} $otp");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> getCenters() async {
  Uri url = Uri.parse('$baseUrl/api/v1/users/centers');
  final response = await client.get(url);
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> getCenterAds() async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/users/center/ads');
  final response = await client
      .get(url, headers: {"Authorization": "Bearer ${prefs.get("token")}"});
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> addStockiest(data, PlatformFile? file) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/users/stockiest');

  var request = http.MultipartRequest("POST", url);
  request.fields['firm_name'] = data['firm_name'];
  request.fields['center'] = data['center'];
  request.fields['phone'] = data['phone'];
  var newFile = await http.MultipartFile.fromPath(
      'attachment', file?.path ?? "",
      filename: file?.name);
  request.files.add(newFile);

  request.headers["Authorization"] = "Bearer ${prefs.get("token")}";

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> addProduct(PlatformFile? file) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/users/product');

  var request = http.MultipartRequest("POST", url);
  var newFile = await http.MultipartFile.fromPath(
      'attachment', file?.path ?? "",
      filename: file?.name);
  request.files.add(newFile);

  request.headers["Authorization"] = "Bearer ${prefs.get("token")}";

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> validateRegKey(String regKey) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/users/validate-key/$regKey');
  final response = await client
      .get(url, headers: {"Authorization": "Bearer ${prefs.get("token")}"});
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<dynamic> getOption(String key) async {
  final prefs = await SharedPreferences.getInstance();
  Uri url = Uri.parse('$baseUrl/api/v1/users/get-option/$key');
  final response = await client
      .get(url, headers: {"Authorization": "Bearer ${prefs.get("token")}"});
  if (kDebugMode) {
    print("response ${response.body}");
  }
  final body = json.decode(response.body);
  return body;
}

Future<void> requestPermission() async {
  const permissionCamera = Permission.camera;

  if (await permissionCamera.isDenied) {
    await permissionCamera.request();
  }
}

Future removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
  prefs.clear();
  ContextHolder.key.currentState?.pushNamed('/');
}
