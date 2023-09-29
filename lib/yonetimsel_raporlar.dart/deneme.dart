import 'package:flutter/material.dart';
//import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFPreviewScreen extends StatelessWidget {
  final String pdfPath; // Bu, PDF dosyasının yolunu tutar.

  const PDFPreviewScreen({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Önizleme"),
      ),
      /*
      body: PDFView(
        filePath: pdfPath,
      ),
      */
    );
  }
}