import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:opak_mobil_v2/cari_kart/yeni_cari_olustur.dart';
import 'package:opak_mobil_v2/controllers/cariController.dart';
import 'package:opak_mobil_v2/controllers/fisController.dart';
import 'package:opak_mobil_v2/genel_belge.dart/genel_belge_tab_page.dart';
import 'package:opak_mobil_v2/webservis/base.dart';
import 'package:opak_mobil_v2/webservis/satisTipiModel.dart';
import 'package:opak_mobil_v2/webservis/stokFiyatListesiModel.dart';

import 'package:opak_mobil_v2/widget/appbar.dart';
import 'package:opak_mobil_v2/widget/veriler/listeler.dart';
import '../widget/cari.dart';
import '../widget/ctanim.dart';
import 'package:uuid/uuid.dart';


class genel_belge_cari_page extends StatefulWidget {
  const genel_belge_cari_page(
      {super.key, required this.fis_ID, required this.belgetipi});
  final int? fis_ID;
  final String belgetipi;

  @override
  State<genel_belge_cari_page> createState() => _genel_belge_cari_pageState();
}

class _genel_belge_cari_pageState extends State<genel_belge_cari_page> {
  BaseService bs = BaseService();

  var uuid = Uuid();
  final CariController cariEx = Get.find();
  TextEditingController editController = TextEditingController();
  TextEditingController belgeNo = TextEditingController();
  final FisController fisEx = Get.find();

  Color randomColor() {
    Random random = Random();
    int red = random.nextInt(128); // 0-127 arasında rastgele bir değer
    int green = random.nextInt(128);
    int blue = random.nextInt(128);
    return Color.fromARGB(255, red, green, blue);
  }


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
        if (listeler.listStokFiyatListesi.isNotEmpty) {
      Ctanim.seciliSatisFiyatListesi = listeler.listStokFiyatListesi.first;
    
    
    } else {
      Ctanim.seciliSatisFiyatListesi =
          StokFiyatListesiModel(ADI: "",ID: -1);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cariEx.searchCari("");
  }

