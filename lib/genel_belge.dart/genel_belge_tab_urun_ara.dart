import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opak_mobil_v2/controllers/fisController.dart';
import 'package:opak_mobil_v2/genel_belge.dart/genel_belge_gecmis_satis_bilgileri.dart';
import 'package:opak_mobil_v2/genel_belge.dart/genel_belge_stok_kart_guncelleme.dart';
import 'package:opak_mobil_v2/stok_kart/stok_tanim.dart';
import 'package:opak_mobil_v2/webservis/satisTipiModel.dart';
import 'package:opak_mobil_v2/webservis/stokFiyatListesiModel.dart';
import 'package:opak_mobil_v2/widget/String_tanim.dart';
import 'package:opak_mobil_v2/widget/ctanim.dart';
import 'package:opak_mobil_v2/widget/veriler/listeler.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../controllers/cariController.dart';
import '../controllers/stokKartController.dart';

import '../faturaFis/fisHareket.dart';

import '../stok_kart/stok_kart_detay_guncel.dart';
import '../widget/cari.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class genel_belge_tab_urun_ara extends StatefulWidget {
  const genel_belge_tab_urun_ara({
    super.key,
    required this.cariKod,
    required this.satisTipi, required this.stokFiyatListesi,
  });
  final String? cariKod;
  final SatisTipiModel? satisTipi;
  final StokFiyatListesiModel? stokFiyatListesi;

  @override
  State<genel_belge_tab_urun_ara> createState() =>
      _genel_belge_tab_urun_araState();
}

class _genel_belge_tab_urun_araState extends State<genel_belge_tab_urun_ara> {
  TextEditingController editingController = TextEditingController(text: "");
  late String alinanString;
  String result = '';
  DateTime now = DateTime.now();
  final StokKartController stokKartEx = Get.find();
  final CariController cariEx = Get.find();
  final FisController fisEx = Get.find();
  List<String> fiyatListesi = [];

  String seciliFiyat = Ctanim.satisFiyatListesi[0];
  TextStyle boldBlack =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  SampleItem? selectedMenu;

