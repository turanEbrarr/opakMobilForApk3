import 'package:get/get.dart';

class SatisTipiModel {
  int? ID = 0;
  String? TIP = "";
  String? FIYATTIP = "";
  String? ISK1 = "";
  String? ISK2 = "";

  SatisTipiModel(
      {required this.ID,
      required this.TIP,
      required this.FIYATTIP,
      required this.ISK1,
      required this.ISK2});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = ID;
    data['TIP'] = TIP;
    data['FIYATTIP'] = FIYATTIP;
    data['ISK1'] = ISK1;
    data['ISK2'] = ISK2;

    return data;
  }

  SatisTipiModel.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
    TIP = json['TIP'].toString();
    FIYATTIP = json['FIYATTIP'].toString();
    ISK1 = json['ISK1'].toString();
    ISK2 = json['ISK2'].toString();
  }
}

