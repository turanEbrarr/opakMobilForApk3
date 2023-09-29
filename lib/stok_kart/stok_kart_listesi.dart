import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opak_mobil_v2/controllers/stokKartController.dart';

import 'package:opak_mobil_v2/stok_kart/stok_kart_detay_guncel.dart';
import 'package:opak_mobil_v2/stok_kart/stok_kart_ekle.dart';
import 'package:opak_mobil_v2/webservis/satisTipiModel.dart';
import 'package:opak_mobil_v2/widget/ctanim.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import '../genel_belge.dart/genel_belge_gecmis_satis_bilgileri.dart';
import 'package:opak_mobil_v2/stok_kart/stok_tanim.dart';
import 'package:opak_mobil_v2/webservis/base.dart';
import 'package:opak_mobil_v2/widget/appbar.dart';
import 'package:opak_mobil_v2/widget/veriler/listeler.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../localDB/databaseHelper.dart';
import '../widget/modeller/sharedPreferences.dart';
import 'Spinkit.dart';

enum SampleItem { itemOne, itemTwo }

class stok_kart_listesi extends StatefulWidget {
  stok_kart_listesi({super.key, required this.widgetListBelgeSira});
  final int widgetListBelgeSira;

  @override
  State<stok_kart_listesi> createState() => _stok_kart_listesiState();
}

class _stok_kart_listesiState extends State<stok_kart_listesi> {
  Color favIconColor = Colors.black;
  String _barcodeResults = '';
  late String alinanString;

