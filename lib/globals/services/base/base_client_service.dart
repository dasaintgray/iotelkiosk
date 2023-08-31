// ignore_for_file: constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iotelkiosk/globals/constant/environment_constant.dart';
import 'package:iotelkiosk/globals/services/exceptions/base_client_exception.dart';

class HenryBaseClient {
  // HenryBaseClient._();

  // final http.Client client = http.Client();
  // GLOBAL HTTP METHOD
  Future<dynamic> requestMethod(String? httpMethod, String? apiURL,
      {Map<String, String>? headers, dynamic bodyPayload}) async {
    var uriEndpoint = Uri.parse(apiURL!);
    var request = http.Request(httpMethod!, uriEndpoint);
    request.headers.addAll(headers ?? HenryGlobal.defaultHttpHeaders);

    switch (httpMethod) {
      case "GET":
        request.body = "{}";
        break;
      case "POST":
        request.body = json.encode(bodyPayload); //json.encode(bodyPayload);
        break;
      case "DELETE":
        break;
      case "PUT":
        break;
      case "PATCH":
        break;
      default:
        request.body = "{}";
        break;
    }

    try {
      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: HenryGlobal.receiveTimeOut));
      return _processStreamedResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uriEndpoint.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responding', uriEndpoint.toString());
    }
  }

  // GET
  Future<dynamic> getRequest(String baseURL, String endpoint, Map<String, String> headers, {String? queryParam}) async {
    // var ep = Uri.encodeQueryComponent(queryParam);
    // var ep = Uri.encodeQueryComponent(queryParam);
    var uriEP = queryParam == null ? Uri.parse(baseURL + endpoint) : Uri.parse(baseURL + endpoint + queryParam);

    var request = http.Request("GET", uriEP);
    // request.body = queryParam != null ? json.encode(queryParam) : "{}";
    request.headers.addAll(headers);
    try {
      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: HenryGlobal.receiveTimeOut));
      return _processStreamedResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uriEP.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responding', uriEP.toString());
    }
  }

  // POST
  Future<dynamic> postRequest(String baseURL, String endpoint, Map<String, String> bodyPayload,
      {dynamic httpHeaders}) async {
    var uriEndpoint = Uri.parse(baseURL + endpoint);
    var request = http.Request("POST", uriEndpoint);
    request.headers.addAll(httpHeaders);
    request.body = json.encode(bodyPayload);
    try {
      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: HenryGlobal.receiveTimeOut));
      return _processStreamedResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uriEndpoint.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responding', uriEndpoint.toString());
    }
  }

  // MULTIPART REQUEST
  Future<dynamic> makeFormRequest(String httpMethod, String baseUrl, String endpoint, Map<String, String> formBody,
      {Map<String, String>? headers}) async {
    final uriEP = Uri.parse(baseUrl + endpoint);
    var request = http.MultipartRequest(httpMethod, uriEP);

    request.fields.addAll(formBody);

    try {
      http.StreamedResponse response =
          await request.send().timeout(const Duration(seconds: HenryGlobal.receiveTimeOut));
      return _processStreamedResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uriEP.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responding', uriEP.toString());
    }
  }

  // UPDATE
  // DELETE

  // GLOBAL RESPONSE
  dynamic _processStreamedResponse(http.StreamedResponse response) {
    // var responseJSON = response.stream.bytesToString();
    var responseJSON = utf8.decodeStream(response.stream);
    switch (response.statusCode) {
      case 200: // READ RESPONSE
        return responseJSON;
      case 201: //CREATE, UPDATE
        return responseJSON;
      case 400:
        throw BadRequestException(responseJSON.toString(), response.request!.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(responseJSON.toString(), response.request!.url.toString());
      case 422:
        throw BadRequestException(responseJSON.toString(), response.request!.url.toString());
      case 500:
        throw BadRequestException(responseJSON.toString(), response.request!.url.toString());
      default:
        throw FetchDataException('Error occured with code \n${response.statusCode} : ${response.reasonPhrase}',
            response.request!.url.toString());
    }
  }

// ----------------------------------------------------------------------------------
// OTHER METHOD OF HTTP REQUEST
  // POST
  Future<dynamic> post(String baseURL, String endpoint, dynamic objPayload, dynamic httpHeaders) async {
    var uriEndpoint = Uri.parse(baseURL + endpoint);
    var payload = json.encode(objPayload);
    try {
      var response = await http
          .post(uriEndpoint, body: payload, headers: httpHeaders)
          .timeout(const Duration(seconds: HenryGlobal.receiveTimeOut));
      // var response = await dio
      //     .post(baseURL + endpoint, data: payload)
      //     .timeout(const Duration(seconds: HenryGlobal.receiveTimeOut));
      return _processReponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uriEndpoint.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responding', uriEndpoint.toString());
    }
  }

  // GET
  Future<dynamic> getv1(String baseURL, String endpoint, Map<String, String> httpHeaders) async {
    var uri = baseURL + endpoint;
    var encoded = Uri.encodeFull(uri);
    // var uriEP = Uri.parse(baseURL + endpoint);
    // assert(encoded == uri);
    var decoded = Uri.decodeFull(encoded);
    assert(uri == decoded);

    var uriEP = Uri.parse(decoded);

    try {
      var response =
          await http.get(uriEP, headers: httpHeaders).timeout(const Duration(seconds: HenryGlobal.receiveTimeOut));
      return _processReponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection', uriEP.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responding', uriEP.toString());
    }
  }

  Future<dynamic> get(String baseURL, String endpoint, Map<String, String> httpHeaders, {dynamic queryParam}) async {
    // var uri = Uri.https(baseURL, endpoint);
    var uri = Uri.parse(baseURL + endpoint);
    debugPrint(uri.toString());
    debugPrint(uri.queryParameters.toString());
    debugPrint(uri.scheme);
    debugPrint(uri.host);
    debugPrint(uri.path);
    debugPrint(uri.userInfo);
    debugPrint(uri.pathSegments.toString());
    var response =
        await http.get(uri, headers: httpHeaders).timeout(const Duration(seconds: HenryGlobal.connectionTimeOut));
    // var response = await http.get(url);
    return _processReponse(response);
  }

  // GLOBAL PROCESS RESPONSE
  dynamic _processReponse(http.Response response) {
    switch (response.statusCode) {
      case 200: // READ RESPONSE
        var responseJSON = utf8.decode(response.bodyBytes);
        return responseJSON;
      case 201: //CREATE, UPDATE
        var responseJSON = utf8.decode(response.bodyBytes);
        return responseJSON;
      case 400:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:
      case 403:
        throw UnAuthorizedException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 422:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException('Error occured with code : ${response.statusCode}', response.request!.url.toString());
    }
  }

  // HARDWARE COMMUNICATION
}
