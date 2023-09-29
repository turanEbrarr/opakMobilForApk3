import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:opak_mobil_v2/siparis_raporlari/bekleyen_siparis_cari_list.dart';
import 'package:opak_mobil_v2/webservis/base.dart';
import 'package:intl/intl.dart';
import 'package:opak_mobil_v2/widget/appbar.dart';

import '../stok_kart/Spinkit.dart';
import '../widget/cari.dart';
import '../widget/ctanim.dart';
import '../widget/customAlertDialog.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';
import 'bekleyen_siparis_list.dart';
import 'musteri_siparis_cari_list.dart';
import 'musteri_siparis_list.dart';

class siparis_raporlari_main_page extends StatefulWidget {
  const siparis_raporlari_main_page(
      {super.key,
      required this.widgetListBelgeSira,
      this.cariKart,
      required this.cariGonderildiMi});
  final int widgetListBelgeSira;
  final Cari? cariKart;
  final bool cariGonderildiMi;

  @override
  State<siparis_raporlari_main_page> createState() =>
      _siparis_raporlari_main_pageState();
}

class _siparis_raporlari_main_pageState
    extends State<siparis_raporlari_main_page> {
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
        appBar: MyAppBar(height: 50, title: "Sipariş Raporları"),
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
              padding:
                  const EdgeInsets.only(left: 5.0, right: 5, bottom: 5, top: 8),
              child: Container(
                child: ListTile(
                  leading: Icon(Icons.history),
                  title: Text(
                    "Bekleyen Sipariş Raporu",
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
                                bekleyen_siparis_cari_list_page(
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
                            message: "Bekleyen Sipariş Raporu Hazırlanıyor...",
                          );
                        },
                      );

                      List<bool> cek = await SharedPrefsHelper.filtreCek(
                          "raporBekleyenSiparisFiltre");
                      List<List<dynamic>> gelen =
                          await bs.getirBekleyenSiparisRapor(
                              sirket: Ctanim.sirket!,
                              cariKodu: widget.cariKart!.KOD!,
                              basTar: Ctanim.son10GunDon()[0],
                              bitTar: Ctanim.son10GunDon()[1]);

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
                            builder: ((context) => bekleyen_siparis_rapor_page(
                                  gelenFiltre: cek,
                                  gelenBakiyeRapor: gelen,
                                  cariKart: widget.cariKart!,
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
                  leading: Icon(Icons.person_2_rounded),
                  title: Text(
                    "Müşteri Sipariş Raporu",
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
                                musteri_siparis_cari_list_page(
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
                            message: "Müşteri Sipariş Raporu Hazırlanıyor...",
                          );
                        },
                      );

                      List<bool> cek = await SharedPrefsHelper.filtreCek(
                          "raporMusteriSiparisFiltre");
                      List<List<dynamic>> gelen =
                          await bs.getirMusteriSiparisRapor(
                              sirket: Ctanim.sirket!,
                              cariKodu: widget.cariKart!.KOD!,
                              basTar: Ctanim.son10GunDon()[0],
                              bitTar: Ctanim.son10GunDon()[1]);

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
                            builder: ((context) => musteri_siparis_rapor_page(
                                  cariKart: widget.cariKart!,
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
          ],
        ));
  }
}
