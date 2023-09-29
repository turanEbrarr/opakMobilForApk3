import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:money_formatter/money_formatter.dart';
import '../widget/kullaniciModel.dart';
import '../faturaFis/fisHareket.dart';
import '../controllers/fisController.dart';
import '../widget/customAlertDialog.dart';
import '../widget/veriler/listeler.dart';
import '../webservis/satisTipiModel.dart';
import 'package:intl/intl.dart';
import '../webservis/stokFiyatListesiModel.dart';

class Ctanim {
  String SatisFiyatTip = "Fiyat1";
  String SatisIskonto = "ISK1";

  static SatisTipiModel seciliIslemTip =
      SatisTipiModel(ID: -1, TIP: "", FIYATTIP: "", ISK1: "", ISK2: "");
        static StokFiyatListesiModel seciliSatisFiyatListesi =
    StokFiyatListesiModel(ID: -1, ADI: "");

  static String seciliCariKodu = "";
  static List<String> fiyatListesiKosul = [];

  static var db;

  static KullaniciModel? kullanici;
  static String? sirket;
  static int faturaNumarasi = 0;
  static int siparisNumarasi = 0;
  static int irsaliyeNumarasi = 0;
  static int eirsaliyeNumarasi = 0;
  static int perakendeSatisNumarasi = 0;
  static int depolarArasiTransfer = 0;
  static int eFaturaNumarasi = 0;
  static int eArsivNumarasi = 0;

//  static bool KDVDahilMiDefault = false;

  static List<String> son10GunDon() {
    var bitTarTemp = DateTime.now();
    String bitTar = DateFormat('yyyy-MM-dd').format(bitTarTemp);
    DateTime basTarTemp = bitTarTemp.subtract(Duration(days: 10));
    String basTar = DateFormat('yyyy-MM-dd').format(basTarTemp);
    return [basTar, bitTar];
  }

  static Future<String> pickDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      locale: const Locale('tr', 'TR'),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      return formattedDate;
    } else {
      return '';
    }
  }

  static Widget tarihAraligiSecim(
      BuildContext context,
      List<List<dynamic>> Function(String, String, String, String) fonksiyon,
      String sirket) {
    RxString basTar = "".obs;
    RxString bitTar = "".obs;
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: ElevatedButton(
                    onPressed: () async {
                      String date = await pickDate(context);
                      if (date == "") return;

                      basTar.value = date;
                      print(basTar);
                    },
                    child: Text(basTar.value != ""
                        ? basTar.value
                        : "Başlangıç Tarihi Seçiniz"),
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: ElevatedButton(
                    onPressed: () async {
                      String date = await pickDate(context);
                      if (date == "") return;

                      bitTar.value = date;
                      print(basTar);
                      print(bitTar);
                      print("bitti ara");
                      fonksiyon(sirket, sirket, "", "");
                    },
                    child: Text(bitTar.value != ""
                        ? bitTar.value
                        : "Bitiş Tarihi Seçiniz"),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  static Widget dataTableOlustur(
      List<DataRow> satirlar, List<DataColumn> kolonlar,
      {double? genislik = 20}) {
    List<Color> rowColors = [
      Color.fromARGB(255, 255, 255, 255),
      Color.fromARGB(255, 174, 179, 176),
    ];

    int _currentColorIndex = 0;

    Color getNextRowColor() {
      Color color = rowColors[_currentColorIndex];
      _currentColorIndex = (_currentColorIndex + 1) % rowColors.length;
      return color;
    }

    List<DataColumn> guncellenmisKolon = [];
    for (var element in kolonlar) {
      if ((element.label as Text).data == "Id") {
        guncellenmisKolon.add(DataColumn(
            label: SizedBox(
          width: 0,
          child: Text("Id"),
        )));
      } else {
        guncellenmisKolon.add(DataColumn(
            label: SizedBox(
          width: 100,
          child: Text((element.label as Text).data!),
        )));
      }
    }
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8)),
              child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) {
                    return Color.fromARGB(255, 224, 241, 255);
                  }),
                  dataRowColor: MaterialStateColor.resolveWith((states) {
                    return getNextRowColor();
                  }),
                  columnSpacing: genislik,
                  dataRowHeight: 50,
                  headingRowHeight: 40,
                  horizontalMargin: 16,
                  columns: guncellenmisKolon,
                  rows: satirlar),
            ),
          ),
        ),
      ),
    );
  }

  static bool KDVDahilMiDinamik = false;
  static double noktadanSonraAlinacak(double veri) {
    String result = veri.toStringAsFixed(2);
    return double.parse(result);
  }

  static String donusturMusteri(String inText) {
    MoneyFormatter fmf = MoneyFormatter(amount: double.parse(inText));
    MoneyFormatterOutput fo = fmf.output;
    String tempSonTutar = fo.nonSymbol.toString();

    if (tempSonTutar.contains(",")) {
      String kusurat = "";
      List<String> gecici = tempSonTutar.split(",");
      for (int i = 1; i < gecici.length; i++) {
        if (i == gecici.length - 1) {
          String eklen = gecici[i].replaceAll(".", ",");
          kusurat = kusurat + eklen;
        } else {
          kusurat = kusurat + gecici[i] + ".";
        }
      }
      // String kusuratSon = kusurat.replaceAll(".", ",");
      String sonYazilacak = gecici[0] + "." + kusurat;
      return sonYazilacak;
    } else {
      String sonYazilacak = tempSonTutar.replaceAll(".", ",");
      return sonYazilacak;
    }
  }

