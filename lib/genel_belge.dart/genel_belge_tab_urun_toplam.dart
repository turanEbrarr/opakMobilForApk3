//import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:opak_mobil_v2/localDB/veritabaniIslemleri.dart';
import 'package:opak_mobil_v2/webservis/base.dart';
import 'package:opak_mobil_v2/webservis/kurModel.dart';
import 'package:opak_mobil_v2/widget/cariAltHesap.dart';
import 'package:opak_mobil_v2/widget/ctanim.dart';
import 'package:opak_mobil_v2/widget/customAlertDialog.dart';
import 'package:opak_mobil_v2/widget/main_page.dart';
import 'package:opak_mobil_v2/widget/modeller/logModel.dart';
import 'package:opak_mobil_v2/widget/veriler/listeler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/fisController.dart';
import '../faturaFis/fis.dart';
import '../stok_kart/Spinkit.dart';
import '../widget/modeller/sHataModel.dart';
import '../widget/modeller/sharedPreferences.dart';
import 'genel_belge_pdf_onizleme.dart';

class genel_belge_tab_urun_toplam extends StatefulWidget {
  const genel_belge_tab_urun_toplam({
    super.key,
    required this.belgeTipi,
  });
  final String belgeTipi;
  @override
  State<genel_belge_tab_urun_toplam> createState() =>
      _genel_belge_tab_urun_toplamState();
}

