import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:opak_mobil_v2/faturaFis/fisHareket.dart';
import 'package:opak_mobil_v2/genel_belge.dart/genel_belge_gecmis_satis_bilgileri.dart';

import '../widget/cari.dart';
import '../widget/ctanim.dart';

///ONAY VE KDV DAHİL DEĞİŞTİ GELEN DEFAULT DEĞERLER İLE OYNANDI!
class Fis {
  int? ID = 0;
  int? TIP = 0;
  String EFATURAMI = "";
  String EARSIVMI = "";
  int? SUBEID = 0;
  int? DEPOID = 0;
  int? GIDENDEPOID = 0;
  int GIDENSUBEID = 0;
  String? CARIKOD = "";
  String? CARIADI = "";
  String? ALTHESAP = "";
  String? BELGENO = "";
  String? SERINO = "";
  String? TARIH = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String? ACIKLAMA1 = "";
  String? ACIKLAMA2 = "";
  String? ACIKLAMA3 = "";
  String? ACIKLAMA4 = "";
  String? ACIKLAMA5 = "";
  String? VADEGUNU = "";
  String? VADETARIHI = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String? KDVDAHIL = "H";
  String? DOVIZ = "";
  double? KUR = 0.0;
  double? ISK1 = 0.0;
  double ISK2 = 0.0;
  double? TOPLAM = 0.0;
  double? INDIRIM_TOPLAMI = 0.0;
  double? ARA_TOPLAM = 0.0;
  double? KDVTUTARI = 0.0;
  double? GENELTOPLAM = 0.0;
  bool? DURUM = false;
  bool? AKTARILDIMI = false;
  bool? isExpanded = false;
  List<FisHareket> fisStokListesi = [];
  Cari cariKart = Cari();
  String? UUID = "";
  String? ISLEMTIPI = "";
  String? PLASIYERKOD = "";
  int? ALTHESAPID = 0;
  String? FATURANO = "";
  String? TESLIMTARIHI = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String? SAAT = "";
  int? DOVIZID = 0;
  String? ONAY = "H";

  Fis(
      this.ID,
      this.TIP,
      this.EFATURAMI,
      this.EARSIVMI,
      this.SUBEID,
      this.DEPOID,
      this.GIDENDEPOID,
      this.GIDENSUBEID,
      this.CARIKOD,
      this.CARIADI,
      this.ALTHESAP,
      this.BELGENO,
      this.SERINO,
      this.TARIH,
      this.ACIKLAMA1,
      this.ACIKLAMA2,
      this.ACIKLAMA3,
      this.ACIKLAMA4,
      this.ACIKLAMA5,
      this.VADEGUNU,
      this.VADETARIHI,
      this.KDVDAHIL,
      this.DOVIZ,
      this.KUR,
      this.ISK1,
      this.ISK2,
      this.TOPLAM,
      this.INDIRIM_TOPLAMI,
      this.ARA_TOPLAM,
      this.KDVTUTARI,
      this.GENELTOPLAM,
      this.DURUM,
      this.AKTARILDIMI,
      this.UUID,
      this.ISLEMTIPI,
      this.PLASIYERKOD,
      this.ALTHESAPID,
      this.FATURANO,
      this.TESLIMTARIHI,
      this.SAAT,
      this.DOVIZID,
      this.ONAY,
      {this.isExpanded = false});
  Fis.empty()
      : this(
            0,
            0,
            "",
            "",
            0,
            0,
            0,
            0,
            "",
            "",
            "",
            "",
            "",
            DateFormat("yyyy-MM-dd").format(DateTime.now()),
            "",
            "",
            "",
            "",
            "",
            "",
            DateFormat("yyyy-MM-dd").format(DateTime.now()),
            "H",
            "TR",
            1,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            false,
            false,
            "",
            "",
            "",
            0,
            "",
            DateFormat("yyyy-MM-dd").format(DateTime.now()),
            "",
            0,
            "H");

