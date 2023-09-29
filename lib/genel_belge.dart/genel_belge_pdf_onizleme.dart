import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:opak_mobil_v2/localDB/veritabaniIslemleri.dart';

import 'package:printing/printing.dart';
import '../faturaFis/fis.dart';
import 'genel_belge_make_pdf.dart';


class PdfOnizleme extends StatefulWidget {
  final Fis m;
  const PdfOnizleme({Key? key, required this.m}) : super(key: key);

  @override
  State<PdfOnizleme> createState() => _PdfOnizlemeState();
}

class _PdfOnizlemeState extends State<PdfOnizleme> {
  Uint8List? _imageData;
  Future<void> _loadImage() async {
    String? imagePath = await VeriIslemleri().getFirstImage();
    if (imagePath != "") {
      final File imageFile = File(imagePath!);
      final Uint8List imageData = await imageFile.readAsBytes();
      setState(() {
        _imageData = imageData;
      });
    } else {
        final ByteData assetData = await rootBundle.load('images/beyaz.jpg');
      _imageData = assetData.buffer.asUint8List();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
         theme: ThemeData(
        // Temayı karanlık (siyah) yapar
        primaryColor:
            const Color.fromARGB(255, 80, 79, 79),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('PDF Önizleme'),
            backgroundColor: const Color.fromARGB(255, 80, 79, 79),
        ),
          backgroundColor: const Color.fromARGB(255, 80, 79, 79),
        body: PdfPreview(
          build: (context) => makePdf(widget.m, _imageData!),
        ),
      ),
    );
  }
}
