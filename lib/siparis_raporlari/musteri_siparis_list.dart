import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:opak_mobil_v2/cari_raporlari/kapatilmamis_faturalar/kapatilmamis_faturalar_pdf_onizleme.dart';
import 'package:opak_mobil_v2/cari_raporlari/pdf/cari_rapor_pdf_onizleme.dart';
import 'package:opak_mobil_v2/siparis_raporlari/musteri_siparis_detay_rapor.dart';
import 'package:opak_mobil_v2/webservis/base.dart';
import 'package:opak_mobil_v2/widget/appbar.dart';
import 'package:opak_mobil_v2/widget/ctanim.dart';

import '../../widget/modeller/sharedPreferences.dart';
import '../stok_kart/Spinkit.dart';
import '../widget/cari.dart';
import '../widget/customAlertDialog.dart';

class musteri_siparis_rapor_page extends StatefulWidget {
  final List<List<dynamic>> gelenBakiyeRapor;
  final List<bool> gelenFiltre;
  final Cari cariKart;
  //final String titletemp;
  const musteri_siparis_rapor_page(
      {super.key,
      required this.gelenBakiyeRapor,
      required this.gelenFiltre,
      required this.cariKart});

  @override
  State<musteri_siparis_rapor_page> createState() =>
      _musteri_siparis_rapor_pageState();
}

