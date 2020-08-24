import 'dart:io' show Platform;

import 'package:bitcoin_ticker/components/reusable_card.dart';
import 'package:bitcoin_ticker/services/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[0];
  int rate;
  List<int> rates = [];

  // get currency exchange rates
  Future<void> getCurrencyExchangeRate(String currency,
      {String crypto = 'BTC'}) async {
    rates.clear(); // clear rates
    List<int> tempRates = [];

    print('getCurrencyExchangeRate: getting currency rates...');

    List<dynamic> data =
        await NetworkHelper().getData(crypto: crypto, currency: currency);
    print(data);

    for (int i = 0; i < data.length; i++) {
      if (data[i] == null) {
        data[i]['rate'] = 0;
      }
    }

    print('start for-loop');
    for (int i = 0; i < data.length; i++) {
      var dataResult = data[i];
      print(dataResult['rate']);
      print('Data results $dataResult');
      double dbRate = dataResult['rate'];
      tempRates.add(dbRate.toInt());
    }
    print('end for-loop');

    setState(() {
      rates = tempRates;
    });
  }

  // android dropdown menu
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> currencyItems = [];
    for (String currency in currenciesList) {
      currencyItems.add(
        DropdownMenuItem(
          child: Text(currency),
          value: currency,
        ),
      );
    }

    // Instantiate dropdown button and initializes with properties
    DropdownButton<String> dropdownButton = DropdownButton(
        value: selectedCurrency,
        items: currencyItems,
        onChanged: (newCurrency) {
          setState(() async {
            selectedCurrency = newCurrency;
            print(selectedCurrency);
            await getCurrencyExchangeRate(selectedCurrency, crypto: 'BTC');
          });
        });

    return dropdownButton;
  }

  // iosPicker
  CupertinoPicker iosPicker() {
    List<Text> currencies = [];
    for (String currency in currenciesList) {
      currencies.add(Text(currency));
    }

    CupertinoPicker cupertinoPicker = CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (itemIndex) {
        setState(() {
          selectedCurrency = currenciesList[itemIndex];
          print(selectedCurrency);
        });
      },
      children: currencies,
    );

    return cupertinoPicker;
  }

  @override
  Widget build(BuildContext context) {
    getCurrencyExchangeRate('ZAR');
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: <Widget>[
              ReusableCard(
                assetBaseId: cryptoList[0],
                currencyId: selectedCurrency,
                rate: 0,
              ),
              ReusableCard(
                assetBaseId: cryptoList[1],
                currencyId: selectedCurrency,
                rate: 0,
              ),
              ReusableCard(
                assetBaseId: cryptoList[2],
                currencyId: selectedCurrency,
                rate: 0,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
