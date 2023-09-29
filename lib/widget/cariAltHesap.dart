import 'package:flutter/material.dart';

class CariAltHesap {
  String? KOD = "";
  String? ALTHESAP = "";
  int? DOVIZID;

  CariAltHesap({required this.KOD, required this.ALTHESAP,required this.DOVIZID});

  CariAltHesap.fromJson(Map<String, dynamic> json) {
    KOD = json['KOD'];
    ALTHESAP = json['ALTHESAP'];
    DOVIZID = int.parse(json['DOVIZID'].toString());
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['KOD'] = KOD;
    data['ALTHESAP'] = ALTHESAP;
    data['DOVIZID'] = DOVIZID;
    return data;
  }
}
