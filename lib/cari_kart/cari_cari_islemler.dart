import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'package:opak_mobil_v2/controllers/cariController.dart';
import 'package:opak_mobil_v2/odeme/odeme_tab_page.dart';
import 'package:opak_mobil_v2/widget/appbar.dart';
import 'package:uuid/uuid.dart';
import '../controllers/fisController.dart';
import '../genel_belge.dart/genel_belge_tab_page.dart';
import '../tahsilat/tahsilat_tab_page.dart';
import '../webservis/satisTipiModel.dart';
import '../widget/cari.dart';
import '../widget/ctanim.dart';

import '../controllers/tahsilatController.dart';

import '../widget/veriler/listeler.dart';

class cari_cari_islemler extends StatefulWidget {
  const cari_cari_islemler({super.key, required this.cariKart});

  @override
  State<cari_cari_islemler> createState() => _cari_cari_islemlerState();
  final Cari cariKart;
}

class _cari_cari_islemlerState extends State<cari_cari_islemler> {
  TextEditingController belgeNo = TextEditingController();
  var uuid = Uuid();
  static FisController fisEx = Get.find();
  static TahsilatController tahsilatEx = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (listeler.listSatisTipiModel.isNotEmpty) {
      Ctanim.seciliIslemTip = listeler.listSatisTipiModel.first;
    } else {
      Ctanim.seciliIslemTip =
          SatisTipiModel(ID: -1, TIP: "", FIYATTIP: "", ISK1: "", ISK2: "");
    }
  }

  @override
  Widget build(BuildContext context) {
    int anaBirimID = 0;
    double kurGelen = 0.0;
    String doviAdi = "";
    for (var kur in listeler.listKur) {
      if (kur.ANABIRIM == "E") {
        anaBirimID = kur.ID!;
        kurGelen = kur.KUR!;
        doviAdi = kur.ACIKLAMA!;
      }
    }
    List<Widget> tasarimList = [
      GestureDetector(
        onTap: () {
          if (listeler.listSatisTipiModel.length > 0) {
            Ctanim.seciliIslemTip = listeler.listSatisTipiModel.first;
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      insetPadding: EdgeInsets.zero,
                      title: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Satış Tipi Seçiniz",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      content: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<SatisTipiModel>(
                            value: Ctanim.seciliIslemTip,
                            items: listeler.listSatisTipiModel
                                .map((SatisTipiModel banka) {
                              return DropdownMenuItem<SatisTipiModel>(
                                value: banka,
                                child: Text(
                                  banka.TIP ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                            onChanged: (SatisTipiModel? selected) {
                              setState(() {
                                Ctanim.seciliIslemTip = selected!;
                                print("B" + Ctanim.seciliIslemTip!.TIP!);
                              });
                            },
                          ),
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 50,
                            child: ElevatedButton(
                                child: Text(
                                  "İptal",
                                  style: TextStyle(fontSize: 15),
                                ),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 30, 38, 45),
                                    shadowColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    )),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 50,
                            child: ElevatedButton(
                                child: Text(
                                  "Tamam",
                                  style: TextStyle(fontSize: 15),
                                ),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 30, 38, 45),
                                    shadowColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    )),
                                onPressed: () {
                                  if (Ctanim.seciliIslemTip != null) {
                                    fisEx.fis!.value.DOVIZ = doviAdi;
                                    fisEx.fis!.value.DOVIZID = anaBirimID;
                                    fisEx.fis!.value.KUR = kurGelen;
                                    fisEx.fis!.value.DEPOID = int.parse(
                                        Ctanim.kullanici!.YERELDEPOID!);
                                    fisEx.fis!.value.SUBEID = int.parse(
                                        Ctanim.kullanici!.YERELSUBEID!);
                                    fisEx.fis!.value.UUID = uuid.v1();
                                    fisEx.fis!.value.PLASIYERKOD =
                                        Ctanim.kullanici!.KOD;
                                    fisEx.fis?.value.VADEGUNU = "0";
                                    fisEx.fis?.value.ISLEMTIPI = "0";
                                    fisEx.fis?.value.CARIKOD =
                                        widget.cariKart.KOD;
                                    fisEx.fis?.value.CARIADI =
                                        widget.cariKart.ADI;
                                    fisEx.fis?.value.cariKart = widget.cariKart;
                                    Get.to(() => genel_belge_tab_page(
                                      stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                                          satisTipi: Ctanim.seciliIslemTip!,
                                          belgeTipi: "Satis_Fatura",
                                          cariKod: widget.cariKart.KOD,
                                          cariKart: widget.cariKart,
                                        ));
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
                  );
                });
          } else {
            fisEx.fis!.value.DOVIZ = doviAdi;
            fisEx.fis!.value.DOVIZID = anaBirimID;
            fisEx.fis!.value.KUR = kurGelen;
            fisEx.fis!.value.DEPOID = int.parse(Ctanim.kullanici!.YERELDEPOID!);
            fisEx.fis!.value.SUBEID = int.parse(Ctanim.kullanici!.YERELSUBEID!);
            fisEx.fis!.value.UUID = uuid.v1();
            fisEx.fis!.value.PLASIYERKOD = Ctanim.kullanici!.KOD;
            fisEx.fis?.value.VADEGUNU = "0";
            fisEx.fis?.value.ISLEMTIPI = "0";
            fisEx.fis?.value.CARIKOD = widget.cariKart.KOD;
            fisEx.fis?.value.CARIADI = widget.cariKart.ADI;
            fisEx.fis?.value.cariKart = widget.cariKart;
            Get.to(() => genel_belge_tab_page(
               stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                  satisTipi: Ctanim.seciliIslemTip!,
                  belgeTipi: "Satis_Fatura",
                  cariKod: widget.cariKart.KOD,
                  cariKart: widget.cariKart,
                ));
          }
        },
        child: tasarim(icon: Icon(Icons.shopping_bag), title: "Satış Faturası"),
      ),
      GestureDetector(
        onTap: () {
          if (listeler.listSatisTipiModel.length > 0) {
            Ctanim.seciliIslemTip = listeler.listSatisTipiModel.first;
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      insetPadding: EdgeInsets.zero,
                      title: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Satış Tipi Seçiniz",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      content: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<SatisTipiModel>(
                            value: Ctanim.seciliIslemTip,
                            items: listeler.listSatisTipiModel
                                .map((SatisTipiModel banka) {
                              return DropdownMenuItem<SatisTipiModel>(
                                value: banka,
                                child: Text(
                                  banka.TIP ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                            onChanged: (SatisTipiModel? selected) {
                              setState(() {
                                Ctanim.seciliIslemTip = selected!;
                                print("B" + Ctanim.seciliIslemTip!.TIP!);
                              });
                            },
                          ),
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 50,
                            child: ElevatedButton(
                                child: Text(
                                  "İptal",
                                  style: TextStyle(fontSize: 15),
                                ),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 30, 38, 45),
                                    shadowColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    )),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 50,
                            child: ElevatedButton(
                                child: Text(
                                  "Tamam",
                                  style: TextStyle(fontSize: 15),
                                ),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 30, 38, 45),
                                    shadowColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    )),
                                onPressed: () {
                                  if (Ctanim.seciliIslemTip != null) {
                                    fisEx.fis!.value.DOVIZ = doviAdi;
                                    fisEx.fis!.value.DOVIZID = anaBirimID;
                                    fisEx.fis!.value.KUR = kurGelen;
                                    fisEx.fis!.value.DEPOID = int.parse(
                                        Ctanim.kullanici!.YERELDEPOID!);
                                    fisEx.fis!.value.SUBEID = int.parse(
                                        Ctanim.kullanici!.YERELSUBEID!);
                                    fisEx.fis!.value.UUID = uuid.v1();
                                    fisEx.fis!.value.PLASIYERKOD =
                                        Ctanim.kullanici!.KOD;
                                    fisEx.fis?.value.VADEGUNU = "0";
                                    fisEx.fis?.value.ISLEMTIPI = "0";
                                    fisEx.fis?.value.CARIKOD =
                                        widget.cariKart.KOD;
                                    fisEx.fis?.value.CARIADI =
                                        widget.cariKart.ADI;
                                    fisEx.fis?.value.cariKart = widget.cariKart;
                                    Get.to(() => genel_belge_tab_page(
                                       stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                                          satisTipi: Ctanim.seciliIslemTip!,
                                          belgeTipi: "Satis_Irsaliye",
                                          cariKod: widget.cariKart.KOD,
                                          cariKart: widget.cariKart,
                                        ));
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
                  );
                });
          } else {
            fisEx.fis!.value.DOVIZ = doviAdi;
            fisEx.fis!.value.DOVIZID = anaBirimID;
            fisEx.fis!.value.KUR = kurGelen;
            fisEx.fis!.value.DEPOID = int.parse(Ctanim.kullanici!.YERELDEPOID!);
            fisEx.fis!.value.SUBEID = int.parse(Ctanim.kullanici!.YERELSUBEID!);
            fisEx.fis!.value.UUID = uuid.v1();
            fisEx.fis!.value.PLASIYERKOD = Ctanim.kullanici!.KOD;
            fisEx.fis?.value.VADEGUNU = "0";
            fisEx.fis?.value.ISLEMTIPI = "0";
            fisEx.fis?.value.CARIKOD = widget.cariKart.KOD;
            fisEx.fis?.value.CARIADI = widget.cariKart.ADI;
            fisEx.fis?.value.cariKart = widget.cariKart;
            Get.to(() => genel_belge_tab_page(
               stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                  satisTipi: Ctanim.seciliIslemTip!,
                  belgeTipi: "Satis_Irsaliye",
                  cariKod: widget.cariKart.KOD,
                  cariKart: widget.cariKart,
                ));
          }
        },
        child: tasarim(
            icon: Icon(
              Icons.receipt_long,
            ),
            title: "Satış İrsaliye"),
      ),
      GestureDetector(
        onTap: () {
          Ctanim.seciliIslemTip =
              SatisTipiModel(ID: -1, TIP: "", FIYATTIP: "", ISK1: "", ISK2: "");
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  insetPadding: EdgeInsets.zero,
                  title: Text(
                    "   Belge Numarası Girişi",
                    style: TextStyle(fontSize: 17),
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                            cursorColor: Color.fromARGB(255, 30, 38, 45),
                            controller: belgeNo,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  color: Color.fromARGB(255, 30, 38, 45),
                                  onPressed: () {
                                    belgeNo.text = "";
                                  },
                                  icon: Icon(Icons.clear)),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 3, color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Color.fromARGB(255, 30, 38, 45))),
                              hintText: 'Belge No',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.5,
                              height: 50,
                              child: Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: ElevatedButton(
                                    child: Text(
                                      "Tamam",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Color.fromARGB(255, 30, 38, 45),
                                        shadowColor: Colors.black,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        )),
                                    onPressed: () {
                                      if (belgeNo.text != "") {
                                        int anaBirimID = 0;
                                        double kurGelen = 0.0;
                                        String doviAdi = "";
                                        for (var kur in listeler.listKur) {
                                          if (kur.ANABIRIM == "E") {
                                            anaBirimID = kur.ID!;
                                            kurGelen = kur.KUR!;
                                            doviAdi = kur.ACIKLAMA!;
                                          }
                                        }
                                        fisEx.fis!.value.BELGENO = belgeNo.text;
                                        fisEx.fis!.value.DOVIZ = doviAdi;
                                        fisEx.fis!.value.DOVIZID = anaBirimID;
                                        fisEx.fis!.value.KUR = kurGelen;

                                        fisEx.fis!.value.DEPOID = int.parse(
                                            Ctanim.kullanici!.YERELDEPOID!);
                                        fisEx.fis!.value.SUBEID = int.parse(
                                            Ctanim.kullanici!.YERELSUBEID!);
                                        fisEx.fis?.value.CARIKOD =
                                            widget.cariKart.KOD;
                                        fisEx.fis?.value.CARIADI =
                                            widget.cariKart.ADI;
                                        fisEx.fis?.value.cariKart =
                                            widget.cariKart;
                                        fisEx.fis!.value.UUID = uuid.v1();
                                        fisEx.fis!.value.PLASIYERKOD =
                                            Ctanim.kullanici!.KOD;
                                        fisEx.fis?.value.VADEGUNU = "0";
                                        fisEx.fis?.value.ISLEMTIPI = "0";
                                        Get.to(() => genel_belge_tab_page(
                                           stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                                              satisTipi: Ctanim.seciliIslemTip!,
                                              belgeTipi: "Alis_Irsaliye",
                                              cariKod: widget.cariKart.KOD,
                                              cariKart: widget.cariKart,
                                            ));
                                      }
                                    }),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: tasarim(
            icon: Icon(
              Icons.receipt_long,
            ),
            title: "Alış İrsaliye"),
      ),
      GestureDetector(
        onTap: () {
          if (listeler.listSatisTipiModel.length > 0) {
            Ctanim.seciliIslemTip = listeler.listSatisTipiModel.first;
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      insetPadding: EdgeInsets.zero,
                      title: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Satış Tipi Seçiniz",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      content: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<SatisTipiModel>(
                            value: Ctanim.seciliIslemTip,
                            items: listeler.listSatisTipiModel
                                .map((SatisTipiModel banka) {
                              return DropdownMenuItem<SatisTipiModel>(
                                value: banka,
                                child: Text(
                                  banka.TIP ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                            onChanged: (SatisTipiModel? selected) {
                              setState(() {
                                Ctanim.seciliIslemTip = selected!;
                                print("B" + Ctanim.seciliIslemTip!.TIP!);
                              });
                            },
                          ),
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 50,
                            child: ElevatedButton(
                                child: Text(
                                  "İptal",
                                  style: TextStyle(fontSize: 15),
                                ),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 30, 38, 45),
                                    shadowColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    )),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 50,
                            child: ElevatedButton(
                                child: Text(
                                  "Tamam",
                                  style: TextStyle(fontSize: 15),
                                ),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 30, 38, 45),
                                    shadowColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    )),
                                onPressed: () {
                                  if (Ctanim.seciliIslemTip != null) {
                                    fisEx.fis!.value.DOVIZ = doviAdi;
                                    fisEx.fis!.value.DOVIZID = anaBirimID;
                                    fisEx.fis!.value.KUR = kurGelen;
                                    fisEx.fis!.value.DEPOID = int.parse(
                                        Ctanim.kullanici!.YERELDEPOID!);
                                    fisEx.fis!.value.SUBEID = int.parse(
                                        Ctanim.kullanici!.YERELSUBEID!);
                                    fisEx.fis!.value.UUID = uuid.v1();
                                    fisEx.fis!.value.PLASIYERKOD =
                                        Ctanim.kullanici!.KOD;
                                    fisEx.fis?.value.VADEGUNU = "0";
                                    fisEx.fis?.value.ISLEMTIPI = "0";
                                    fisEx.fis?.value.CARIKOD =
                                        widget.cariKart.KOD;
                                    fisEx.fis?.value.CARIADI =
                                        widget.cariKart.ADI;
                                    fisEx.fis?.value.cariKart = widget.cariKart;
                                    Get.to(() => genel_belge_tab_page(
                                       stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                                          satisTipi: Ctanim.seciliIslemTip!,
                                          belgeTipi: "Musteri_Siparis",
                                          cariKod: widget.cariKart.KOD,
                                          cariKart: widget.cariKart,
                                        ));
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
                  );
                });
          } else {
            fisEx.fis!.value.DOVIZ = doviAdi;
            fisEx.fis!.value.DOVIZID = anaBirimID;
            fisEx.fis!.value.KUR = kurGelen;
            fisEx.fis!.value.DEPOID = int.parse(Ctanim.kullanici!.YERELDEPOID!);
            fisEx.fis!.value.SUBEID = int.parse(Ctanim.kullanici!.YERELSUBEID!);
            fisEx.fis!.value.UUID = uuid.v1();
            fisEx.fis!.value.PLASIYERKOD = Ctanim.kullanici!.KOD;
            fisEx.fis?.value.VADEGUNU = "0";
            fisEx.fis?.value.ISLEMTIPI = "0";
            fisEx.fis?.value.CARIKOD = widget.cariKart.KOD;
            fisEx.fis?.value.CARIADI = widget.cariKart.ADI;
            fisEx.fis?.value.cariKart = widget.cariKart;
            Get.to(() => genel_belge_tab_page(
               stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                  satisTipi: Ctanim.seciliIslemTip!,
                  belgeTipi: "Musteri_Siparis",
                  cariKod: widget.cariKart.KOD,
                  cariKart: widget.cariKart,
                ));
          }
        },
        child:
            tasarim(icon: Icon(Icons.shopping_cart), title: "Müşteri Sipariş"),
      ),
      GestureDetector(
        onTap: () {
          if (listeler.listSatisTipiModel.length > 0) {
            Ctanim.seciliIslemTip = listeler.listSatisTipiModel.first;
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      insetPadding: EdgeInsets.zero,
                      title: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Satış Tipi Seçiniz",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      content: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<SatisTipiModel>(
                            value: Ctanim.seciliIslemTip,
                            items: listeler.listSatisTipiModel
                                .map((SatisTipiModel banka) {
                              return DropdownMenuItem<SatisTipiModel>(
                                value: banka,
                                child: Text(
                                  banka.TIP ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                            onChanged: (SatisTipiModel? selected) {
                              setState(() {
                                Ctanim.seciliIslemTip = selected!;
                                print("B" + Ctanim.seciliIslemTip!.TIP!);
                              });
                            },
                          ),
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 50,
                            child: ElevatedButton(
                                child: Text(
                                  "İptal",
                                  style: TextStyle(fontSize: 15),
                                ),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 30, 38, 45),
                                    shadowColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    )),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 50,
                            child: ElevatedButton(
                                child: Text(
                                  "Tamam",
                                  style: TextStyle(fontSize: 15),
                                ),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 30, 38, 45),
                                    shadowColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    )),
                                onPressed: () {
                                  if (Ctanim.seciliIslemTip != null) {
                                    fisEx.fis!.value.DOVIZ = doviAdi;
                                    fisEx.fis!.value.DOVIZID = anaBirimID;
                                    fisEx.fis!.value.KUR = kurGelen;
                                    fisEx.fis!.value.DEPOID = int.parse(
                                        Ctanim.kullanici!.YERELDEPOID!);
                                    fisEx.fis!.value.SUBEID = int.parse(
                                        Ctanim.kullanici!.YERELSUBEID!);
                                    fisEx.fis!.value.UUID = uuid.v1();
                                    fisEx.fis!.value.PLASIYERKOD =
                                        Ctanim.kullanici!.KOD;
                                    fisEx.fis?.value.VADEGUNU = "0";
                                    fisEx.fis?.value.ISLEMTIPI = "0";
                                    fisEx.fis?.value.CARIKOD =
                                        widget.cariKart.KOD;
                                    fisEx.fis?.value.CARIADI =
                                        widget.cariKart.ADI;
                                    fisEx.fis?.value.cariKart = widget.cariKart;
                                    Get.to(() => genel_belge_tab_page(
                                       stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                                          satisTipi: Ctanim.seciliIslemTip!,
                                          belgeTipi: "Satis_Teklif",
                                          cariKod: widget.cariKart.KOD,
                                          cariKart: widget.cariKart,
                                        ));
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
                  );
                });
          } else {
            fisEx.fis!.value.DOVIZ = doviAdi;
            fisEx.fis!.value.DOVIZID = anaBirimID;
            fisEx.fis!.value.KUR = kurGelen;
            fisEx.fis!.value.DEPOID = int.parse(Ctanim.kullanici!.YERELDEPOID!);
            fisEx.fis!.value.SUBEID = int.parse(Ctanim.kullanici!.YERELSUBEID!);
            fisEx.fis!.value.UUID = uuid.v1();
            fisEx.fis!.value.PLASIYERKOD = Ctanim.kullanici!.KOD;
            fisEx.fis?.value.VADEGUNU = "0";
            fisEx.fis?.value.ISLEMTIPI = "0";
            fisEx.fis?.value.CARIKOD = widget.cariKart.KOD;
            fisEx.fis?.value.CARIADI = widget.cariKart.ADI;
            fisEx.fis?.value.cariKart = widget.cariKart;
            Get.to(() => genel_belge_tab_page(
               stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                  satisTipi: Ctanim.seciliIslemTip!,
                  belgeTipi: "Satis_Teklif",
                  cariKod: widget.cariKart.KOD,
                  cariKart: widget.cariKart,
                ));
          }
        },
        child:
            tasarim(icon: Icon(Icons.real_estate_agent), title: "Satış Teklif"),
      ),
      GestureDetector(
        onTap: () {
          Ctanim.seciliIslemTip =
              SatisTipiModel(ID: -1, TIP: "", FIYATTIP: "", ISK1: "", ISK2: "");
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  insetPadding: EdgeInsets.zero,
                  title: Text(
                    "   Belge Numarası Girişi",
                    style: TextStyle(fontSize: 17),
                  ),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextFormField(
                            cursorColor: Color.fromARGB(255, 30, 38, 45),
                            controller: belgeNo,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  color: Color.fromARGB(255, 30, 38, 45),
                                  onPressed: () {
                                    belgeNo.text = "";
                                  },
                                  icon: Icon(Icons.clear)),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(width: 3, color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Color.fromARGB(255, 30, 38, 45))),
                              hintText: 'Belge No',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3.5,
                              height: 50,
                              child: Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: ElevatedButton(
                                    child: Text(
                                      "Tamam",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            Color.fromARGB(255, 30, 38, 45),
                                        shadowColor: Colors.black,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        )),
                                    onPressed: () {
                                      if (belgeNo.text != "") {
                                        int anaBirimID = 0;
                                        double kurGelen = 0.0;
                                        String doviAdi = "";
                                        for (var kur in listeler.listKur) {
                                          if (kur.ANABIRIM == "E") {
                                            anaBirimID = kur.ID!;
                                            kurGelen = kur.KUR!;
                                            doviAdi = kur.ACIKLAMA!;
                                          }
                                        }
                                        fisEx.fis!.value.BELGENO = belgeNo.text;
                                        fisEx.fis!.value.DOVIZ = doviAdi;
                                        fisEx.fis!.value.DOVIZID = anaBirimID;
                                        fisEx.fis!.value.KUR = kurGelen;

                                        fisEx.fis!.value.DEPOID = int.parse(
                                            Ctanim.kullanici!.YERELDEPOID!);
                                        fisEx.fis!.value.SUBEID = int.parse(
                                            Ctanim.kullanici!.YERELSUBEID!);
                                        fisEx.fis?.value.CARIKOD =
                                            widget.cariKart.KOD;
                                        fisEx.fis?.value.CARIADI =
                                            widget.cariKart.ADI;
                                        fisEx.fis?.value.cariKart =
                                            widget.cariKart;
                                        fisEx.fis!.value.UUID = uuid.v1();
                                        fisEx.fis!.value.PLASIYERKOD =
                                            Ctanim.kullanici!.KOD;
                                        fisEx.fis?.value.VADEGUNU = "0";
                                        fisEx.fis?.value.ISLEMTIPI = "0";
                                        Get.to(() => genel_belge_tab_page(
                                           stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                                              satisTipi: Ctanim.seciliIslemTip!,
                                              belgeTipi: "Alinan_Siparis",
                                              cariKod: widget.cariKart.KOD,
                                              cariKart: widget.cariKart,
                                            ));
                                      }
                                    }),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: tasarim(
            icon: Icon(Icons.arrow_outward_rounded), title: "Alınan Sipariş"),
      ),
      GestureDetector(
        onTap: () {
          if (listeler.listSatisTipiModel.length > 0) {
            Ctanim.seciliIslemTip = listeler.listSatisTipiModel.first;
            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      insetPadding: EdgeInsets.zero,
                      title: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          "Satış Tipi Seçiniz",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      content: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<SatisTipiModel>(
                            value: Ctanim.seciliIslemTip,
                            items: listeler.listSatisTipiModel
                                .map((SatisTipiModel banka) {
                              return DropdownMenuItem<SatisTipiModel>(
                                value: banka,
                                child: Text(
                                  banka.TIP ?? "",
                                  style: TextStyle(fontSize: 16),
                                ),
                              );
                            }).toList(),
                            onChanged: (SatisTipiModel? selected) {
                              setState(() {
                                Ctanim.seciliIslemTip = selected!;
                                print("B" + Ctanim.seciliIslemTip!.TIP!);
                              });
                            },
                          ),
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 50,
                            child: ElevatedButton(
                                child: Text(
                                  "İptal",
                                  style: TextStyle(fontSize: 15),
                                ),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 30, 38, 45),
                                    shadowColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    )),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 50,
                            child: ElevatedButton(
                                child: Text(
                                  "Tamam",
                                  style: TextStyle(fontSize: 15),
                                ),
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 30, 38, 45),
                                    shadowColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    )),
                                onPressed: () {
                                  if (Ctanim.seciliIslemTip != null) {
                                    fisEx.fis!.value.DOVIZ = doviAdi;
                                    fisEx.fis!.value.DOVIZID = anaBirimID;
                                    fisEx.fis!.value.KUR = kurGelen;
                                    fisEx.fis!.value.DEPOID = int.parse(
                                        Ctanim.kullanici!.YERELDEPOID!);
                                    fisEx.fis!.value.SUBEID = int.parse(
                                        Ctanim.kullanici!.YERELSUBEID!);
                                    fisEx.fis!.value.UUID = uuid.v1();
                                    fisEx.fis!.value.PLASIYERKOD =
                                        Ctanim.kullanici!.KOD;
                                    fisEx.fis?.value.VADEGUNU = "0";
                                    fisEx.fis?.value.ISLEMTIPI = "0";
                                    fisEx.fis?.value.CARIKOD =
                                        widget.cariKart.KOD;
                                    fisEx.fis?.value.CARIADI =
                                        widget.cariKart.ADI;
                                    fisEx.fis?.value.cariKart = widget.cariKart;
                                    Get.to(() => genel_belge_tab_page(
                                       stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                                          satisTipi: Ctanim.seciliIslemTip!,
                                          belgeTipi: "Perakande_Satis",
                                          cariKod: widget.cariKart.KOD,
                                          cariKart: widget.cariKart,
                                        ));
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
                  );
                });
          } else {
            fisEx.fis!.value.DOVIZ = doviAdi;
            fisEx.fis!.value.DOVIZID = anaBirimID;
            fisEx.fis!.value.KUR = kurGelen;
            fisEx.fis!.value.DEPOID = int.parse(Ctanim.kullanici!.YERELDEPOID!);
            fisEx.fis!.value.SUBEID = int.parse(Ctanim.kullanici!.YERELSUBEID!);
            fisEx.fis!.value.UUID = uuid.v1();
            fisEx.fis!.value.PLASIYERKOD = Ctanim.kullanici!.KOD;
            fisEx.fis?.value.VADEGUNU = "0";
            fisEx.fis?.value.ISLEMTIPI = "0";
            fisEx.fis?.value.CARIKOD = widget.cariKart.KOD;
            fisEx.fis?.value.CARIADI = widget.cariKart.ADI;
            fisEx.fis?.value.cariKart = widget.cariKart;
            Get.to(() => genel_belge_tab_page(
               stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                  satisTipi: Ctanim.seciliIslemTip!,
                  belgeTipi: "Perakende_Satis",
                  cariKod: widget.cariKart.KOD,
                  cariKart: widget.cariKart,
                ));
          }
        },
        child: tasarim(
            icon: Icon(Icons.store_mall_directory), title: "Perakende Satış"),
      ),
      GestureDetector(
        onTap: () {
          tahsilatEx.tahsilat!.value.UUID = uuid.v1().toString();
          tahsilatEx.tahsilat!.value.TIP = Ctanim().MapIlslemTip["Tahsilat"];
          tahsilatEx.tahsilat!.value.BELGENO = "123456";
          tahsilatEx.tahsilat!.value.PLASIYERKOD = Ctanim.kullanici!.KOD;
          tahsilatEx.tahsilat?.value.CARIKOD = widget.cariKart.KOD;
          tahsilatEx.tahsilat?.value.CARIADI = widget.cariKart.ADI;
          tahsilatEx.tahsilat?.value.cariKart = widget.cariKart;
          Get.to(() => tahsilat_tab_page(
                uuid: tahsilatEx.tahsilat!.value.UUID.toString(),
                belgeTipi: "Tahsilat",
                cariKod: widget.cariKart.KOD,
                cariKart: widget.cariKart,
              ));
        },
        child: tasarim(icon: Icon(Icons.payment), title: "Tahsilat"),
      ),
      GestureDetector(
        onTap: () {
          tahsilatEx.tahsilat!.value.UUID = uuid.v1().toString();
          tahsilatEx.tahsilat!.value.TIP = Ctanim().MapIlslemTip["Odeme"];
          tahsilatEx.tahsilat!.value.BELGENO = "123456";
          tahsilatEx.tahsilat!.value.PLASIYERKOD = Ctanim.kullanici!.KOD;
          tahsilatEx.tahsilat?.value.CARIKOD = widget.cariKart.KOD;
          tahsilatEx.tahsilat?.value.CARIADI = widget.cariKart.ADI;
          tahsilatEx.tahsilat?.value.cariKart = widget.cariKart;
          Get.to(() => odeme_detay_tab_page(
                uuid: tahsilatEx.tahsilat!.value.UUID.toString(),
                belgeTipi: "Odeme",
                cariKod: widget.cariKart.KOD,
                cariKart: widget.cariKart,
              ));
        },
        child: tasarim(icon: Icon(Icons.payment), title: "Ödeme"),
      ),
    ];

    return Scaffold(
        body: ListView.builder(
      itemCount: tasarimList.length,
      itemBuilder: (context, index) {
        return tasarimList[index];
      },
    ));
  }
}