class _musteri_siparis_rapor_pageState
    extends State<musteri_siparis_rapor_page> {
  BaseService bs = BaseService();
  List<String> bakiyeRaporSatirlar = [];
  List<DataColumn> bakiyeRaporKolonlar = [];
  List<String> aramaliBakiyeRaporSatirlar = [];
  List<String> kolonIsimleri = [];
  List<DataColumn> filtreliBakiyeRaporKolonlar = [];

  List<DataRow> satirOlustur({
    required List<DataColumn> gelenDurumKolonlar,
    required List<String> gelenDurumSatirlar,
  }) {
    int genelcolsayisi = widget.gelenBakiyeRapor[1].length;
    int fark = widget.gelenBakiyeRapor[1].length - gelenDurumKolonlar.length;
    int enSonEklenen = 0;
    List<DataRow> donecek = [];
    for (int i = 0; i < gelenDurumSatirlar.length / genelcolsayisi; i++) {
      List<DataCell> donecekDataCell = [];

      for (DataColumn element in widget.gelenBakiyeRapor[1]) {
        if (element.label is Text) {
          String labelText = (element.label as Text).data ?? '';
          for (DataColumn element1 in gelenDurumKolonlar) {
            String labelText1 = (element1.label as Text).data ?? '';
            if (labelText == labelText1) {
              DataCell newValue = DataCell(Text(
                gelenDurumSatirlar[enSonEklenen],
                style: TextStyle(fontWeight: FontWeight.w400),
              ));

              donecekDataCell.add(newValue);
            }
          }
        }
        enSonEklenen++;
      }

      DataRow dataRowWithInkWell = DataRow(
        cells: donecekDataCell,
        onLongPress: () async {
          String fatID = (donecekDataCell[0].child as Text).data!;
          print("Satıra tıklandı: ${(donecekDataCell[0].child as Text).data}");
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return LoadingSpinner(
                color: Colors.black,
                message: "Muşteri Sipariş Detayları Hazırlanıyor...",
              );
            },
          );

          List<bool> cek = await SharedPrefsHelper.filtreCek(
              "raporMusteriSiparisListesiDetay");
          List<List<dynamic>> gelen = await bs.getirMusteriSiparisDetayRapor(
              sirket: Ctanim.sirket!,
              faturaID: (donecekDataCell[0].child as Text).data!);

          if (gelen[0].length == 1 && gelen[1].length == 0) {
            await showDialog(
              context: context,
              builder: (context) {
                return CustomAlertDialog(
                  align: TextAlign.left,
                  title: gelen[0][0] == "Veri Bulunamadı"
                      ? "Kayıtlı Belge Yok"
                      : "Hata",
                  message: gelen[0][0] == "Veri Bulunamadı"
                      ? 'İstenilen Belge Mevcut Değil'
                      : 'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                          gelen[0][0],
                  onPres: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  buttonText: 'Geri',
                );
              },
            );
          } else {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => musteri_siparis_detay_rapor(
                      gelenFiltre: cek,
                      gelenBakiyeRapor: gelen,
                      carikart: widget.cariKart,
                      faturaID: fatID,
                    )),
              ),
            );
          }
        },
      );

      donecek.add(dataRowWithInkWell);
    }

    return donecek;
  }

  bool veriVarmi = false;

  List<bool> secilenKolonlar = [];

  List<bool> secilenKolonlarIlk = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secilenKolonlar.addAll(widget.gelenFiltre);
    for (int i = 0;
        i < widget.gelenBakiyeRapor[0].length;
        i = i + widget.gelenBakiyeRapor[1].length) {
      for (int j = 0; j < widget.gelenBakiyeRapor[1].length; j++) {
        bakiyeRaporSatirlar.add(widget.gelenBakiyeRapor[0][i + j]);
      }
    }
    for (DataColumn element in widget.gelenBakiyeRapor[1]) {
      bakiyeRaporKolonlar.add(element);
      secilenKolonlarIlk.add(true);
      if (element.label is Text) {
        String labelText = (element.label as Text).data ?? '';
        kolonIsimleri.add(labelText);
      } else {
        kolonIsimleri.add('');
      }
    }

    if (secilenKolonlar.isEmpty) {
      filtreliBakiyeRaporKolonlar.addAll(bakiyeRaporKolonlar);
      secilenKolonlar.addAll(secilenKolonlarIlk);
    } else {
      for (int i = 0; i < secilenKolonlar.length; i++) {
        if (secilenKolonlar[i] == true) {
          filtreliBakiyeRaporKolonlar
              .add(DataColumn(label: Text(kolonIsimleri[i])));
        }
      }
    }

    // filtreliBakiyeRaporKolonlar.addAll(bakiyeRaporKolonlar);

    aramaliBakiyeRaporSatirlar.addAll(bakiyeRaporSatirlar);
  }

  bool ustfiltre = false;
  String aramaTerimi = '';
  String basTar = "";
  String bitTar = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        label: Icon(Icons.picture_as_pdf),
        onPressed: () {
          List<String> temp = [];
          List<List<String>> parcali = [];
          List<List<String>> son = [];

          for (int i = 0;
              i < bakiyeRaporSatirlar.length;
              i = i + bakiyeRaporKolonlar.length) {
            temp = [];
            for (int j = i; j <= i + (bakiyeRaporKolonlar.length - 1); j++) {
              temp.add(bakiyeRaporSatirlar[j]);
            }
            parcali.add(List.from(temp));
          }

          Navigator.pop(context);
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => kapatilmamisFaturalarPdfOnizleme(
                      carikart: widget.cariKart,
                      baslik: "Müsteri Sipariş Raporu",
                      kolonlar: kolonIsimleri,
                      satirlar: parcali,
                    )),
          );
        },
      ),
      appBar: MyAppBar(
        height: 50,
        title: 'Müsteri Sipariş Raporu',
      ),
      body: Column(
        children: [
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: ElevatedButton(
                        onPressed: () async {
                          String date = await Ctanim.pickDate(context);
                          if (date == "") return;
                          setState(() {
                            basTar = date;
                            print(basTar);
                          });
                        },
                        child: Text(
                            basTar != "" ? basTar : "Başlangıç Tarihi Seçiniz"),
                      ),
                    ),
                    SizedBox(width: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: ElevatedButton(
                        onPressed: () async {
                          String date = await Ctanim.pickDate(context);
                          if (date == "") return;
                          setState(() async {
                            bitTar = date;
                            print(bitTar);
                            print("bitti ara");

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return LoadingSpinner(
                                  color: Colors.black,
                                  message:
                                      "Müşteri Sipariş Raporu Hazırlanıyor...",
                                );
                              },
                            );

                            List<bool> cek = await SharedPrefsHelper.filtreCek(
                                "raporMusteriSiparisFiltre");
                            List<List<dynamic>> gelen =
                                await bs.getirMusteriSiparisRapor(
                                    sirket: Ctanim.sirket!,
                                    cariKodu: widget.cariKart!.KOD!,
                                    basTar: basTar,
                                    bitTar: bitTar);

                            if (gelen[0].length == 1 && gelen[1].length == 0) {
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    align: TextAlign.left,
                                    title: gelen[0][0] == "Veri Bulunamadı"
                                        ? 'Kayıtlı Belge Yok'
                                        : "Hata",
                                    message: gelen[0][0] == "Veri Bulunamadı"
                                        ? 'İstenilen Belge Mevcut Değil'
                                        : 'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                                            gelen[0][0],
                                    onPres: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    buttonText: 'Geri',
                                  );
                                },
                              );
                            } else {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        musteri_siparis_rapor_page(
                                          gelenFiltre: cek,
                                          gelenBakiyeRapor: gelen,
                                          cariKart: widget.cariKart,
                                        )),
                              );
                            }
                          });
                        },
                        child: Text(
                            bitTar != "" ? bitTar : "Bitiş Tarihi Seçiniz"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Aranacak kelime(Kod/Cari Adı)",
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      iconColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        aramaTerimi = value;
                        if (aramaTerimi != "") {
                          aramaliBakiyeRaporSatirlar.clear();
                          for (int i = 0;
                              i < bakiyeRaporSatirlar.length;
                              i = i + 5) {
                            if (bakiyeRaporSatirlar[i + 1]
                                .toLowerCase()
                                .contains(aramaTerimi.toLowerCase())) {
                              aramaliBakiyeRaporSatirlar
                                  .add(bakiyeRaporSatirlar[i]);
                              aramaliBakiyeRaporSatirlar
                                  .add(bakiyeRaporSatirlar[i + 1]);
                              aramaliBakiyeRaporSatirlar
                                  .add(bakiyeRaporSatirlar[i + 2]);
                              aramaliBakiyeRaporSatirlar
                                  .add(bakiyeRaporSatirlar[i + 3]);
                              aramaliBakiyeRaporSatirlar
                                  .add(bakiyeRaporSatirlar[i + 4]);
                            }
                            if (bakiyeRaporSatirlar[i]
                                .toLowerCase()
                                .contains(aramaTerimi.toLowerCase())) {
                              aramaliBakiyeRaporSatirlar
                                  .add(bakiyeRaporSatirlar[i]);
                              aramaliBakiyeRaporSatirlar
                                  .add(bakiyeRaporSatirlar[i + 1]);
                              aramaliBakiyeRaporSatirlar
                                  .add(bakiyeRaporSatirlar[i + 2]);
                              aramaliBakiyeRaporSatirlar
                                  .add(bakiyeRaporSatirlar[i + 3]);
                              aramaliBakiyeRaporSatirlar
                                  .add(bakiyeRaporSatirlar[i + 4]);
                            }
                          }
                        } else {
                                aramaliBakiyeRaporSatirlar.clear();
                          aramaliBakiyeRaporSatirlar
                              .addAll(bakiyeRaporSatirlar);
                        }
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        ustfiltre = !ustfiltre;
                      });
                    },
                    icon:
                        Image.asset("images/slider.png", height: 60, width: 60),
                  ),
                ),
              ],
            ),
          ),
          ustfiltre == true
              ? Container(
                  height: MediaQuery.of(context).size.height * .4,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: kolonIsimleri.length,
                          itemBuilder: (context, index) {
                            return CheckboxListTile(
                              title: Text(kolonIsimleri[index]),
                              value: secilenKolonlar[index],
                              onChanged: (newValue) {
                                setState(() {
                                  secilenKolonlar[index] = newValue ?? false;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            filtreliBakiyeRaporKolonlar.clear();
                            for (int i = 0; i < secilenKolonlar.length; i++) {
                              if (secilenKolonlar[i] == true) {
                                filtreliBakiyeRaporKolonlar.add(
                                    DataColumn(label: Text(kolonIsimleri[i])));
                              }
                            }

                            setState(() {});
                            await SharedPrefsHelper.filtreKaydet(
                                secilenKolonlar, "raporMusteriSiparisFiltre");
                                   ustfiltre = false;
                            setState(() {});
                          },
                          child: Text("Filtreyi Uygula"))
                    ],
                  ))
              : Container(),
          Ctanim.dataTableOlustur(
              satirOlustur(
                  gelenDurumKolonlar: filtreliBakiyeRaporKolonlar,
                  gelenDurumSatirlar: aramaliBakiyeRaporSatirlar),
              filtreliBakiyeRaporKolonlar)
        ],
      ),
    );
  }
} 

/*
 */