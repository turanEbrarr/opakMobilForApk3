import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:opak_mobil_v2/interaktif_rapor/interaktifRaporGenelModel.dart';
import 'package:opak_mobil_v2/interaktif_rapor/interaktif_rapor_detay.dart';
import 'package:opak_mobil_v2/webservis/base.dart';
import 'package:opak_mobil_v2/widget/appbar.dart';
import '../stok_kart/Spinkit.dart';
import '../widget/ctanim.dart';
import '../widget/customAlertDialog.dart';
import '../widget/veriler/listeler.dart';

class interaktif_rapor_main_page extends StatefulWidget {
  const interaktif_rapor_main_page({super.key});

  @override
  State<interaktif_rapor_main_page> createState() =>
      _interaktif_rapor_main_pageState();
}

class _interaktif_rapor_main_pageState
    extends State<interaktif_rapor_main_page> {
  BaseService bs = BaseService();
  Widget takvimWidgetOlustur(Map<String, dynamic> data) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * .8,
      child: Container(
        color: Color.fromARGB(255, 30, 38, 45),
        child: ElevatedButton(
          onPressed: () async {
            String date = await Ctanim.pickDate(context);
            if (date == "") return;
            setState(() {
              data["obje"].SQL = date;
              print("PARAMID: " + data["obje"].ID.toString());
              print("COLID" + data["degiskenAdi"]);
              print("turanBaba" + data["obje"].SQL);
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 30, 38, 45),
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(data["obje"].COLNAME),
        ),
      ),
    );
  }

  Widget stringWidgetOlustur(Map<String, dynamic> data) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * .8,
      child: TextFormField(
        cursorColor: Color.fromARGB(255, 30, 38, 45),
        controller: data["controller"],
        onChanged: (value) {
          data["obje"].SQL = value.toString();
          print("STRİNG İÇERİK:" + data["obje"].SQL.toString());
        },
        decoration: InputDecoration(
          suffixIcon: IconButton(
              color: Color.fromARGB(255, 30, 38, 45),
              onPressed: () {
                print("CONT İÇERİK:" + data["controller"].text.toString());
              },
              icon: Icon(Icons.clear)),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 3, color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 2, color: Color.fromARGB(255, 30, 38, 45))),
          hintText: data["degiskenAdi"],
        ),
      ),
    );
  }

  Widget decimalWidgetOlustur(Map<String, dynamic> data) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * .8,
        child: TextField(
          keyboardType: TextInputType.number,
          controller: data["controller"],
          onChanged: (value) {
            data["obje"].SQL = value.toString();
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
                color: Color.fromARGB(255, 30, 38, 45),
                onPressed: () {
                  //  belgeNo.text = "";
                },
                icon: Icon(Icons.clear)),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Color.fromARGB(255, 30, 38, 45))),
            hintText: data["degiskenAdi"],
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            //  FilteringTextInputFormatter.digitsOnly,
          ],
        ));
  }

  Widget boolWidgetOlustur(Map<String, dynamic> data) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * .8,
      child: CheckboxListTile(
        title: Text(data["degiskenAdi"]),
        value: data["value"],
        onChanged: (newValue) {
          setState(() {
            data["value"] = newValue ?? false;
            data["obje"].SQL = newValue.toString();
          });
        },
      ),
    );
  }

  Widget intWidgetOlustur(Map<String, dynamic> data) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * .8,
        height: MediaQuery.of(context).size.height * 0.07,
        child: TextField(
          controller: data["controller"],
          onChanged: (value) {
            data["obje"].SQL = value.toString();
          },
          decoration: InputDecoration(
            suffixIcon: IconButton(
                color: Color.fromARGB(255, 30, 38, 45),
                onPressed: () {
                  //  belgeNo.text = "";
                },
                icon: Icon(Icons.clear)),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 3, color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2, color: Color.fromARGB(255, 30, 38, 45))),
            hintText: data["degiskenAdi"],
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            FilteringTextInputFormatter.digitsOnly,
          ],
        ));
  }

  List<Widget> widgetList = [];
  List<Map<String, dynamic>> params = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(height: 50, title: "İnteraktif Rapor"),
        body: ListView.builder(
            itemCount: listeler.listInteraktifRapor.length,
            itemBuilder: ((context, index) {
              return Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        )),
                        child: ListTile(
                          leading: SizedBox(
                            width: 40,
                            height: 40,
                            child: Image.asset('images/report.png'),
                          ),
                          title: Text(
                            ' ${listeler.listInteraktifRapor[index].ADI}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            print("bass");
                            if (listeler
                                    .listInteraktifRapor[index].params!.length >
                                0) {
                              params.clear();
                              widgetList.clear();
                              for (var element in listeler
                                  .listInteraktifRapor[index].params!) {
                                if (element!.COLTYPE == "System.DateTime") {
                                  Map<String, dynamic> data = {
                                    "degiskenAdi": element.COLNAME,
                                    "obje": element
                                  };
                                  params.add(data);
                                  widgetList.add(takvimWidgetOlustur(data));
                                } else if (element.COLTYPE == "System.String") {
                                  TextEditingController s1 =
                                      TextEditingController();
                                  Map<String, dynamic> data = {
                                    "degiskenAdi": element.COLNAME,
                                    "obje": element,
                                    "controller": s1
                                  };
                                  params.add(data);
                                  widgetList.add(stringWidgetOlustur(data));
                                } else if (element.COLTYPE == "System.Int32") {
                                  TextEditingController s1 =
                                      TextEditingController();
                                  Map<String, dynamic> data = {
                                    "degiskenAdi": element.COLNAME,
                                    "obje": element,
                                    "controller": s1
                                  };
                                  params.add(data);

                                  widgetList.add(intWidgetOlustur(data));
                                } else if (element.COLTYPE ==
                                    "System.Decimal") {
                                  TextEditingController s1 =
                                      TextEditingController();
                                  Map<String, dynamic> data = {
                                    "degiskenAdi": element.COLNAME,
                                    "obje": element,
                                    "controller": s1
                                  };
                                  params.add(data);

                                  widgetList.add(decimalWidgetOlustur(data));
                                } else if (element.COLTYPE ==
                                    "System.Boolean") {
                                  bool value = false;
                                  Map<String, dynamic> data = {
                                    "degiskenAdi": element.COLNAME,
                                    "obje": element,
                                    "value": value
                                  };
                                  params.add(data);

                                  String tittle = element.COLNAME!;
                                  widgetList.add(boolWidgetOlustur(data));
                                }
                              }
                              if (params.length > 0) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      print("Basildi");
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .7,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .8,
                                        child: AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32.0))),
                                          insetPadding: EdgeInsets.zero,
                                          title: Text(
                                            "   Parametre Seçimi",
                                            style: TextStyle(fontSize: 17),
                                          ),
                                          content: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .7,
                                            height: ((params.length + 1) *
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.07) +
                                                100,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    height:
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .height *
                                                                0.07 *
                                                                params.length) +
                                                            ((params.length -
                                                                    1) *
                                                                10),
                                                    child: ListView.builder(
                                                      itemCount:
                                                          widgetList.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          children: [
                                                            widgetList[index],
                                                            SizedBox(
                                                              height: 10,
                                                            )
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 65),
                                                    child: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.07,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .8,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                      .green),
                                                          onPressed: () async {
                                                            for (var element
                                                                in params) {
                                                              print(element[
                                                                      "obje"]
                                                                  .ID);
                                                              print(element[
                                                                  "degiskenAdi"]);
                                                              print(element[
                                                                      "obje"]
                                                                  .SQL);
                                                            }

                                                            List<Param>
                                                                sonList = [];
                                                            for (var element
                                                                in params) {
                                                              sonList.add(
                                                                  element[
                                                                      "obje"]);
                                                            }

                                                            List<
                                                                    Map<String,
                                                                        dynamic>>
                                                                jj = sonList
                                                                    .map((fis1) =>
                                                                        fis1.toJson())
                                                                    .toList();
                                                            var son =
                                                                json.encode(jj);
                                                            if (await Connectivity()
                                                                    .checkConnectivity() ==
                                                                ConnectivityResult
                                                                    .none) {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return CustomAlertDialog(
                                                                      align: TextAlign
                                                                          .center,
                                                                      title:
                                                                          'Hata',
                                                                      message:
                                                                          "İnternet Bağlantısı Bulunamadı!",
                                                                      onPres:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      buttonText:
                                                                          'Tamam',
                                                                    );
                                                                  });
                                                            } else {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    false,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return LoadingSpinner(
                                                                    color: Colors
                                                                        .black,
                                                                    message:
                                                                        "${listeler.listInteraktifRapor[index].ADI} Raporu Hazırlanıyor...",
                                                                  );
                                                                },
                                                              );
                                                            }

                                                            List<List<dynamic>>
                                                                gelen =
                                                                await bs.getirSonucInteraktifRapor(
                                                                    rapor: son,
                                                                    sirket: Ctanim
                                                                        .sirket!);
                                                            if (gelen[0].length ==
                                                                    1 &&
                                                                gelen[1].length ==
                                                                    0) {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return CustomAlertDialog(
                                                                    align:
                                                                        TextAlign
                                                                            .left,
                                                                    title: gelen[0][0] ==
                                                                            "Veri Bulunamadı"
                                                                        ? "Kayıtlı Belge Yok"
                                                                        : "Hata",
                                                                    message: gelen[0][0] ==
                                                                            "Veri Bulunamadı"
                                                                        ? 'İstenilen Belge Mevcut Değil'
                                                                        : 'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                                                                            gelen[0][0],
                                                                    onPres: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    buttonText:
                                                                        'Geri',
                                                                  );
                                                                },
                                                              );
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          interaktif_rapor_detay(
                                                                            baslik:
                                                                                listeler.listInteraktifRapor[index].ADI!,
                                                                            gelenBakiyeRapor:
                                                                                gelen,
                                                                            gelenFiltre: [],
                                                                          )));
                                                            }
                                                          },
                                                          child:
                                                              Text("GÖNDER")),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                // rapora git
                              }
                            }
                          },
                        ),
                      )),
                  Divider(
                    thickness: 2,
                  )
                ],
              );
            })));
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,1000}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
