import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mygallerybook/core/app_constants.dart';
import 'package:mygallerybook/core/app_exceptions.dart';

import 'app_storage.dart';

class BaseClient {
  BaseClient._();

  static int timeOutDuration = 20;
  static final appStorage = Get.find<AppStorage>();

  static Map<String, String> requestHeaders() {
    return <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      // 'Authorization': 'Bearer ${appStorage.loggedInUser?.token}'
    };
  }

  static String get backendUrl {
    final appStorage = Get.find<AppStorage>();
    String result =
        (appStorage.read("baseUrl") as String?) ?? AppConstants.baseUrl;
    return result.endsWith("/") ? result : "$result/";
  }

  static set backendUrl(String? url) {
    final appStorage = Get.find<AppStorage>();
    appStorage.write("baseUrl", url);
  }

  //GET
  static Future<dynamic> get({required String endPoint}) async {
    const baseUrl = "http://mygallerybook.com/";
    final uri = Uri.parse(baseUrl + endPoint);
    try {
      final response = await http.get(uri, headers: {
        "Authorization": "059D87FB2EA6EFAE"
      }).timeout(Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        'Socket Exception',
        uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API Timed out',
        uri.toString(),
      );
    }
  }

  //POST
  static Future<dynamic> post({
    required dynamic headers,
    required String endPoint,
    required dynamic payloadObj,
    bool isEncoded = true,
  }) async {
    const baseURL = "http://mygallerybook.com/";
    final uri = Uri.parse(baseURL + endPoint);
    final payload = isEncoded ? json.encode(payloadObj) : payloadObj;
    try {
      final response = await http
          .post(uri, headers: headers, body: payload)
          .timeout(Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        'Socket Exception',
        uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API Timed out',
        uri.toString(),
      );
    }
  }

  //POST-FOR-LOGIN
  static Future<dynamic> postForLogin({
    required String endPoint,
    required dynamic header,
    required String backendUrl,
  }) async {
    //   final packageInfo = await PackageInfo.fromPlatform();
    // final uri = Uri.parse(AppURL.authenticationBaseURL + endPoint);
    final uri = Uri.parse(backendUrl + endPoint);

    try {
      final response = await http
          .post(
            uri,
            headers: header as Map<String, String>?,
            body: json.encode({}),
          )
          .timeout(Duration(seconds: timeOutDuration));

      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        'Socket Exception',
        uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API Timed out',
        uri.toString(),
      );
    }
  }

  //PUT
  static Future<dynamic> put({
    required String endPoint,
    required dynamic payloadObj,
  }) async {
    final uri = Uri.parse(backendUrl + endPoint);
    final payload = json.encode(payloadObj);
    try {
      final response = await http
          .put(uri, headers: requestHeaders(), body: payload)
          .timeout(Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        'Socket Exception',
        uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API Timed out',
        uri.toString(),
      );
    }
  }

  //PATCH
  static Future<dynamic> patch({
    required String endPoint,
    required dynamic payloadObj,
  }) async {
    final uri = Uri.parse(backendUrl + endPoint);
    final payload = json.encode(payloadObj);
    try {
      final response = await http
          .patch(uri, headers: requestHeaders(), body: payload)
          .timeout(Duration(seconds: timeOutDuration));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        'Socket Exception',
        uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API Timed out',
        uri.toString(),
      );
    }
  }

  static final _emptyResponse = <String, dynamic>{};

  static dynamic _processResponse(http.Response response) {
    final url = response.request!.url.toString();
    if (kDebugMode) {
      print(response.request?.url.toString());
      print(response.body);
      print(response.reasonPhrase);
    }
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 204:
        return _emptyResponse;
      case 400:
        throw BadRequestException('Something went wrong', url);
      case 403:
        throw UnAuthorizedException('Something went wrong', url);
      case 404:
        throw ResourceNotFoundException('Something went wrong', url);
      case 422:
        throw BadRequestException('Something went wrong', url);
      case 429:
        throw RateLimitException('Something went wrong', url);
      case 500:
        throw ServerErrorException('Something went wrong', url);
      default:
        throw FetchDataException('Something went wrong', url);
    }
  }
}
