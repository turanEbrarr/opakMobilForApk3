import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:opak_mobil_v2/cari_virman/virman_liste.dart';

class cari_virman_page extends StatefulWidget {
  const cari_virman_page({super.key});

  @override
  State<cari_virman_page> createState() => _cari_virman_pageState();
}

class _cari_virman_pageState extends State<cari_virman_page> {
  List<String> para_birimi = ["TL", "DOLAR", "EURO"];
  String? s_para_birimi = "TL";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Card(
          elevation: 15,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Cari Adı",style: TextStyle(color: Colors.blue),),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  Text("-"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Cari Kodu",style: TextStyle(color: Colors.blue)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField()),
                  IconButton(
                    icon: Icon(Icons.search,
                    color: Colors.blue,),
                    onPressed: () {
                       showDialog(
                  context: context,
                  builder: (_) {
                    return virman_liste();
                  });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Tutar     ",style: TextStyle(color: Colors.blue)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField()),
                ],
              ),
            ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Row(
                    children: [
                      Text("DÖVİZ",style: TextStyle(color: Colors.blue)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                      DropdownButton<String>(
                          value: s_para_birimi,
                          items: para_birimi
                              .map((e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(
                                    e,
                                  )))
                              .toList(),
                          onChanged: ((e) => setState(() {
                                s_para_birimi = e;
                              }))),
                    ],
                  ),
           ),
          Row(
            children: [
              
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Container(width: MediaQuery.of(context).size.width*.95 ,
                  decoration: BoxDecoration(border: Border( top: (BorderSide(color: Colors.blue, width: 1)),
                  bottom: (BorderSide(color: Colors.blue, width: 1)))),
                  child: Padding(
                    padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*.3, bottom: 8, top:8),
                    child: Text("VİRMAN BİLGİLERİ", style: TextStyle(fontSize: 16, color: Colors.blue),),
                  )),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Cari Adı",style: TextStyle(color: Colors.blue)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                  Text("-"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Cari Kodu",style: TextStyle(color: Colors.blue)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField()),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.blue,),
                    onPressed: () { showDialog(
                  context: context,
                  builder: (_) {
                    return virman_liste();
                  });},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(onPressed: (() {
                  Navigator.pop(context);
                }),style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ) ,
                 child: Text("Kaydet",style: TextStyle(color: Colors.white),),) 
                 //butona kontrol gelecek( virman seç, cari seç, tutar kontrol)
              ],),
            )
          
          ]),
        ),
      ],
    ));
  }
}
