import 'dart:convert';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  dynamic rateBTC = '62780.79';
  dynamic federalCBTC = 'AUD';

  dynamic rateETH = '2292.57';
  dynamic federalCETH = 'AUD';

  dynamic rateLTC = '73.30';
  dynamic federalCLTC = 'AUD';

  List<Text>? items = [];
  List<Text> menuItems() {
    for (String str in currenciesList) {
      items!.add(Text(
        str,
        style: TextStyle(
          color: Colors.red,
          fontFamily: 'VarelaRound',
        ),
      ));
    }
    return items!;
  }

  Future getData({var federal}) async {
    String urlBTC =
        'https://rest.coinapi.io/v1/exchangerate/BTC/$federal?apikey=5BDA143F-C411-43CD-933C-EB88C9A6464E';
    http.Response responseBTC = await http.get(Uri.parse(urlBTC));
    dynamic jsonDataBTC = json.decode(responseBTC.body);

    String urlETH =
        'https://rest.coinapi.io/v1/exchangerate/ETH/$federal?apikey=5BDA143F-C411-43CD-933C-EB88C9A6464E';
    http.Response responseETH = await http.get(Uri.parse(urlETH));
    dynamic jsonDataETH = json.decode(responseETH.body);

    String urlLTC =
        'https://rest.coinapi.io/v1/exchangerate/LTC/$federal?apikey=5BDA143F-C411-43CD-933C-EB88C9A6464E';
    http.Response responseLTC = await http.get(Uri.parse(urlLTC));
    dynamic jsonDataLTC = json.decode(responseLTC.body);

    setState(() {
      federalCBTC = federal;
      double price1 = jsonDataBTC['rate']!;
      rateBTC = price1.toStringAsFixed(2);

      federalCETH = federal;
      double price2 = jsonDataETH['rate']!;
      rateETH = price2.toStringAsFixed(2);

      federalCLTC = federal;
      double price3 = jsonDataLTC['rate']!;
      rateLTC = price3.toStringAsFixed(2);
    });
  }

  String getText({var crypto}) {
    if (crypto == 'BTC') {
      return '1 $crypto = $rateBTC $federalCBTC';
    } else if (crypto == 'ETH') {
      return '1 $crypto = $rateETH $federalCETH';
    } else {
      return '1 $crypto = $rateLTC $federalCLTC';
    }
  }

  dynamic getCard({String? crypto}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Text(
            getText(crypto: crypto),
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'VarelaRound',
                color: Colors.green,
                fontWeight: FontWeight.w500),
          )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(35)),
        ),
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'Bitcoin Ticker',
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontWeight: FontWeight.w500,
              color: Colors.red,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              getCard(
                crypto: 'BTC',
              ),
              getCard(crypto: 'ETH'),
              getCard(crypto: 'LTC'),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
            ),
            padding: EdgeInsets.only(bottom: 30, top: 30),
            alignment: Alignment.center,
            height: 120,
            child: CupertinoPicker(
              backgroundColor: Colors.black,
              itemExtent: 32,
              children: menuItems(),
              onSelectedItemChanged: (selected) {
                SystemSound.play(SystemSoundType.click);
                getData(federal: items![selected].data);
              },
            ),
          ),
        ],
      ),
    );
  }
}
