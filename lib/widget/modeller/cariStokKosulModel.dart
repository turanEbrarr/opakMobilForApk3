class CariStokKosulModel {
  int? ID;
  String? STOKKOD;
  String? CARIKOD;
  double? FIYAT;
  double? ISK1;
  double? ISK2;
  double? SABITFIYAT;

  CariStokKosulModel(
      {this.ID,
      this.STOKKOD,
      this.CARIKOD,
      this.FIYAT,
      this.ISK1,
      this.ISK2,
      this.SABITFIYAT});

  CariStokKosulModel.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    STOKKOD = json['STOKKOD'];
    CARIKOD = json['CARIKOD'];
    FIYAT = double.parse(json['FIYAT'].toString());
    ISK1 = double.parse(json['ISK1'].toString());
    ISK2 = double.parse(json['ISK2'].toString());
    SABITFIYAT =double.parse(json['SABITFIYAT'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = ID;
    data['STOKKOD'] = STOKKOD;
    data['CARIKOD'] = CARIKOD;
    data['FIYAT'] = FIYAT;
    data['ISK1'] = ISK1;
    data['ISK2'] = ISK2;
    data['SABITFIYAT'] = SABITFIYAT;
    return data;
  }
}
