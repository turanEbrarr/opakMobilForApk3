/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/

class DahaFazlaBarkod {
  String KOD = "";
  String BARKOD = "";
  String ACIKLAMA = "";
  double CARPAN = 0.0;
  int SIRA = 0;
  double REZERVMIKTAR = 0.00;
  DahaFazlaBarkod({
    required this.KOD,
    required this.BARKOD,
    required this.ACIKLAMA,
    required this.CARPAN,
    required this.SIRA,
    required this.REZERVMIKTAR,
  });

  DahaFazlaBarkod.fromJson(Map<String, dynamic> json) {
    KOD = json['KOD'];
    BARKOD = json['BARKOD'];
    ACIKLAMA = json['ACIKLAMA'];
    CARPAN = double.parse(json['CARPAN'].toString());
    SIRA = int.parse(json['SIRA'].toString());
    REZERVMIKTAR = double.parse(json['REZERVMIKTAR'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['KOD'] = KOD;
    data['BARKOD'] = BARKOD;
    data['ACIKLAMA'] = ACIKLAMA;
    data['CARPAN'] = CARPAN;
    data['SIRA'] = SIRA;
    data['REZERVMIKTAR'] = REZERVMIKTAR;

    return data;
  }
}
