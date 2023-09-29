import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:opak_mobil_v2/fatura_raporlari/satisFatura/satis_fatura_cari_list.dart';
import 'package:opak_mobil_v2/irsaliye_raporlari/bekleyen_siparis_irsaliyeleri/bekleyen_siparis_irsaliyeleri_cari_list.dart';
import 'package:opak_mobil_v2/irsaliye_raporlari/satis_irsaliye_rapor/satis_irsaliye_cari_list.dart';
import 'package:opak_mobil_v2/irsaliye_raporlari/satis_irsaliye_rapor/satis_irsaliye_rapor.dart';
import 'package:opak_mobil_v2/siparis_raporlari/bekleyen_siparis_cari_list.dart';
import 'package:opak_mobil_v2/webservis/base.dart';
import 'package:opak_mobil_v2/widget/appbar.dart';

import '../stok_kart/Spinkit.dart';
import '../widget/cari.dart';
import '../widget/ctanim.dart';
import '../widget/customAlertDialog.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';
import 'bekleyen_siparis_irsaliyeleri/bekleyen_siparis_irsaliyeleri_rapor.dart';

class irsaliye_raporlari_main_page extends StatefulWidget {
  const irsaliye_raporlari_main_page(
      {super.key,
      required this.widgetListBelgeSira,
      this.cariKart,
      required this.cariGonderildiMi});
  final int widgetListBelgeSira;
  final Cari? cariKart;
  final bool cariGonderildiMi;
  @override
  State<irsaliye_raporlari_main_page> createState() =>
      _irsaliye_raporlari_main_pageState();
}

class _irsaliye_raporlari_main_pageState
    extends State<irsaliye_raporlari_main_page> {
  BaseService bs = BaseService();
  Color favIconColor = Colors.black;
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
        appBar: MyAppBar(height: 50, title: "İrsaliye Raporları"),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(255, 30, 38, 45),
          onPressed: () async {
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
          },
          label: favIconColor == Colors.amber
              ? Text("Favorilerimden Kaldır")
              : Text("Favorilerime Ekle"),
          icon: Icon(
            Icons.star,
            color: favIconColor,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: ListTile(
                  leading: Icon(Icons.receipt_long),
                  title: Text(
                    "Satış İrsaliye Rapor",
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  onTap: () async {
                    if (widget.cariGonderildiMi == false) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return satis_irsaliye_cari_list_page(
                            widgetListBelgeSira: 0,
                          );
                        }),
                      );
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return LoadingSpinner(
                            color: Colors.black,
                            message: "Satış İrsaliye Raporu Hazırlanıyor...",
                          );
                        },
                      );

                      List<bool> cek = await SharedPrefsHelper.filtreCek(
                          "satisIrsaliyeRaporFiltre");
                      List<List<dynamic>> gelen =
                          await bs.getirSatisIrsaliyeRapor(
                        sirket: Ctanim.sirket!,
                        cariKodu: widget.cariKart!.KOD!,
                        basTar: Ctanim.son10GunDon()[0],
                        bitTar: Ctanim.son10GunDon()[1],
                      );

                      if (gelen[0].length == 1 && gelen[1].length == 0) {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              align: TextAlign.left,
                              title: gelen[0][0] == "Veri Bulunamadı"
                                  ? "Kayıtlı Belge Yok"
                                  : 'Hata',
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
                            builder: ((context) => satis_irsaliye_rapor_page(
                                  cariKart: widget.cariKart,
                                  gelenFiltre: cek,
                                  gelenBakiyeRapor: gelen,
                                )),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                child: ListTile(
                    leading: Icon(Icons.history),
                    title: Text(
                      "Bekleyen Sipariş İrsaliyeleri",
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                    onTap: () async {
                      if (widget.cariGonderildiMi == false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  bekleyen_siparis_irsaliyeleri_cari_list_page(
                                    widgetListBelgeSira: 0,
                                  )),
                        );
                      } else {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return LoadingSpinner(
                              color: Colors.black,
                              message:
                                  "Bekleyen Sipariş İrsaliye Raporu Hazırlanıyor...",
                            );
                          },
                        );

                        List<bool> cek = await SharedPrefsHelper.filtreCek(
                            "bekleyenSiparisIrsaliyeRaporFiltre");
                        List<List<dynamic>> gelen =
                            await bs.getirBekleyenSiparisIrsaliyeRapor(
                          sirket: Ctanim.sirket!,
                          cariKod: widget.cariKart!.KOD!,
                          basTar: Ctanim.son10GunDon()[0],
                          bitTar: Ctanim.son10GunDon()[1],
                        );

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
                              builder: ((context) =>
                                  bekleyen_siparis_irsaliyeleri_rapor_page(
                                    cariKart: widget.cariKart,
                                    gelenFiltre: cek,
                                    gelenBakiyeRapor: gelen,
                                  )),
                            ),
                          );
                        }
                      }
                    }),
              ),
            ),
            Divider(
              thickness: 2,
            ),
          ],
        ));
  }
}
