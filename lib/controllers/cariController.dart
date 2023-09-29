import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../localDB/databaseHelper.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../main.dart';
import '../widget/ctanim.dart';
import '../widget/veriler/listeler.dart';
import '../widget/cari.dart';

class CariController extends GetxController {
  RxList<Cari> searchCariList = <Cari>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void searchCari(String query) {
    if (query.isEmpty) {
      searchCariList.assignAll(listeler.listCari);
    } else {
      var results = listeler.listCari
          .where((value) =>
              value.ADI!.toLowerCase().contains(query.toLowerCase()) ||
              value.KOD!.toLowerCase().contains(query.toLowerCase()) ||
              value.IL!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      searchCariList.assignAll(results);
    }
  }

  Future<String> servisCariGetir() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none) {
      print("internet yok");
      const snackBar = SnackBar(
        content: Text(
          'İnternet bağlantısı yok.',
          style: TextStyle(fontSize: 16),
        ),
        showCloseIcon: true,
        backgroundColor: Colors.blue,
        closeIconColor: Colors.white,
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      return 'İnternet bağlantısı yok.';
    } else {
      if (Ctanim.db == null) {
        const snackBar = SnackBar(
          content: Text(
            'Veritabanı bağlantısı başarısız.',
            style: TextStyle(fontSize: 16),
          ),
          showCloseIcon: true,
          backgroundColor: Colors.blue,
          closeIconColor: Colors.white,
        );
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
        return 'İnternet bağlantısı yok.';
      } else {
        String altHesapDon = await bs.getirCariAltHesap(sirket: Ctanim.sirket!);
        String cariDon = await bs.getirCariler(
            sirket: Ctanim.sirket!, kullaniciKodu: Ctanim.kullanici!.KOD);

        for (int i = 0; i < listeler.listCari.length; i++) {
          for (var element2 in listeler.listCariAltHesap) {
            if (listeler.listCari[i].KOD == element2.KOD) {
              listeler.listCari[i].cariAltHesaplar.add(element2);
            }
          }
        }
        if (cariDon == "" && altHesapDon == "") {
          return "";
        } else if (cariDon != "" && altHesapDon == "") {
          return cariDon;
        } else if (cariDon == "" && altHesapDon != "") {
          return altHesapDon;
        } else {
          return cariDon + " / " + altHesapDon;
        }
      }
    }
  }
}
