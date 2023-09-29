import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:opak_mobil_v2/controllers/fisController.dart';
import 'package:opak_mobil_v2/genel_belge.dart/genel_belge_gecmis_satis_bilgileri.dart';
import 'package:opak_mobil_v2/genel_belge.dart/genel_belge_stok_kart_guncelleme.dart';
import 'package:opak_mobil_v2/stok_kart/stok_tanim.dart';
import 'package:opak_mobil_v2/widget/ctanim.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../controllers/cariController.dart';
import '../controllers/stokKartController.dart';
import '../controllers/depoController.dart';

import '../faturaFis/fisHareket.dart';

import '../stok_kart/stok_kart_detay_guncel.dart';
import '../widget/cari.dart';
import '../widget/veriler/listeler.dart';

enum SampleItem { itemOne, itemTwo, itemThree }

class sayim_kayit_urun_ara extends StatefulWidget {
  const sayim_kayit_urun_ara({
    super.key,
    required this.cariKod,
  });
  final String? cariKod;

  @override
  State<sayim_kayit_urun_ara> createState() => _sayim_kayit_urun_araState();
}

class _sayim_kayit_urun_araState extends State<sayim_kayit_urun_ara> {
  List<TextEditingController> conList = [];

  TextEditingController editingController = TextEditingController(text: "");
  late String alinanString;

  DateTime now = DateTime.now();
  final StokKartController stokKartEx = Get.find();
  //final CariController cariEx = Get.find();

  final FisController fisExFisControllerOlan = Get.find();
  final SayimController fisEx = Get.find();
  bool flag = false;
  String? rafYok = "RAF SEÇİLMEMİŞ";
  String? seciliRaf;
  List<String> raflar = [];

  String? pu = listeler.listOlcuBirim[0].ACIKLAMA;
  String seciliFiyat = Ctanim().SatisFiyatTip;
  TextStyle boldBlack =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  SampleItem? selectedMenu;
  bool? otomatik = false;
  bool? ayri_ekle = false;

