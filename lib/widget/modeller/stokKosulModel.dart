class StokKosulModel {
    int? ID;
    int? KOSULID;
    String? GRUPKODU;
    double? FIYAT;
    double? ISK1;
    double? ISK2;
    double? ISK3;
    double? ISK4;
    double? ISK5;
    double? ISK6;
    double? SABITFIYAT;

    StokKosulModel({this.ID, this.KOSULID, this.GRUPKODU, this.FIYAT, this.ISK1, this.ISK2, this.ISK3, this.ISK4, this.ISK5, this.ISK6, this.SABITFIYAT}); 

    StokKosulModel.fromJson(Map<String, dynamic> json) {
        ID = int.parse(json['ID'].toString());
        KOSULID =  int.parse(json['KOSULID'].toString());
        GRUPKODU = json['GRUPKODU'];
        FIYAT = double.parse(json['FIYAT'].toString());
        ISK1 = double.parse(json['ISK1'].toString());
        ISK2 = double.parse(json['ISK2'].toString());
        ISK3 = double.parse(json['ISK3'].toString());
        ISK4 = double.parse(json['ISK4'].toString());
        ISK5 = double.parse(json['ISK5'].toString());
        ISK6 = double.parse(json['ISK6'].toString());
        SABITFIYAT = double.parse(json['SABITFIYAT'].toString());
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = Map<String, dynamic>();
        data['ID'] = ID;
        data['KOSULID'] = KOSULID;
        data['GRUPKODU'] = GRUPKODU;
        data['FIYAT'] = FIYAT;
        data['ISK1'] = ISK1;
        data['ISK2'] = ISK2;
        data['ISK3'] = ISK3;
        data['ISK4'] = ISK4;
        data['ISK5'] = ISK5;
        data['ISK6'] = ISK6;
        data['SABITFIYAT'] = SABITFIYAT;
        return data;
    }
}