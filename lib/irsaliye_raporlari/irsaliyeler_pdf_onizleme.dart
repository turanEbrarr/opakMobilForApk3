import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:opak_mobil_v2/localDB/veritabaniIslemleri.dart';

import 'package:printing/printing.dart';

import '../../widget/cari.dart';
import 'irsaliyeler_make_pdf.dart';

class irsaliyelerPdfOnizleme extends StatefulWidget {
  List<List<String>>? satirlar;
  List<String>? kolonlar;
  final Cari? caraiKart;
  final String? faturaID;
  final String? baslik;

  irsaliyelerPdfOnizleme({
    required this.satirlar,
    required this.kolonlar,
    required this.caraiKart,
    required this.faturaID,required this.baslik,
  });

  @override
  State<irsaliyelerPdfOnizleme> createState() => _irsaliyelerPdfOnizlemeState();
}

class _irsaliyelerPdfOnizlemeState extends State<irsaliyelerPdfOnizleme> {
  Uint8List? _imageData;

  Future<void> _loadImage() async {
    // Veritabanından resmin yolunu alın
    String? imagePath = await VeriIslemleri().getFirstImage();
    if (imagePath != "") {
      // Resim yolu varsa, bu yolu Uint8List'e dönüştürün ve _imageData değişkenine atayın
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
            const Color.fromARGB(255, 80, 79, 79), // Ana rengi siyah yapar
        // Vurgu rengini gri yapar (isteğe bağlı)
        // Diğer tema özelliklerini istediğiniz gibi ayarlayabilirsiniz
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('PDF Önizleme'),
          backgroundColor: const Color.fromARGB(255, 80, 79, 79),
        ),
        body: PdfPreview(
          build: (context) => irsaliyeler_make_pdf(
              cariKart: widget.caraiKart!,
              imagePath: _imageData!,
              kolon: widget.kolonlar!,
              satir: widget.satirlar!,
              faturaID: widget.faturaID!, baslik: widget.baslik!),
        ),
      ),
    );
  }
}
