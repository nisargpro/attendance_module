import 'dart:convert';
import 'dart:io';

import 'package:core/custom_exception.dart';
import 'package:core/log_helper.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

import 'api_response_type.dart';

class Api {
  static const _apiLogStart = "<<<<<<<   ";
  static const _apiLogEnd = "   >>>>>>>";
  static const _apiLogUrl = "URL -> ";
  static const _apiLogHeaders = "HEADERS -> ";
  static const _apiLogRequest = "REQUEST -> ";
  static const _apiLogResponse = "RESPONSE -> ";

  IOClient get http {
    final ioc = HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return IOClient(ioc);
  }

  Future<dynamic> get(
      String url, dynamic requestModel, ApiResponseType apiResponseType,
      [String? token]) async {
    dynamic responseJson;

    logBlueText(_apiLogStart + _apiLogUrl + url + _apiLogEnd);
    Uri uri = Uri.parse(url);
    if (requestModel != null) {
      uri =
          uri.replace(queryParameters: json.decode(json.encode(requestModel)));
    }

    var headers = token == null
        ? {
            "Content-Type": "application/json",
          }
        : {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token'
          };

    final response = await http.get(uri, headers: headers);
    logGreenText(_apiLogStart + _apiLogResponse + response.body + _apiLogEnd);
    responseJson = _response(response, apiResponseType);
    return responseJson;
  }

  Future<dynamic> post(
      String url, dynamic requestModel, ApiResponseType apiResponseType,
      [String? token]) async {
    dynamic responseJson;

    logBlueText(_apiLogStart + _apiLogUrl + url + _apiLogEnd);
    var uri = Uri.parse(url);
    var headers = token == null
        ? {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          };

    logYellowText(
        _apiLogStart + _apiLogHeaders + headers.toString() + _apiLogEnd);
    var requestBody = json.encode(requestModel);
    logYellowText(_apiLogStart + _apiLogRequest + requestBody + _apiLogEnd);
    final response = await http.post(uri, headers: headers, body: requestBody);
    logGreenText(_apiLogStart +
        _apiLogResponse +
        utf8.decode(response.bodyBytes) +
        _apiLogEnd);
    responseJson = _response(response, apiResponseType);
    return responseJson;
  }

  Future<dynamic> put(
      String url, dynamic requestModel, ApiResponseType apiResponseType,
      [String? token]) async {
    dynamic responseJson;

    logBlueText(_apiLogStart + _apiLogUrl + url + _apiLogEnd);
    var uri = Uri.parse(url);
    var headers = token == null
        ? {
            "Content-Type": "application/json",
          }
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          };
    logYellowText(
        _apiLogStart + _apiLogHeaders + headers.toString() + _apiLogEnd);
    Response response;
    if (requestModel == null) {
      response = await http.put(uri, headers: headers);
      logYellowText(_apiLogStart + _apiLogRequest + _apiLogEnd);
    } else {
      var requestBody = json.encode(requestModel);
      response = await http.put(uri, headers: headers, body: requestBody);
      logYellowText(_apiLogStart + _apiLogRequest + requestBody + _apiLogEnd);
    }
    logGreenText(_apiLogStart +
        _apiLogResponse +
        utf8.decode(response.bodyBytes) +
        _apiLogEnd);
    responseJson = _response(response, apiResponseType);
    return responseJson;
  }

  dynamic _response(Response response, ApiResponseType apiResponseType) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var body = utf8.decode(response.bodyBytes);
        if (apiResponseType == ApiResponseType.json) {
          dynamic responseJson = json.decode(body.toString());
          return responseJson;
        } else {
          return body;
        }
      case 400:
        _checkApiErrors(response, apiResponseType);
        break;
      case 401:
      case 403:
        throw UnauthorisedException(response.body);
      case 500:
        throw InternalServerException(response.body.toString());
      default:
        throw FetchDataException(
            'Communication Error : ${response.statusCode}');
    }
  }

  void _checkApiErrors(Response response, ApiResponseType apiResponseType) {
    var body = utf8.decode(response.bodyBytes);
    if (apiResponseType == ApiResponseType.json) {
      dynamic responseJson = json.decode(body.toString());
      throw ApiErrorException(responseJson['message']);
    }
  }
}

class ErrorResponseModel {
  ErrorResponseModel({
    required this.accountExists,
    required this.message,
  });

  ErrorResponseModel.fromJson(final Map<String, dynamic>? json) {
    accountExists = json?['accountExists'] as bool?;
    message = json?['message'] as String?;
  }

  bool? accountExists;
  String? message;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['accountExists'] = accountExists;
    data['message'] = message;
    return data;
  }
}
