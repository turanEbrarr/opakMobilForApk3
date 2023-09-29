import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:opak_mobil_v2/tahsilat/tahsilat_toplam.dart';
import 'package:opak_mobil_v2/tahsilatOdemeModel/tahsilatHaraket.dart';
import 'package:opak_mobil_v2/webservis/bankaSozlesmeModel.dart';
import 'package:opak_mobil_v2/widget/veriler/listeler.dart';
import 'package:uuid/uuid.dart';

import '../controllers/tahsilatController.dart';
import '../webservis/bankaModel.dart';
import '../webservis/kurModel.dart';
import '../widget/ctanim.dart';

class odeme_nakit_visa extends StatefulWidget {
  const odeme_nakit_visa({
    super.key,
    required this.uid,
  });

  final String uid;

  @override
  State<odeme_nakit_visa> createState() => _odeme_nakit_visaState();
}

class _odeme_nakit_visaState extends State<odeme_nakit_visa> {
  final TahsilatController tahsilatEx = Get.find();
  List<KurModel> paraBirimi = [];
  List<String> kasa = ["MERKEZ-TL-KASA", ""];
  List<BankaModel> bankalar = [];
  List<BankaSozlesmeModel> posSozlesme = [];
  DateTime dt = DateTime.now();
  var uuid = Uuid();
  KurModel? s_para_birimi;
  String? s_kasa = "MERKEZ-TL-KASA";
  BankaModel? seciliBanka;
  BankaSozlesmeModel? seciliSozlesme;
  TextEditingController nakitAciklama = new TextEditingController();
  TextEditingController nakitBelgeNo = new TextEditingController();
  TextEditingController nakitTutar = new TextEditingController();

