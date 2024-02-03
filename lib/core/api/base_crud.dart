import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import 'package:shltr_flutter/core/api/api_mixin.dart';
import 'package:shltr_flutter/core/models/models.dart';
import 'package:shltr_flutter/core/models/base_models.dart';
import '../i18n_mixin.dart';

final log = Logger('BaseCrud');

abstract class BaseCrud<T extends BaseModel, U extends BaseModelPagination> with ApiMixin {
  String get basePath;
  http.Client httpClient = http.Client();

  U fromJsonList(Map<String, dynamic>? parsedJson);
  T fromJsonDetail(Map<String, dynamic>? parsedJson);

  Future<U> list({Map<String, dynamic>? filters, String? basePathAddition,
    http.Client? httpClientOverride, bool needsAuth=true}) async {
    final String responseBody = await getListResponseBody(
        filters: filters, basePathAddition: basePathAddition,
        httpClientOverride: httpClientOverride, needsAuth: needsAuth
    );
    return fromJsonList(json.decode(responseBody));
  }

  Future<String> getListResponseBody({Map<String, dynamic>? filters,
    String? basePathAddition, http.Client? httpClientOverride,
    bool needsAuth=true
  }) async {
    var client = httpClientOverride ?? httpClient;

    Map<String, String> headers = {};
    if (needsAuth) {
      SlidingToken newToken = await getNewToken(httpClientOverride: client);
      headers = getHeaders(newToken.token);
    }

    // List<String> args = ["page_size=5"];
    List<String> args = [];
    if (filters != null) {
      for (String key in filters.keys) {
        if (filters[key] != null || (key == 'q' && filters[key] != "" && filters[key] != null)) {
          args.add("$key=${filters[key]}");
        }
      }
    }

    String url = await getUrl(basePath);
    if (basePathAddition != null) {
      url = "$url/$basePathAddition";
    }

    // log.info('url.substring ${url.substring(url.length-1)}');
    if (url.substring(url.length-1) == '/') {
      url = url.substring(0, url.length-1);
    }

    if (args.isNotEmpty) {
      url = "$url/?${args.join('&')}";
    } else {
      url = "$url/";
    }
    // log.info('list: $url, httpClient: $_client, headers: $headers');

    final response = await client.get(
        Uri.parse(url),
        headers: headers
    );

    if (response.statusCode == 200) {
      return response.body;
    }
    //log.info(response.body);

    final String errorMsg = getTranslationTr('generic.exception_fetch', null);
    String msg = "$errorMsg (${response.body})";

    throw Exception(msg);
  }

  Future<T> detail(int pk, {String? basePathAddition, bool needsAuth=true}) async {
    Map<String, String> headers = {};
    if (needsAuth) {
      SlidingToken newToken = await getNewToken();
      headers = getHeaders(newToken.token);
    }

    String url = await getUrl('$basePath/$pk/');
    if (basePathAddition != null) {
      url = "$url$basePathAddition";
    }
    // log.info('detail: $url, httpClient: $httpClient');

    final response = await httpClient.get(
        Uri.parse(url),
        headers: headers
    );

    if (response.statusCode == 200) {
      return fromJsonDetail(json.decode(response.body));
    }

    final String errorMsg = getTranslationTr('generic.exception_fetch_detail', null);
    String msg = "$errorMsg (${response.body})";

    throw Exception(msg);
  }

  Future<T> insert(BaseModel model) async {
    SlidingToken newToken = await getNewToken(httpClientOverride: httpClient);

    final url = await getUrl('$basePath/');
    Map<String, String> allHeaders = {"Content-Type": "application/json; charset=UTF-8"};
    allHeaders.addAll(getHeaders(newToken.token));
    // log.info('insert: $url');

    final response = await httpClient.post(
      Uri.parse(url),
      body: model.toJson(),
      headers: allHeaders,
    );

    if (response.statusCode == 201) {
      return fromJsonDetail(json.decode(response.body));
    }

    final String errorMsg = getTranslationTr('generic.exception_insert', null);
    String msg = "$errorMsg (${response.body})";

    throw Exception(msg);
  }

  Future<dynamic> insertCustom(Map data, String basePathAddition, {bool returnTypeBool = true}) async {
    // insert custom data within the base URL
    SlidingToken newToken = await getNewToken(httpClientOverride: httpClient);

    final url = await getUrl('$basePath/$basePathAddition');

    Map<String, String> allHeaders = {"Content-Type": "application/json; charset=UTF-8"};
    allHeaders.addAll(getHeaders(newToken.token));
    // log.info(url);

    // log.info(data);
    final response = await httpClient.post(
      Uri.parse(url),
      body: json.encode(data),
      headers: allHeaders,
    );

    // log.info(response.body);

    if (response.statusCode == 200) {
      if (returnTypeBool) {
        return true;
      }

      return json.decode(response.body);
    }

    if (returnTypeBool) {
      return false;
    }

    return json.decode(response.body);
  }

  Future<T> update(int pk, BaseModel model) async {
    SlidingToken newToken = await getNewToken(httpClientOverride: httpClient);

    final url = await getUrl('$basePath/$pk/');
    Map<String, String> allHeaders = {"Content-Type": "application/json; charset=UTF-8"};
    allHeaders.addAll(getHeaders(newToken.token));
    // log.info('update: $url');

    final response = await httpClient.patch(
      Uri.parse(url),
      body: model.toJson(),
      headers: allHeaders,
    );

    if (response.statusCode == 200) {
      return fromJsonDetail(json.decode(response.body));
    }

    final String errorMsg = getTranslationTr('generic.exception_update', null);
    String msg = "$errorMsg (${response.body})";
    throw Exception(msg);
  }

  Future<bool> delete(int pk) async {
    SlidingToken newToken = await getNewToken(httpClientOverride: httpClient);

    final url = await getUrl('$basePath/$pk/');
    final response = await httpClient.delete(
        Uri.parse(url),
        headers: getHeaders(newToken.token)
    );
    // log.info('delete: $url');

    if (response.statusCode == 204) {
      return true;
    }

    final String errorMsg = getTranslationTr('generic.exception_delete', null);
    String msg = "$errorMsg (${response.body})";
    throw Exception(msg);
  }

  Future<SlidingToken> getNewToken({http.Client? httpClientOverride}) async {
    var client = httpClientOverride ?? httpClient;
    SlidingToken? newToken = await refreshSlidingToken(client);

    if(newToken == null) {
      log.info('newToken is null');
      throw Exception(getTranslationTr('generic.token_expired', null));
    }

    return newToken;
  }
}
