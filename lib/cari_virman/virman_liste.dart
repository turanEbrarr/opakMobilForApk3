import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:opak_mobil_v2/widget/cari.dart';

class virman_liste extends StatefulWidget {
  const virman_liste({super.key});

  @override
  State<virman_liste> createState() => _virman_listeState();
}

class _virman_listeState extends State<virman_liste> {
  List<Cari> carikayit = [];
  TextEditingController editController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      // labelText: "Listeyi ara",
                      hintText: "Aranacak kelime (Ünvan/Kod)",
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      iconColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  // onChanged: searchB,
                  ),
                ),
              ],
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: carikayit.length,
                  itemBuilder: (context, index) {
                    final c1 = carikayit[index];
                    return GestureDetector(
                      onTap: () {
                              Navigator.pop(context);
                            },
                      child: Card(
                        // color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        elevation: 15,
                        //color: Colors.blue[70],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kodu:   " + carikayit[index].KOD!,
                              ),
                              Text(
                                carikayit[index].ADI!,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

 /* void searchB(String query) {
    final suggestion = cariler.where((c1) {
      final Ctitle = c1.title.toLowerCase();
      final Ckod = c1.kodu.toLowerCase();
      final input = query.toLowerCase();
      return Ctitle.contains(input) || Ckod.contains(input);
    }).toList();
    setState(() => carikayit = suggestion);
  }*/
}
