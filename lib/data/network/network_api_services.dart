import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:depd_2024_mvvm/data/app_exception.dart';
import 'package:depd_2024_mvvm/data/network/base_api_services.dart';
import 'package:depd_2024_mvvm/shared/shared.dart';
import 'package:http/http.dart' as http;

class NetworkApiServices implements BaseApiServices {
  @override
  Future getApiResponse(String endpoint) async {
    dynamic responseJson;
    try {
      final response = await http
          .get(Uri.https(Const.baseUrl, endpoint), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'key': Const.apiKey,
      });
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network request time out!');
    }

    return responseJson;
  }

  @override
  Future postApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    try {
      final response = await http.post(
        Uri.https(Const.baseUrl, url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'key': Const.apiKey,
        },
        body: jsonEncode(data),
      );
      responseJson = returnResponse(response);
    } on SocketException {
      throw NoInternetException('No Internet connection');
    } on Exception catch (e) {
      throw FetchDataException('Unexpected error: ${e.toString()}');
    }

    return responseJson;
  }

   dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      default:
        throw FetchDataException(
            'Error occurred while communicating with server');
    }
  }

}
