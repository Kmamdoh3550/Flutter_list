import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:listhttp/model/coins.dart';

class HttpService {
  Future<List<CoinsSize>> getCoins() async {
    var request = http.Request(
        'GET', Uri.parse('https://api.coinbase.com/v2/currencies'));

    http.StreamedResponse response = await request.send();

    List<CoinsSize> coinsSize = [];

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final results = json.decode(body);

      for (var i = 0; i < results['data'].length; i++) {
        CoinsSize coinitem = CoinsSize(
            id: results['data'][i]['id'].toString(),
            name: results['data'][i]['name'].toString(),
            minsize: results['data'][i]['min_size'].toString());

        coinsSize.add(coinitem);
      }
    } else {}
    return coinsSize;
  }

  Future<List<CoinsSize>> getCoinsFilter(String coin) async {
    var request = http.Request(
        'GET', Uri.parse('https://api.coinbase.com/v2/currencies'));

    http.StreamedResponse response = await request.send();

    List<CoinsSize> coinsSize = [];

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final results = json.decode(body);

      for (var i = 0; i < results['data'].length; i++) {
        CoinsSize coinitem = CoinsSize(
            id: results['data'][i]['id'].toString(),
            name: results['data'][i]['name'].toString(),
            minsize: results['data'][i]['min_size'].toString());

        coinsSize.add(coinitem);
      }
    } else {}
    return coinsSize.where((element) => element.id.startsWith(coin)).toList();
  }
}
