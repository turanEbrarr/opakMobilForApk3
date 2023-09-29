import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:opak_mobil_v2/cari_virman/cari_virman_page.dart';
import 'package:opak_mobil_v2/widget/appbar.dart';

import '../widget/ctanim.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';

class cari_virman_main_page extends StatefulWidget {
  const cari_virman_main_page({super.key, required this.widgetListBelgeSira});
  final int widgetListBelgeSira;

  @override
  State<cari_virman_main_page> createState() => _cari_virman_main_pageState();
}

class _cari_virman_main_pageState extends State<cari_virman_main_page> {
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
      appBar: MyAppBar(height: 50, title: "Cari Virman"),
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
                      child: IconButton(
                        onPressed: () async {
                          listeler.sayfaDurum[widget.widgetListBelgeSira] =
                              !listeler.sayfaDurum[widget.widgetListBelgeSira]!;
                          if (listeler.sayfaDurum[widget.widgetListBelgeSira] ==
                              true) {
                            setState(() {
                              favIconColor = Colors.amber;
                            });
                          } else {
                            setState(() {
                              favIconColor = Colors.white;
                            });
                          }
                          await SharedPrefsHelper.saveList(listeler.sayfaDurum,);
                        },
                        icon: Icon(
                          Icons.star,
                          color: favIconColor,
                          size: 30,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => cari_virman_page()));
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