  Fis.fromFis(Fis fis, List<FisHareket> fisHareket) {
    this.ID = fis.ID;
    this.TIP = fis.TIP;
    this.EFATURAMI = fis.EFATURAMI;
    this.EARSIVMI = fis.EARSIVMI;
    this.SUBEID = fis.SUBEID;
    this.DEPOID = fis.DEPOID;
    this.GIDENDEPOID = fis.GIDENDEPOID;
    this.GIDENSUBEID = fis.GIDENSUBEID;
    this.CARIKOD = fis.CARIKOD;
    this.CARIADI = fis.CARIADI;
    this.ALTHESAP = fis.ALTHESAP;
    this.BELGENO = fis.BELGENO;
    this.SERINO = fis.SERINO;
    this.TARIH = fis.TARIH;
    this.ACIKLAMA1 = fis.ACIKLAMA1;
    this.ACIKLAMA2 = fis.ACIKLAMA2;
    this.ACIKLAMA3 = fis.ACIKLAMA3;
    this.ACIKLAMA4 = fis.ACIKLAMA4;
    this.ACIKLAMA5 = fis.ACIKLAMA5;
    this.VADEGUNU = fis.VADEGUNU;
    this.VADETARIHI = fis.VADETARIHI;
    this.KDVDAHIL = fis.KDVDAHIL;
    this.DOVIZ = fis.DOVIZ;
    this.KUR = fis.KUR;
    this.ISK1 = fis.ISK1;
    this.ISK2 = fis.ISK2;
    this.TOPLAM = fis.TOPLAM;
    this.INDIRIM_TOPLAMI = fis.INDIRIM_TOPLAMI;
    this.ARA_TOPLAM = fis.ARA_TOPLAM;
    this.KDVTUTARI = fis.KDVTUTARI;
    this.GENELTOPLAM = fis.GENELTOPLAM;
    this.DURUM = fis.DURUM;
    this.AKTARILDIMI = fis.AKTARILDIMI;
    this.UUID = fis.UUID;
    this.ISLEMTIPI = fis.ISLEMTIPI;
    this.PLASIYERKOD = fis.PLASIYERKOD;
    this.ALTHESAPID = ALTHESAPID;
    this.FATURANO = fis.FATURANO;
    this.TESLIMTARIHI = fis.TESLIMTARIHI;
    this.SAAT = fis.SAAT;
    this.DOVIZID = fis.DOVIZID;
    this.ONAY = fis.ONAY;
    this.fisStokListesi = fisHareket;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["ID"] = ID;
    data['TIP'] = TIP;
    data["EFATURAMI"] = EFATURAMI;
    data["EARSIVMI"] = EARSIVMI;
    data['SUBEID'] = SUBEID;
    data['DEPOID'] = DEPOID;
    data['GIDENDEPOID'] = GIDENDEPOID;
    data['GIDENSUBEID'] = GIDENSUBEID;
    data['CARIKOD'] = CARIKOD;
    data['CARIADI'] = CARIADI;
    data['ALTHESAP'] = ALTHESAP;
    data['BELGENO'] = BELGENO;
    data['SERINO'] = SERINO;
    data['TARIH'] = TARIH;
    data['ACIKLAMA1'] = ACIKLAMA1;
    data['ACIKLAMA2'] = ACIKLAMA2;
    data['ACIKLAMA3'] = ACIKLAMA3;
    data['ACIKLAMA4'] = ACIKLAMA4;
    data['ACIKLAMA5'] = ACIKLAMA5;
    data['VADEGUNU'] = VADEGUNU;
    data['VADETARIHI'] = VADETARIHI;
    data['KDVDAHIL'] = KDVDAHIL;
    data['DOVIZ'] = DOVIZ;
    data['KUR'] = KUR;
    data['ISK1'] = ISK1;
    data['ISK2'] = ISK2;
    data['TOPLAM'] = TOPLAM;
    data['INDIRIM_TOPLAMI'] = INDIRIM_TOPLAMI;
    data['ARA_TOPLAM'] = ARA_TOPLAM;
    data['KDVTUTARI'] = KDVTUTARI;
    data['GENELTOPLAM'] = GENELTOPLAM;
    data['DURUM'] = DURUM;
    data['AKTARILDIMI'] = AKTARILDIMI;
    data['UUID'] = UUID;
    data['ISLEMTIPI'] = ISLEMTIPI;
    data['PLASIYERKOD'] = PLASIYERKOD;
    data['ALTHESAPID'] = ALTHESAPID;
    data['FATURANO'] = FATURANO;
    data['TESLIMTARIHI'] = TESLIMTARIHI;
    data['SAAT'] = SAAT;
    data['DOVIZID'] = DOVIZID;
    data['ONAY'] = ONAY;

    return data;
  }

  Map<String, dynamic> toJson2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["ID"] = ID.toString();
    data['TIP'] = TIP.toString();
    data["EFATURAMI"] = EFATURAMI.toString();
    data["EARSIVMI"] = EARSIVMI.toString();

    data['SUBEID'] = SUBEID.toString();
    data['DEPOID'] = DEPOID.toString();

    data['GIDENDEPOID'] = GIDENDEPOID.toString();
    data['GIDENSUBEID'] = GIDENSUBEID.toString();