  @override
  void initState() {
    super.initState();
    Ctanim.fiyatListesiKosul.clear();
    Ctanim.seciliCariKodu = widget.cariKod!;
    fiyatListesi.addAll(Ctanim.satisFiyatListesi);
    Ctanim.fiyatListesiKosul.addAll(fiyatListesi);
/*
    int kalan = 0;
    double ilk = stokKartEx.searchList.length / 100;
    int kacTam = int.parse(ilk.toString().split(".")[0]);
    kalan = stokKartEx.searchList.length % 20;
    List<List<StokKart>> parcali = [];
    int b = 0;
    if (kalan != 0) {
      kacTam += 1;
    }
    for (int i = 0; i < kacTam; i++) {
      if (b + 100 <= stokKartEx.searchList.length) {
        parcali.add(stokKartEx.searchList.sublist(b, b + 100));
        b = b + 100;
      } else {
        parcali.add(
            stokKartEx.searchList.sublist(b, stokKartEx.searchList.length));
      }
    }

    // bagla(parcali);
    
    final iterator = stokKartEx.searchList.iterator;

    while (iterator.moveNext()) {
      final item = iterator.current;
      // Tek tek öğeleri işleyebilirsiniz

      conList.add(TextEditingController(text: "1"));

      List<dynamic> gelenFiyatVeIskonto =
          stokKartEx.fiyatgetir(item, widget.cariKod!, fiyatListesi[0]);

      item.guncelDegerler!.fiyat =
          double.parse(gelenFiyatVeIskonto[0].toString());
      item.guncelDegerler!.iskonto =
          double.parse(gelenFiyatVeIskonto[1].toString());
      item.guncelDegerler!.seciliFiyati = gelenFiyatVeIskonto[2].toString();
      item.guncelDegerler!.fiyatDegistirMi = gelenFiyatVeIskonto[3];

      item.guncelDegerler!.netfiyat = item.guncelDegerler!.hesaplaNetFiyat();
      if (!fiyatListesiKosul.contains(item.guncelDegerler!.seciliFiyati)) {
        fiyatListesiKosul.add(item.guncelDegerler!.seciliFiyati);
      }
    }

 */
    stokKartEx.tempList.clear();
    if (stokKartEx.searchList.length > 100) {
      for (int i = 0; i < 100; i++) {
        List<dynamic> gelenFiyatVeIskonto = stokKartEx.fiyatgetir(
            stokKartEx.searchList[i],
            widget.cariKod!,
            fiyatListesi[0],
            widget.satisTipi!,Ctanim.seciliSatisFiyatListesi);

        stokKartEx.searchList[i].guncelDegerler!.fiyat =
            double.parse(gelenFiyatVeIskonto[0].toString());
        stokKartEx.searchList[i].guncelDegerler!.iskonto =
            double.parse(gelenFiyatVeIskonto[1].toString());
        stokKartEx.searchList[i].guncelDegerler!.guncelBarkod =
            stokKartEx.searchList[i].KOD;
        stokKartEx.searchList[i].guncelDegerler!.seciliFiyati =
            gelenFiyatVeIskonto[2].toString();
        stokKartEx.searchList[i].guncelDegerler!.fiyatDegistirMi =
            gelenFiyatVeIskonto[3];

        stokKartEx.searchList[i].guncelDegerler!.netfiyat =
            stokKartEx.searchList[i].guncelDegerler!.hesaplaNetFiyat();
        //fiyat listesi koşul arama fonksiyonua gönderiliyor orda ekleme yapsanda buraya eklemez giyatListesiKosulu cTanima ekle !
        if (!Ctanim.fiyatListesiKosul
            .contains(stokKartEx.searchList[i].guncelDegerler!.seciliFiyati)) {
          Ctanim.fiyatListesiKosul
              .add(stokKartEx.searchList[i].guncelDegerler!.seciliFiyati!);
        }
        stokKartEx.tempList.add(stokKartEx.searchList[i]);
      }
    } else {
      for (int i = 0; i < stokKartEx.searchList.length; i++) {
        List<dynamic> gelenFiyatVeIskonto = stokKartEx.fiyatgetir(
            stokKartEx.searchList[i],
            widget.cariKod!,
            fiyatListesi[0],
            widget.satisTipi!,Ctanim.seciliSatisFiyatListesi);
        stokKartEx.searchList[i].guncelDegerler!.guncelBarkod =
            stokKartEx.searchList[i].KOD;
        stokKartEx.searchList[i].guncelDegerler!.carpan = 1;
        stokKartEx.searchList[i].guncelDegerler!.fiyat =
            double.parse(gelenFiyatVeIskonto[0].toString());

        stokKartEx.searchList[i].guncelDegerler!.iskonto =
            double.parse(gelenFiyatVeIskonto[1].toString());
        stokKartEx.searchList[i].guncelDegerler!.seciliFiyati =
            gelenFiyatVeIskonto[2].toString();
        stokKartEx.searchList[i].guncelDegerler!.fiyatDegistirMi =
            gelenFiyatVeIskonto[3];

        stokKartEx.searchList[i].guncelDegerler!.netfiyat =
            stokKartEx.searchList[i].guncelDegerler!.hesaplaNetFiyat();
        //fiyat listesi koşul arama fonksiyonua gönderiliyor orda ekleme yapsanda buraya eklemez giyatListesiKosulu cTanima ekle !
        if (!Ctanim.fiyatListesiKosul
            .contains(stokKartEx.searchList[i].guncelDegerler!.seciliFiyati)) {
          Ctanim.fiyatListesiKosul
              .add(stokKartEx.searchList[i].guncelDegerler!.seciliFiyati!);
        }
        stokKartEx.tempList.add(stokKartEx.searchList[i]);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stokKartEx.searchB("");
  }

  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    double y = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*
            Container(
              color: const Color.fromARGB(255, 121, 184, 240),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Obx(
                    () => Text(
                      "Listelenen Stok:   ${stokKartEx.searchList.length}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.refresh_outlined,
                      color: Colors.white,
                    ),
                  ),
                ]),
              ),
            ),
            */
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .85,
                  height: MediaQuery.of(context).size.height * .12,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 5, left: 8, right: 8),
                    child: TextField(
                      onChanged: ((value) {
                        if (value.length > 0) {
                          stokKartEx.searchC(value, widget.cariKod!, "Fiyat1",
                              widget.satisTipi!,Ctanim.seciliSatisFiyatListesi);
                        }
                      }),
                      controller: editingController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          hintText: "Aranacak kelime (İsim/Kod)",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SimpleBarcodeScannerPage(),
                              ));
                          setState(() {
                            if (res is String) {
                              result = res;
                              editingController.text = result;
                            }
                            stokKartEx.searchC(result, widget.cariKod!,
                                "Fiyat1", widget.satisTipi!,Ctanim.seciliSatisFiyatListesi);
                          });
                        },
                      ),
                      /*
                      const Icon(Icons.mic),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: IconButton(
                          onPressed: () {
                            for (int i = 0; i < fisEx.sonListem.length; i++) {
                              print(fisEx.sonListem[i].CARIADI);
                            }
                          },
                          icon: Image.asset("images/slider.png",
                              height: 60, width: 60),
                        ),
                      ),
                      */
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .70,
              child: Obx(() => ListView.builder(
                  itemCount: stokKartEx.tempList.length,
                  itemBuilder: (context, index) {
                    StokKart stokKart = stokKartEx.tempList[index];

                    var miktar = stokKart.guncelDegerler!.carpan.obs;

                    print("S" + stokKartEx.tempList.length.toString());
                    return Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        elevation: 5,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .70,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, left: 20.0),
                                    child: Text(
                                      stokKart.ADI!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () {
                                      fisEx.listFisStokHareketGetir(
                                          stokKartEx.tempList[index].KOD!);
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(16.0),
                                          ),
                                        ),
                                        builder: (BuildContext context) {
                                          return Container(
                                            padding: EdgeInsets.all(16.0),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Divider(
                                                  thickness: 3,
                                                  indent: 150,
                                                  endIndent: 150,
                                                  color: Colors.grey,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Future.delayed(
                                                        Duration.zero,
                                                        () => showDialog(
                                                            context: context,
                                                            builder: (_) {
                                                              return genel_belge_stok_kart_guncellemeDialog(
                                                                urunListedenMiGeldin: false,
                                                                  stokkart: stokKartEx
                                                                          .tempList[
                                                                      index],
                                                                  stokAdi: stokKartEx
                                                                      .tempList[
                                                                          index]
                                                                      .ADI!,
                                                                  stokKodu: stokKart
                                                                      .guncelDegerler!
                                                                      .guncelBarkod!,
                                                                  KDVOrani: stokKartEx
                                                                      .tempList[
                                                                          index]
                                                                      .SATIS_KDV!,
                                                                  cariKod: widget
                                                                      .cariKod
                                                                      .toString(),
                                                                  fiyat: stokKart
                                                                      .guncelDegerler!
                                                                      .fiyat!,
                                                                  iskonto: stokKart
                                                                      .guncelDegerler!
                                                                      .iskonto!,
                                                               
                                                                  miktar: miktar
                                                                      .value!
                                                                      .toInt());
                                                            }));
                                                  },
                                                  child: ListTile(
                                                    title: Text("Düzenle"),
                                                    leading: Icon(
                                                      Icons.edit,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Future.delayed(
                                                        Duration.zero,
                                                        () => showDialog(
                                                            context: context,
                                                            builder: (_) {
                                                              return genel_belge_gecmis_satis_bilgileri();
                                                            }));
                                                  },
                                                  child: ListTile(
                                                    title: Text(
                                                        "Geçmiş Satış Detayları"),
                                                    leading: Icon(
                                                      Icons.history,
                                                      color: Colors.amber,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Future.delayed(
                                                        Duration.zero,
                                                        () => showDialog(
                                                            context: context,
                                                            builder: (_) {
                                                              return stok_kart_detay_guncel(
                                                                stokKart:
                                                                    stokKart,
                                                              );
                                                            }));
                                                  },
                                                  child: ListTile(
                                                    title: Text("Stoğa Git"),
                                                    leading: Icon(
                                                      Icons.search,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.more_vert))
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: y * .03,
                                    left: x * .07,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: x * .25,
                                          child: Text("Ürün Kodu:",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      Padding(
                                        padding: EdgeInsets.only(left: x * .1),
                                        child: SizedBox(
                                            width: x * .5,
                                            child: Text(stokKart.KOD!)),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: y * .01,
                                    left: x * .07,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: x * .25,
                                          child: Text("Fiyat Seç:",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      Padding(
                                        padding: EdgeInsets.only(left: x * .1),
                                        child: SizedBox(
                                            width: x * .5,
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                  value: stokKartEx
                                                      .tempList[index]
                                                      .guncelDegerler!
                                                      .seciliFiyati,
                                                  items: stokKartEx
                                                              .tempList[index]
                                                              .guncelDegerler!
                                                              .fiyatDegistirMi ==
                                                          false
                                                      ? Ctanim.fiyatListesiKosul
                                                          .map((e) =>
                                                              DropdownMenuItem<String>(
                                                                  value: e,
                                                                  child:
                                                                      Text(e)))
                                                          .toList()
                                                      : fiyatListesi
                                                          .map((e) =>
                                                              DropdownMenuItem<String>(
                                                                  value: e,
                                                                  child:
                                                                      Text(e)))
                                                          .toList(),
                                                  onChanged: stokKartEx
                                                              .tempList[index]
                                                              .guncelDegerler!
                                                              .fiyatDegistirMi ==
                                                          true
                                                      ? (value) {
                                                          setState(() {
                                                            List<dynamic>
                                                                donenListe =
                                                                stokKartEx.fiyatgetir(
                                                                    stokKart,
                                                                    widget
                                                                        .cariKod
                                                                        .toString(),
                                                                    value!,
                                                                    widget
                                                                        .satisTipi!,Ctanim.seciliSatisFiyatListesi);
                                                            stokKartEx
                                                                .tempList[index]
                                                                .guncelDegerler!
                                                                .seciliFiyati = value;
                                                            stokKartEx
                                                                .tempList[index]
                                                                .guncelDegerler!
                                                                .fiyat = donenListe[0];
                                                            stokKartEx
                                                                    .tempList[index]
                                                                    .guncelDegerler!
                                                                    .netfiyat =
                                                                stokKartEx
                                                                    .tempList[
                                                                        index]
                                                                    .guncelDegerler!
                                                                    .hesaplaNetFiyat();
                                                          });
                                                        }
                                                      : null),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: x * .03,
                                    left: x * .07,
                                  ),
                                  child: Container(
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: x * .15,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 14),
                                            child: Text(
                                              "Fiyat",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: x * .05,
                                            child: VerticalDivider(
                                              color: Colors.green,
                                              thickness: 2,
                                              indent: 10,
                                            )),
                                        Padding(
                                          padding:
                                              EdgeInsets.only(left: x * .05),
                                          child: SizedBox(
                                              width: x * .15,
                                              child: Text("İskonto",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ),
                                        SizedBox(
                                            width: x * .05,
                                            child: VerticalDivider(
                                              color: Colors.green,
                                              thickness: 2,
                                              indent: 10,
                                            )),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: x * .05, right: x * .05),
                                          child: SizedBox(
                                              width: x * .15,
                                              child: Text("Net Fiyat",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: x * .03,
                                    left: x * .08,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: x * .05),
                                        child: SizedBox(
                                            width: x * .15,
                                            child: Text(
                                              stokKartEx.tempList[index]
                                                  .guncelDegerler!.fiyat!
                                                  .toStringAsFixed(2),
                                            )),
                                      ),
                                      SizedBox(
                                          width: x * .03,
                                          child: Text(" ",
                                              style: TextStyle(fontSize: 15))),
                                      Padding(
                                        padding: EdgeInsets.only(left: x * .05),
                                        child: SizedBox(
                                            width: x * .15,
                                            child: Text(stokKartEx
                                                .tempList[index]
                                                .guncelDegerler!
                                                .iskonto!
                                                .toStringAsFixed(2))),
                                      ),
                                      SizedBox(
                                          width: x * .03,
                                          child: Text(" ",
                                              style: TextStyle(fontSize: 15))),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: x * .05, right: x * .04),
                                        child: SizedBox(
                                          width: x * .15,
                                          child: Text(stokKartEx.tempList[index]
                                              .guncelDegerler!.netfiyat!
                                              .toStringAsFixed(2)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: x * .05,
                                      left: x * .07,
                                      bottom: x * .05),
                                  child: Container(
                                    height: 35,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(
                                          () => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                FloatingActionButton(
                                                  onPressed: () {
                                                    if (miktar.value! -
                                                            stokKart
                                                                .guncelDegerler!
                                                                .carpan! >
                                                        0) {
                                                      miktar.value = miktar
                                                              .value! -
                                                          stokKart
                                                              .guncelDegerler!
                                                              .carpan!;
                                                    }
                                                  },
                                                  backgroundColor: Colors.red,
                                                  child: Icon(Icons.remove),
                                                ),
                                                SizedBox(
                                                  width: x * .1,
                                                  child: Text((miktar.value)
                                                      .toString()),
                                                ),
                                                FloatingActionButton(
                                                  onPressed: () {
                                                    miktar.value =
                                                        miktar.value! +
                                                            stokKart
                                                                .guncelDegerler!
                                                                .carpan!;
                                                    print(miktar.value);

                                                    /*
                                                  int a = int.parse(
                                                      conList[index].text);
                                                  a = a +
                                                      (stokKart.guncelDegerler!
                                                              .carpan)
                                                          .toInt();
                                                  conList[index].text =
                                                      a.toString();
                                                      */
                                                  },
                                                  backgroundColor: Colors.green,
                                                  child: Icon(Icons.add),
                                                ),
                                              ]),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: x * .05, right: x * .05),
                                          child: SizedBox(
                                              width: x * .3,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.blue),
                                                child: Text("Sepete Ekle"),
                                                onPressed: () {
                                                  int birimID = -1;
                                                  for (var element in listeler
                                                      .listOlcuBirim) {
                                                    if (stokKart.OLCUBIRIM1 ==
                                                        element.ACIKLAMA) {
                                                      birimID = element.ID!;
                                                    }
                                                  }

                                                  int dovizID = -1;
                                                  double kur = 0.0;
                                                  String dovizAdi = "";
                                                  listeler.listKur
                                                      .forEach((element) {
                                                    if (element.ACIKLAMA ==
                                                        stokKart.SATDOVIZ) {
                                                      dovizID = element.ID!;
                                                      kur = element.KUR!;
                                                      dovizAdi =
                                                          element.ACIKLAMA!;
                                                    }
                                                  });
                                                  double KDVTUtarTemp = stokKart
                                                          .guncelDegerler!
                                                          .fiyat! *
                                                      (1 +
                                                          (stokKart
                                                              .SATIS_KDV!));
                                                  {
                                                    fisEx.fiseStokEkle(
                                                      urunListedenMiGeldin: false,
                                                      stokAdi: stokKart.ADI!,
                                                      KDVOrani: double.parse(
                                                          stokKart.SATIS_KDV
                                                              .toString()),
                                                      birim:
                                                          stokKart.OLCUBIRIM1!,
                                                      birimID: birimID,
                                                      dovizAdi: dovizAdi,
                                                      dovizId: dovizID,
                                                      burutFiyat: stokKart
                                                          .guncelDegerler!
                                                          .fiyat!,
                                                      iskonto: stokKart
                                                          .guncelDegerler!
                                                          .iskonto!,
                                                      iskonto2: 0.0,
                                                      miktar: (miktar.value)!
                                                          .toInt(),
                                                      stokKodu: stokKart
                                                          .guncelDegerler!
                                                          .guncelBarkod!,
                                                      Aciklama1: '',
                                                      KUR: kur,
                                                      TARIH: DateFormat(
                                                              "yyyy-MM-dd")
                                                          .format(
                                                              DateTime.now()),
                                                      UUID: fisEx
                                                          .fis!.value.UUID!,
                                                    );
                                                    Ctanim.genelToplamHesapla(
                                                        fisEx);
                                                    Get.snackbar(
                                                      "Stok eklendi",
                                                      (miktar.value)
                                                              .toString() +
                                                          " adet ürün sepete eklendi ! ",
                                                      //sepette ${sepettekiStok.length} adet stok var",
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      duration: Duration(
                                                          milliseconds: 800),
                                                      backgroundColor:
                                                          Colors.blue,
                                                      colorText: Colors.white,
                                                    );
                                                    miktar.value = stokKart
                                                        .guncelDegerler!.carpan;
                                                  }
                                                },
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .2,
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
            )
          ],
        ),
      ),
    );
  }
}
