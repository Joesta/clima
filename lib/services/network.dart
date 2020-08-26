import 'dart:convert';

import 'package:bitcoin_ticker/model/currency_exchange.dart';
import 'package:bitcoin_ticker/model/error_handler.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'http://rest.coinapi.io/v1/exchangerate';

class NetworkHelper {
  Future<dynamic> getData({String crypto, String currency}) async {
    print('getData: getting data....');

    print(
        'Request url $baseUrl/$crypto/$currency?apikey=${FlutterConfig.get('API_KEY')}');
    http.Response response = await http.get(
        '$baseUrl/$crypto/$currency?apikey=${FlutterConfig.get('API_KEY')}');
    int statusCode = response.statusCode;

    var body = response.body;
    if (statusCode == 200) {
      return CurrencyExchange.fromJson(jsonDecode(body));
    }

    return ErrorHandler.fromJson(jsonDecode(body));
  }
}