  @override
  void initState() {
    super.initState();

    for (var element in listeler.listRaf) {
      raflar.add(element.RAF!);
    }
    stokKartEx.searchList.forEach((element) {
      conList.add(TextEditingController(text: "1"));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stokKartEx.searchB("");
  }

  String result = '';

  @override
  Widget build(BuildContext context) {
    double x = MediaQuery.of(context).size.width;
    double y = MediaQuery.of(context).size.height;
    print("lenCon" + conList.length.toString());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color.fromARGB(255, 66, 82, 97),
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
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .85,
                  height: MediaQuery.of(context).size.height * .12,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 5, left: 8, right: 8),
                    child: TextField(
                      onChanged: ((value) => stokKartEx.searchB(value)),
                      controller: editingController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(5.0),
                          hintText: "Aranacak kelime (Ünvan/Kod)",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                  child: IconButton(
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
                        stokKartEx.searchB(result);
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Checkbox(
                      value: otomatik,
                      onChanged: (bool? value) {
                        setState(() {
                          otomatik = value;
                        });
                      },
                    ),
                  ),
                  Text("Otomatik Ekle"),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .1,
                  ),
                  Checkbox(
                    value: ayri_ekle,
                    onChanged: (bool? value) {
                      setState(() {
                        ayri_ekle = value;
                      });
                    },
                  ),
                  Text("Ayrı Eklensin"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildDropdown('Raf Seçimi', seciliRaf, raflar,
                  (String? value) {
                flag = true;
                setState(() {
                  seciliRaf = value;
                });
              }),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .70,
              child: Obx(() => ListView.builder(
                  itemCount: stokKartEx.searchList.length,
                  itemBuilder: (context, index) {
                    StokKart stokKart = stokKartEx.searchList[index];
                    String selectedValue = "";
                    String olcuAdet = "1";

                    int hangiBirimSecili = 1;
                    List<String> dropdownItems = [];
                    if (stokKart.OLCUBIRIM1 != "") {
                      dropdownItems.add(stokKart.OLCUBIRIM1!);
                      selectedValue = dropdownItems[0];
                    }
                    if (stokKart.OLCUBIRIM2 != "") {
                      dropdownItems.add(stokKart.OLCUBIRIM2!);
                    }
                    if (stokKart.OLCUBIRIM3 != "") {
                      dropdownItems.add(stokKart.OLCUBIRIM3!);
                    }
                    print("S" + stokKartEx.searchList.length.toString());
                    return Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
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
                                      fisExFisControllerOlan
                                          .listFisStokHareketGetir(stokKartEx
                                              .searchList[index].KOD!);
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
                                                                stokAdi: stokKartEx
                                                                    .searchList[
                                                                        index]
                                                                    .ADI!,
                                                                stokKodu: stokKartEx
                                                                    .searchList[
                                                                        index]
                                                                    .KOD!,
                                                                KDVOrani: stokKartEx
                                                                    .searchList[
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
                                                                miktar: int.parse(
                                                                    conList[index]
                                                                        .text),
                                                                stokkart: stokKartEx
                                                                        .searchList[
                                                                    index],
                                                              );
                                                            }));
                                                  },
                                                  child: ListTile(
                                                    title: Text("Düzenle"),
                                                    leading: Icon(Icons.edit,color: Colors.blue,),
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
                                                    leading:
                                                        Icon(Icons.history,color: Colors.amber,),
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
                                                    leading: Icon(Icons.search,color: Colors.green,),
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
                                SizedBox(
                                  height: 20,
                                ),
                                buildDropdown(
                                    'Birim', selectedValue, dropdownItems,
                                    (String? value) {
                                  setState(() {
                                    if (value == stokKart.OLCUBIRIM1) {
                                    } else if (value == stokKart.OLCUBIRIM2) {
                                      olcuAdet = stokKart.BIRIMADET1!;
                                    } else if (value == stokKart.OLCUBIRIM3) {
                                      olcuAdet = stokKart.BIRIMADET2!;
                                    }
                                    selectedValue = value!;
                                    pu = value;
                                  });
                                }),
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
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FloatingActionButton(
                                                onPressed: () {
                                                  setState(() {
                                                    int a = int.parse(
                                                        conList[index].text);
                                                    if (a > 0) {
                                                      a--;
                                                      conList[index].text =
                                                          a.toString();
                                                    }
                                                  });
                                                },
                                                backgroundColor: Colors.red,
                                                child: Icon(Icons.remove),
                                              ),
                                              SizedBox(
                                                width: x * .1,
                                                child: TextFormField(
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none),
                                                  controller: conList[index],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d+\.?\d{0,2}')),
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              FloatingActionButton(
                                                onPressed: () {
                                                  int a = int.parse(
                                                      conList[index].text);
                                                  a++;
                                                  conList[index].text =
                                                      a.toString();
                                                },
                                                backgroundColor: Colors.green,
                                                child: Icon(Icons.add),
                                              ),
                                            ]),
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
                                                    if (pu ==
                                                        element.ACIKLAMA) {
                                                      birimID = element.ID!;
                                                    }
                                                  }
                                                  int sonMiktar = int.parse(
                                                          conList[index].text) *
                                                      int.parse(olcuAdet);
                                                  double KDVTUtarTemp = stokKart
                                                          .guncelDegerler!
                                                          .fiyat! *
                                                      (1 +
                                                          (stokKart
                                                              .SATIS_KDV!));
                                                  {
                                                    fisEx.DepoaHareketEkle(
                                                      ACIKLAMA: fisEx.sayim!
                                                          .value.ACIKLAMA!,
                                                      BIRIM: pu!,
                                                      BIRIMID: birimID,
                                                      FIYAT: 0.0,
                                                      MIKTAR: sonMiktar,
                                                      RAF: flag == false
                                                          ? rafYok!
                                                          : seciliRaf!,
                                                      SAYIMID: fisEx
                                                          .sayim!.value.ID!,
                                                      STOKADI: stokKart.ADI!,
                                                      STOKKOD: stokKart.KOD!,
                                                      UUID: fisEx
                                                          .sayim!.value.UUID!,
                                                    );
                                                    pu = stokKart.OLCUBIRIM1;
                                                    Get.snackbar(
                                                      "Stok eklendi",
                                                      "${conList[index].text} adet ürün sepete eklendi ! ",
                                                      //sepette ${sepettekiStok.length} adet stok var",
                                                      snackPosition:
                                                          SnackPosition.BOTTOM,
                                                      duration: Duration(
                                                          milliseconds: 800),
                                                      backgroundColor:
                                                          Colors.blue,
                                                      colorText: Colors.white,
                                                    );
                                                    conList[index].text = "1";
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

Widget buildDropdown(String label, String? selectedValue, List<String> items,
    void Function(String?) onChanged) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: DropdownButtonFormField<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    ),
  );
}
