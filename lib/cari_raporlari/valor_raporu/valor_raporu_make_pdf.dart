
import 'dart:typed_data';
import 'package:opak_mobil_v2/widget/veriler/listeler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

import '../../widget/cari.dart';

Future<Uint8List> valor_raporu_make_pdf(
    { required Cari cariKart,
      required Uint8List imagePath,
    required List<List<String>> satir,
    required List<String> kolon}) async {
  final image = pw.MemoryImage(imagePath);
  final fontData = await rootBundle.load("images/fonts/Roboto-Regular.ttf");
  final ttfFont = pw.Font.ttf(fontData);

  final boldfontData = await rootBundle.load("images/fonts/Roboto-Bold.ttf");
  final boldttfFont = pw.Font.ttf(boldfontData);

  final pdf = pw.Document();
  print(satir.length);

  int ilkSayfa = 0;
  bool ikinciGozuksun = false;

  // İlk sayfada üst bilgiler ve tablo başlıkları

  List<Widget> glen = [];
  int i = 0;
  while (i < satir.length) {
    glen.add(pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        i == 0
            ? Padding(
                padding: EdgeInsets.only(bottom: 40),
                child:Column(children: [Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("Valör Raporu",
                        style: TextStyle(font: boldttfFont, fontSize: 16)), pw.Image(image, width: 150, height: 100),]),
                        Column(children: [
                          Row(children: [Text("Cari Adı: ",style: TextStyle(font: boldttfFont, fontSize: 16)),Text(cariKart.ADI!,style: TextStyle(font: boldttfFont, fontSize: 16))])
                       , Row(children: [Text("Cari Kodu: ",style: TextStyle(font: boldttfFont, fontSize: 16)),Text(cariKart.KOD!,style: TextStyle(font: boldttfFont, fontSize: 16))])
                     ,   Row(children: [Text("İl: ",style: TextStyle(font: boldttfFont, fontSize: 16)),Text(cariKart.IL!,style: TextStyle(font: boldttfFont, fontSize: 16))])
                     ,   Row(children: [Text("İlçe: ",style: TextStyle(font: boldttfFont, fontSize: 16)),Text(cariKart.ILCE!,style: TextStyle(font: boldttfFont, fontSize: 16))])
                     ,   Row(children: [Text("Telefon: ",style: TextStyle(font: boldttfFont, fontSize: 16)),Text(cariKart.TELEFON!,style: TextStyle(font: boldttfFont, fontSize: 16))])
                       
                        ])]) )
            : Container(),
        i == 0
            ? pw.Table.fromTextArray(
                headers: kolon,
                data: buildTableRows(satir, start: i, end: i + 1),
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.center,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,

                },
                cellStyle: pw.TextStyle(
                  font: ttfFont,
                  fontSize: 10,
                ),
                headerStyle: pw.TextStyle(
                  font: boldttfFont,
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
                border: pw.TableBorder.all(color: PdfColors.black),
                headerDecoration: pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                columnWidths: {
                  0: pw.FractionColumnWidth(0.2),
                  1: pw.FractionColumnWidth(0.1),
                  2: pw.FractionColumnWidth(0.2),
                  3: pw.FractionColumnWidth(0.1),
    
                },
                headerHeight: 40)
            : pw.Table.fromTextArray(
                data: buildTableRows(satir, start: i, end: i + 1),
                border: pw.TableBorder.all(color: PdfColors.black),
                columnWidths: {
                  0: pw.FractionColumnWidth(0.2),
                  1: pw.FractionColumnWidth(0.1),
                  2: pw.FractionColumnWidth(0.2),
                  3: pw.FractionColumnWidth(0.1),

                },
                cellAlignments: {
              0: pw.Alignment.center,
                  1: pw.Alignment.center,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
       
                },
              ),
      ],
    ));
    i++;
  }

  // Diğer sayfalarda sadece tablo

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: pw.ThemeData(defaultTextStyle: pw.TextStyle(font: ttfFont)),
      build: (context) {
        return glen;
      },
    ),
  );

  return pdf.save();
}

List<List<String>> buildTableRows(List<List<String>> parca,
    {int start = 0, int end = 0}) {
  List<List<String>> rows = [];

  for (var j = start; j < end; j++) {
    rows.add(parca[start]);
  }

  return rows;
}