    data['CARIKOD'] = CARIKOD.toString();
    data['CARIADI'] = CARIADI.toString();
    data['ALTHESAP'] = ALTHESAP.toString();
    data['BELGENO'] = BELGENO.toString();
    data['SERINO'] = SERINO.toString();
    data['TARIH'] = TARIH.toString();
    data['ACIKLAMA1'] = ACIKLAMA1.toString();
    data['ACIKLAMA2'] = ACIKLAMA2.toString();
    data['ACIKLAMA3'] = ACIKLAMA3.toString();
    data['ACIKLAMA4'] = ACIKLAMA4.toString();
    data['ACIKLAMA5'] = ACIKLAMA5.toString();
    data['VADEGUNU'] = VADEGUNU.toString();
    data['VADETARIHI'] = VADETARIHI.toString();
    data['KDVDAHIL'] = KDVDAHIL.toString();
    data['DOVIZ'] = DOVIZ.toString();
    data['KUR'] = KUR.toString();
    data['ISK1'] = ISK1.toString();
    data['ISK2'] = ISK2.toString();
    data['TOPLAM'] = TOPLAM.toString();
    data['INDIRIM_TOPLAMI'] = INDIRIM_TOPLAMI.toString();
    data['ARA_TOPLAM'] = ARA_TOPLAM.toString();
    data['KDVTUTARI'] = KDVTUTARI.toString();
    data['GENELTOPLAM'] = GENELTOPLAM.toString();
    data['DURUM'] = DURUM.toString();
    data['AKTARILDIMI'] = AKTARILDIMI.toString();
    data['UUID'] = UUID.toString();
    data['ISLEMTIPI'] = ISLEMTIPI.toString();
    data['PLASIYERKOD'] = PLASIYERKOD.toString();
    data['ALTHESAPID'] = ALTHESAPID.toString();
    data['FATURANO'] = FATURANO.toString();
    data['TESLIMTARIHI'] = TESLIMTARIHI.toString();
    data['SAAT'] = SAAT.toString();
    data['DOVIZID'] = DOVIZID.toString();
    data['ONAY'] = ONAY.toString();
    data['STOKLISTESI'] = fisStokListesi.map((fis1) => fis1.toJson()).toList();

