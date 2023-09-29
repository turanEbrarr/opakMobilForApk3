import 'package:opak_mobil_v2/webservis/stokFiyatListesiHar.dart';
import 'package:opak_mobil_v2/webservis/stokFiyatListesiModel.dart';

import '../../faturaFis/fis.dart';
import '../../webservis/kurModel.dart';
import '../../stok_kart/stok_tanim.dart';
import '../cari.dart';
import '../cariAltHesap.dart';
import '../../Depo Transfer/subeDepoModel.dart';
import '../modeller/cariKosulModel.dart';
import '../modeller/stokKosulModel.dart';
import '../modeller/cariStokKosulModel.dart';
import '../modeller/logModel.dart';
import '../modeller/olcuBirimModel.dart';
import '../modeller/rafModel.dart';
import '../../webservis/kullaniciYetki.dart';
import '../../stok_kart/daha_fazla_barkod.dart';
import '../../webservis/bankaModel.dart';
import '../../webservis/bankaSozlesmeModel.dart';
import '../../webservis/satisTipiModel.dart';
import '../../interaktif_rapor/interaktifRaporGenelModel.dart';

class listeler {
  static List<StokKart> liststok = [];
  static List<StokKart> listlocalstok = [];
  static List<Cari> listCari = [];
  static List<Fis> listFis = [];
  static List<bool> sayfaDurum = [];
  static List<KurModel> listKur = [];
  static List<CariAltHesap> listCariAltHesap = [];
  static List<SubeDepoModel> listSubeDepoModel = [];
  static List<CariKosulModel> listCariKosul = [];
  static List<StokKosulModel> listStokKosul = [];
  static List<CariStokKosulModel> listCariStokKosul = [];
  static List<LogModel> listLog = [];
  static List<OlcuBirimModel> listOlcuBirim = [];
  static List<RafModel> listRaf = [];
  static List<KullaniciYetki> yetki = [];
  static List<DahaFazlaBarkod> listDahaFazlaBarkod = [];
  static List<BankaModel> listBankaModel = [];
  static List<BankaSozlesmeModel> listBankaSozlesmeModel = [];
  static List<SatisTipiModel> listSatisTipiModel = [];
  static List<GenelInteraktifRapor> listInteraktifRapor = [];
  static List<StokFiyatListesiModel> listStokFiyatListesi = [];
  static List<StokFiyatListesiHarModel> listStokFiyatListesiHar = [];
  static List<bool> plasiyerYetkileri = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  static bool ust = false;
  //
  // static List<DepoModel> depolar = [DepoModel(1, "Merkez"),DepoModel(2, "Selçuklu")];
  //
}
