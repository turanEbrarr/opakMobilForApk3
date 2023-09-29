import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class deneme extends StatefulWidget {
  const deneme({super.key});

  @override
  State<deneme> createState() => _denemeState();
}

class _denemeState extends State<deneme> {
  late StreamSubscription subscription;
  late StreamSubscription internetSubscription;
  bool hasInternet = false;
  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((_showConnectivitySnackBar) {});
        internetSubscription =  InternetConnectionChecker().onStatusChange.listen((status) { 
               final hasInternet = status == InternetConnectionStatus.connected; });
            setState(() {
              this.hasInternet = hasInternet;
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget> [
          buildInternetStatus(),
          ElevatedButton(
              onPressed: () async {
                final result = await Connectivity().checkConnectivity();
                _showConnectivitySnackBar(result);
              },
              child: Text('Check Connectivity'))
        ],
      ),
    );
  }

  void _showConnectivitySnackBar(ConnectivityResult result) {
    final hasInternet = result != ConnectivityResult.none;
    final message = hasInternet
        ? result == ConnectivityResult.mobile
            ? 'Mobile bağlısınız '
            : ' Wifi ye bağlısınız'
        : 'İnternet yok';
        

    _showSnackBar(context, message, );}


    void _showSnackBar(BuildContext context, String? message) {
      final snackBar = SnackBar(content: Text(message!));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    Column buildInternetStatus() {
      return Column( mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Connection Status", ),
          Row(
            children: [
              Icon(hasInternet ? Icons.done : Icons.error,
              ),
          //    Text(hasInternet ? 'internet var' : 'internet yok')

            ],
          )
        ],
      );
    }
  }