class tasarim extends StatelessWidget {
  const tasarim({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    bool gosterilsinmi = true;
    if (title == "Satış Faturası") {
      if (listeler.plasiyerYetkileri[1] == false) {
        gosterilsinmi = false;
      }
    }
    if (title == "Satış İrsaliye") {
      if (listeler.plasiyerYetkileri[2] == false) {
        gosterilsinmi = false;
      }
    }
    if (title == "Alış İrsaliye") {
      if (listeler.plasiyerYetkileri[3] == false) {
        gosterilsinmi = false;
      }
    }
    if (title == "Alınan Sipariş") {
      if (listeler.plasiyerYetkileri[4] == false) {
        gosterilsinmi = false;
      }
    }
    if (title == "Müşteri Sipariş") {
      if (listeler.plasiyerYetkileri[5] == false) {
        gosterilsinmi = false;
      }
    }
    if (title == "Satış Teklif") {
      if (listeler.plasiyerYetkileri[6] == false) {
        gosterilsinmi = false;
      }
    }
    if (title == "Perakende Satış") {
      if (listeler.plasiyerYetkileri[10] == false) {
        gosterilsinmi = false;
      }
    }
    if (title == "Tahsilat") {
      if (listeler.plasiyerYetkileri[11] == false) {
        gosterilsinmi = false;
      }
    }
    if (title == "Ödeme") {
      if (listeler.plasiyerYetkileri[12] == false) {
        gosterilsinmi = false;
      }
    }

    return gosterilsinmi == true
        ? Column(
            children: [
              ListTile(
                  title: Text(title),
                  leading: icon,
                  trailing: Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 10,
                  )),
              Divider(
                thickness: 1,
              )
            ],
          )
        : Container();
  }
}
