class SubeDepoModel {
  int? ID;
  int? SUBEID;
  int? DEPOID;
  String? SUBEADI;
  String? DEPOADI;

  SubeDepoModel(
      {required this.SUBEID,
      required this.DEPOID,
      required this.SUBEADI,
      required this.DEPOADI});
  SubeDepoModel.fromJson(Map<String, dynamic> json) {
    SUBEID = json['SUBEID'];
    DEPOID = json['DEPOID'];
    SUBEADI = json['SUBEADI'];
    DEPOADI = json['DEPOADI'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['SUBEID'] = SUBEID;
    data['DEPOID'] = DEPOID;
    data['SUBEADI'] = SUBEADI;
    data['DEPOADI'] = DEPOADI;

    return data;
  }
}
