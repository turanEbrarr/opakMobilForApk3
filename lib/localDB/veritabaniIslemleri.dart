import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:opak_mobil_v2/Depo%20Transfer/subeDepoModel.dart';
import 'package:opak_mobil_v2/controllers/cariController.dart';
import 'package:opak_mobil_v2/webservis/satisTipiModel.dart';
import 'package:opak_mobil_v2/webservis/kurModel.dart';
import 'package:opak_mobil_v2/webservis/stokFiyatListesiHar.dart';
import 'package:opak_mobil_v2/webservis/stokFiyatListesiModel.dart';
import 'package:opak_mobil_v2/widget/cari.dart';
import 'package:opak_mobil_v2/widget/cariAltHesap.dart';
import 'package:opak_mobil_v2/widget/modeller/cariKosulModel.dart';
import 'package:opak_mobil_v2/widget/modeller/cariStokKosulModel.dart';
import 'package:opak_mobil_v2/widget/modeller/olcuBirimModel.dart';
import 'package:opak_mobil_v2/widget/modeller/stokKosulModel.dart';
import 'package:opak_mobil_v2/widget/veriler/listeler.dart';
import '../controllers/stokKartController.dart';
import '../stok_kart/stok_tanim.dart';
import '../webservis/bankaModel.dart';
import '../webservis/bankaSozlesmeModel.dart';
import '../widget/ctanim.dart';
import '../webservis/base.dart';
import '../widget/modeller/logModel.dart';
import '../widget/modeller/rafModel.dart';
import '../stok_kart/daha_fazla_barkod.dart';

CariController cariEx = Get.find(); // PUT DEĞİŞTİ
final StokKartController stokKartEx = Get.find();

class VeriIslemleri {
  //database stokları getir

  Future<List<StokKart>?> stokGetir() async {
    var result = await Ctanim.db?.query("TBLSTOKSB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLSTOKSB");
    listeler.liststok =
        List.generate(maps.length, (i) => StokKart.fromJson(maps[i]));
    stokKartEx.searchList.assignAll(listeler.liststok);
    return listeler.liststok;
  }

  //database stokları güncelle
  Future<int?> stokGuncelle(StokKart stokKart) async {
    var result = await Ctanim.db?.update("TBLSTOKSB", stokKart.toJson(),
        where: 'ID = ?', whereArgs: [stokKart.ID]);
    return result;
  }

