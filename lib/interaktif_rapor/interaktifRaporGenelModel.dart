/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myGenelInteraktifRaporNode = GenelInteraktifRapor.fromJson(map);
*/
import 'dart:convert';

class Param {
  String? ID;
  String? RAPORID;
  String? COLNAME;
  String? COLTYPE;
  String? SQL;

  Param(
      {this.ID = "0",
      this.RAPORID = "0",
      this.COLNAME = "",
      this.COLTYPE = "",
      this.SQL = ""});

  Param.fromJson(Map<String, dynamic> json) {
    ID = json['ID'].toString();
    RAPORID = json['RAPORID'].toString();
    COLNAME = json['COLNAME'].toString();
    COLTYPE = json['COLTYPE'].toString();
    SQL = json['SQL'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["ID"] = ID;
    data["RAPORID"] = RAPORID;
    data["COLNAME"] = COLNAME;
    data["COLTYPE"] = COLTYPE;
    data["SQL"] = SQL;
    print(data);
    return data;
  }
}

class GenelInteraktifRapor {
  int? ID;
  int? SIRA;
  String? ADI;
  String? SQL;
  List<Param?>? params;

  GenelInteraktifRapor({this.ID, this.SIRA, this.ADI, this.SQL, this.params});

  GenelInteraktifRapor.fromJson(Map<String, dynamic> json) {
    ID = int.tryParse(json['ID'].toString());
    SIRA = int.tryParse(json['SIRA'].toString());
    ADI = json['ADI'];
    SQL = json['SQL'];

    if (json['Params'] != "") {
      var paramsList = jsonDecode(json['Params']);

      params = <Param>[];
      paramsList.forEach((v) {
        params!.add(Param.fromJson(v));
      });
    } else {
      params = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['ID'] = ID;
    data['SIRA'] = SIRA;
    data['ADI'] = ADI;
    data['SQL'] = SQL;
    data['Params'] =
        params != null ? params!.map((v) => v?.toJson()).toList() : null;
    return data;
  }
}
