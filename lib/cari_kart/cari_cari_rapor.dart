import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:opak_mobil_v2/cari_kart/genel_cari_rapor.dart';
import 'package:opak_mobil_v2/siparis_raporlari/siparis_raporlar%C4%B1_main_page.dart';
import 'package:opak_mobil_v2/webservis/base.dart';
import 'package:opak_mobil_v2/widget/ctanim.dart';
import '../cari_kart/yeni_cari_olustur.dart';
import '../fatura_raporlari/fatura_raporlari_main_page.dart';
import '../irsaliye_raporlari/irsaliye_raporlari_main_page.dart';
import '../siparis_raporlari/musteri_siparis_cari_list.dart';
import '../stok_kart/Spinkit.dart';
import '../widget/cari.dart';
import '../widget/customAlertDialog.dart';
import '../widget/modeller/sharedPreferences.dart';

class cari_cari_rapor extends StatefulWidget {
  final Cari cariKart;
  const cari_cari_rapor({super.key, required this.cariKart});

  @override
  State<cari_cari_rapor> createState() => _cari_cari_raporState();
}

class _cari_cari_raporState extends State<cari_cari_rapor> {
  Future<void> hataGoster(List<List<dynamic>> donen) async {
    await showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          align: TextAlign.left,
          title:
              donen[0][0] == "Veri Bulunamadı" ? "Kayıtlı Belge Yok" : 'Hata',
          message: donen[0][0] == "Veri Bulunamadı"
              ? 'İstenilen Belge Mevcut Değil'
              : 'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                  donen[0][0],
          onPres: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          buttonText: 'Geri',
        );
      },
    );
  }

  BaseService bs = BaseService();
  @override
  Widget build(BuildContext context) {
    final List rapor = [
      "Cari Hesap Ektresi",
      "Cari Alt Hesap Bakiye",
      //"Stoklu Cari Hesap Ekstresi",
      "Siparişler",
      //"Bekleyen Siparişler",
      "Faturalar",
      "İrsaliyeler",
      //"Yapılacak Tahsilatlar",
      //  "Yapılacak Ödemeler",
      "Müşteri Çek Senet Listesi",
      // "En Çok Tercih Edilen Ürünler(Satış)",
      //"En Çok Tercih Edilen Ürünler(Alış)"
    ];

    return Center(
        child: ListView.builder(
            itemCount: rapor.length,
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
                            child: Image.asset('images/veri.png'),
                          ),
                          title: Text(
                            ' ${rapor[index]}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () async {
                            List<List<dynamic>> donen = [];
                            if (rapor[index] == "Cari Hesap Ektresi") {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return LoadingSpinner(
                                    color: Colors.black,
                                    message:
                                        "Cari Ekstre Raporu Hazırlanıyor...",
                                  );
                                },
                              );
                              List<bool> cek =
                                  await SharedPrefsHelper.filtreCek(
                                      "cariEkstreRapor");
                              donen = await bs.getirCariEkstre(
                                  sirket: Ctanim.sirket!,
                                  cariKodu: widget.cariKart.KOD!);
                              if (donen[0].length == 1 &&
                                  donen[1].length == 0) {
                                hataGoster(donen);
                              } else {
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => genel_cari_rapor(
                                            gelenBakiyeRapor: donen,
                                            gelenFiltre: cek,
                                            cariKart: widget.cariKart,
                                            raporAdi: 'Cari Hesap Ektresi',
                                          )),
                                );
                              }
                            } else if (rapor[index] ==
                                "Cari Alt Hesap Bakiye") {
                              List<bool> cek =
                                  await SharedPrefsHelper.filtreCek(
                                      "cariAltHesapBakiyeRapor");
                              donen = await bs.getirAltHesapBakiye(
                                  sirket: Ctanim.sirket!,
                                  cariKodu: widget.cariKart.KOD!);
                              if (donen[0].length == 1 &&
                                  donen[1].length == 0) {
                                hataGoster(donen);
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => genel_cari_rapor(
                                            gelenBakiyeRapor: donen,
                                            gelenFiltre: cek,
                                            cariKart: widget.cariKart,
                                            raporAdi: 'Cari Alt Hesap Bakiye',
                                          )),
                                );
                              }
                            } else if (rapor[index] == "Siparişler") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          siparis_raporlari_main_page(
                                            widgetListBelgeSira: 18,
                                            cariGonderildiMi: true,
                                            cariKart: widget.cariKart,
                                          ))));
                            } else if (rapor[index] == "Faturalar") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          fatura_raporlari_main_page(
                                            widgetListBelgeSira: 19,
                                            cariGonderildiMi: true,
                                            cariKart: widget.cariKart,
                                          ))));
                            } else if (rapor[index] == "İrsaliyeler") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          irsaliye_raporlari_main_page(
                                            widgetListBelgeSira: 20,
                                            cariGonderildiMi: true,
                                            cariKart: widget.cariKart,
                                          ))));
                            } else if (rapor[index] ==
                                "Müşteri Çek Senet Listesi") {
                              List<bool> cek =
                                  await SharedPrefsHelper.filtreCek(
                                      "musteriCekSenetListesiRapor");
                              donen = await bs.getirCariCekSenet(
                                  sirket: Ctanim.sirket!,
                                  cariKodu: widget.cariKart.KOD!,
                                  basTar: Ctanim.son10GunDon()[0],
                                  bitTar: Ctanim.son10GunDon()[1]);
                              if (donen[0].length == 1 &&
                                  donen[1].length == 0) {
                                hataGoster(donen);
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => genel_cari_rapor(
                                            gelenBakiyeRapor: donen,
                                            gelenFiltre: cek,
                                            cariKart: widget.cariKart,
                                            raporAdi:
                                                'Müşteri Çek Senet Listesi',
                                          )),
                                );
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