  //database stok ekle
  Future<int?> stokEkle(StokKart stokKart, {bool yeniStokMu = false}) async {
    try {
      stokKart.ID = null;
      var result = await Ctanim.db?.insert("TBLSTOKSB", stokKart.toJson());
      if (yeniStokMu == true) {
        listeler.liststok.add(stokKart);
      }
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

////database cari getir
  Future<List<Cari>?> cariGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLCARISB");
    listeler.listCari =
        List.generate(maps.length, (i) => Cari.fromJson(maps[i]));
    cariEx.searchCariList.assignAll(listeler.listCari);

    await cariAltHesapGetir();

    return listeler.listCari;
  }

  //database carileri güncelle
  Future<int?> cariGuncelle(Cari cariKart) async {
    var result = await Ctanim.db?.update("TBLCARISB", cariKart.toJson(),
        where: 'ID = ?', whereArgs: [cariKart.ID]);
    return result;
  }

  //database cari ekle
  Future<int?> cariEkle(Cari cariKart) async {
    try {
      cariKart.ID = null;
      var result = await Ctanim.db?.insert("TBLCARISB", cariKart.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<List<CariAltHesap>?> cariAltHesapGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps =
        await Ctanim.db?.query("TBLCARIALTHESAPSB");
    listeler.listCariAltHesap =
        List.generate(maps.length, (i) => CariAltHesap.fromJson(maps[i]));

    for (int i = 0; i < listeler.listCari.length; i++) {
      for (var element2 in listeler.listCariAltHesap) {
        if (listeler.listCari[i].KOD == element2.KOD) {
          listeler.listCari[i].cariAltHesaplar.add(element2);
        }
      }
    }
    cariEx.searchCariList.assignAll(listeler.listCari);

    return listeler.listCariAltHesap;
  }

  //database carileri güncelle
  Future<int?> cariAltHesapGuncelle(CariAltHesap cariAltHesap) async {
    var result = await Ctanim.db?.update(
        "TBLCARIALTHESAPSB", cariAltHesap.toJson(),
        where: 'KOD = ?', whereArgs: [cariAltHesap.KOD]);
    return result;
  }

  //database cari ekle
  Future<int?> cariAltHesapEkle(CariAltHesap cariAltHesap) async {
    try {
      // cariAltHesap.KOD = null;
      var result =
          await Ctanim.db?.insert("TBLCARIALTHESAPSB", cariAltHesap.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<List<SubeDepoModel>?> subeDepoGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLSUBEDEPOSB");
    listeler.listSubeDepoModel =
        List.generate(maps.length, (i) => SubeDepoModel.fromJson(maps[i]));

    return listeler.listSubeDepoModel;
  }

  //database carileri güncelle
  Future<int?> subeDepoGuncelle(SubeDepoModel subeDepoModel) async {
    var result = await Ctanim.db?.update(
        "TBLSUBEDEPOSB", subeDepoModel.toJson(), where: 'ID = ?', whereArgs: [
      subeDepoModel.ID
    ]); // ıd'ye göre mi güncelleme yapılacak ?????????????
    return result;
  }

  //database cari ekle
  Future<int?> subeDepoEkle(SubeDepoModel subeDepoModel) async {
    try {
      subeDepoModel.ID = null;
      var result =
          await Ctanim.db?.insert("TBLSUBEDEPOSB", subeDepoModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<List<StokKosulModel>?> stokKosulGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLSTOKKOSULSB");
    listeler.listStokKosul =
        List.generate(maps.length, (i) => StokKosulModel.fromJson(maps[i]));

    return listeler.listStokKosul;
  }

  //database carileri güncelle
  Future<int?> stokKosulGuncelle(StokKosulModel stokKosul) async {
    var result = await Ctanim.db?.update("TBLSTOKKOSULSB", stokKosul.toJson(),
        where: 'KOSULID = ?', whereArgs: [stokKosul.KOSULID]);
    return result;
  }

  //database cari ekle
  Future<int?> stokKosulEkle(StokKosulModel stokKosul) async {
    try {
      stokKosul.ID = null;
      var result =
          await Ctanim.db?.insert("TBLSTOKKOSULSB", stokKosul.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> StokKosulTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLSTOKKOSULSB");
      print("TBLSTOKKOSULSB tablosu temizlendi.");

      // "TBLCARISTOKKOSULSB" tablosunu sil.
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLSTOKKOSULSB");

      // "TBLCARISTOKKOSULSB" tablosunu yeniden oluştur.
      await Ctanim.db?.execute("""CREATE TABLE TBLSTOKKOSULSB (
     ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      KOSULID INTEGER,
      GRUPKODU TEXT,
      FIYAT DECIMAL,
      ISK1 DECIMAL,
      ISK2 DECIMAL,
      ISK3 DECIMAL,
      ISK4 DECIMAL,
      ISK5 DECIMAL,
      ISK6 DECIMAL,
      SABITFIYAT DECIMAL
      )""");

      print("TBLSTOKKOSULSB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<List<CariKosulModel>?> cariKosulGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLCARIKOSULSB");
    listeler.listCariKosul =
        List.generate(maps.length, (i) => CariKosulModel.fromJson(maps[i]));

    return listeler.listCariKosul;
  }

  //database carileri güncelle
  Future<int?> cariKosulGuncelle(CariKosulModel cariKosul) async {
    var result = await Ctanim.db?.update("TBLCARIKOSULSB", cariKosul.toJson(),
        where: 'ID = ?', whereArgs: [cariKosul.ID]);
    return result;
  }

  //database cari ekle
  Future<int?> cariKosulEkle(CariKosulModel cariKosul) async {
    try {
      cariKosul.ID = null;
      var result =
          await Ctanim.db?.insert("TBLCARIKOSULSB", cariKosul.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> CariKosulTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLCARIKOSULSB");
      print("TBLCARIKOSULSB tablosu temizlendi.");

      // "TBLCARISTOKKOSULSB" tablosunu sil.
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLCARIKOSULSB");

      // "TBLCARISTOKKOSULSB" tablosunu yeniden oluştur.
      await Ctanim.db?.execute("""CREATE TABLE TBLCARIKOSULSB (
 ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      CARIKOD TEXT,
      GRUPKODU TEXT,
      FIYAT DECIMAL,
      ISK1 DECIMAL,
      ISK2 DECIMAL,
      ISK3 DECIMAL,
      ISK4 DECIMAL,
      ISK5 DECIMAL,
      ISK6 DECIMAL,
      SABITFIYAT DECIMAL
      )""");

      print("TBLCARIKOSULSB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<List<CariStokKosulModel>?> cariStokKosulGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps =
        await Ctanim.db?.query("TBLCARISTOKKOSULSB");
    listeler.listCariStokKosul =
        List.generate(maps.length, (i) => CariStokKosulModel.fromJson(maps[i]));
    return listeler.listCariStokKosul;
  }

  //database carileri güncelle
  Future<int?> cariStokKosulGuncelle(CariStokKosulModel cariStokKosul) async {
    var result = await Ctanim.db?.update(
        "TBLCARISTOKKOSULSB", cariStokKosul.toJson(),
        where: 'ID = ?', whereArgs: [cariStokKosul.ID]);
    return result;
  }

  //database cari ekle
  Future<int?> cariStokKosulEkle(CariStokKosulModel cariStokKosul) async {
    try {
      cariStokKosul.ID = null;
      var result =
          await Ctanim.db?.insert("TBLCARISTOKKOSULSB", cariStokKosul.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> CariStokKosulTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLCARISTOKKOSULSB");
      print("TBLCARISTOKKOSULSB tablosu temizlendi.");

      // "TBLCARISTOKKOSULSB" tablosunu sil.
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLCARISTOKKOSULSB");

      // "TBLCARISTOKKOSULSB" tablosunu yeniden oluştur.
      await Ctanim.db?.execute("""CREATE TABLE TBLCARISTOKKOSULSB (
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        STOKKOD TEXT,
        CARIKOD TEXT,
        FIYAT DECIMAL,
        ISK1 DECIMAL,
        ISK2 DECIMAL,
        SABITFIYAT DECIMAL
      )""");

      print("TBLCARISTOKKOSULSB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  /*Future<List<Cari>?> fisGetir() async {
    Database? db = await databaseHelper.database;
    var result = await db?.query("TBLFISSB");
    listeler.listCari = result!.map((e) => f.fromJson(e)).toList();
    cariEx.searchCariList.assignAll(listeler.listCari);
    return listeler.listCari;
  }
*/
  Future<int?> kurEkle(KurModel kurModel) async {
    try {
      var result = await Ctanim.db?.insert("TBLKURSB", kurModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> kurTemizle() async {
    if (Ctanim.db != null) {
      await Ctanim.db!.delete('TBLKURSB');
    }
  }

  Future<void> kurGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    listeler.listKur.clear();
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLKURSB");
    listeler.listKur =
        List.generate(maps.length, (i) => KurModel.fromJson(maps[i]));
    print(listeler.listKur);
  }

  Future<int?> logKayitEkle(LogModel logModel) async {
    try {
      var result = await Ctanim.db?.insert("TBLLOGSB", logModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<List<LogModel>?> logKayitGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLLOGSB");
    listeler.listLog =
        List.generate(maps.length, (i) => LogModel.fromJson(maps[i]));

    return listeler.listLog;
  }

  Future<List<OlcuBirimModel>?> olcuBirimGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLOLCUBIRIMSB");
    listeler.listOlcuBirim =
        List.generate(maps.length, (i) => OlcuBirimModel.fromJson(maps[i]));

    return listeler.listOlcuBirim;
  }

  //database carileri güncelle

  //database cari ekle
  Future<int?> olcuBirimEkle(OlcuBirimModel olcuBirimModel) async {
    try {
      var result =
          await Ctanim.db?.insert("TBLOLCUBIRIMSB", olcuBirimModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> olcuBirimTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLOLCUBIRIMSB");
      print("TBLOLCUBIRIMSB tablosu temizlendi.");

      // "TBLCARISTOKKOSULSB" tablosunu sil.
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLOLCUBIRIMSB");

      // "TBLCARISTOKKOSULSB" tablosunu yeniden oluştur.
      await Ctanim.db?.execute("""CREATE TABLE TBLOLCUBIRIMSB (
     ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ACIKLAMA TEXT
      )""");

      print("TBLOLCUBIRIMSB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> deleteAllImages() async {
    final db = await Ctanim?.db;
    await db?.execute('DELETE FROM images');
  }

  Future<int> insertImage(String imagePath) async {
    await deleteAllImages();
    return await Ctanim?.db.insert(
      'images',
      {'image_path': imagePath},
    );
  }

  Future<String?> getFirstImage() async {
    final List<Map<String, dynamic>> maps =
        await Ctanim.db.query('images', limit: 1);
    if (maps.isNotEmpty) {
      return maps.first['image_path'] as String;
    } else {
      return "";
    }
  }

  Future<int?> rafEkle(RafModel rafModel) async {
    try {
      var result = await Ctanim.db?.insert("TBLRAFSB", rafModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<List<RafModel>> rafGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLRAFSB");
    listeler.listRaf =
        List.generate(maps.length, (i) => RafModel.fromJson(maps[i]));

    return listeler.listRaf;
  }

  Future<void> rafTemizle() async {
    try {
      // Veritabanında "TBLCARISTOKKOSULSB" tablosunu temizle.
      await Ctanim.db?.delete("TBLRAFSB");
      print("TBLRAFSB tablosu temizlendi.");

      // "TBLCARISTOKKOSULSB" tablosunu sil.
      await Ctanim.db?.execute("DROP TABLE IF EXISTS TBLRAFSB");

      // "TBLCARISTOKKOSULSB" tablosunu yeniden oluştur.
      await Ctanim.db?.execute("""CREATE TABLE TBLRAFSB (
     ID INTEGER PRIMARY KEY AUTOINCREMENT,
      RAF TEXT
      )""");

      print("TBLRAFSB tablosu temizlendi ve yeniden oluşturuldu.");
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<List<DahaFazlaBarkod>?> dahaFazlaBarkodGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    List<Map<String, dynamic>> maps =
        await Ctanim.db?.query("TBLDAHAFAZLABARKODSB");
    listeler.listDahaFazlaBarkod =
        List.generate(maps.length, (i) => DahaFazlaBarkod.fromJson(maps[i]));

    return listeler.listDahaFazlaBarkod;
  }

  //database carileri güncelle

  //database cari ekle
  Future<int?> dahaFazlaBarkodEkle(DahaFazlaBarkod dahaFazlaBarkod) async {
    try {
      var result = await Ctanim.db
          ?.insert("TBLDAHAFAZLABARKODSB", dahaFazlaBarkod.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<int?> dahaFazlaBarkodGuncelle(DahaFazlaBarkod dahaFazlaBarkod) async {
    var result = await Ctanim.db?.update(
        "TBLDAHAFAZLABARKODSB", dahaFazlaBarkod.toJson(),
        where: 'BARKOD = ?', whereArgs: [dahaFazlaBarkod.BARKOD]);
    return result;
  }

  Future<int?> plasiyerBankaEkle(BankaModel bankaModel) async {
    try {
      var result =
          await Ctanim.db?.insert("TBLPLASIYERBANKASB", bankaModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> plasiyerBankaTemizle() async {
    if (Ctanim.db != null) {
      await Ctanim.db!.delete('TBLPLASIYERBANKASB');
    }
  }

  Future<void> plasiyerBankaGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    listeler.listBankaModel.clear();
    List<Map<String, dynamic>> maps =
        await Ctanim.db?.query("TBLPLASIYERBANKASB");
    listeler.listBankaModel =
        List.generate(maps.length, (i) => BankaModel.fromJson(maps[i]));
    print(listeler.listBankaModel);
  }

  Future<int?> plasiyerBankaSozlesmeEkle(
      BankaSozlesmeModel bankaSozlesmeModel) async {
    try {
      var result = await Ctanim.db
          ?.insert("TBLPLASIYERBANKASOZLESMESB", bankaSozlesmeModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> plasiyerBankaSozlesmeTemizle() async {
    if (Ctanim.db != null) {
      await Ctanim.db!.delete('TBLPLASIYERBANKASOZLESMESB');
    }
  }

  Future<void> plasiyerBankaSozlesmeGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    listeler.listBankaSozlesmeModel.clear();
    List<Map<String, dynamic>> maps =
        await Ctanim.db?.query("TBLPLASIYERBANKASOZLESMESB");
    listeler.listBankaSozlesmeModel =
        List.generate(maps.length, (i) => BankaSozlesmeModel.fromJson(maps[i]));
    print(listeler.listBankaSozlesmeModel);
  }

  Future<int?> islemTipiEkle(SatisTipiModel satisTipiModel) async {
    try {
      var result =
          await Ctanim.db?.insert("TBLSATISTIPSB", satisTipiModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> islemTipiTemizle() async {
    if (Ctanim.db != null) {
      await Ctanim.db!.delete('TBLSATISTIPSB');
    }
  }

  Future<void> islemTipiGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    listeler.listSatisTipiModel.clear();
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLSATISTIPSB");
    listeler.listSatisTipiModel =
        List.generate(maps.length, (i) => SatisTipiModel.fromJson(maps[i]));
    print(listeler.listSatisTipiModel);
  }

  Future<int?> stokFiyatListesiEkle(StokFiyatListesiModel stokFiyatListesiModel) async {
    try {
      var result =
          await Ctanim.db?.insert("TBLSTOKFIYATLISTESISB", stokFiyatListesiModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> stokFiyatListesiTemizle() async {
    if (Ctanim.db != null) {
      await Ctanim.db!.delete('TBLSTOKFIYATLISTESISB');
    }
  }

  Future<void> stokFiyatListesiGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    listeler.listStokFiyatListesi.clear();
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLSTOKFIYATLISTESISB");
    listeler.listStokFiyatListesi =
        List.generate(maps.length, (i) => StokFiyatListesiModel.fromJson(maps[i]));
    print(listeler.listStokFiyatListesi);
  }  



  Future<int?> stokFiyatListesiHarEkle(StokFiyatListesiHarModel stokFiyatListesiHarModel) async {
    try {
      var result =
          await Ctanim.db?.insert("TBLSTOKFIYATLISTESIHARSB", stokFiyatListesiHarModel.toJson());
      return result;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> stokFiyatListesiHarTemizle() async {
    if (Ctanim.db != null) {
      await Ctanim.db!.delete('TBLSTOKFIYATLISTESIHARSB');
    }
  }

  Future<void> stokFiyatListesiHarGetir() async {
    //   var result = await Ctanim.db?.query("TBLCARISB");
    listeler.listStokFiyatListesiHar.clear();
    List<Map<String, dynamic>> maps = await Ctanim.db?.query("TBLSTOKFIYATLISTESIHARSB");
    listeler.listStokFiyatListesiHar =
        List.generate(maps.length, (i) => StokFiyatListesiHarModel.fromJson(maps[i]));
    print(listeler.listStokFiyatListesiHar);
  }  
  Future<int> veriGetir() async {
    await rafGetir();
    await olcuBirimGetir();
    await kurGetir();
    await cariKosulGetir();
    await stokKosulGetir();
    await cariStokKosulGetir();
    await dahaFazlaBarkodGetir();
    List<StokKart>? temp1 = await stokGetir();
    List<Cari>? temp2 = await cariGetir();
    List<SubeDepoModel>? temp3 = await subeDepoGetir();
    if (temp1!.length > 0 || temp2!.length > 0 || temp3!.length > 0) {
      return 1;
    } else {
      return 0;
    }

    //cariAltHesapGetir();
    //cari ve alt hesapları burda mı bağlasak
  }
}
