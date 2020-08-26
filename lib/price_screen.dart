import 'dart:io' show Platform;

import 'package:bitcoin_ticker/components/reusable_card.dart';
import 'package:bitcoin_ticker/model/currency_exchange.dart';
import 'package:bitcoin_ticker/model/error_handler.dart';
import 'package:bitcoin_ticker/services/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = currenciesList[0];
  int rate = 0;

  // get currency exchange rates
  Future<void> getCurrencyExchangeRate(String currency,
      {BuildContext context, String crypto = 'BTC'}) async {
    print('getCurrencyExchangeRate: getting currency rates...');

    var data =
        await NetworkHelper().getData(crypto: crypto, currency: currency);

    print('completed async task');
    print(data);

    if (data is ErrorHandler) {
      _showAlert(title: 'Error', desc: data.error, context: context);
    } else {
      if (data is CurrencyExchange) {
        setState(() {
          rate = data.rate.toInt();
        });
      } else {
        print("We have network issues!");
      }
    }
  }

  void _showAlert({String title, String desc, BuildContext context}) {
    //Alert(context: context, title: title, desc: desc).show();

    Alert(
      context: context,
      title: title,
      desc: desc,
      buttons: [
        DialogButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        )
      ],
    ).show();
  }

  // android dropdown menu
  DropdownButton<String> androidDropdown(BuildContext context) {
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
        onChanged: (newCurrency) async {
          selectedCurrency = newCurrency;
          print(selectedCurrency);
          await getCurrencyExchangeRate(selectedCurrency,
              context: context, crypto: 'BTC');
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
                rate: rate,
              ),
              ReusableCard(
                assetBaseId: cryptoList[1],
                currencyId: selectedCurrency,
                rate: rate,
              ),
              ReusableCard(
                assetBaseId: cryptoList[2],
                currencyId: selectedCurrency,
                rate: rate,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(context),
          ),
        ],
      ),
    );
  }
}
