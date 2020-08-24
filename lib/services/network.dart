import 'dart:convert';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'http://rest.coinapi.io/v1/exchangerate';

class NetworkHelper {
  List<dynamic> _results = [];
  var _json;

  Future<List<dynamic>> getData({String crypto, String currency}) async {
    print('getData: getting data....');

    _results.clear();
    http.Response response;

    for (int i = 0; i < cryptoList.length; i++) {
      response = await http.get(
          '$baseUrl/${cryptoList[i]}/$currency?apikey=${FlutterConfig.get('API_KEY')}');
      int statusCode = response.statusCode;

      if (statusCode == 200) {
        print(response.body);
        _json = jsonDecode(response.body);
        _results.add(json);
      } else {
        _json = jsonDecode(response.body);
        _json['rate'] = 0; // set rate to zero
        _results.add(_json);
        print('Network helper: $_results');
        print('Request failed with status code: $statusCode');
      }
    }

    return _results;
  }
}
