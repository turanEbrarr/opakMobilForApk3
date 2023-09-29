

class StokFiyatListesiHarModel {
  int? USTID = 0;
  String? STOKKOD = "";
    int? DOVIZID = 0;
  double?   FIYAT = 0.0;
    double? ISK1 = 0.0;
  String? KDV_DAHIL = "";


  StokFiyatListesiHarModel(
      {required this.USTID,
      required this.STOKKOD,
      required this.DOVIZID,
      required this.FIYAT,
      required this.ISK1,
      required this.KDV_DAHIL
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['USTID'] = USTID;
    data['STOKKOD'] = STOKKOD;
    data['DOVIZID'] = DOVIZID;
    data['FIYAT'] = FIYAT;
    data['ISK1'] = ISK1;
    data['KDV_DAHIL'] = KDV_DAHIL;
    return data;
  }

  StokFiyatListesiHarModel.fromJson(Map<String, dynamic> json) {
  USTID = int.parse(json['USTID'].toString());
  STOKKOD = json["STOKKOD"];
  DOVIZID = int.parse(json["DOVIZID"].toString())  ;
  FIYAT = double.parse(json["FIYAT"].toString())  ;
  ISK1 = double.parse(json["ISK1"].toString())  ;
  KDV_DAHIL = json["KDV_DAHIL"];
  }
}

