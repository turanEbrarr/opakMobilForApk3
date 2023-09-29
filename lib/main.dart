import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';



import 'package:opak_mobil_v2/controllers/tahsilatController.dart';
import 'package:opak_mobil_v2/localDB/databaseHelper.dart';
import 'package:opak_mobil_v2/widget/ctanim.dart';

import 'controllers/depoController.dart';
import 'controllers/fisController.dart';
import 'controllers/stokKartController.dart';
import 'widget/login2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper dt = DatabaseHelper();
  Ctanim.db = await dt.database();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final stokKartEx = Get.put(StokKartController());
  final fisEx = Get.put(FisController());
  final tahsilatEx = Get.put(TahsilatController());
  final turaEx = Get.put(FisController());
  final sayimEx = Get.put(SayimController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return

    GetMaterialApp(localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
     GlobalWidgetsLocalizations.delegate, //BURAYI TURAN PATLATTI SAYGILAR...
    ], supportedLocales: [
      const Locale('en', 'US'),
      const Locale('tr', 'TR'),
    ], debugShowCheckedModeBanner: false, home: LoginPage(title: "title")

        // LoginPage(title: "title")  // HomePage()

        //deneme()
        //  MyHomePage(title: " "),

        //MyHomePage(title: " "),

        );
        
  }
}