    return data;
  }

  Fis.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    TIP = int.parse(json['TIP'].toString());
    EFATURAMI = json["EFATURAMI"].toString();
    EARSIVMI = json["EARSIVMI"].toString();
    SUBEID = int.parse(json['SUBEID'].toString());
    DEPOID = int.parse(json['DEPOID'].toString());
    GIDENDEPOID = int.parse(json['GIDENDEPOID'].toString());
    GIDENSUBEID = int.parse(json['GIDENSUBEID'].toString());
    CARIKOD = json['CARIKOD'];
    CARIADI = json['CARIADI'];
    ALTHESAP = json['ALTHESAP'];
    BELGENO = json['BELGENO'];
    SERINO = json['SERINO'];
    TARIH = json['TARIH'];
    ACIKLAMA1 = json['ACIKLAMA1'];
    ACIKLAMA2 = json['ACIKLAMA2'];
    ACIKLAMA3 = json['ACIKLAMA3'];
    ACIKLAMA4 = json['ACIKLAMA4'];
    ACIKLAMA5 = json['ACIKLAMA5'];
    VADEGUNU = json['VADEGUNU'];
    VADETARIHI = json['VADETARIHI'];
    KDVDAHIL = json['KDVDAHIL']; //  bool.fromEnvironment();
    DOVIZ = json['DOVIZ'];
    ISK1 = double.parse(json['ISK1'].toString());
    ISK2 = double.parse(json['ISK2'].toString());
    TOPLAM = double.parse(json['TOPLAM'].toString());
    INDIRIM_TOPLAMI = double.parse(json['INDIRIM_TOPLAMI'].toString());
    ARA_TOPLAM = double.parse(json['ARA_TOPLAM'].toString());
    KDVTUTARI = double.parse(json['KDVTUTARI'].toString());
    GENELTOPLAM = double.parse(json['GENELTOPLAM'].toString());
    DURUM = json['DURUM'] == 0 ? false : true;
    AKTARILDIMI = json['AKTARILDIMI'] == 0 ? false : true;
    KUR = double.parse(json['KUR'].toString());
    UUID = json['UUID'];
    ISLEMTIPI = json['ISLEMTIPI'];
    PLASIYERKOD = json['PLASIYERKOD'];
    FATURANO = json['FATURANO'];
    TESLIMTARIHI = json['TESLIMTARIHI'];
    SAAT = json['SAAT'];
    ALTHESAPID = int.parse(json['ALTHESAPID'].toString());
    DOVIZID = int.parse(json['DOVIZID'].toString());
    ONAY = json['ONAY'];
  }
  Fis.fromJson2(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    TIP = int.parse(json['TIP'].toString());
    EFATURAMI = json["EFATURAMI"].toString();
    EARSIVMI = json["EARSIVMI"].toString();
    SUBEID = int.parse(json['SUBEID'].toString());
    DEPOID = int.parse(json['DEPOID'].toString());
    GIDENDEPOID = int.parse(json['GIDENDEPOID'].toString());
    GIDENSUBEID = int.parse(json['GIDENSUBEID'].toString());
    CARIKOD = json['CARIKOD'];
    CARIADI = json['CARIADI'];
    ALTHESAP = json['ALTHESAP'];
    BELGENO = json['BELGENO'];
    SERINO = json['SERINO'];
    TARIH = json['TARIH'];
    ACIKLAMA1 = json['ACIKLAMA1'];
    ACIKLAMA2 = json['ACIKLAMA2'];
    ACIKLAMA3 = json['ACIKLAMA3'];
    ACIKLAMA4 = json['ACIKLAMA4'];
    ACIKLAMA5 = json['ACIKLAMA5'];
    VADEGUNU = json['VADEGUNU'];
    VADETARIHI = json['VADETARIHI'];
    KDVDAHIL = json['KDVDAHIL']; //  bool.fromEnvironment();
    DOVIZ = json['DOVIZ'];
    ISK1 = double.parse(json['ISK1'].toString());
    ISK2 = double.parse(json['ISK2'].toString());
    TOPLAM = double.parse(json['TOPLAM'].toString());
    INDIRIM_TOPLAMI = double.parse(json['INDIRIM_TOPLAMI'].toString());
    ARA_TOPLAM = double.parse(json['ARA_TOPLAM'].toString());
    KDVTUTARI = double.parse(json['KDVTUTARI'].toString());
    GENELTOPLAM = double.parse(json['GENELTOPLAM'].toString());
    DURUM = json['DURUM'] == 0 ? false : true;
    AKTARILDIMI = json['AKTARILDIMI'] == 0 ? false : true;
    UUID = json['UUID'];
    ISLEMTIPI = json['ISLEMTIPI'];
    PLASIYERKOD = json['PLASIYERKOD'];
    FATURANO = json['FATURANO'];
    TESLIMTARIHI = json['TESLIMTARIHI'];
    SAAT = json['SAAT'];
    ALTHESAPID = int.parse(json['ALTHESAPID'].toString());
    DOVIZID = int.parse(json['DOVIZID'].toString());
    ONAY = json['ONAY'];
  }
  //database fiş ekle
  Future<int?> fisEkle({required Fis fis, required String belgeTipi}) async {
    var result;
    fis.TIP = Ctanim().MapFisTip[belgeTipi];

    if (fis.ID != 0) {
      try {
        await Ctanim.db?.update("TBLFISSB", fis.toJson(),
            where: 'ID = ?',
            whereArgs: [fis.ID]).then((value) => result = value);

        for (var element in fis.fisStokListesi) {
          if (element.ID! > 0) {
            Ctanim.db?.update("TBLFISHAR", element.toJson(),
                where: "ID=?", whereArgs: [element.ID]);
          } else {
            element.ID = null;
            Ctanim.db?.insert("TBLFISHAR", element.toJson());
          }
        }

        return result;
      } on PlatformException catch (e) {
        print(e);
      }
    } else {
      print("else");
      try {
        fis.ID = null;
        if (fis.CARIKOD != "" ||
            (fis.GIDENDEPOID != 0 && fis.GIDENSUBEID != 0)) {
          result = await Ctanim.db
              ?.insert("TBLFISSB", fis.toJson())
              .then((value) => fis.ID = value);
          print("ELse:" + fis.ID.toString());
          for (var element in fis.fisStokListesi) {
            element.FIS_ID = result;
            element.ID = null;
            Ctanim.db?.insert("TBLFISHAR", element.toJson());
          }

          return result;
        }
        return result;
      } on PlatformException catch (e) {
        print(e);
      }
    }
  }

  Future<void> fisVeHareketSil(int fisId) async {
    //FisHareket idsi fiş id te eşitleri sil

    await Ctanim.db
        ?.delete("TBLFISHAR", where: "FIS_ID = ?", whereArgs: [fisId]);
    //fisleri sil
    await Ctanim.db?.delete("TBLFISSB", where: "ID = ?", whereArgs: [fisId]);
  }
}