  TextEditingController visaAciklama = new TextEditingController();
  TextEditingController visaBelgeNo = new TextEditingController();
  TextEditingController visaTutar = new TextEditingController();
  TextEditingController visaTaksit = new TextEditingController();
  TextEditingController visaSozlesme =
      new TextEditingController(text: "Akbank Pos Hesabı");
  @override
  KurModel? anaBirim;
  bool nakitTahsilat = true;
  bool visaTahsilat = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    for (var element in listeler.listKur) {
      paraBirimi.add(element);
      if (element.ANABIRIM == "E") {
        s_para_birimi = element;
        anaBirim = element;
      }
    }
    for (var element in listeler.listBankaModel) {
      bankalar.add(element);
    }
    if (bankalar.isNotEmpty) {
      seciliBanka = bankalar.first;
    }
    for (var element in listeler.listBankaSozlesmeModel) {
      if (element.BANKAID == seciliBanka!.ID) {
        posSozlesme.add(element);
      }
    }
    if (posSozlesme.isNotEmpty) {
      seciliSozlesme = posSozlesme.first;
    }
  }

  bool nakitTutarBosmu = true;
  bool nakitBelgeNoBosmu = true;
  bool visaTaksitBosMu = true;
  bool visaBelgeNoBosMu = true;
  bool visaTutarBosMu = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            nakitTahsilat == true
                ? Card(
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: ListTile(
                            leading: Icon(Icons.receipt_long_outlined),
                            title: Text(
                              "Nakit Ödeme:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_drop_up),
                              onPressed: () {
                                nakitTahsilat = !nakitTahsilat;
                                nakitTutar.text = "";
                                nakitBelgeNo.text = "";
                                nakitAciklama.text = "";
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .3,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        "DÖVİZ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                      child: Text(":"),
                                    )
                                  ],
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .6,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<KurModel>(
                                  value: s_para_birimi,
                                  items: paraBirimi.map((KurModel banka) {
                                    return DropdownMenuItem<KurModel>(
                                      value: banka,
                                      child: Text(
                                        banka.ACIKLAMA ?? "",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (KurModel? selected) {
                                    setState(() {
                                      s_para_birimi = selected;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .3,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        "KASA ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                      child: Text(":"),
                                    )
                                  ],
                                )),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .6,
                                child: Text(
                                  Ctanim.kullanici!.KASAADI!,
                                  style: TextStyle(fontSize: 14),
                                )

                                /*
                                                DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                              value: s_kasa,
                              items: kasa
                                  .map((e) => DropdownMenuItem<String>(
                                      value: e,
                                      child: Text(
                                        e,
                                      )))
                                  .toList(),
                              onChanged: ((e) => setState(() {
                                    s_kasa = e;
                                  }))),
                        ),
                        */
                                ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        "AÇIKLAMA",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(width: 20, child: Text(":"))
                                  ],
                                )),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .6,
                                child: TextField(
                                  controller: nakitAciklama,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .3,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        "BELGE NO",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                      child: Text(":"),
                                    )
                                  ],
                                )),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .6,
                                child: TextField(
                                  onChanged: (value) {
                                    if (value != "") {
                                      nakitBelgeNoBosmu = false;
                                      setState(() {});
                                    } else {
                                      nakitBelgeNoBosmu = true;
                                      setState(() {});
                                    }
                                  },
                                  controller: nakitBelgeNo,
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "TUTAR",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: Text(":"),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: TextField(
                                    onChanged: (value) {
                                      if (value != "") {
                                        nakitTutarBosmu = false;
                                        setState(() {});
                                      } else {
                                        nakitTutarBosmu = true;
                                        setState(() {});
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}')),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    controller: nakitTutar,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            height: 40,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: nakitBelgeNoBosmu == false &&
                                            nakitTutarBosmu == false
                                        ? Colors.green
                                        : Colors.red),
                                onPressed: () {
                                  if (nakitTutar.text != "" &&
                                      nakitBelgeNo.text != "") {
                                    tahsilatEx.tahsilataHareketEkle(
                                        dovizID: s_para_birimi!.ID!,
                                        kur: s_para_birimi!.KUR!,
                                        kasaKod: Ctanim.kullanici!.KASAKOD!,
                                        ID: 22,
                                        UID: widget.uid,
                                        aciklama: nakitAciklama.text,
                                        asil: "-",
                                        belgeNo: nakitBelgeNo.text,
                                        cekSeriNo: nakitBelgeNo.text,
                                        doviz: s_para_birimi!.ACIKLAMA!,
                                        sozlesmeId: 0,
                                        taksit: 1,
                                        tip: 1,
                                        tutar: double.parse(
                                            donusturDouble(nakitTutar.text)),
                                        vadeTarihi:
                                            '${dt.year}-${dt.month}-${dt.day}',
                                        yeri: "Ankara");

                                    Get.snackbar(
                                      "Ödeme Eklendi",
                                      "${nakitTutar.text} ${s_para_birimi!.ACIKLAMA} tutarında nakit fişe eklendi",
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: Duration(milliseconds: 1500),
                                      backgroundColor:
                                          Color.fromARGB(255, 30, 38, 45),
                                      colorText: Colors.white,
                                    );
                                    nakitAciklama.text = "";
                                    nakitBelgeNo.text = "";
                                    nakitTutar.text = "";
                                    nakitTutarBosmu = true;
                                    nakitBelgeNoBosmu = true;
                                    setState(() {});
                                  } else {
                                    showAlertDialog(context,
                                        "Nakit Ödemelerde Ait Tutar Girişi ve Belge Numarası Doldurulmalıdır.");
                                  }
                                },
                                child: Text("Ödeme Listesine Ekle")),
                          ),
                        ),
                      ]),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      nakitTahsilat = !nakitTahsilat;
                      visaTahsilat = false;
                      setState(() {});
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: ListTile(
                          leading: Icon(Icons.receipt_long_outlined),
                          title: Text(
                            "Nakit Ödeme:",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_drop_down),
                            onPressed: () {
                              nakitTahsilat = !nakitTahsilat;
                              visaTahsilat = false;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
            visaTahsilat == true
                ? Card(
                    elevation: 15,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListTile(
                            leading: Icon(Icons.receipt_long_outlined),
                            title: Text(
                              "Visa Ödeme:",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 20),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_drop_up),
                              onPressed: () {
                                visaTahsilat = !visaTahsilat;
                                visaTaksit.text = "";
                                visaAciklama.text = "";
                                visaBelgeNo.text = "";
                                visaTutar.text = "";
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "POS SEÇ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: Text(":"),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .6,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<BankaModel>(
                                    value: seciliBanka,
                                    items: bankalar.map((BankaModel banka) {
                                      return DropdownMenuItem<BankaModel>(
                                        value: banka,
                                        child: Text(
                                          banka.BANKAADI ?? "",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (BankaModel? selected) {
                                      setState(() {
                                        seciliBanka = selected;
                                        seciliSozlesme = null;

                                        posSozlesme.clear();
                                        for (var element in listeler
                                            .listBankaSozlesmeModel) {
                                          if (element.BANKAID ==
                                              seciliBanka!.ID) {
                                            posSozlesme.add(element);
                                          }
                                        }
                                        if (posSozlesme.isNotEmpty) {
                                          seciliSozlesme = posSozlesme.first;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "SÖZLEŞME",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: Text(":"),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .6,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<BankaSozlesmeModel>(
                                    value: seciliSozlesme,
                                    items: posSozlesme.isEmpty
                                        ? null
                                        : posSozlesme
                                            .map((BankaSozlesmeModel sozlesme) {
                                            return DropdownMenuItem<
                                                BankaSozlesmeModel>(
                                              value: sozlesme,
                                              child: Text(
                                                sozlesme.ADI ?? "",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            );
                                          }).toList(),
                                    onChanged: (BankaSozlesmeModel? selected) {
                                      setState(() {
                                        seciliSozlesme = selected;
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "TAKSİT",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: Text(":"),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: TextFormField(
                                  onChanged: (value) {
                                    if (value != "") {
                                      visaTaksitBosMu = false;
                                      setState(() {});
                                    } else {
                                      visaTaksitBosMu = true;
                                      setState(() {});
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}')),
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  controller: visaTaksit,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "AÇIKLAMA",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: Text(":"),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: TextField(
                                    controller: visaAciklama,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "BELGE NO",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: Text(":"),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: TextField(
                                    onChanged: (value) {
                                      if (value != "") {
                                        visaBelgeNoBosMu = false;
                                        setState(() {});
                                      } else {
                                        visaBelgeNoBosMu = true;
                                        setState(() {});
                                      }
                                    },
                                    controller: visaBelgeNo,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 8, right: 8, bottom: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .3,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          "TUTAR",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                        child: Text(":"),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * .6,
                                  child: TextField(
                                    onChanged: (value) {
                                      if (value != "") {
                                        visaTutarBosMu = false;
                                        setState(() {});
                                      } else {
                                        visaTutarBosMu = true;
                                        setState(() {});
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d{0,2}')),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    controller: visaTutar,
                                  )),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * .8,
                            height: 40,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: visaBelgeNoBosMu == false &&
                                            visaTaksitBosMu == false &&
                                            visaTutarBosMu == false &&
                                            seciliBanka != null &&
                                            seciliSozlesme != null
                                        ? Colors.green
                                        : Colors.red),
                                onPressed: () {
                                  if (visaTaksit.text != "" &&
                                      int.parse(visaTaksit.text) >= 1 &&
                                      seciliSozlesme != null &&
                                      visaBelgeNo.text != "" &&
                                      visaTutar.text != "") {
                                    tahsilatEx.tahsilataHareketEkle(
                                        dovizID: anaBirim!.ID!,
                                        kasaKod: Ctanim.kullanici!.KASAKOD!,
                                        ID: 22,
                                        UID: widget.uid,
                                        aciklama: visaAciklama.text,
                                        asil: "-",
                                        belgeNo: visaBelgeNo.text,
                                        cekSeriNo: visaBelgeNo.text,
                                        doviz: anaBirim!.ACIKLAMA!,
                                        sozlesmeId: seciliSozlesme!.ID!,
                                        taksit: int.parse(visaTaksit.text),
                                        tip: 2,
                                        tutar: double.parse(
                                            donusturDouble(visaTutar.text)),
                                        vadeTarihi:
                                            '${dt.year}-${dt.month}-${dt.day}',
                                        yeri: "Ankara",
                                        kur: anaBirim!.KUR!);
                                    Get.snackbar(
                                      "Ödeme Eklendi",
                                      "${visaTutar.text} ${anaBirim!.ACIKLAMA} tutarında visa fişe eklendi",
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: Duration(milliseconds: 1500),
                                      backgroundColor:
                                          Color.fromARGB(255, 30, 38, 45),
                                      colorText: Colors.white,
                                    );
                                    visaAciklama.text = "";
                                    visaBelgeNo.text = "";
                                    visaTaksit.text = "";
                                    visaTutar.text = "";
                                    tahsilatEx.tahsilat!.value.GENELTOPLAM =
                                        genelToplamHesapla();
                                    visaTaksitBosMu = true;
                                    visaBelgeNoBosMu = true;
                                    visaTutarBosMu = true;
                                    setState(() {});
                                  } else {
                                    showAlertDialog(context,
                                        "Visa Ödemelerde Taksit Alanı Birden Büyük Değerlerle Doldurulmalı, Sözleşme Alanı Seçilmeli ve Belge Numarası Doldurulmalıdır.");
                                  }
                                },
                                child: Text("Ödeme Listesine Ekle")),
                          ),
                        ),
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      visaTahsilat = !visaTahsilat;
                      nakitTahsilat = false;
                      setState(() {});
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: ListTile(
                          leading: Icon(Icons.receipt_long_outlined),
                          title: Text(
                            "Visa Ödeme:",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_drop_down),
                            onPressed: () {
                              visaTahsilat = !visaTahsilat;
                              nakitTahsilat = false;
                              setState(() {});
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String mesaj) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hatalı İşlem!"),
      content: Text(mesaj),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  double genelToplamHesapla() {
    double genelToplam = 0.0;
    for (var element in tahsilatEx.tahsilat!.value.tahsilatHareket) {
      genelToplam += element.TUTAR!;
    }
    return genelToplam;
  }

  String donusturPara(String inText) {
    print("bana gelen " + inText);
    MoneyFormatter fmf = MoneyFormatter(amount: double.parse(inText));
    MoneyFormatterOutput fo = fmf.output;
    String tempSonTutar = fo.nonSymbol.toString();
    print("benden Donen " + tempSonTutar);
    return tempSonTutar;
  }

  String donusturDouble(String inText) {
    String donecekTemp = inText;
    if (donecekTemp.contains(",")) {
      String donecek = donecekTemp.replaceAll(",", ".");
      return donecek;
    } else {
      return donecekTemp;
    }
  }
}