  @override
  Widget build(BuildContext context) {
    print("A" + Ctanim.seciliIslemTip!.TIP!);
 
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_arrow,
        backgroundColor: Color.fromARGB(255, 30, 38, 45),
        buttonSize: Size(65, 65),
        children: [
          SpeedDialChild(
              backgroundColor: Color.fromARGB(255, 70, 89, 105),
              child: Icon(
                Icons.add,
                color: Colors.green,
                size: 32,
              ),
              label: "Yeni Cari Oluştur",
              onTap: () {
                Get.to(const yeni_cari_olustur());
              }),
          SpeedDialChild(
              backgroundColor: Color.fromARGB(255, 70, 89, 105),
              child: Icon(
                Icons.refresh,
                color: Colors.amber,
                size: 32,
              ),
              label: "Carilerimi Güncelle",
              onTap: () async {
                await cariEx.servisCariGetir();
              }),
        ],
      ),
      appBar: MyAppBar(
        title: Ctanim().MapFisTR[widget.belgetipi].toString(),
        height: 50,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 247, 245, 245),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(),
                          ),
                          child: TextFormField(
                            onChanged: (value) => cariEx.searchCari(value),
                            cursorColor: Color.fromARGB(255, 60, 59, 59),
                            decoration: InputDecoration(
                                icon: Icon(Icons.search),
                                iconColor: Color.fromARGB(255, 60, 59, 59),
                                hintText: "Cari Adı / Cari Kodu / İl" ,
                                border: InputBorder.none),
                          )),
                    ),
                  ),
                  /*
                  Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset("images/slider.png",
                            height: 60, width: 60),
                      )),
                      */
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .8,
              child: Obx(() => ListView.builder(
                    itemCount: cariEx.searchCariList.length,
                    itemBuilder: (context, index) {
                      Cari cariKart = cariEx.searchCariList[index];
                      String trim = cariKart.ADI!.trim();
                      String harf1 = "";
                      String harf2 = "";
                      harf1 = trim[0];
                      if (trim.length == 1) {
                        harf2 = "K";
                      } else {
                        harf2 = trim[1];
                      }
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5, top: 1, bottom: 1),
                        child: Column(
                          children: [
                            Container(
                              // color: Colors.grey[100],
                              color: Colors.blue[70],
                              child: Column(
                                children: [
                                  ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: randomColor(),
                                        child: Text(
                                          harf1 + harf2,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      title: Text(
                                        cariKart.ADI!,
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(cariKart.IL.toString()),
                                      ),
                                      trailing: Text(Ctanim.donusturMusteri(
                                              cariKart.BAKIYE.toString()) +
                                          " ₺"),
                                      onTap: () {
                                        if (widget.belgetipi ==
                                                "Alinan_Siparis" ||
                                            widget.belgetipi ==
                                                "Alis_Irsaliye") {
                                          Ctanim.seciliIslemTip =
                                              SatisTipiModel(
                                                  ID: -1,
                                                  TIP: "",
                                                  FIYATTIP: "",
                                                  ISK1: "",
                                                  ISK2: "");
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  32.0))),
                                                  insetPadding: EdgeInsets.zero,
                                                  title: Text(
                                                    "   Belge Numarası Girişi",
                                                    style:
                                                        TextStyle(fontSize: 17),
                                                  ),
                                                  content: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: TextFormField(
                                                            cursorColor:
                                                                Color.fromARGB(
                                                                    255,
                                                                    30,
                                                                    38,
                                                                    45),
                                                            controller: belgeNo,
                                                            decoration:
                                                                InputDecoration(
                                                              suffixIcon:
                                                                  IconButton(
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          30,
                                                                          38,
                                                                          45),
                                                                      onPressed:
                                                                          () {
                                                                        belgeNo.text =
                                                                            "";
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .clear)),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 3,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      width: 2,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          30,
                                                                          38,
                                                                          45))),
                                                              hintText:
                                                                  'Belge No',
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  3.5,
                                                              height: 50,
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            4),
                                                                child: ElevatedButton(
                                                                    child: Text(
                                                                      "Tamam",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                    style: ElevatedButton.styleFrom(
                                                                        foregroundColor: Colors.white,
                                                                        backgroundColor: Color.fromARGB(255, 30, 38, 45),
                                                                        shadowColor: Colors.black,
                                                                        elevation: 0,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10.0)),
                                                                        )),
                                                                    onPressed: () {
                                                                      if (belgeNo
                                                                              .text !=
                                                                          "") {
                                                                        int anaBirimID =
                                                                            0;
                                                                        double
                                                                            kurGelen =
                                                                            0.0;
                                                                        String
                                                                            doviAdi =
                                                                            "";
                                                                        for (var kur
                                                                            in listeler.listKur) {
                                                                          if (kur.ANABIRIM ==
                                                                              "E") {
                                                                            anaBirimID =
                                                                                kur.ID!;
                                                                            kurGelen =
                                                                                kur.KUR!;
                                                                            doviAdi =
                                                                                kur.ACIKLAMA!;
                                                                          }
                                                                        }
                                                                        fisEx
                                                                            .fis!
                                                                            .value
                                                                            .BELGENO = belgeNo.text;
                                                                        fisEx
                                                                            .fis!
                                                                            .value
                                                                            .DOVIZ = doviAdi;
                                                                        fisEx
                                                                            .fis!
                                                                            .value
                                                                            .DOVIZID = anaBirimID;
                                                                        fisEx
                                                                            .fis!
                                                                            .value
                                                                            .KUR = kurGelen;

                                                                        fisEx
                                                                            .fis!
                                                                            .value
                                                                            .DEPOID = int.parse(Ctanim.kullanici!.YERELDEPOID!);
                                                                        fisEx
                                                                            .fis!
                                                                            .value
                                                                            .SUBEID = int.parse(Ctanim.kullanici!.YERELSUBEID!);
                                                                        fisEx
                                                                            .fis
                                                                            ?.value
                                                                            .CARIKOD = cariEx.searchCariList[index].KOD;
                                                                        fisEx
                                                                            .fis
                                                                            ?.value
                                                                            .CARIADI = cariEx.searchCariList[index].ADI;
                                                                        fisEx
                                                                            .fis
                                                                            ?.value
                                                                            .cariKart = cariEx
                                                                                .searchCariList[
                                                                            index];
                                                                        fisEx
                                                                            .fis!
                                                                            .value
                                                                            .UUID = uuid.v1();
                                                                        fisEx
                                                                            .fis!
                                                                            .value
                                                                            .PLASIYERKOD = Ctanim.kullanici!.KOD;
                                                                        fisEx
                                                                            .fis
                                                                            ?.value
                                                                            .VADEGUNU = "0";
                                                                        fisEx
                                                                            .fis
                                                                            ?.value
                                                                            .ISLEMTIPI = "0";
                                                                        Get.to(() =>
                                                                            genel_belge_tab_page(
                                                                               stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                                                                              satisTipi: Ctanim.seciliIslemTip!,
                                                                              belgeTipi: widget.belgetipi,
                                                                              cariKod: cariEx.searchCariList[index].KOD,
                                                                              cariKart: cariEx.searchCariList[index],
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
                                        } 
                                        if(listeler.listStokFiyatListesi.isEmpty){
                                         if (listeler
                                                .listSatisTipiModel.length >
                                            0) {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder:
                                                      (context, setState) =>
                                                          AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0))),
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    title: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      child: Text(
                                                        "Satış Tipi Seçiniz",
                                                        style: TextStyle(
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                    content: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child: DropdownButton<
                                                            SatisTipiModel>(
                                                          value: Ctanim
                                                              .seciliIslemTip,
                                                          items: listeler
                                                              .listSatisTipiModel
                                                              .map(
                                                                  (SatisTipiModel
                                                                      banka) {
                                                            return DropdownMenuItem<
                                                                SatisTipiModel>(
                                                              value: banka,
                                                              child: Text(
                                                                banka.TIP ?? "",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged:
                                                              (SatisTipiModel?
                                                                  selected) {
                                                            setState(() {
                                                              Ctanim.seciliIslemTip =
                                                                  selected!;
                                                              print("B" +
                                                                  Ctanim
                                                                      .seciliIslemTip!
                                                                      .TIP!);
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 15),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3.5,
                                                          height: 50,
                                                          child: ElevatedButton(
                                                              child: Text(
                                                                "İptal",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      backgroundColor:
                                                                          Color.fromARGB(
                                                                              255,
                                                                              30,
                                                                              38,
                                                                              45),
                                                                      shadowColor:
                                                                          Colors
                                                                              .black,
                                                                      elevation:
                                                                          0,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10.0)),
                                                                      )),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              }),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .15,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 15),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3.5,
                                                          height: 50,
                                                          child: ElevatedButton(
                                                              child: Text(
                                                                "Tamam",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      backgroundColor:
                                                                          Color.fromARGB(
                                                                              255,
                                                                              30,
                                                                              38,
                                                                              45),
                                                                      shadowColor:
                                                                          Colors
                                                                              .black,
                                                                      elevation:
                                                                          0,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10.0)),
                                                                      )),
                                                              onPressed: () {
                                                                if (Ctanim
                                                                        .seciliIslemTip !=
                                                                    null) {
                                                                  int anaBirimID =
                                                                      0;
                                                                  double
                                                                      kurGelen =
                                                                      0.0;
                                                                  String
                                                                      doviAdi =
                                                                      "";
                                                                  for (var kur
                                                                      in listeler
                                                                          .listKur) {
                                                                    if (kur.ANABIRIM ==
                                                                        "E") {
                                                                      anaBirimID =
                                                                          kur.ID!;
                                                                      kurGelen =
                                                                          kur.KUR!;
                                                                      doviAdi =
                                                                          kur.ACIKLAMA!;
                                                                    }
                                                                  }
                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .DOVIZ =
                                                                      doviAdi;
                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .DOVIZID =
                                                                      anaBirimID;
                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .KUR =
                                                                      kurGelen;

                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .DEPOID =
                                                                      int.parse(Ctanim
                                                                          .kullanici!
                                                                          .YERELDEPOID!);
                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .SUBEID =
                                                                      int.parse(Ctanim
                                                                          .kullanici!
                                                                          .YERELSUBEID!);

                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .UUID =
                                                                      uuid.v1();
                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .PLASIYERKOD =
                                                                      Ctanim
                                                                          .kullanici!
                                                                          .KOD;
                                                                  fisEx
                                                                      .fis
                                                                      ?.value
                                                                      .VADEGUNU = "0";
                                                                  fisEx
                                                                      .fis
                                                                      ?.value
                                                                      .ISLEMTIPI = "0";
                                                                  fisEx
                                                                          .fis
                                                                          ?.value
                                                                          .CARIKOD =
                                                                      cariEx
                                                                          .searchCariList[
                                                                              index]
                                                                          .KOD;
                                                                  fisEx
                                                                          .fis
                                                                          ?.value
                                                                          .CARIADI =
                                                                      cariEx
                                                                          .searchCariList[
                                                                              index]
                                                                          .ADI;
                                                                  fisEx
                                                                      .fis
                                                                      ?.value
                                                                      .cariKart = cariEx
                                                                          .searchCariList[
                                                                      index];
                                                                  Get.to(() =>
                                                                      genel_belge_tab_page(
                                                                        stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                                                                        satisTipi:
                                                                            Ctanim.seciliIslemTip!,
                                                                        belgeTipi:
                                                                            widget.belgetipi,
                                                                        cariKod: cariEx
                                                                            .searchCariList[index]
                                                                            .KOD,
                                                                        cariKart:
                                                                            cariEx.searchCariList[index],
                                                                      ));
                                                                }
                                                              }),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              });
                                        } 
                                        else if (listeler
                                                .listSatisTipiModel.length ==
                                            0) {
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
                                              cariEx.searchCariList[index].KOD;
                                          fisEx.fis?.value.CARIADI =
                                              cariEx.searchCariList[index].ADI;
                                          fisEx.fis?.value.cariKart =
                                              cariEx.searchCariList[index];
                                          Get.to(() => genel_belge_tab_page(
                                             stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                                                satisTipi:
                                                    Ctanim.seciliIslemTip!,
                                                belgeTipi: widget.belgetipi,
                                                cariKod: cariEx
                                                    .searchCariList[index].KOD,
                                                cariKart: cariEx
                                                    .searchCariList[index],
                                              ));
                                        }
                                        }
                                        else{
                                          print(Ctanim.seciliSatisFiyatListesi.ADI);
                                          print(listeler.listStokFiyatListesi.length);
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder:
                                                      (context, setState) =>
                                                          AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0))),
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    title: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      child: Text(
                                                        "Stok Fiyat Listesi Seçiniz",
                                                        style: TextStyle(
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                    content: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 15),
                                                      child:
                                                          DropdownButtonHideUnderline(
                                                        child: DropdownButton<
                                                            StokFiyatListesiModel>(
                                                          value: Ctanim
                                                              .seciliSatisFiyatListesi,
                                                          items: listeler
                                                              .listStokFiyatListesi
                                                              .map(
                                                                  (StokFiyatListesiModel
                                                                      banka) {
                                                            return DropdownMenuItem<
                                                                StokFiyatListesiModel>(
                                                              value: banka,
                                                              child: Text(
                                                                banka.ADI ?? "",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            );
                                                          }).toList(),
                                                          onChanged:
                                                              (StokFiyatListesiModel?
                                                                  selected) {
                                                            setState(() {
                                                              Ctanim.seciliSatisFiyatListesi =
                                                                  selected!;
                                                            
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 15),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3.5,
                                                          height: 50,
                                                          child: ElevatedButton(
                                                              child: Text(
                                                                "İptal",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      backgroundColor:
                                                                          Color.fromARGB(
                                                                              255,
                                                                              30,
                                                                              38,
                                                                              45),
                                                                      shadowColor:
                                                                          Colors
                                                                              .black,
                                                                      elevation:
                                                                          0,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10.0)),
                                                                      )),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              }),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .15,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 15),
                                                        child: SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3.5,
                                                          height: 50,
                                                          child: ElevatedButton(
                                                              child: Text(
                                                                "Tamam",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      foregroundColor:
                                                                          Colors
                                                                              .white,
                                                                      backgroundColor:
                                                                          Color.fromARGB(
                                                                              255,
                                                                              30,
                                                                              38,
                                                                              45),
                                                                      shadowColor:
                                                                          Colors
                                                                              .black,
                                                                      elevation:
                                                                          0,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10.0)),
                                                                      )),
                                                              onPressed: () {
                                                                if (Ctanim
                                                                        .seciliSatisFiyatListesi.ADI !=
                                                                    "Kullanmadan Devam Et") {
                                                                  int anaBirimID =
                                                                      0;
                                                                  double
                                                                      kurGelen =
                                                                      0.0;
                                                                  String
                                                                      doviAdi =
                                                                      "";
                                                                  for (var kur
                                                                      in listeler
                                                                          .listKur) {
                                                                    if (kur.ANABIRIM ==
                                                                        "E") {
                                                                      anaBirimID =
                                                                          kur.ID!;
                                                                      kurGelen =
                                                                          kur.KUR!;
                                                                      doviAdi =
                                                                          kur.ACIKLAMA!;
                                                                    }
                                                                  }
                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .DOVIZ =
                                                                      doviAdi;
                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .DOVIZID =
                                                                      anaBirimID;
                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .KUR =
                                                                      kurGelen;

                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .DEPOID =
                                                                      int.parse(Ctanim
                                                                          .kullanici!
                                                                          .YERELDEPOID!);
                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .SUBEID =
                                                                      int.parse(Ctanim
                                                                          .kullanici!
                                                                          .YERELSUBEID!);

                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .UUID =
                                                                      uuid.v1();
                                                                  fisEx
                                                                          .fis!
                                                                          .value
                                                                          .PLASIYERKOD =
                                                                      Ctanim
                                                                          .kullanici!
                                                                          .KOD;
                                                                  fisEx
                                                                      .fis
                                                                      ?.value
                                                                      .VADEGUNU = "0";
                                                                  fisEx
                                                                      .fis
                                                                      ?.value
                                                                      .ISLEMTIPI = "0";
                                                                  fisEx
                                                                          .fis
                                                                          ?.value
                                                                          .CARIKOD =
                                                                      cariEx
                                                                          .searchCariList[
                                                                              index]
                                                                          .KOD;
                                                                  fisEx
                                                                          .fis
                                                                          ?.value
                                                                          .CARIADI =
                                                                      cariEx
                                                                          .searchCariList[
                                                                              index]
                                                                          .ADI;
                                                                  fisEx
                                                                      .fis
                                                                      ?.value
                                                                      .cariKart = cariEx
                                                                          .searchCariList[
                                                                      index];
                                                                  Get.to(() =>
                                                                      genel_belge_tab_page(
                                                                        stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                                                                        satisTipi:
                                                                            Ctanim.seciliIslemTip!,
                                                                        belgeTipi:
                                                                            widget.belgetipi,
                                                                        cariKod: cariEx
                                                                            .searchCariList[index]
                                                                            .KOD,
                                                                        cariKart:
                                                                            cariEx.searchCariList[index],
                                                                      ));
                                                                }
                                                              }),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              });                                          

                                        }

                                      }),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            )
                          ],
                        ),
                      );
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