class _genel_belge_tab_urun_toplamState
    extends State<genel_belge_tab_urun_toplam> {
  BaseService bs = BaseService();
  bool tamamaBastiMi = false;
  int vadeGunuFlag = 0;
  late DateTime vade_tarihi;
  late DateTime soz_tarihi = DateTime.now();
  bool? ischecked = false;
  final FisController fisEx = Get.find();
  List<String> para_birim = [];
  List<double> para_kur = [];
  String? seciliParaBirimi = "";
  bool gen1Bas = false;
  bool gen2Bas = false;
  TextEditingController vadeGunuController = TextEditingController();
  TextEditingController genelIskonto1Controller = TextEditingController();
  TextEditingController genelIskonto2Controller = TextEditingController();
  TextEditingController kurController = TextEditingController();
  TextEditingController aciklama1Controller = TextEditingController();
  TextEditingController aciklama2Controller = TextEditingController();
  TextEditingController aciklama3Controller = TextEditingController();
  TextEditingController aciklama4Controller = TextEditingController();
  TextEditingController aciklama5Controller = TextEditingController();
  TextEditingController aciklama6Controller = TextEditingController();
  TextEditingController depoController = TextEditingController();
  TextEditingController subeController = TextEditingController();

  //TextEditingController ozelKod1Controller = TextEditingController();
  //TextEditingController ozelKod2Controller = TextEditingController();

  /*InputDecoration decoration = const InputDecoration(
   contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
  labelStyle: TextStyle(fontSize: 12),
);*/

  hesapla({DateTime? fisTarihi, DateTime? vadeTarihi, int? vadeGunu}) {
    if (fisTarihi != null) {
      vadeGunu = 0;
      vadeGunuController.text = vadeGunu.toString();
      vadeTarihi = vade_tarihi;
      vade_tarihi = DateTime.now();
      fisEx.fis!.value.VADETARIHI =
          DateFormat('yyyy-MM-dd').format(vade_tarihi);
    } else if (vadeGunu != null) {
      vadeGunu = vadeGunu;
      vade_tarihi = fisEx.fis_tarihi.add(Duration(days: vadeGunu));
      fisEx.fis!.value.VADEGUNU = vadeGunu.toString();
      fisEx.fis!.value.VADETARIHI =
          DateFormat('yyyy-MM-dd').format(vade_tarihi);
    } else if (vadeTarihi != null) {
      final gunFark = vadeTarihi.difference(fisEx.fis_tarihi).inDays;
      vadeGunuController.text = gunFark.toString();
      fisEx.fis!.value.VADETARIHI =
          DateFormat('yyyy-MM-dd').format(vade_tarihi);
      fisEx.fis!.value.VADEGUNU = vadeGunuController.text;
    } else {
      AlertDialog(title: Text("Lütfen doğru parametreleri girin."));
    }
  }

  List<CariAltHesap> altHesaplar = [];
  CariAltHesap? selectedAltHesap;
  KurModel? altHesaptanGelen;
  bool KDVDAHIL = false;
  Color KDVDahil = Colors.black;
  @override
  void initState() {
    super.initState();

    String? cariKod = fisEx.fis!.value.CARIKOD;
    for (var element in listeler.listCariAltHesap) {
      if (element.KOD == cariKod) {
        altHesaplar.add(element);
      }
    }
    if (altHesaplar.isNotEmpty) {
      selectedAltHesap = altHesaplar.first;
      fisEx.fis!.value.ALTHESAP = altHesaplar.first.ALTHESAP;
      for (var element in listeler.listKur) {
        if (element.ID == altHesaplar.first.DOVIZID) {
          setState(() {
            altHesaptanGelen = element;
            kurController.text = altHesaptanGelen!.KUR.toString();
          });
        }
      }
      fisEx.fis!.value.DOVIZ = altHesaptanGelen!.ACIKLAMA;
      fisEx.fis!.value.KUR = altHesaptanGelen!.KUR;
      fisEx.fis!.value.DOVIZID = altHesaptanGelen!.ID;

      Ctanim.genelToplamHesapla(fisEx);
    }

    if (widget.belgeTipi == "Alinan_Siparis" ||
        widget.belgeTipi == "Musteri_Siparis") {
      if (Ctanim.kullanici!.SIPKDV == "E") {
        KDVDAHIL = true;
        Ctanim.KDVDahilMiDinamik = KDVDAHIL;
      } else {
        KDVDAHIL = false;
        Ctanim.KDVDahilMiDinamik = KDVDAHIL;
      }
    }
    if (widget.belgeTipi == "Satis_Teklif") {
      if (Ctanim.kullanici!.SATISTEKLIFKDV == "E") {
        KDVDAHIL = true;
        Ctanim.KDVDahilMiDinamik = KDVDAHIL;
      } else {
        KDVDAHIL = false;
        Ctanim.KDVDahilMiDinamik = KDVDAHIL;
      }
    }
    if (widget.belgeTipi == "Perakende_Satis") {
      if (Ctanim.kullanici!.PERSATKDV == "E") {
        KDVDAHIL = true;
        Ctanim.KDVDahilMiDinamik = KDVDAHIL;
      } else {
        KDVDAHIL = false;
        Ctanim.KDVDahilMiDinamik = KDVDAHIL;
      }
    }
    if (widget.belgeTipi == "Satis_Fatura") {
      if (Ctanim.kullanici!.FATKDV == "E") {
        KDVDAHIL = true;
        Ctanim.KDVDahilMiDinamik = KDVDAHIL;
      } else {
        KDVDAHIL = false;
        Ctanim.KDVDahilMiDinamik = KDVDAHIL;
      }
    }
    if (widget.belgeTipi == "Satis_Irsaliye") {
      if (Ctanim.kullanici!.SATIRSKDV == "E") {
        KDVDAHIL = true;
        Ctanim.KDVDahilMiDinamik = KDVDAHIL;
      } else {
        KDVDAHIL = false;
        Ctanim.KDVDahilMiDinamik = KDVDAHIL;
      }
    }
    if (widget.belgeTipi == "Alis_Irsaliye") {
      if (Ctanim.kullanici!.ALIRSKDV == "E") {
        KDVDAHIL = true;
        Ctanim.KDVDahilMiDinamik = KDVDAHIL;
      } else {
        KDVDAHIL = false;
        Ctanim.KDVDahilMiDinamik = KDVDAHIL;
      }
    }
    if (Ctanim.KDVDahilMiDinamik == true) {
      KDVDahil = Colors.green;
    } else {
      KDVDahil = Colors.red;
    }
    setState(() {});
    Ctanim.genelToplamHesapla(fisEx);
    fisEx.fis_tarihi = DateTime.parse(fisEx.fis!.value.TARIH!);
    vade_tarihi = DateTime.parse(fisEx.fis!.value.VADETARIHI!);
    String? vadeGunu =
        fisEx.fis?.value.VADEGUNU == "" ? "0" : fisEx.fis?.value.VADEGUNU!;
    vadeGunuController.text = vadeGunu!;

    for (var element in listeler.listKur) {
      para_birim.add(element.ACIKLAMA!);
      para_kur.add(element.KUR!);
    }

    seciliParaBirimi = fisEx.fis!.value.DOVIZ;
    kurController.text = fisEx.fis!.value.KUR.toString();
    for (var element in listeler.listSubeDepoModel) {
      if (Ctanim.kullanici!.YERELDEPOID == element.DEPOID.toString()) {
        depoController.text = element.DEPOADI!;
      }
      if (Ctanim.kullanici!.YERELSUBEID == element.SUBEID.toString()) {
        subeController.text = element.SUBEADI!;
      }
      if (depoController.text == "") {
        depoController.text = "Uygun Depo Yok";
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //fisEx.fis!.value.TESLIMTARIHI = soz_tarihi.toString();

    fisEx.fis!.value.ALTHESAPID = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Fatura Düzenlemeleri",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 0, left: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Alt Hesap Seçimi :",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .80,
                  height: MediaQuery.of(context).size.height / 15,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<CariAltHesap>(
                        value: selectedAltHesap,
                        items: altHesaplar.map((CariAltHesap banka) {
                          return DropdownMenuItem<CariAltHesap>(
                            value: banka,
                            child: Text(
                              banka.ALTHESAP ?? "",
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (CariAltHesap? selected) {
                          setState(() {
                            selectedAltHesap = selected;
                          });
                          fisEx.fis!.value.ALTHESAP = selected!.ALTHESAP;
                          for (var element in listeler.listKur) {
                            if (element.ID == selected.DOVIZID) {
                              setState(() {
                                altHesaptanGelen = element;
                                kurController.text =
                                    altHesaptanGelen!.KUR.toString();
                              });
                            }
                          }
                          fisEx.fis!.value.DOVIZ = altHesaptanGelen!.ACIKLAMA;
                          fisEx.fis!.value.KUR = altHesaptanGelen!.KUR;
                          fisEx.fis!.value.DOVIZID = altHesaptanGelen!.ID;
                          Ctanim.genelToplamHesapla(fisEx);
                        },
                      ),
                    ),
                    /* DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedAltHesap,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedAltHesap = newValue!;
                              fisEx.fis!.value.ALTHESAP = selectedAltHesap;
                            });
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: '',
                              child: Text("NORMAL"),
                            ),
                            ...altHesaplar.map((String altHesap) {
                              return DropdownMenuItem<String>(
                                value: altHesap,
                                child: Text(altHesap),
                              );
                            }).toList(),
                          ],
                        ),
                      )
                      */
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .9,
                  height: MediaQuery.of(context).size.height / 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * .4,
                          child: Row(
                            children: [
                              Text("Döviz Tipi : "),
                              Text(altHesaptanGelen!.ACIKLAMA == null ||
                                      altHesaptanGelen!.ACIKLAMA == ""
                                  ? "HATA"
                                  : altHesaptanGelen!.ACIKLAMA.toString())

/*
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                    value: seciliParaBirimi,
                                    items: para_birim
                                        .map((e) => DropdownMenuItem<String>(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (e) {
                                      double tempKur = 0.0;
                                      int tempID = 0;
                                      print(e);
                                      setState(() {
                                        for (int i = 0;
                                            i < listeler.listKur.length;
                                            i++) {
                                          if (e ==
                                              listeler.listKur[i].ACIKLAMA) {
                                            kurController.text = listeler
                                                .listKur[i].KUR
                                                .toString();
                                            tempKur = listeler.listKur[i].KUR!;
                                            tempID = listeler.listKur[i].ID!;
                                          }
                                        }
                                        seciliParaBirimi = e;
                                      });
                                      fisEx.fis!.value.DOVIZ = seciliParaBirimi;
                                      fisEx.fis!.value.KUR = tempKur;
                                      fisEx.fis!.value.DOVIZID = tempID;
                                      Ctanim.genelToplamHesapla(fisEx);
                                    }),
                              ),
                              */
                            ],
                          )),
                      VerticalDivider(
                        thickness: 1,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 247, 245, 245),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextFormField(
                            controller: kurController,
                            cursorColor: Color.fromARGB(255, 60, 59, 59),
                            decoration: InputDecoration(
                                label: Text(
                                  "Kur Giriniz:",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 60, 59, 59),
                                      fontSize: 15),
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
            ),
            CheckboxListTile(
              title: Text(
                "KDV DAHİL",
                style: TextStyle(color: KDVDahil),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              value: KDVDAHIL,
              onChanged: (value) {
                setState(() {
                  KDVDAHIL = value!;
                  Ctanim.KDVDahilMiDinamik = KDVDAHIL;
                  if (value == true) {
                    KDVDahil = Colors.green;
                  } else {
                    KDVDahil = Colors.red;
                  }
                  setState(() {});
                  /*
                  asd
                  KDVDahilMiKaydet(value).then((value) {
                    print("Kaydedilen Değer:" +
                        Ctanim.KDVDahilMiDinamik.toString());
                  });
                  */

                  Ctanim.genelToplamHesapla(fisEx);
                });
              },
            ),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 80,
                  padding: EdgeInsets.all(
                      8.0), // İstediğiniz padding değerini belirleyin
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 247, 245, 245),
                    // Kenarlık rengini ve kalınlığını ayarlayın
                    borderRadius:
                        BorderRadius.circular(5), // Köşe yarıçapını ayarlayın
                  ),
                  child: Ctanim.kullanici!.GISK1 == "E"
                      ? TextFormField(
                          controller: genelIskonto1Controller,
                          onTap: () {
                            setState(() {
                              gen1Bas = true;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value == "") {
                                fisEx.fis!.value.ISK1 = 0.0;
                                Ctanim.genelToplamHesapla(fisEx);
                                setState(() {});
                              }
                              fisEx.fis!.value.ISK1 =
                                  Ctanim.noktadanSonraAlinacak(double.parse(
                                      genelIskonto1Controller.text));
                              Ctanim.genelToplamHesapla(fisEx);
                            });
                          },
                          cursorColor: Color.fromARGB(255, 60, 59, 59),
                          decoration: InputDecoration(
                              label: Text(
                                fisEx.fis!.value.ISK1 == 0.0
                                    ? "Genel İskonto1 Giriniz : "
                                    : gen1Bas == true
                                        ? "Yapılan Birinci İskonto Tutarı: " +
                                            "%" +
                                            fisEx.fis!.value.ISK1.toString()
                                        : fisEx.fis!.value.ISK1.toString(),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 60, 59, 59),
                                    fontSize: 15),
                              ),
                              border: InputBorder.none),
                        )
                      : Container()),
            ),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 80,
                  padding: EdgeInsets.all(
                      8.0), // İstediğiniz padding değerini belirleyin
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 247, 245, 245),
                    // Kenarlık rengini ve kalınlığını ayarlayın
                    borderRadius:
                        BorderRadius.circular(5), // Köşe yarıçapını ayarlayın
                  ),
                  child: Ctanim.kullanici!.GISK2 == "E"
                      ? TextFormField(
                          controller: genelIskonto2Controller,
                          onTap: () {
                            setState(() {
                              gen2Bas = true;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              if (value == "") {
                                fisEx.fis!.value.ISK2 = 0.0;
                                Ctanim.genelToplamHesapla(fisEx);
                                setState(() {});
                              }
                              fisEx.fis!.value.ISK2 =
                                  Ctanim.noktadanSonraAlinacak(double.parse(
                                      genelIskonto2Controller.text));
                              Ctanim.genelToplamHesapla(fisEx);
                            });
                          },
                          cursorColor: Color.fromARGB(255, 60, 59, 59),
                          decoration: InputDecoration(
                              label: Text(
                                fisEx.fis!.value.ISK1 == 0.0
                                    ? "Genel İskonto2 Giriniz : "
                                    : gen2Bas == true
                                        ? "Yapılan İkinci İskonto Tutarı: " +
                                            "%" +
                                            fisEx.fis!.value.ISK2.toString()
                                        : fisEx.fis!.value.ISK2.toString(),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 60, 59, 59),
                                    fontSize: 15),
                              ),
                              border: InputBorder.none),
                        )
                      : Container()),
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text(
                            "ÜRÜN TOPLAMI      :",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                            Ctanim.donusturMusteri(
                                fisEx.fis!.value.TOPLAM!.toString()),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text("İNDİRİM TOPLAMI : ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                              Ctanim.donusturMusteri(
                                  fisEx.fis!.value.INDIRIM_TOPLAMI!.toString()),
                              textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text("ARA TOPLAMI        :",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                              Ctanim.donusturMusteri(
                                  fisEx.fis!.value.ARA_TOPLAM!.toString()),
                              textAlign: TextAlign.end),
                        ), //araToplam.toString()
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text("KDV TUTARI            :",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                              Ctanim.donusturMusteri(
                                  fisEx.fis!.value.KDVTUTARI!.toString()),
                              textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text("GENEL TOPLAMI    :",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .3,
                          child: Text(
                              Ctanim.donusturMusteri(
                                  fisEx.fis!.value.GENELTOPLAM!.toString()),
                              textAlign: TextAlign.end),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Text("DÖVİZ TOPLAMI     :",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ), // DEĞER EKLENECEK LİSTEDEN
                  ],
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 8, left: 8, bottom: 8, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Fatura Detayları",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .90,
              height: MediaQuery.of(context).size.height / 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: TextFormField(
                      controller: subeController,
                      readOnly: true,
                      cursorColor: Color.fromARGB(255, 60, 59, 59),
                      decoration: InputDecoration(
                          label: Text(
                            "Şube:",
                            style: TextStyle(
                                color: Color.fromARGB(255, 60, 59, 59),
                                fontSize: 15),
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                  VerticalDivider(
                    thickness: 1,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .3,
                    child: TextFormField(
                      controller: depoController,
                      readOnly: true,
                      cursorColor: Color.fromARGB(255, 60, 59, 59),
                      decoration: InputDecoration(
                          label: Text(
                            "Depo:",
                            style: TextStyle(
                                color: Color.fromARGB(255, 60, 59, 59),
                                fontSize: 15),
                          ),
                          border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: 100,
                      child: Text("FİŞ TARİHİ",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .15,
                ),
                ElevatedButton(
                  child:
                      Text(DateFormat("yyyy-MM-dd").format(fisEx.fis_tarihi)),
                  onPressed: () async {
                    DateTime? date = await pickDate();

                    if (date == null) {
                      return;
                    } else if (date.isBefore(DateTime.now())) {
                      date = DateTime.now();

                      await showDialog(
                        context: context,
                        builder: (context) {
                          return CustomAlertDialog(
                            align: TextAlign.left,
                            title: 'Hata',
                            message: 'Geçmiş Tarihli Belgeye İşlem Yapılamaz',
                            onPres: () {
                              Navigator.pop(context);
                            },
                            buttonText: 'Geri',
                          );
                        },
                      );
                    }
                    setState(() {
                      fisEx.fis_tarihi = date!;

                      fisEx.fis!.value.TARIH =
                          DateFormat('yyyy-MM-dd').format(fisEx.fis_tarihi);
                      hesapla(fisTarihi: fisEx.fis_tarihi);
                    });
                  },
                ),
              ],
            ),
            Divider(
              thickness: 1,
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: 100,
                      child: Text("VADE TARİHİ ",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .15,
                ),
                ElevatedButton(
                    child:
                        Text("${DateFormat("yyyy-MM-dd").format(vade_tarihi)}"),
                    onPressed: () async {
                      DateTime? date = await pickDate();
                      if (date == null) {
                        return;
                      } else if (date.isBefore(DateTime.now())) {
                        date = DateTime.now();

                        await showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              align: TextAlign.left,
                              title: 'Hata',
                              message: 'Geçmiş Tarihli Belgeye İşlem Yapılamaz',
                              onPres: () {
                                Navigator.pop(context);
                              },
                              buttonText: 'Geri',
                            );
                          },
                        );
                      }
                      setState(() {
                        vade_tarihi = date!;
                        vadeGunuFlag = 1;
                        hesapla(vadeTarihi: vade_tarihi);
                        /*      
                           vadeGunuController.text=vadeGunuHEsapla(vade_tarihi, fisEx.fis_tarihi);
                           fisEx.fis!.value.VADETARIHI = DateFormat('yyyy-MM-dd').format(vade_tarihi);
                           fisEx.fis!.value.VADEGUNU=vadeGunuController.text;
                        */
                      });
                    }),
              ],
            ),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 65,
                  padding: EdgeInsets.all(
                      8.0), // İstediğiniz padding değerini belirleyin
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 247, 245, 245),
                    // Kenarlık rengini ve kalınlığını ayarlayın
                    borderRadius:
                        BorderRadius.circular(5), // Köşe yarıçapını ayarlayın
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: vadeGunuController,
                    onChanged: (value) {
                      fisEx.fis!.value.VADEGUNU = vadeGunuController.text;
                      vadeGunuFlag = 1;
                      setState(() {
                        hesapla(vadeGunu: int.parse(vadeGunuController.text));
                      });
                    },
                    cursorColor: Color.fromARGB(255, 60, 59, 59),
                    decoration: InputDecoration(
                        label: Text(
                          "Vade Günü Giriniz",
                          style: TextStyle(
                              color: Color.fromARGB(255, 60, 59, 59),
                              fontSize: 15),
                        ),
                        border: InputBorder.none),
                  )),
            ),
            Divider(
              thickness: 1,
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: 100,
                      child: Text("SEVK/TES. TARİHİ ",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .15,
                ),
                ElevatedButton(
                    child:
                        Text("${DateFormat("yyyy-MM-dd").format(soz_tarihi)}"),
                    onPressed: () async {
                      DateTime? date = await pickDate();
                      if (date == null) {
                        return;
                      } else if (date.isBefore(DateTime.now())) {
                        date = DateTime.now();

                        await showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              align: TextAlign.left,
                              title: 'Hata',
                              message: 'Geçmiş Tarihli Belgeye İşlem Yapılamaz',
                              onPres: () {
                                Navigator.pop(context);
                              },
                              buttonText: 'Geri',
                            );
                          },
                        );
                      }
                      setState(() {
                        soz_tarihi = date!;
                        // String son = soz_tarihi.year.toString() +
                        "-" +
                            soz_tarihi.month.toString() +
                            "-" +
                            soz_tarihi.day.toString();
                        fisEx.fis!.value.TESLIMTARIHI =
                            DateFormat('yyyy-MM-dd').format(soz_tarihi);
                        /*  
                        hesapla(vadeTarihi: soz_tarihi);
                         vadeGunuController.text=vadeGunuHEsapla(vade_tarihi, fisEx.fis_tarihi);
                           fisEx.fis!.value.VADETARIHI = DateFormat('yyyy-MM-dd').format(vade_tarihi);
                           fisEx.fis!.value.VADEGUNU=vadeGunuController.text;
                        */
                      });
                    }),
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 8, left: 8, bottom: 8, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Açıklama Ve Özel Kodlar",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Satir(labelText: "AÇIKLAMA 1"),
            Divider(
              thickness: 1,
            ),
            Satir(labelText: "AÇIKLAMA 2"),
            Divider(
              thickness: 1,
            ),
            Satir(labelText: "AÇIKLAMA 3"),
            Divider(
              thickness: 1,
            ),
            Satir(labelText: "AÇIKLAMA 4"),
            Divider(
              thickness: 1,
            ),
            Satir(labelText: "AÇIKLAMA 5"),
            Divider(
              thickness: 1,
            ),
            Satir(labelText: "ÖZEL KOD 1"),
            Divider(
              thickness: 1,
            ),
            Satir(labelText: "ÖZEL KOD 2"),
            Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.save),
        onPressed: () async {
          if (fisEx.fis!.value.fisStokListesi.length != 0) {
            Fis fiss = fisEx.fis!.value;
            if (widget.belgeTipi == "Satis_Fatura") {
              if (Ctanim.kullanici!.EFATURA == "E") {
                if (fisEx.fis!.value.cariKart.EFATURAMI == true) {
                  fisEx.fis!.value.EFATURAMI = "E";
                  fisEx.fis!.value.EARSIVMI = "H";
                  fisEx.fis!.value.SERINO = Ctanim.kullanici!.EFATURASERINO!;
                  fisEx.fis!.value.BELGENO = Ctanim.eFaturaNumarasi.toString();
                  fisEx.fis!.value.FATURANO = Ctanim.eFaturaNumarasi.toString();
                  Ctanim.eFaturaNumarasi = Ctanim.eFaturaNumarasi + 1;
                  await SharedPrefsHelper.efaturaNumarasiKaydet(
                      Ctanim.eFaturaNumarasi);
                } else {
                  fisEx.fis!.value.EFATURAMI = "H";
                  fisEx.fis!.value.EARSIVMI = "E";
                  fisEx.fis!.value.SERINO = Ctanim.kullanici!.EARSIVSERINO!;
                  fisEx.fis!.value.BELGENO = Ctanim.eArsivNumarasi.toString();
                  // cari efatura değil
                  fisEx.fis!.value.FATURANO = Ctanim.eArsivNumarasi.toString();
                  Ctanim.eArsivNumarasi = Ctanim.eArsivNumarasi + 1;
                  await SharedPrefsHelper.eArsivNumarasiKaydet(
                      Ctanim.eArsivNumarasi);
                }
              } else {
                // kullanıcı eftura değil
                fisEx.fis!.value.EFATURAMI = "H";
                fisEx.fis!.value.EARSIVMI = "H";
                fisEx.fis!.value.SERINO = Ctanim.kullanici!.FATURASERISERINO!;
                fisEx.fis!.value.BELGENO = Ctanim.faturaNumarasi.toString();
                fisEx.fis!.value.FATURANO = Ctanim.faturaNumarasi.toString();
                Ctanim.faturaNumarasi = Ctanim.faturaNumarasi + 1;
                await SharedPrefsHelper.faturaNumarasiKaydet(
                    Ctanim.faturaNumarasi);
              }
            }

            if (widget.belgeTipi == "Satis_Irsaliye") {
              if (Ctanim.kullanici!.EIRSALIYE == "E") {
                fisEx.fis!.value.BELGENO = Ctanim.eirsaliyeNumarasi.toString();
                fisEx.fis!.value.SERINO = Ctanim.kullanici!.EIRSALIYESERINO!;
                fisEx.fis!.value.FATURANO = Ctanim.eirsaliyeNumarasi.toString();
                Ctanim.eirsaliyeNumarasi = Ctanim.eirsaliyeNumarasi + 1;
                await SharedPrefsHelper.eirsaliyeNumarasiKaydet(
                    Ctanim.eirsaliyeNumarasi);
              } else {
                // kullanıcı eftura değil
                fisEx.fis!.value.SERINO = Ctanim.kullanici!.IRSALIYESERISERINO!;
                fisEx.fis!.value.BELGENO = Ctanim.irsaliyeNumarasi.toString();
                fisEx.fis!.value.FATURANO = Ctanim.irsaliyeNumarasi.toString();
                Ctanim.irsaliyeNumarasi = Ctanim.irsaliyeNumarasi + 1;
                await SharedPrefsHelper.faturaNumarasiKaydet(
                    Ctanim.irsaliyeNumarasi);
              }
            }

            if (widget.belgeTipi == "Musteri_Siparis") {
              fisEx.fis!.value.FATURANO = Ctanim.siparisNumarasi.toString();
              fisEx.fis!.value.BELGENO = Ctanim.siparisNumarasi.toString();
              Ctanim.siparisNumarasi = Ctanim.siparisNumarasi + 1;
              await SharedPrefsHelper.siparisNumarasiKaydet(
                  Ctanim.siparisNumarasi);
            }

            if (widget.belgeTipi == "Perakende_Satis") {
              fisEx.fis!.value.FATURANO =
                  Ctanim.perakendeSatisNumarasi.toString();
              fisEx.fis!.value.BELGENO =
                  Ctanim.perakendeSatisNumarasi.toString();
              Ctanim.perakendeSatisNumarasi = Ctanim.perakendeSatisNumarasi + 1;
              await SharedPrefsHelper.perakendeSatisNumKaydet(
                  Ctanim.perakendeSatisNumarasi);
            }

            if (Ctanim.kullanici!.ISLEMAKTARILSIN == "H") {
              fisEx.fis!.value.DURUM = true;
              final now = DateTime.now();
              final formatter = DateFormat('HH:mm');
              String saat = formatter.format(now);
              fisEx.fis!.value.SAAT = saat;
              await Fis.empty()
                  .fisEkle(fis: fisEx.fis!.value, belgeTipi: widget.belgeTipi);
              fisEx.fis!.value = Fis.empty();
              showDialog(
                  context: context,
                  builder: (context) {
                    return CustomAlertDialog(
                      secondButtonText: "Tamam",
                      onSecondPress: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      pdfSimgesi: true,
                      align: TextAlign.center,
                      title: 'Kayıt Başarılı',
                      message:
                          'Fatura Kaydedildi. PDF Dosyasını Görüntülemek İster misiniz?',
                      onPres: () async {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => PdfOnizleme(m: fiss)),
                        );
                      },
                      buttonText: 'Faturayı Gör',
                    );
                  });
            } else {
              final now = DateTime.now();
              final formatter = DateFormat('HH:mm');
              String saat = formatter.format(now);
              fisEx.fis!.value.SAAT = saat;
              fisEx.fis!.value.DURUM = true;
              fisEx.fis!.value.AKTARILDIMI = true;
              await Fis.empty()
                  .fisEkle(fis: fisEx.fis!.value, belgeTipi: widget.belgeTipi);
              int tempID = fisEx.fis!.value.ID!;

              // await fisEx.listFisGetir(belgeTip: widget.belgeTipi);
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return LoadingSpinner(
                    color: Colors.black,
                    message:
                        "Online Aktarım Aktif. Fatura Merkeze Gönderiliyor..",
                  );
                },
              );
              await fisEx.listGidecekTekFisGetir(
                  belgeTip: widget.belgeTipi, fisID: tempID);

              Map<String, dynamic> jsonListesi =
                  fisEx.list_fis_gidecek[0].toJson2();

              setState(() {});
              SHataModel gelenHata = await bs.ekleFatura(
                  jsonDataList: jsonListesi, sirket: Ctanim.sirket!);
              if (gelenHata.Hata == "true") {
                fisEx.fis!.value.DURUM = false;
                fisEx.fis!.value.AKTARILDIMI = false;
                LogModel logModel = LogModel(
                  TABLOADI: "TBLFISSB",
                  FISID: fisEx.list_fis_gidecek[0].ID,
                  HATAACIKLAMA: gelenHata.HataMesaj,
                  UUID: fisEx.list_fis_gidecek[0].UUID,
                  CARIADI: fisEx.list_fis_gidecek[0].CARIADI,
                );

                await VeriIslemleri().logKayitEkle(logModel);
                print("GÖNDERİM HATASI");
                await Ctanim.showHataDialog(
                    context, gelenHata.HataMesaj.toString(),
                    ikinciGeriOlsunMu: true);
              } else {
                fisEx.fis!.value = Fis.empty();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(),
                  ),
                  (Route<dynamic> route) => false,
                );

                showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        pdfSimgesi: true,
                        secondButtonText: "Geri",
                        onSecondPress: () {
                          Navigator.pop(context);
                        },
                        align: TextAlign.left,
                        title: 'Başarılı',
                        message:
                            'Fatura Merkeze Başarıyla Gönderildi. PDF Dosyasını Görmek İster misiniz ?',
                        onPres: () async {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => PdfOnizleme(m: fiss)),
                          );
                        },
                        buttonText: 'Faturayı Gör',
                      );
                    });
                setState(() {});
                fisEx.list_fis_gidecek.clear();

                print("ONLİNE AKRARIM AKTİF EDİLECEK");
              }
            }
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog(
                    align: TextAlign.center,
                    title: 'Hata',
                    message: 'Faturanın Kalem Listesi Boş Olamaz',
                    onPres: () async {
                      Navigator.pop(context);

                      setState(() {});
                    },
                    buttonText: 'Geri',
                  );
                });
          }
        },
        label: Text("Belgeyi Kaydet"),
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
      locale: const Locale('tr', 'TR'),
      context: context,
      initialDate: fisEx.fis_tarihi,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));
}

class Satir extends StatelessWidget {
  const Satir({
    super.key,
    required this.labelText,
  });
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 70,
          padding:
              EdgeInsets.all(8.0), // İstediğiniz padding değerini belirleyin
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 245, 245),
            // Kenarlık rengini ve kalınlığını ayarlayın
            borderRadius: BorderRadius.circular(5), // Köşe yarıçapını ayarlayın
          ),
          child: TextFormField(
            cursorColor: Color.fromARGB(255, 60, 59, 59),
            decoration: InputDecoration(
                label: Text(
                  labelText,
                  style: TextStyle(
                      color: Color.fromARGB(255, 60, 59, 59), fontSize: 15),
                ),
                border: InputBorder.none),
          )),
    );
  }
}
