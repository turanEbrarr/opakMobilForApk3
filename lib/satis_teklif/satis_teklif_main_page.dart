import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:opak_mobil_v2/cari_kart/yeni_cari_olustur.dart';
import 'package:opak_mobil_v2/satis_teklif/satis_teklif_var_olan_cari.dart';
import 'package:opak_mobil_v2/satis_teklif/satis_teklif_yeni_cari.dart';
import 'package:opak_mobil_v2/widget/appbar.dart';

class satis_teklif_main_page extends StatefulWidget {
  const satis_teklif_main_page({super.key});

  @override
  State<satis_teklif_main_page> createState() => _satis_teklif_main_pageState();
}

class _satis_teklif_main_pageState extends State<satis_teklif_main_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(height: 50, title: "Satış Teklif"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                color: Color.fromARGB(255, 121, 184, 240),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(
                        Icons.star,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: 15),
                                    Text(
                                      "Cari Tipi",
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Divider(
                                      height: 1,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .30,
                                      height: 50,
                                      child: InkWell(
                                        highlightColor: Colors.grey[200],
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: ((context) =>
                                                  satis_teklif_yeni_cari()),
                                            ),
                                          );
                                        },
                                        child: Center(
                                          child: Text(
                                            "Yeni Cari",
                                            style: TextStyle(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          .30,
                                      height: 50,
                                      child: InkWell(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(15.0),
                                          bottomRight: Radius.circular(15.0),
                                        ),
                                        highlightColor: Colors.grey[200],
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      satis_teklif_var_olan_cari())));
                                        },
                                        child: Center(
                                          child: Text(
                                            "Var Olan Cari",
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      icon: Icon(
                        Icons.add_circle_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
