

class StokFiyatListesiModel {
  int? ID = 0;
  String? ADI = "";


  StokFiyatListesiModel(
      {required this.ID,
      required this.ADI
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = ID;
    data['ADI'] = ADI;


    return data;
  }

  StokFiyatListesiModel.fromJson(Map<String, dynamic> json) {
    ID = int.parse(json['ID'].toString());
  ADI = json["ADI"];
  }
}

