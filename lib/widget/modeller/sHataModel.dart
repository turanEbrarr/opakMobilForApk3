import 'package:intl/intl.dart';
import '../../interaktif_rapor/interaktifRaporGenelModel.dart';

class SHataModel {
  String? HataMesaj;
  String? Hata;


  SHataModel({this.HataMesaj, this.Hata});

  factory SHataModel.fromJson(Map<String, dynamic> json) {

    return SHataModel(
        Hata: json['Hata'].toString(),
        HataMesaj: json['HataMesaj'].toString(),
       );
  }
}