static genelToplamHesapla(FisController fisEx) {
    double KDVTutari = 0.0;
    double urunToplami = 0.0;
    double genelUrunToplami = 0.0;
    double genelKalemIndirimToplami = 0.0;
    double araToplam = 0.0;
    double araToplam1 = 0.0;
    double kalemindirimToplami = 0.0;
    double genelToplam = 0.0;
    int anaBirimID = 0;
    for (var kur in listeler.listKur) {
      if (kur.ANABIRIM == "E") {
        anaBirimID = kur.ID!;
      }
    }
    for (FisHareket element in fisEx.fis!.value.fisStokListesi) {
      urunToplami = 0;
      kalemindirimToplami = 0;

      double brut = element.BRUTFIYAT!.toDouble();

      double kdvOrani = element.KDVORANI! / 100;
      int miktar = element.MIKTAR!;

      if (fisEx.fis!.value.DOVIZID != anaBirimID) {
        brut = brut / fisEx.fis!.value.KUR!;
      }
      /*
      if (fisEx.fis!.value.DOVIZID != element.DOVIZID) {
        if (anaBirimID != element.DOVIZID) {
          brut = brut * element.KUR!;
          brut = brut / fisEx.fis!.value.KUR!;
        } else {
          brut = brut / fisEx.fis!.value.KUR!;
        }
      }*/

      if (Ctanim.KDVDahilMiDinamik == false) {
        fisEx.fis!.value.KDVDAHIL = "H";
        urunToplami += (brut * miktar);
      } else {
        fisEx.fis!.value.KDVDAHIL = "E";
        urunToplami += brut * (1 - kdvOrani) * miktar;
      }

      double tt =
          double.parse(((element.ISK! / 100) * urunToplami).toStringAsFixed(2));
      double tt2 = double.parse(
          ((element.ISK2! / 100) * (urunToplami - tt)).toStringAsFixed(2));
      // (urunToplami - (((element.ISK! / 100) * urunToplami)));
      kalemindirimToplami = tt + tt2;
      KDVTutari =
          KDVTutari + ((brut - kalemindirimToplami) * kdvOrani * miktar);
      genelUrunToplami += urunToplami;
      genelKalemIndirimToplami += kalemindirimToplami;
    }

    double? controllerDeger =
        double.tryParse((fisEx.fis!.value.ISK1.toString())) ?? 0;
    double? controllerDeger2 =
        double.tryParse(fisEx.fis!.value.ISK2.toString()) ?? 0;
    double nettoplam = (urunToplami - kalemindirimToplami);

    double altIndirimToplami =
        double.parse(((nettoplam * controllerDeger / 100)).toStringAsFixed(2));
    araToplam1 =
        genelUrunToplami - genelKalemIndirimToplami - altIndirimToplami;
    if (controllerDeger2 != 0.0 && controllerDeger != 0.0) {
      altIndirimToplami += double.parse(
          (araToplam1 * controllerDeger2 / 100).toStringAsFixed(2));
    }

//
    //indirimToplami = indirimToplami + altIndirimToplami;

    araToplam = genelUrunToplami - genelKalemIndirimToplami - altIndirimToplami;

    KDVTutari = KDVTutari -
        double.parse(((controllerDeger / 100) * KDVTutari).toStringAsFixed(2));
    KDVTutari = KDVTutari -
        double.parse(((controllerDeger2 / 100) * KDVTutari).toStringAsFixed(2));
    genelToplam += araToplam + KDVTutari;
    fisEx.fis!.value.TOPLAM = Ctanim.noktadanSonraAlinacak(genelUrunToplami);
    fisEx.fis!.value.INDIRIM_TOPLAMI = Ctanim.noktadanSonraAlinacak(
        genelKalemIndirimToplami + altIndirimToplami);
    fisEx.fis!.value.ARA_TOPLAM = Ctanim.noktadanSonraAlinacak(araToplam);
    fisEx.fis!.value.KDVTUTARI = Ctanim.noktadanSonraAlinacak(KDVTutari);
    fisEx.fis!.value.GENELTOPLAM = Ctanim.noktadanSonraAlinacak(genelToplam);
  }

  static String doubleToMusteriGorunumu(String input) {
    List<String> parts = input.split('.');
    String leftPart = parts[0];
    String rightPart = parts[1];

    String formattedLeftPart = '';
    for (int i = leftPart.length - 1, count = 0; i >= 0; i--, count++) {
      if (count != 0 && count % 3 == 0) {
        formattedLeftPart = '.' + formattedLeftPart;
      }
      formattedLeftPart = leftPart[i] + formattedLeftPart;
    }

    String formattedRightPart = rightPart.substring(0, 2);

    return formattedLeftPart + ',' + formattedRightPart;
  }

  static Future<void> showHataDialog(BuildContext context, String hataMesaj,
      {ikinciGeriOlsunMu = false}) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          align: TextAlign.center,
          title: 'Hata',
          message:
              'Fatura Merkeze Gönderilirken Hata Oluştu. Hata : $hataMesaj',
          onPres: () {
            Navigator.pop(context);
            if (ikinciGeriOlsunMu == true) {
              Navigator.pop(context);
            }
          },
          buttonText: 'Tamam',
        );
      },
    );
  }

  static bool bekleyenBelgeVarMi = false;

  Map<int, String> MapFisTipTersENG = {
    1: "Perakende_Satis",
    2: "Satis_Fatura",
    3: "Alis_Fatura",
    4: "Perakende_Satis_Iade",
    5: "Satis_Iade_Fatura",
    6: "Perakende_Iptal",
    7: "Fatura_Iptal",
    8: "Satis_Irsaliye",
    9: "Satis_Irsaliye_Iptal",
    10: "Gider_Pusulasi",
    11: "Satin_Alma_Fisi",
    12: "Alis_Irsaliye",
    13: "Alinan_Siparis",
    14: "Satis_Teklif",
    15: "Depo_Transfer",
    16: "Musteri_Siparis",
  };

  Map<String, int> MapFisTip = {
    "Perakende_Satis": 1,
    "Satis_Fatura": 2,
    "Alis_Fatura": 3,
    "Perakende_Satis_Iade": 4,
    "Satis_Iade_Fatura": 5,
    "Perakende_Iptal": 6,
    "Fatura_Iptal": 7,
    "Satis_Irsaliye": 8,
    "Satis_Irsaliye_Iptal": 9,
    "Gider_Pusulasi": 10,
    "Satin_Alma_Fisi": 11,
    "Alis_Irsaliye": 12,
    "Alinan_Siparis": 13,
    "Satis_Teklif": 14,
    "Depo_Transfer": 15,
    "Musteri_Siparis": 16
  };
  Map<int, String> MapFisTipTers = {
    1: "Perakende Satış",
    2: "Satış Faturası",
    3: "Alış Faturası",
    4: "Perakende Satış İade",
    5: "Satış İade Faturası",
    6: "Perakende İptal",
    7: "Fatura İptal",
    8: "Satış İrsaliye",
    9: "Satış İrsaliye İptal",
    10: "Gider Pusulası",
    11: "Satın Alma Fişi",
    12: "Alış İrsaliye",
    13: "Alınan Sipariş",
    14: "Satış Teklif",
    15: "Depo Transfer",
    16: "Müşteri Sipariş",
  };
  static Map<String, double> pastaIcin = {};

  Map<String, String> MapFisTR = {
    "Perakende_Satis": "Perakende Satış",
    "Satis_Fatura": "Satış Faturası",
    "Alis_Fatura": "Alış Faturası",
    "Perakende_Satis_Iade": "Perakende Satış İade",
    "Satis_Iade_Fatura": "Satış İade Faturası",
    "Perakende_Iptal": "Perakende İptal",
    "Fatura_Iptal": "Fatura İptal",
    "Satis_Irsaliye": "Satış İrsaliye",
    "Satis_Irsaliye_Iptal": "Satış İrsaliye İptal",
    "Gider_Pusulasi": "Gider Pusulası",
    "Satin_Alma_Fisi": "Satın Alma Fişi",
    "Alis_Irsaliye":
        "Alış İrsaliye", //sonra bakılacak tasarımlar aynı olsun diye eklendi
    "Alinan_Siparis":
        "Alınan Sipariş", //sonra bakılacak tasarımlar aynı olsun diye eklendi
    "Satis_Teklif":
        "Satış Teklif", //sonra bakılacak tasarımlar aynı olsun diye eklendi
    "Depo_Transfer": "Depo Transfer",
    "Musteri_Siparis": "Müşteri Sipariş"
  };

  Map<String, int> MapIlslemTip = {
    "Tahsilat": 1,
    "Odeme": 2,
  };
  Map<int, String> MapIlslemTipTers = {
    1: "Tahsilat",
    2: "Odeme",
  };

  Map<int, String> MapTahsilatOdemeTip = {
    1: "Nakit",
    2: "Visa",
    3: "Cek",
    4: "Senet"
  };

  static Map<String, bool> MapMainPage = {
    "Cari_Kart_Listesi": true,
    "Satis_Fatura": true,
    "Satis_Irsaliye": true,
    "Alis_Irsaliye": true,
    "Alinan_Siparis": true,
    "Musteri_Siparis": false,
    "Satis_Teklif": false,
    "Stok_Kart_Listesi": false,
    "Depo_Transfer": false,
    "Sayim_Kayit_Fisi": false,
    "Perakende_Satis": true,
    "Tahsilat": false,
    "Odeme": false,
    "Virman": false,
    "Veri_Islemleri": false, //
    "Raporlar": false, //
    "Cari_Raporlari": false,
    "Stok_Raporlari": false,
    "Siparis_Raporlari": false,
    "Fatura_Raporlari": false,
    "Irsaliye_Raporlari": false,
    "Interaktif_Rapor": false,
    "Yonetimsel_Rapor": false,
  };
  static List<String> satisFiyatListesi = [];
  static List<String> satisIskontoListesi = [];
  // static List<String> satisIskontoDegistirmeListesi = [];
  static List<String> genelIskontoListesi = [];
  // static List<String> genelIskontoDegistirmeListesi = [];
}
