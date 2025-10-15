import 'dart:async';
import 'package:dhis2_dart_utils/dhis2_dart_utils.dart';
import 'package:http/http.dart' as http;
import 'package:snake_app/core/constants/dhis2_connection.dart';

class Dhis2HttpService {
  HttpService? httpService;

  Dhis2HttpService({required String username, required String password}) {
    String serverUrl = Dhis2Connection.subBaseUrl.isEmpty
        ? Dhis2Connection.baseUrl
        : '${Dhis2Connection.baseUrl}/${Dhis2Connection.subBaseUrl}';
    httpService = HttpService(
      username: username,
      password: password,
      serverUrl: serverUrl,
    );
  }

  Future<http.Response> httpPost(
    String url,
    body, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await httpService!.httpPost(
      url,
      body,
      queryParameters: queryParameters,
    );
  }

  Future<http.Response> httpPut(
    String url,
    body, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await httpService!.httpPut(
      url,
      body,
      queryParameters: queryParameters,
    );
  }

  Future<http.Response> httpDelete(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await httpService!.httpDelete(url, queryParameters: queryParameters);
  }

  Future<http.Response> httpGet(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await httpService!.httpGet(url, queryParameters: queryParameters);
  }

  Future<http.Response> httpGetPagination(
    String url,
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, String?> dataQueryParameters = {
      'totalPages': 'true',
      'pageSize': '1',
      'fields': 'none',
    };
    if (queryParameters.keys.isNotEmpty) {
      dataQueryParameters.addAll(queryParameters as Map<String, String?>);
    }
    return await httpService!.httpGetPagination(url, dataQueryParameters);
  }
}
