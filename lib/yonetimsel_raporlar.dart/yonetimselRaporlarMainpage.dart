import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:opak_mobil_v2/widget/appbar.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/veriler/listeler.dart';

import 'deneme.dart';

class yonetimselRaporlarMainPage extends StatefulWidget {
  const yonetimselRaporlarMainPage(
      {super.key,
      required this.widgetListBelgeSira,
      required this.nakitDurumGelenVeri,
      required this.satisDurumGelenVeri,
      required this.siparisTeklifDurumGelenVeri,
      required this.cekSenetDurumGelenVeri,
      required this.cariDurumGelenVeri});
  final int widgetListBelgeSira;
  final List<List<dynamic>> nakitDurumGelenVeri;
  final List<List<dynamic>> satisDurumGelenVeri;
  final List<List<dynamic>> siparisTeklifDurumGelenVeri;
  final List<List<dynamic>> cekSenetDurumGelenVeri;
  final List<List<dynamic>> cariDurumGelenVeri;

  @override
  State<yonetimselRaporlarMainPage> createState() =>
      _yonetimselRaporlarMainPageState();
}

class _yonetimselRaporlarMainPageState
    extends State<yonetimselRaporlarMainPage> {
  bool nakitDurum = false;
  bool satislar = false;
  bool siparisVeTeklifler = false;
  bool cekSenetDurum = false;
  bool cariDurum = false;

  List<String> nakitDurumSatirlar = [];
  List<DataColumn> nakitDurumKolonlar = [];
  List<String> nakitDurumDegerler = [];

  List<String> satisDurumSatirlar = [];
  List<DataColumn> satisDurumKolonlar = [];
  List<String> satisDurumDegerler = [];

  List<String> siparisTeklifDurumSatirlar = [];
  List<DataColumn> siparisTeklifDurumKolonlar = [];
  List<String> siparisTeklifDurumDegerler = [];

  List<String> cekSenetDurumSatirlar = [];
  List<DataColumn> cekSenetDurumKolonlar = [];
  List<String> cekSenetDurumDegerler = [];

  List<String> cariDurumSatirlar = [];
  List<DataColumn> cariDurumKolonlar = [];
  List<String> cariDurumDegerler = [];
  List<DataRow> satirOlustur(
      {required List<String> gelenDurumDegerler,
      required List<DataColumn> gelenDurumKolonlar,
      required List<String> gelenDurumSatirlar}) {
    int enSonEklenen = 0;
    List<DataRow> donecek = [];
    for (int i = 0; i < gelenDurumSatirlar.length; i++) {
      List<DataCell> donecekDataCell = [];

      DataCell newDataCell = DataCell(Text(
        gelenDurumSatirlar[i],
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
      donecekDataCell.add(newDataCell);

      int j = 0;
      while (j < gelenDurumKolonlar.length - 1) {
        DataCell newValue = DataCell(Text(
          gelenDurumDegerler[enSonEklenen],
          style: TextStyle(fontWeight: FontWeight.w400),
        ));
        enSonEklenen++;
        donecekDataCell.add(newValue);
        j++;
      }

      donecek.add(DataRow(cells: donecekDataCell));
    }
    return donecek;
  }

/*
pw.Table _buildDataTable(List<DataRow> rows) {
  final List<pw.Widget> headerWidgets = rows[0].cells.map((cell) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(8),
      child: pw.Text(
        cell.child.toString() ?? '', // Cell içeriğini doğrudan al
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      ),
    );
  }).toList();

  final List<pw.TableRow> dataRows = rows.map((row) {
    final List<pw.Widget> dataWidgets = row.cells.map((cell) {
      return pw.Padding(
        padding: pw.EdgeInsets.all(8),
        child: pw.Text(
          cell.child?.toString() ?? '', // Cell içeriğini doğrudan al
          style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
        ),
      );
    }).toList();

    return pw.TableRow(children: dataWidgets);
  }).toList();

  return pw.Table(
    border: pw.TableBorder.all(),
    children: [
      pw.TableRow(children: headerWidgets),
      ...dataRows,
    ],
  );
}
 Future<void> generatePDF(List<DataRow> rows) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) => pw.Center(
        child: pw.Container(
          child: _buildDataTable(rows), // DataTable'ı PDF içeriğine dönüştürme
        ),
      ),
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File("${output.path}/example.pdf");
  await file.writeAsBytes(await pdf.save());

  print("PDF oluşturuldu: ${file.path}");

  // PDF önizleme ekranını açmak için navigasyonu kullanın.
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PDFPreviewScreen(pdfPath: file.path),
    ),
  );
}

*/
  Map<String, double> toplamVeriler = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var element in widget.nakitDurumGelenVeri[0]) {
      nakitDurumSatirlar.add(element);
    }
    for (var element in widget.nakitDurumGelenVeri[1]) {
      nakitDurumKolonlar.add(element);
    }
    for (var element in widget.nakitDurumGelenVeri[2]) {
      nakitDurumDegerler.add(element);
    }

    for (var element in widget.satisDurumGelenVeri[0]) {
      satisDurumSatirlar.add(element);
    }
    for (var element in widget.satisDurumGelenVeri[1]) {
      satisDurumKolonlar.add(element);
    }
    for (var element in widget.satisDurumGelenVeri[2]) {
      satisDurumDegerler.add(element);
    }

    for (var element in widget.siparisTeklifDurumGelenVeri[0]) {
      siparisTeklifDurumSatirlar.add(element);
    }
    for (var element in widget.siparisTeklifDurumGelenVeri[1]) {
      siparisTeklifDurumKolonlar.add(element);
    }
    for (var element in widget.siparisTeklifDurumGelenVeri[2]) {
      siparisTeklifDurumDegerler.add(element);
    }

    for (var element in widget.cekSenetDurumGelenVeri[0]) {
      cekSenetDurumSatirlar.add(element);
    }
    for (var element in widget.cekSenetDurumGelenVeri[1]) {
      cekSenetDurumKolonlar.add(element);
    }
    for (var element in widget.cekSenetDurumGelenVeri[2]) {
      cekSenetDurumDegerler.add(element);
    }

    for (var element in widget.cariDurumGelenVeri[0]) {
      cariDurumSatirlar.add(element);
    }
    for (var element in widget.cariDurumGelenVeri[1]) {
      cariDurumKolonlar.add(element);
    }
    for (var element in widget.cariDurumGelenVeri[2]) {
      cariDurumDegerler.add(element);
    }
    /*
   for (int rowIndex = 0; rowIndex < nakitDurumSatirlar.length; rowIndex++) {
      // String kolonAdi = nakitDurumKolonlar[rowIndex+1].label.toString();
      double deger = 0;
      for (int colIndex = 1; colIndex < nakitDurumKolonlar.length; colIndex++) {
        deger += double.parse(nakitDurumDEgerler[rowIndex][colIndex]);
      }
      toplamVeriler["kolonAdi"] = deger;
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    Color favIconColor = Colors.black;
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
      appBar: MyAppBar(height: 50, title: "Yönetimsel Raporlar"),
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
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        nakitDurum = !nakitDurum;
                      });
                    },
                    child: ListTile(
                        leading: Icon(
                          Icons.account_balance,
                          color: Color.fromARGB(255, 26, 82, 131),
                        ),
                        title: Text(
                          "Nakit Durumu",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                nakitDurum = !nakitDurum;
                              });
                            },
                            icon: nakitDurum == false
                                ? Icon(Icons.arrow_drop_down)
                                : Icon(Icons.arrow_drop_up_sharp))),
                  ),
                ),
                nakitDurum == true
                    ? Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columnSpacing: 50,
                                dataRowHeight: 50,
                                headingRowHeight: 60,
                                horizontalMargin: 16,
                                columns: nakitDurumKolonlar,
                                rows: satirOlustur(
                                    gelenDurumDegerler: nakitDurumDegerler,
                                    gelenDurumKolonlar: nakitDurumKolonlar,
                                    gelenDurumSatirlar: nakitDurumSatirlar)),
                          ),
                          /*
                          ElevatedButton(onPressed: () async {
                            await generatePDF(satirOlustur(
                                    gelenDurumDegerler: nakitDurumDegerler,
                                    gelenDurumKolonlar: nakitDurumKolonlar,
                                    gelenDurumSatirlar: nakitDurumSatirlar));
                          }, child: Text("PDF"))
                           
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              thickness: 1,
                              endIndent: 30,
                              indent: 30,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Genel Durum:",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        
                          PieChart(
                            PieChartData(
                              sections: toplamVeriler.entries.map((entry) {
                                return PieChartSectionData(
                                  title: entry.key,
                                  value: entry.value,
                                );
                              }).toList(),
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                            ),
                          ),
                          */
                        ],
                      )
                    : Container(),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        satislar = !satislar;
                      });
                    },
                    child: ListTile(
                        leading: Icon(
                          Icons.local_mall,
                          color: Color.fromARGB(255, 26, 82, 131),
                        ),
                        title: Text(
                          "Satışlar",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                satislar = !satislar;
                              });
                            },
                            icon: satislar == false
                                ? Icon(Icons.arrow_drop_down)
                                : Icon(Icons.arrow_drop_up_sharp))),
                  ),
                ),
                satislar == true
                    ? Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columnSpacing: 200,
                                dataRowHeight: 50,
                                headingRowHeight: 60,
                                horizontalMargin: 16,
                                columns: satisDurumKolonlar,
                                rows: satirOlustur(
                                    gelenDurumDegerler: satisDurumDegerler,
                                    gelenDurumKolonlar: satisDurumKolonlar,
                                    gelenDurumSatirlar: satisDurumSatirlar)),
                          ),
                        ],
                      )
                    : Container(),
                // SizedBox(height: 20),
                /* SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 300,
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: satislarModel.BUGUN!,
                            color: Colors.blue,
                            width: 20,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                             toY: satislarModel.BUHAFTA!,
                            color: Colors.green,
                            width: 20,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                             toY: satislarModel.BUAY!,
                            color: Colors.orange,
                            width: 20,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                             toY: satislarModel.BUYIL!,
                            color: Colors.red,
                            width: 20,
                          ),
                        ],
                      ),
                    ],
                    titlesData: FlTitlesData(
                      show: true,
                      
                    ),
                  ),
                ),
              ),
*/
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        siparisVeTeklifler = !siparisVeTeklifler;
                      });
                    },
                    child: ListTile(
                        leading: Icon(
                          Icons.description,
                          color: Color.fromARGB(255, 26, 82, 131),
                        ),
                        title: Text(
                          "Sipariş Ve Teklifler",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                siparisVeTeklifler = !siparisVeTeklifler;
                              });
                            },
                            icon: siparisVeTeklifler == false
                                ? Icon(Icons.arrow_drop_down)
                                : Icon(Icons.arrow_drop_up_sharp))),
                  ),
                ),
                siparisVeTeklifler == true
                    ? Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columnSpacing: 25,
                                dataRowHeight: 50,
                                headingRowHeight: 60,
                                horizontalMargin: 16,
                                columns: siparisTeklifDurumKolonlar,
                                rows: satirOlustur(
                                    gelenDurumDegerler:
                                        siparisTeklifDurumDegerler,
                                    gelenDurumKolonlar:
                                        siparisTeklifDurumKolonlar,
                                    gelenDurumSatirlar:
                                        siparisTeklifDurumSatirlar)),
                          ),
                          SizedBox(height: 20),
                          /*
                          Padding(
                            padding: const EdgeInsets.only(right: 60, left: 60),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    siparisVeTekliflerModel.MUSTERISIPARISLER!
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: 16),
                                Text(
                                    siparisVeTekliflerModel.SATINALMASIPARISLER!
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: 16),
                                Text(
                                    siparisVeTekliflerModel.BEKLEYETEKLIFLER!
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: 16),
                                Text(
                                    siparisVeTekliflerModel
                                        .ONAYDABEKLEYENMUSTERISIPARISLER!
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(width: 16),
                                Text(
                                    siparisVeTekliflerModel
                                        .ONAYDABEKLEYENSATINALMASIPARISLER!
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.purple,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                         
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 60, left: 60),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 300,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceBetween,
                                  barGroups: [
                                    BarChartGroupData(x: 0, barRods: [
                                      BarChartRodData(
                                          toY: siparisVeTekliflerModel
                                              .MUSTERISIPARISLER!,
                                          color: Colors.blue)
                                    ]),
                                    BarChartGroupData(x: 1, barRods: [
                                      BarChartRodData(
                                          toY: siparisVeTekliflerModel
                                              .SATINALMASIPARISLER!,
                                          color: Colors.green)
                                    ]),
                                    BarChartGroupData(x: 2, barRods: [
                                      BarChartRodData(
                                          toY: siparisVeTekliflerModel
                                              .BEKLEYETEKLIFLER!,
                                          color: Colors.orange)
                                    ]),
                                    BarChartGroupData(x: 3, barRods: [
                                      BarChartRodData(
                                          toY: siparisVeTekliflerModel
                                              .ONAYDABEKLEYENMUSTERISIPARISLER!,
                                          color: Colors.red)
                                    ]),
                                    BarChartGroupData(x: 4, barRods: [
                                      BarChartRodData(
                                          toY: siparisVeTekliflerModel
                                              .ONAYDABEKLEYENSATINALMASIPARISLER!,
                                          color: Colors.purple)
                                    ]),
                                  ],
                                  titlesData: FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  barTouchData: BarTouchData(enabled: false),
                                ),
                              ),
                            ),
                          ),
                           */
                        ],
                      )
                    : Container(),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        cekSenetDurum = !cekSenetDurum;
                      });
                    },
                    child: ListTile(
                        leading: Icon(
                          Icons.book,
                          color: Color.fromARGB(255, 26, 82, 131),
                        ),
                        title: Text(
                          "Çek & Senet Durumu",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                cekSenetDurum = !cekSenetDurum;
                              });
                            },
                            icon: cekSenetDurum == false
                                ? Icon(Icons.arrow_drop_down)
                                : Icon(Icons.arrow_drop_up_sharp))),
                  ),
                ),
                cekSenetDurum == true
                    ? Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columnSpacing: 50,
                                dataRowHeight: 50,
                                headingRowHeight: 60,
                                horizontalMargin: 16,
                                columns: cekSenetDurumKolonlar,
                                rows: satirOlustur(
                                    gelenDurumDegerler: cekSenetDurumDegerler,
                                    gelenDurumKolonlar: cekSenetDurumKolonlar,
                                    gelenDurumSatirlar: cekSenetDurumSatirlar)),
                          ),
                        ],
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        cariDurum = !cariDurum;
                      });
                    },
                    child: ListTile(
                        leading: Icon(
                          Icons.account_balance_wallet,
                          color: Color.fromARGB(255, 26, 82, 131),
                        ),
                        title: Text(
                          "Cari Durumu",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                cariDurum = !cariDurum;
                              });
                            },
                            icon: cariDurum == false
                                ? Icon(Icons.arrow_drop_down)
                                : Icon(Icons.arrow_drop_up_sharp))),
                  ),
                ),
                cariDurum == true
                    ? Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columnSpacing: 50,
                                dataRowHeight: 50,
                                headingRowHeight: 60,
                                horizontalMargin: 16,
                                columns: cariDurumKolonlar,
                                rows: satirOlustur(
                                    gelenDurumDegerler: cariDurumDegerler,
                                    gelenDurumKolonlar: cariDurumKolonlar,
                                    gelenDurumSatirlar: cariDurumSatirlar)),
                          )
                          /*
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              thickness: 1,
                              endIndent: 30,
                              indent: 30,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Bugün Durum:",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          PieChartWidget(
                            alacaklarimTL:
                                cariDurumModel.BUGUNVADELIALACAKLARIMEURO! +
                                    cariDurumModel.BUGUNVADELIALACAKLARIMTL! +
                                    cariDurumModel.BUGUNVADELIALACAKLARIMUSD!,
                            borclarimTL:
                                cariDurumModel.BUGUNVADELIBORCLARIMEURO! +
                                    cariDurumModel.BUGUNVADELIBORCLARIMTL! +
                                    cariDurumModel.BUGUNVADELIBORCLARIMUSD!,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 150,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            color: Colors.green,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Bugün Alacaklarım",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            color: Colors.red,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Bugün Borçlarım",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          */
                        ],
                      )
                    : Container(),
                Padding(
                  padding:  EdgeInsets.only(top:8,bottom: MediaQuery.of(context).size.height*0.15),
                  child: Divider(
                    thickness: 2,
                  ),
                ),

                /*
                    Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Banka:",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                pastaGrafikNakitDurum(
                    deger1: nakitDurumuModel.BANKATL!,
                    deger1Isim: "TL",
                    deger1Renk: Colors.blue,
                    deger2: nakitDurumuModel.BANKAUSD!,
                    deger2Isim: "USD",
                    deger2Renk: Colors.green,
                    deger3: nakitDurumuModel.BANKAEURO!,
                    deger3Isim: "EURO",
                    deger3Renk: Colors.orange,
                    toplam: nakitDurumuModel.BANKATLTOPLAM!),
                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(thickness: 1,endIndent: 30,indent: 30,),
                    ),
                    Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "POS:",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                pastaGrafikNakitDurum(
                    deger1: nakitDurumuModel.POSTL!,
                    deger1Isim: "TL",
                    deger1Renk: Colors.blue,
                    deger2: nakitDurumuModel.POSUSD!,
                    deger2Isim: "USD",
                    deger2Renk: Colors.green,
                    deger3: nakitDurumuModel.POSEURO!,
                    deger3Isim: "EURO",
                    deger3Renk: Colors.orange,
                    toplam: nakitDurumuModel.POSTLTOPLAM!),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class pastaGrafikNakitDurum extends StatelessWidget {
  const pastaGrafikNakitDurum({
    super.key,
    required this.deger1Isim,
    required this.deger2Isim,
    required this.deger3Isim,
    required this.deger1,
    required this.deger2,
    required this.deger3,
    required this.toplam,
    required this.deger1Renk,
    required this.deger2Renk,
    required this.deger3Renk,
  });

  final String deger1Isim;
  final String deger2Isim;
  final String deger3Isim;
  final double deger1;
  final double deger2;
  final double deger3;
  final Color deger1Renk;
  final Color deger2Renk;
  final Color deger3Renk;
  final double toplam;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 0.9999999999999999,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: deger1,
                  title: deger1.toString() + " ₺",
                  titleStyle: TextStyle(fontWeight: FontWeight.bold),
                  titlePositionPercentageOffset:
                      1.8, // Değerlerin yarı yolda görünmesini sağlar
                  color: deger1Renk,
                ),
                PieChartSectionData(
                  value: deger2,
                  title: deger2.toString() + " \$",
                  titleStyle: TextStyle(fontWeight: FontWeight.bold),
                  titlePositionPercentageOffset: 1.9,
                  color: deger2Renk,
                ),
                PieChartSectionData(
                  value: deger3,
                  title: deger3.toString() + " €",
                  titleStyle: TextStyle(fontWeight: FontWeight.bold),
                  titlePositionPercentageOffset: 1.8,
                  color: deger3Renk,
                ),
              ],
              sectionsSpace: 5,
              centerSpaceRadius: 80,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "TOPLAM:" + toplam.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Indicator(
                    color: deger1Renk,
                    title: deger1Isim,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Indicator(
                    color: deger2Renk,
                    title: deger2Isim,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Indicator(
                    color: deger3Renk,
                    title: deger3Isim,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String title;

  const Indicator({
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(title),
        ],
      ),
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final double alacaklarimTL;
  final double borclarimTL;

  PieChartWidget({required this.alacaklarimTL, required this.borclarimTL});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: PieChart(
        PieChartData(
          sectionsSpace: 10,
          centerSpaceRadius: 60,
          sections: [
            PieChartSectionData(
              titlePositionPercentageOffset: 1.8,
              value: alacaklarimTL,
              color: Colors.green,
              title: alacaklarimTL.toStringAsFixed(2) + ' TL',
              radius: 50,
              titleStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            PieChartSectionData(
              titlePositionPercentageOffset: 1.8,
              value: borclarimTL,
              color: Colors.red,
              title: borclarimTL.toStringAsFixed(2) + ' TL',
              radius: 50,
              titleStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
