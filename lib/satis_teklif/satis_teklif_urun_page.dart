import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:opak_mobil_v2/widget/appbar.dart';

class satis_teklif_urun_page extends StatefulWidget {
  const satis_teklif_urun_page({super.key});

  @override
  State<satis_teklif_urun_page> createState() => _satis_teklif_urun_pageState();
}

class _satis_teklif_urun_pageState extends State<satis_teklif_urun_page> {
  @override
  Widget build(BuildContext context) {
    return   Scaffold
    ( appBar: MyAppBar(height: 50, title: "Satış Teklif"),
      body: AlertDialog(
                                    title: Text("SATIŞ TİPİ"),
                                    content: Text("Özel"),
                                    actions: [
                                      MaterialButton(onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: Text("Tamam"),)
                                    ],
                                  ),
    );
                              }
    
  }
