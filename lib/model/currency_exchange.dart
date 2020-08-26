class CurrencyExchange {
  final String time;
  final String assetIdBase;
  final String assetIdQuote;
  final double rate;

  CurrencyExchange({this.time, this.assetIdBase, this.assetIdQuote, this.rate})
      : assert(time != null),
        assert(assetIdBase != null),
        assert(assetIdQuote != null),
        assert(rate != null);

  factory CurrencyExchange.fromJson(Map<String, dynamic> map) {
    return CurrencyExchange(
        time: map['time'],
        assetIdBase: map['asset_id_base'],
        assetIdQuote: map['asset_id_quote'],
        rate: map['rate']);
  }

  String get getTime => time;
  String get getAssetIdBase => assetIdBase;
  String get getAssetIdQuote => assetIdQuote;
  double get getRate => rate;
}
