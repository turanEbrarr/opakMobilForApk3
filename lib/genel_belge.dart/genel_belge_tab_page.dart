import 'package:flutter/material.dart';
import 'package:opak_mobil_v2/genel_belge.dart/genel_belge_tab_urun_ara.dart';
import 'package:opak_mobil_v2/webservis/stokFiyatListesiModel.dart';
import 'package:opak_mobil_v2/widget/appbar.dart';
import 'package:opak_mobil_v2/widget/cari.dart';
import '../faturaFis/fis.dart';
import '../widget/ctanim.dart';
import 'genel_belge_tab_urun_liste.dart';
import 'genel_belge_tab_cari_bilgi.dart';
import 'genel_belge_tab_urun_ara.dart';
import 'genel_belge_tab_urun_toplam.dart';
import '../webservis/satisTipiModel.dart';

class genel_belge_tab_page extends StatefulWidget {
  const genel_belge_tab_page({
    super.key,
    required this.cariKod,
    required this.cariKart,
    required this.belgeTipi, 
    required this.satisTipi, required this.stokFiyatListesi,
  });
  final String belgeTipi;
  final String? cariKod;
  final Cari cariKart;
  final SatisTipiModel satisTipi;
  final StokFiyatListesiModel stokFiyatListesi;

  @override
  State<genel_belge_tab_page> createState() => _genel_belge_tab_pageState();
}

class _genel_belge_tab_pageState extends State<genel_belge_tab_page> {
  void dispose() {
    Fis.empty().fisEkle(fis: fisEx.fis!.value, belgeTipi: widget.belgeTipi);
    fisEx.fis!.value = Fis.empty();
    super.dispose();
    //listede güncelleme yaptı ve çıktı
  }

  Color tab1 = Colors.amber;
  Color tab2 = Colors.white;
  Color tab3 = Colors.white;
  Color tab4 = Colors.white;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: MyAppBar(
            height: 50, title: Ctanim().MapFisTR[widget.belgeTipi].toString()),
        body: Column(
          children: [
            Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 10),
              child: Material(
                color: Color.fromARGB(255, 66, 82, 97),
                child: TabBar(
                  labelColor: Colors.amber,
                  unselectedLabelColor: Colors.white,
                  onTap: (value) {
                    setState(() {
                      if (value == 0) {
                        tab1 = Colors.amber;
                        tab2 = Colors.white;
                        tab3 = Colors.white;
                        tab4 = Colors.white;
                      } else if (value == 1) {
                        tab2 = Colors.amber;
                        tab1 = Colors.white;
                        tab3 = Colors.white;
                        tab4 = Colors.white;
                      } else if (value == 2) {
                        tab3 = Colors.amber;
                        tab2 = Colors.white;
                        tab1 = Colors.white;
                        tab4 = Colors.white;
                      } else if (value == 3) {
                        tab4 = Colors.amber;
                        tab2 = Colors.white;
                        tab3 = Colors.white;
                        tab1 = Colors.white;
                      }
                    });
                  },
                  tabs: [
                    Tab(
                      text: ("Ürün Ara"),
                      icon: Icon(
                        Icons.search,
                        color: tab1,
                      ),
                    ),
                    Tab(
                      text: ("Liste"),
                      icon: Icon(
                        Icons.list,
                        color: tab2,
                      ),
                    ),
                    Tab(
                      text: ("Toplam"),
                      icon: Icon(
                        Icons.add_box,
                        color: tab3,
                      ),
                    ),
                    Tab(
                      text: ("Cari Bilgisi"),
                      icon: Icon(
                        Icons.apartment,
                        color: tab4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  genel_belge_tab_urun_ara(
                    stokFiyatListesi: Ctanim.seciliSatisFiyatListesi,
                    satisTipi: Ctanim.seciliIslemTip,
                    cariKod: widget.cariKod,
                  ),
                  genel_belge_tab_urun_liste(),
                  genel_belge_tab_urun_toplam(belgeTipi: widget.belgeTipi),
                  genel_belge_tab_cari_bilgi(
                    cariKart: widget.cariKart,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
