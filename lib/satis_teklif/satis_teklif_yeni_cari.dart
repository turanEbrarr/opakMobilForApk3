import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:opak_mobil_v2/satis_teklif/satis_teklif_main_page.dart';
import 'package:opak_mobil_v2/widget/appbar.dart';

class satis_teklif_yeni_cari extends StatefulWidget {
  const satis_teklif_yeni_cari({super.key});

  @override
  State<satis_teklif_yeni_cari> createState() => _satis_teklif_yeni_cariState();
}

class _satis_teklif_yeni_cariState extends State<satis_teklif_yeni_cari> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(height: 50, title: "Satış Teklif"),
      body: SingleChildScrollView(
        child: Column(
          
          children: [
          /* Row( 
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton( onPressed: () {
                Navigator.pop(context);
              },
                icon: Icon(Icons.check_circle_outline, size: 30, color: Colors.blue,))],

          ),*/
            Card( elevation:15,
             child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("ÜNVAN      "),
                  ),
                 
                   Padding(
                     padding: const EdgeInsets.only(bottom: 8.0, left:8),
                     child: SizedBox( width: MediaQuery.of(context).size.width*.7,
                       child: TextField(
                decoration: InputDecoration(),
              ),
                     ),
                   ),
                ]
              ),
              
             
            ),
              Card( elevation: 15,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: Text("ADRES      "),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.7,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: TextField(  ),
                  ),
                  ),
                ],
              ),
            ),
           
           
              Card( elevation: 15,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: Text("İL             "),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: SizedBox(width: MediaQuery.of(context).size.width*0.7,
                      child: TextField(  )),
                  ),
                ],
              ),
            ),
              Card( elevation: 15,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: Text("İLÇE        "),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: SizedBox(width: MediaQuery.of(context).size.width*0.7,
                      child: TextField(  )),
                  ),
                ],
              ),
            ),
               Card(elevation: 15,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: Text("VERGİ DAİRESİ"),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.6,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: TextField(  ),
                  ),
                  ),
                ],
              ),
            ),
             Card( elevation: 15,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: Text("VERGİ NO   "),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.7,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*.8,
                      child: TextField(  )),
                  ),
                  ),
                ],
              ),
            ),
            Card( elevation: 15,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: Text("E-MAİL"),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.7,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: TextField(  ),
                  ),
                  ),
                ],
              ),
            ), 
             Card( elevation: 15,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: Text("TELEFON"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.70,
                      child: TextField(   )),
                  ),
                ],
              ),
            ), 
          
             Card( elevation: 15,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: Text("FİYAT     "),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: SizedBox(
                     width: MediaQuery.of(context).size.width*0.7,
                      child: TextField(  )),
                  ),
                ],
              ),
            ),
             Card( elevation: 15,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: Text("AÇIKLAMA  "),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.7,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left:8),
                    child: TextField(  ),
                  ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row( mainAxisAlignment: MainAxisAlignment.center,
           
              children: [
                 ElevatedButton (onPressed: () { Navigator.push(context, 
                 MaterialPageRoute(builder: (context) => satis_teklif_main_page()
                 )); },
                 child: Text("Tamam"),),
                
                
                  

           ] ),
            ),
          ],
        )),
    );
  }
}