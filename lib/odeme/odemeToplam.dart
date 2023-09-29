import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:opak_mobil_v2/tahsilatOdemeModel/tahsilatHaraket.dart';
import 'package:opak_mobil_v2/tahsilatOdemeModel/tahsilat_pdf_onizleme.dart';
import 'package:opak_mobil_v2/widget/ctanim.dart';

import '../controllers/tahsilatController.dart';
import '../localDB/databaseHelper.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../stok_kart/Spinkit.dart';
import '../tahsilatOdemeModel/tahsilat.dart';
import '../webservis/base.dart';
import '../widget/customAlertDialog.dart';
import '../widget/main_page.dart';
import '../widget/modeller/logModel.dart';
import '../widget/modeller/sHataModel.dart';

class odeme_toplam extends StatefulWidget {
  const odeme_toplam({
    super.key,
  });

  @override
  State<odeme_toplam> createState() => _odeme_toplamState();
}

class _odeme_toplamState extends State<odeme_toplam> {
  BaseService bs = BaseService();
  double genelToplam = 0.0;
  String sonnnnn = "";
  List<String> textAciklama = [
    "Toplam Nakit",
    "Toplam Visa",
    "Toplam Çek",
    "Toplam Senet"
  ];
  final TahsilatController tahsilatEx = Get.find();
  List<bool> silmeAktifListe = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var element in tahsilatEx.tahsilat!.value.tahsilatHareket) {
      silmeAktifListe.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String sonYazilacak;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(255, 66, 82, 97),
          label: Text("Ödemeyi Kaydet"),
          icon: Icon(Icons.save),
          onPressed: () async {
            if (tahsilatEx.tahsilat!.value.tahsilatHareket.length != 0) {
              Tahsilat fiss = tahsilatEx.tahsilat!.value;
              if (Ctanim.kullanici!.ISLEMAKTARILSIN == "H") {
                Tahsilat fiss = tahsilatEx.tahsilat!.value;
                tahsilatEx.tahsilat!.value.DURUM = true;
                await Tahsilat.empty().tahsilatEkle(
                    tahsilat: tahsilatEx.tahsilat!.value, belgeTipi: "Odeme");

                tahsilatEx.tahsilat!.value = Tahsilat.empty();
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
                            'Ödeme Kaydedildi. PDF Dosyasını Görüntülemek İster misiniz?',
                        onPres: () async {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => TahsilatPdfOnizleme(
                                      m: fiss,
                                      belgeTipi: "Odeme",
                                    )),
                          );
                        },
                        buttonText: 'Ödemeyi Gör',
                      );
                    });
              } else {
                tahsilatEx.tahsilat!.value.DURUM = true;
                tahsilatEx.tahsilat!.value.AKTARILDIMI = true;

                await Tahsilat.empty().tahsilatEkle(
                    tahsilat: tahsilatEx.tahsilat!.value, belgeTipi: "Odeme");
                int tempID = tahsilatEx.tahsilat!.value.ID!;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return LoadingSpinner(
                      color: Colors.black,
                      message:
                          "Online Aktarım Aktif. Ödeme Merkeze Gönderiliyor..",
                    );
                  },
                );
                await tahsilatEx.listGidecekTekTahsilatGetir(
                    tahsilatID: tempID);

                Map<String, dynamic> jsonListesi =
                    tahsilatEx.list_gidecek_tahsilat[0].toJson2();

                setState(() {});
                SHataModel gelenHata = await bs.ekleTahsilat(
                    jsonDataList: jsonListesi, sirket: Ctanim.sirket!);
                if (gelenHata.Hata == "true") {
                  tahsilatEx.tahsilat!.value.DURUM = false;
                  tahsilatEx.tahsilat!.value.AKTARILDIMI = false;
                  LogModel logModel = LogModel(
                    TABLOADI: "TBLTAHSILATSB",
                    FISID: tahsilatEx.list_gidecek_tahsilat[0].ID,
                    HATAACIKLAMA: gelenHata.HataMesaj,
                    UUID: tahsilatEx.list_gidecek_tahsilat[0].UUID,
                    CARIADI: tahsilatEx.list_gidecek_tahsilat[0].CARIADI,
                  );

                  await VeriIslemleri().logKayitEkle(logModel);
                  print("GÖNDERİM HATASI");
                  await Ctanim.showHataDialog(
                      context, gelenHata.HataMesaj.toString(),
                      ikinciGeriOlsunMu: true);
                } else {
                  tahsilatEx.tahsilat!.value = Tahsilat.empty();
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
                              'Ödeme Merkeze Başarıyla Gönderildi. PDF Dosyasını Görmek İster misiniz ?',
                          onPres: () async {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => TahsilatPdfOnizleme(
                                        m: fiss,
                                        belgeTipi: "Odeme",
                                      )),
                            );
                          },
                          buttonText: 'Faturayı Gör',
                        );
                      });
                  setState(() {});
                  tahsilatEx.list_gidecek_tahsilat.clear();
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
                      message: 'Ödemenin Kalem Listesi Boş Olamaz',
                      onPres: () async {
                        Navigator.pop(context);

                        setState(() {});
                      },
                      buttonText: 'Geri',
                    );
                  });
            }
          }),
      body: Container(
        height: tahsilatEx.tahsilat!.value.tahsilatHareket.length *
                MediaQuery.of(context).size.height *
                0.1 +
            100,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: tahsilatEx.tahsilat!.value.tahsilatHareket.length,
                  itemBuilder: ((context, index) {
                    TahsilatHareket tahsilatHareket =
                        tahsilatEx.tahsilat!.value.tahsilatHareket[index];
                    String leadingText;
                    if (tahsilatEx
                            .tahsilat!.value.tahsilatHareket[index].DOVIZ ==
                        "USD") {
                      leadingText = "\$";
                    } else if (tahsilatEx
                            .tahsilat!.value.tahsilatHareket[index].DOVIZ ==
                        "EUR") {
                      leadingText = "€";
                    } else {
                      leadingText = "₺";
                    }
                    return Row(
                      children: [
                        SizedBox(
                          width: silmeAktifListe[index] == false
                              ? MediaQuery.of(context).size.width
                              : MediaQuery.of(context).size.width * .85,
                          height: MediaQuery.of(context).size.height * .1,
                          child: GestureDetector(
                            onLongPress: () {
                              silmeAktifListe[index] = true;
                              setState(() {});
                            },
                            onTap: () {
                              if (silmeAktifListe[index] == true) {
                                silmeAktifListe[index] = false;
                                setState(() {});
                              }
                            },
                            child: Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: Text(
                                      leadingText,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    title: Text(Ctanim()
                                            .MapTahsilatOdemeTip[tahsilatEx
                                                .tahsilat!
                                                .value
                                                .tahsilatHareket[index]
                                                .TIP]
                                            .toString() +
                                        " Ödeme :" +
                                        Ctanim.donusturMusteri(tahsilatEx
                                            .tahsilat!
                                            .value
                                            .tahsilatHareket[index]
                                            .TUTAR
                                            .toString()) +
                                        " " +
                                        tahsilatEx.tahsilat!.value
                                            .tahsilatHareket[index].DOVIZ!),
                                    subtitle: Text(tahsilatEx
                                            .tahsilat!.value.CARIADI
                                            .toString() +
                                        " / " +
                                        tahsilatEx.tahsilat!.value
                                            .tahsilatHareket[index].TAKSIT
                                            .toString() +
                                        " Taksit"),
                                  )),
                            ),
                          ),
                        ),
                        silmeAktifListe[index] == true
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height * .1,
                                child: Card(
                                  child: IconButton(
                                      onPressed: () {
                                        tahsilatEx
                                            .tahsilat?.value.tahsilatHareket
                                            .removeWhere((item) {
                                          return item.TIP ==
                                                  tahsilatHareket.TIP! &&
                                              item.BELGENO ==
                                                  tahsilatHareket.BELGENO!;
                                        });

                                        setState(() {});
                                        const snackBar = SnackBar(
                                          content: Text(
                                            'Ödeme silindi..',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          showCloseIcon: false,
                                          backgroundColor:
                                              Color.fromARGB(255, 30, 38, 45),
                                        );
                                        ScaffoldMessenger.of(
                                                context as BuildContext)
                                            .showSnackBar(snackBar);

                                        silmeAktifListe[index] = false;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      )),
                                ),
                              )
                            : Container()
                      ],
                    );
                  })),
            ),
            /*
            Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Toplam Tahsilat Tutarı : ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Ctanim.donusturMusteri(genelToplam.toString()) + " ₺",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
            */
          ],
        ),
      ),
    );
  }
}