  bool isLoading = false;
  final databaseHelper = DatabaseHelper();
  String newToOld = "Yeniden Eskiye";
  String aToZ = "A-Z İsme Göre";
  String zToA = "Z-A İsme Göre";
  String oldToNew = "Eskiden Yeniye";
  BaseService bs = BaseService();
  TextEditingController editingController = TextEditingController();
  TextStyle blackBold =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16);
  TextStyle black = TextStyle(color: Colors.black, fontSize: 16);
  // List<StokKart> stokSearchList = StokKart.liststok_kartSabit;
  bool order = false;
  File? image;
  final StokKartController stokKartEx = Get.find();
  String result = '';

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      //final imageTemporary = File(image.path);
      final imagePermanent = await saveImagePermananetly(image.path);
      setState(() {
        this.image = imagePermanent;
      });
    } on PlatformException catch (e) {
      AlertDialog(
        title: Text("Failed to pick image"),
      );
    }
  }

  Future<File> saveImagePermananetly(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  Future pickImageCam(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      AlertDialog(
        title: Text("Failed to pick image"),
      );
    }
  }

  void zToASort() {
    Comparator<StokKart> sirala2 =
        (a, b) => b.ADI!.toLowerCase().compareTo(a.ADI!.toLowerCase());
    listeler.liststok.sort(sirala2);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stokKartEx.searchC("","","",Ctanim.seciliIslemTip,Ctanim.seciliSatisFiyatListesi);
  }

  SampleItem? selectedMenu;
  @override
  Widget build(BuildContext context) {
    if (listeler.sayfaDurum[widget.widgetListBelgeSira] == true) {
      setState(() {
        favIconColor = Colors.amber;
      });
    } else {
      setState(() {
        favIconColor = Colors.white;
      });
    }
    return Scaffold(
        appBar: MyAppBar(
          height: 50,
          title: "Stok Kart Listesi",
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_arrow,
          backgroundColor: Color.fromARGB(255, 30, 38, 45),
          buttonSize: Size(65, 65),
          children: [
            SpeedDialChild(
                backgroundColor: Color.fromARGB(255, 70, 89, 105),
                child: Icon(
                  Icons.star,
                  color: favIconColor,
                  size: 32,
                ),
                label: favIconColor == Colors.amber
                    ? "Favorilerimden Kaldır"
                    : "Favorilerime Ekle",
                onTap: () async {
                  listeler.sayfaDurum[widget.widgetListBelgeSira] =
                      !listeler.sayfaDurum[widget.widgetListBelgeSira]!;
                  if (listeler.sayfaDurum[widget.widgetListBelgeSira] == true) {
                    setState(() {
                      favIconColor = Colors.amber;
                    });
                  } else {
                    setState(() {
                      favIconColor = Colors.white;
                    });
                  }
                  await SharedPrefsHelper.saveList(listeler.sayfaDurum);
                }),
            SpeedDialChild(
                backgroundColor: Color.fromARGB(255, 70, 89, 105),
                child: Icon(
                  Icons.refresh,
                  color: Colors.green,
                  size: 32,
                ),
                label:
                    "Stokları Güncelle (Anlık Stok Adedi : ${stokKartEx.tempList.length})",
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return LoadingSpinner(
                        color: Colors.black,
                        message:
                            "Stoklar güncelleniyor. Bu işlem biraz zaman alabilir...",
                      );
                    },
                  );
                  await stokKartEx.servisStokGetir();
                  Navigator.pop(context);
                  //stokKartEx.servisStokGetir();  //servisten stokları çekip günceller
                }),
            SpeedDialChild(
                backgroundColor: Color.fromARGB(255, 70, 89, 105),
                child: Icon(
                  Icons.add,
                  color: Colors.blue,
                  size: 32,
                ),
                label: "Yeni Stok Ekle",
                onTap: () {
                  Get.to(stok_kart_olustur());
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .9,
                      height: MediaQuery.of(context).size.height * .12,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          onChanged: ((value) {
                            SatisTipiModel m = SatisTipiModel(
                                ID: -1,
                                TIP: "",
                                FIYATTIP: "",
                                ISK1: "",
                                ISK2: "");
                            stokKartEx.searchC(value, "", "Fiyat1", m,Ctanim.seciliSatisFiyatListesi);
                            // setState(() {});
                          }),
                          controller: editingController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(5.0),
                              hintText: "Aranacak kelime (Ad/Kod)",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)))),
                        ),
                      ),
                    ),
                  ],
                ),
                /*
                Container(
                  width: 30,
                  child: IconButton(
                      onPressed: pickImage, icon: Icon(Icons.image_outlined)
                      //    height: 60, width: 60),
                      ),
                ),
                */
                Padding(
                  padding: const EdgeInsets.only(bottom: 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 20,
                        child: IconButton(
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
                            icon: Icon(Icons.camera_alt)
                            //    height: 60, width: 60),
                            ),
                      ),
                     
                     
                     /* 
                      Container(
                        width: 30,
                        child: IconButton(
                          onPressed: () {},
                          icon: PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    child: Text(aToZ),
                                    value: aToZ,
                                  ),
                                  PopupMenuItem(
                                    child: Text(zToA),
                                    value: zToA,
                                  ),
                                  PopupMenuItem(
                                    child: Text(newToOld),
                                    value: newToOld,
                                  ),
                                  PopupMenuItem(
                                    child: Text(oldToNew),
                                    value: oldToNew,
                                  ),
                                ];
                              },
                              onSelected: (String value) async {
                                if (value == aToZ) {
                                  stokKartEx.aToZSort();
                                  //    stokKartEx.updateStokKartListGuncelle();
                                }
                                if (value == zToA) {
                                  zToASort();
                                  //    stokKartEx.updateStokKartListGuncelle();
                                }
                                /*
                          if (value == newToOld) {
                            newToOldSort();
                            stokKartEx.updateStokKartListGuncelle();
                          }
                          if (value == oldToNew) {
                            oldToNewSort();
                            stokKartEx.updateStokKartListGuncelle();
                          }*/
                              },
                              icon: Icon(Icons.sort)),
                        ),
                      ),
                      */
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .75,
              child: Obx(
                () => Scrollbar(
                  thickness: 10,
                  //isAlwaysShown: true,
                  child: ListView.builder(
                      itemCount: stokKartEx.tempList.length,
                      itemBuilder: (context, index) {
                        StokKart stokKart = stokKartEx.tempList[index];
                        String doviz = "-";
                        if (stokKart.SATDOVIZ != "") {
                          doviz = stokKart.SATDOVIZ!;
                        }
                        return Card(
                            elevation: 5,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    stokKart.ADI! + " (" + doviz + ")",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  trailing: PopupMenuButton<SampleItem>(
                                    onOpened: () {
                                      fisEx.listFisStokHareketGetir(
                                          stokKartEx.tempList[index].KOD!);
                                    },
                                    initialValue: selectedMenu,
                                    // Callback that sets the selected popup menu item.
                                    onSelected: (SampleItem item) {
                                      setState(() {
                                        selectedMenu = item;
                                      });
                                    },

                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<SampleItem>>[
                                      PopupMenuItem<SampleItem>(
                                        value: SampleItem.itemOne,
                                        onTap: () {
                                          Future.delayed(
                                              Duration.zero,
                                              () => showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return genel_belge_gecmis_satis_bilgileri();
                                                  }));
                                        },
                                        child: Text('Geçmiş Satış Detayları'),
                                      ),
                                      PopupMenuItem<SampleItem>(
                                        value: SampleItem.itemTwo,
                                        child: Text('Stok Detay'),
                                        onTap: () {
                                          Future.delayed(
                                              Duration.zero,
                                              () => showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return stok_kart_detay_guncel(
                                                      stokKart: stokKart,
                                                    );
                                                  }));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 1),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(
                                            "Kodu",
                                          ),
                                          subtitle: Text(
                                            stokKart.KOD!,
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          leading: Icon(
                                            Icons.barcode_reader,
                                            color: Colors.green,
                                          ),
                                        ),
                                        ListTile(
                                          title: Text("Marka"),
                                          subtitle: Text(
                                            stokKart.MARKA!,
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          leading: Icon(
                                            Icons.shopping_bag_rounded,
                                            color: Colors.amber,
                                          ),
                                        ),
                                        ListTile(
                                          title: Text("KDV"),
                                          subtitle: Text(
                                            "%" +
                                                stokKart.SATIS_KDV!
                                                    .toStringAsFixed(2),
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          leading: Icon(
                                            Icons.receipt_long,
                                            color: Colors.red,
                                          ),
                                        ),
                                        ListTile(
                                          title: Text("KDV Dahil"),
                                          subtitle: Text(
                                            stokKart.SFIYAT1!
                                                    .toStringAsFixed(2) +
                                                " " +
                                                doviz,
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          leading: Icon(
                                            Icons.price_change,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        ListTile(
                                          title: Text("Miktar "),
                                          subtitle: stokKart
                                                      .BIRIMADET1!.length >
                                                  5
                                              ? Text(
                                                  stokKart.BIRIMADET1!
                                                      .substring(0, 4),
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                )
                                              : Text(
                                                  stokKart.BIRIMADET1!,
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                ),
                                          leading: Icon(
                                            Icons.assignment_outlined,
                                            color: Colors.purple,
                                          ),
                                        )
                                      ],
                                    ))
                              ],
                            ));
                      }),
                ),
              ),
            )
          ]),
        ));
  }

/* void searchB(String query) {
    final suggestion = StokKart.liststok_kartSabit.where((s1) {
      final stitle = s1.sAdi?.toLowerCase();
      final skod = s1.sKodu?.toLowerCase();
      final input = query.toLowerCase();
      return stitle!.contains(input) || skod!.contains(input);
    }).toList();

/*    setState(() {
      stokSearchList.stokKartList. = suggestion;
    });*/
  }*/
}
