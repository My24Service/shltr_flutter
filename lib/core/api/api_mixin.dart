import 'dart:convert';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shltr_flutter/core/models/models.dart';
import 'package:shltr_flutter/app_config.dart';

mixin ApiMixin {
  Map<String, String> getHeaders(String? token) {
    return {'Authorization': 'Bearer $token'};
  }

  Future<bool?> postDeviceToken(http.Client httpClient) async {
    final Map<String, String> envVars = Platform.environment;

    if (envVars['TESTING'] != null) {
      return null;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? token = prefs.getString('token');
    final int? userId = prefs.getInt('user_id');
    final bool isAllowed = prefs.getBool('fcm_allowed')!;

    if (!isAllowed) {
      return false;
    }

    final url = await getUrl('/company/user-device-token/');

    Map<String, String> allHeaders = {"Content-Type": "application/json; charset=UTF-8"};
    allHeaders.addAll(getHeaders(token));

    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? messagingToken = await messaging.getToken();

    final Map body = {
      "user": userId,
      "device_token": messagingToken
    };

    final response = await httpClient.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: allHeaders,
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<SlidingToken?> refreshSlidingToken(http.Client httpClient) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final url = await getUrl('/jwt-token/refresh/');
    final token = prefs.getString('token');
    final authHeaders = getHeaders(token);
    Map<String, String> allHeaders = {"Content-Type": "application/json; charset=UTF-8"};
    allHeaders.addAll(authHeaders);

    final response = await httpClient.post(
      Uri.parse(url),
      body: json.encode(<String, String?>{"token": token}),
      headers: allHeaders,
    );

    if (response.statusCode == 401) {
      return null;
    }

    if (response.statusCode == 200) {
      SlidingToken token = SlidingToken.fromJson(json.decode(response.body));
      // token.checkIsTokenExpired();

      await prefs.setString('token', token.token!);

      return token;
    }

    return null;
  }

  Future<String> getUrl(String? path) async {
    AppConfig config = AppConfig();

    final prefs = await SharedPreferences.getInstance();
    String? companycode = prefs.getString('companycode');
    String apiBaseUrl = config.apiBaseUrl;

    if (companycode == null || companycode == '') {
      companycode = 'demo';
    }

    return 'https://$companycode.$apiBaseUrl/api$path';
  }

  Future<String> getBaseUrlPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? companycode = prefs.getString('companycode');
    String? apiBaseUrl = prefs.getString('apiBaseUrl');

    if (companycode == null || companycode == '') {
      companycode = 'demo';
    }

    if (apiBaseUrl == null || apiBaseUrl == '') {
      apiBaseUrl = 'my24service-dev.com';
    }

    return 'https://$companycode.$apiBaseUrl';
  }
}
