import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../controllers/tahsilatController.dart';
import '../genel_belge.dart/genel_belge_main_page.dart';
import '../stok_kart/stok_kart_listesi.dart';
import '../widget/veriler/listeler.dart';
import '../Depo Transfer/depo_transfer_main_page.dart';
import '../cari_kart/cari_cari_islemler.dart';
import '../widget/customAlertDialog.dart';
import '../genel_belge.dart/genel_belge_main_page.dart';
import '../yonetimsel_raporlar.dart/yonetimselRaporlarMainpage.dart';
import '../controllers/fisController.dart';
import '../sayim_kayit/sayim_fisi_main_page.dart';
import '../tahsilat/tahsilat_main_page.dart';
import '../odeme/odeme_main_page.dart';
import '../cari_virman/cari_virman_main_page.dart';
import '../veri_islemleri/veri_kayit_main_page.dart';
import '../cari_raporlari/cari_raporlari_main_page.dart';
import '../stok_raporlari/stok_raporlari_main_page.dart';
import '../fatura_raporlari/fatura_raporlari_main_page.dart';
import '../siparis_raporlari/siparis_raporları_main_page.dart';
import '../irsaliye_raporlari/irsaliye_raporlari_main_page.dart';
import '../controllers/cariController.dart';
import '../controllers/depoController.dart';
import '../controllers/stokKartController.dart';
import '../stok_kart/Spinkit.dart';
import '../webservis/base.dart';
import '../widget/kullaniciModel.dart';
import '../widget/modeller/sharedPreferences.dart';
import '../widget/login2.dart';
import '../widget/ctanim.dart';
import '../localDB/veritabaniIslemleri.dart';
import '../cari_kart/cari_islemler_page.dart';
import '../widget/veriler/gonderilmisBelgeler.dart';
import '../widget/veriler/gonderilmisTahsilatOdemeler.dart';
import '../faturaFis/fis.dart';
import '../tahsilatOdemeModel/tahsilat.dart';
import '../Depo Transfer/depo.dart';
import '../widget/veriler/gonderilmisSayimlar.dart';
import '../widget/veriler/kaydedilmisBelgeler.dart';
import '../widget/veriler/kaydedilmisTahsilatOdemeler.dart';
import '../widget/veriler/kaydedilmisTahsilatOdemelerDetay.dart';
import '../widget/veriler/kaydedilmisSayimlar.dart';
import '../widget/veriler/kaydedilmisSayimlarDetay.dart';
import '../tahsilat/deneme3.dart';
import '../interaktif_rapor/interaktif_rapor_main_page.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool tahAcikmi = false;
  bool fatAcikmi = false;
  bool sipAcikmi = false;
  bool perAcikmi = false;
  bool stokAcikmi = false;
  FisController fisEx = Get.find();

  CariController cariEx = Get.find(); // PUT DEĞİŞTİ
  final StokKartController stokKartEx = Get.find();
  BaseService bs = BaseService();
  String currentTime = '';

  @override
  void initState() {
    super.initState();
    updateTime();
  }

  void updateTime() {
    setState(() {
      final now = DateTime.now();
      final formatter = DateFormat('dd.MM.yyyy HH:mm');
      currentTime = formatter.format(now);
    });
    Future.delayed(Duration(seconds: 1), updateTime);
  }

  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  String genelHata = "";

  Future<bool> loadData() async {
    listeler.listKur.clear();
    listeler.listOlcuBirim.clear();

    List<String?> hatalar = [];
    await bs.getKullanicilar(kullaniciKodu: "5", sirket: Ctanim.sirket!);
    hatalar.add(await bs.getirRaf(sirket: Ctanim.sirket!));
    hatalar.add(await bs.getirOlcuBirim(sirket: Ctanim.sirket!));
    hatalar.add(await stokKartEx.servisStokGetir());
    hatalar.add(await cariEx.servisCariGetir());
    hatalar.add(await bs.getirSubeDepo(sirket: Ctanim.sirket!));
    hatalar.add(await bs.getirStokKosul(sirket: Ctanim.sirket!));
    hatalar.add(await bs.getirCariKosul(sirket: Ctanim.sirket!));
    hatalar.add(await bs.getirCariStokKosul(sirket: Ctanim.sirket!));
    hatalar.add(await bs.getirKur(sirket: Ctanim.sirket!));
    hatalar.add(await bs.getirDahaFazlaBarkod(
        sirket: Ctanim.sirket!, kullaniciKodu: Ctanim.kullanici!.KOD!));
    hatalar.add(await bs.getirPlasiyerBanka(
        sirket: Ctanim.sirket!, kullaniciKodu: Ctanim.kullanici!.KOD!));
    hatalar.add(await bs.getirPlasiyerBankaSozlesme(
        sirket: Ctanim.sirket!, kullaniciKodu: Ctanim.kullanici!.KOD!));
    if (hatalar.length > 0) {
      for (var element in hatalar) {
        if (element != "") {
          genelHata = genelHata + "\n" + element!;
        }
      }
    }
    if (genelHata != "") {
      return true;
    } else {
      return false;
    }
  }

  TahsilatController tahsilatEx = Get.find();
  static SayimController sayimEx = Get.find();
  XFile? _selectedImage;
  Future<void> _pickImage() async {
    var pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = pickedImage;
    });

    if (_selectedImage != null) {
      // Resmi veritabanına kaydet
      final imagePath = _selectedImage!.path;
      await VeriIslemleri().insertImage(imagePath);
      showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              pdfSimgesi: false,
              align: TextAlign.center,
              title: 'Başarılı',
              message: 'Logo Değiştirildi',
              onPres: () async {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              buttonText: 'Tamam',
            );
          });

      setState(() {});
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //var ekranBilgisi = MediaQuery(data: MediaQueryData(), child: MaterialApp());
    var ekranBilgisi = MediaQuery.of(context);

    double ekranYuksekligi = ekranBilgisi.size.height;
    double ekranGenisligi = ekranBilgisi.size.width;
    return Drawer(
      child: Container(
        color: Color.fromARGB(255, 29, 29, 29),
        child: ListView(
          children: [
            SizedBox(
              height: ekranYuksekligi / 3.5,
              child: DrawerHeader(
                child: //
                    Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentTime,
                          style: TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Container(
                                  color: Color.fromARGB(255, 27, 28, 29),
                                  padding: EdgeInsets.all(16.0),
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Divider(
                                        thickness: 3,
                                        indent: 150,
                                        endIndent: 150,
                                        color: Colors.grey,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          _pickImage();
                                        },
                                        child: ListTile(
                                          title: Text("Logomu Değiştir",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          leading: Icon(
                                            Icons.image,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ),
                                      /*
                                      GestureDetector(
                                        onTap: () async {
                                          _pickImage();
                                        },
                                        child: ListTile(
                                          title: Text(
                                              "Seçili Verileri Güncelle",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          leading: Icon(
                                            Icons.security_update_good_outlined,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      */
                                      GestureDetector(
                                        onTap: () async {
                                          bool hasInternet =
                                              await checkInternetConnectivity();
                                          if (hasInternet) {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return LoadingSpinner(
                                                  color: Colors.blue,
                                                  message:
                                                      'Ana Makinadan Veriler Çekiliyor...',
                                                );
                                              },
                                            );
                                            bool mu = await loadData();

                                            if (mu == false) {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Tüm Veriler Başarıyla Güncellendi!',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17),
                                                  ),
                                                  duration: Duration(
                                                      seconds:
                                                          10), // Snackbar'ın süresi 10 saniye
                                                  showCloseIcon: true,
                                                  closeIconColor: Colors.red,
                                                ),
                                              );
                                              Navigator.of(context).pop();
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return CustomAlertDialog(
                                                      align: TextAlign.left,
                                                      title: 'Hata',
                                                      message:
                                                          'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                                                              genelHata,
                                                      onPres: () async {
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      buttonText: 'Devam Et',
                                                    );
                                                  });
                                            }
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'İnternet Bağlantısı Yok'),
                                                  content: Text(
                                                      'İnternet bağlantısı olmadığından veriler alınamadı. Kaydedilen Son Veriler Kullanılacak.'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Tamam'),
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: ListTile(
                                          title: Text(
                                            "Tüm Verileri Güncelle",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          leading: Icon(
                                            Icons.update,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          //KullaniciModel.clearUser();
                                          // Ctanim.kullanici = null;
                                          await SharedPrefsHelper.saveList(
                                              listeler.sayfaDurum);
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(
                                                title: '',
                                              ),
                                            ),
                                            (Route<dynamic> route) => false,
                                          );
                                        },
                                        child: ListTile(
                                          title: Text("Çıkış Yap",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          leading: Icon(
                                            Icons.login_outlined,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                    SizedBox(
                        width: ekranGenisligi / 3.5,
                        height: ekranYuksekligi / 8.5,
                        child: Image.asset("images/opaklogo2.png")),
                    Text(
                      "KURUMSAL YAZILIM ÇÖZÜMLERİ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            listeler.plasiyerYetkileri[0] == true
                ? ExpansionTile(
                    leading: Icon(Icons.group),
                    title: Text(
                      "Cari İşlemler",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ListTile(
                          leading: Icon(
                            Icons.format_list_bulleted,
                            color: Colors.white,
                            size: 19,
                          ),
                          title: Padding(
                            padding: EdgeInsets.only(left: ekranGenisligi / 50),
                            child: Text("Cari Kart Listesi",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => cari_islemler_page(
                                      widgetListBelgeSira: 0,
                                    )));
                            //MaterialPageRoute(builder: (context) => cari_islemler_page());
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
            listeler.plasiyerYetkileri[1] == true ||
                    listeler.plasiyerYetkileri[2] == true ||
                    listeler.plasiyerYetkileri[3] == true
                ? ExpansionTile(
                    onExpansionChanged: (value) {
                      fatAcikmi = value;
                    },
                    leading: fatAcikmi == false
                        ? creatBadge(
                            child: Icon(Icons.receipt_sharp),
                            belgeTipi: "faturaToplam",
                            top: -10,
                            end: -12,
                            size: 10)
                        : Icon(Icons.receipt_sharp),
                    title: Text("Fatura İşlemleri",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: [
                        listeler.plasiyerYetkileri[1] == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: ekranGenisligi / 50),
                                child: ListTile(
                                  leading: creatBadge(
                                      top: -10,
                                      end: -12,
                                      size: 10,
                                      child: Icon(
                                        Icons.shopping_bag,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                      belgeTipi: "Satis_Fatura"),
                                  title: Text("Satış Fatura Kayıt",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                  onTap: () {
                                    fisEx
                                        .listFisGetir(belgeTip: "Satis_Fatura")
                                        .then((value) =>
                                            Get.to(() => genel_belge_main_page(
                                                  belgeTipi: "Satis_Fatura",
                                                  widgetListBelgeSira: 1,
                                                )));
                                  },
                                ),
                              )
                            : Container(),
                        listeler.plasiyerYetkileri[2] == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: ekranGenisligi / 50),
                                child: ListTile(
                                  leading: creatBadge(
                                      child: Icon(
                                        Icons.receipt_long,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                      belgeTipi: "Satis_Irsaliye",
                                      top: -10,
                                      end: -12,
                                      size: 10),
                                  title: Text("Satış İrsaliye Kayıt",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                  onTap: () {
                                    fisEx
                                        .listFisGetir(
                                            belgeTip: "Satis_Irsaliye")
                                        .then((value) => Get.to(
                                            () => const genel_belge_main_page(
                                                  belgeTipi: "Satis_Irsaliye",
                                                  widgetListBelgeSira: 2,
                                                )));
                                  },
                                ),
                              )
                            : Container(),
                        listeler.plasiyerYetkileri[3] == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: ekranGenisligi / 50),
                                child: ListTile(
                                  leading: creatBadge(
                                      child: Icon(
                                        Icons.receipt_long,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                      belgeTipi: "Alis_Irsaliye",
                                      top: -10,
                                      end: -12,
                                      size: 10),
                                  title: Text("Alış İrsaliye Kayıt",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                  onTap: () {
                                    fisEx
                                        .listFisGetir(belgeTip: "Alis_Irsaliye")
                                        .then((value) => Get.to(
                                            () => const genel_belge_main_page(
                                                  belgeTipi: "Alis_Irsaliye",
                                                  widgetListBelgeSira: 3,
                                                )));
                                  },
                                ),
                              )
                            : Container(),
                      ])
                : Container(),
            listeler.plasiyerYetkileri[4] == true ||
                    listeler.plasiyerYetkileri[5] == true ||
                    listeler.plasiyerYetkileri[6] == true
                ? ExpansionTile(
                    onExpansionChanged: (value) {
                      sipAcikmi = value;
                    },
                    leading: sipAcikmi == false
                        ? creatBadge(
                            child: Icon(Icons.shopping_basket),
                            belgeTipi: "siparisToplam",
                            top: -10,
                            end: -12,
                            size: 10)
                        : Icon(Icons.shopping_basket),
                    title: Text("Sipariş İşlemleri",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: [
                      listeler.plasiyerYetkileri[4] == true
                          ? Padding(
                              padding:
                                  EdgeInsets.only(left: ekranGenisligi / 50),
                              child: ListTile(
                                leading: creatBadge(
                                    child: Icon(
                                      Icons.south_east,
                                      color: Colors.white,
                                      size: 19,
                                    ),
                                    belgeTipi: "Alinan_Siparis",
                                    top: -10,
                                    end: -12,
                                    size: 10),
                                title: Text("Alinan_Siparis",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                onTap: () {
                                  fisEx
                                      .listFisGetir(belgeTip: "Alinan_Siparis")
                                      .then((value) => Get.to(
                                          () => const genel_belge_main_page(
                                                belgeTipi: "Alinan_Siparis",
                                                widgetListBelgeSira: 4,
                                              )));
                                },
                              ),
                            )
                          : Container(),
                      listeler.plasiyerYetkileri[5] == true
                          ? Padding(
                              padding:
                                  EdgeInsets.only(left: ekranGenisligi / 50),
                              child: ListTile(
                                leading: creatBadge(
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: Colors.white,
                                      size: 19,
                                    ),
                                    belgeTipi: "Musteri_Siparis",
                                    top: -10,
                                    end: -12,
                                    size: 10),
                                title: Text("Müşteri Sipariş",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                onTap: () {
                                  //BURASI DEĞİŞECEK !
                                  fisEx
                                      .listFisGetir(belgeTip: "Musteri_Siparis")
                                      .then((value) => Get.to(
                                          () => const genel_belge_main_page(
                                                belgeTipi: "Musteri_Siparis",
                                                widgetListBelgeSira: 5,
                                              )));
                                },
                              ),
                            )
                          : Container(),
                      listeler.plasiyerYetkileri[6] == true
                          ? Padding(
                              padding:
                                  EdgeInsets.only(left: ekranGenisligi / 50),
                              child: ListTile(
                                leading: creatBadge(
                                    child: Icon(
                                      Icons.real_estate_agent,
                                      color: Colors.white,
                                      size: 19,
                                    ),
                                    belgeTipi: "Satis_Teklif",
                                    top: -10,
                                    end: -12,
                                    size: 10),
                                title: Text("Satış Teklif",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                onTap: () {
                                  fisEx
                                      .listFisGetir(belgeTip: "Satis_Teklif")
                                      .then((value) => Get.to(
                                          () => const genel_belge_main_page(
                                                belgeTipi: "Satis_Teklif",
                                                widgetListBelgeSira: 6,
                                              )));
                                },
                              ),
                            )
                          : Container(),
                    ],
                  )
                : Container(),
            listeler.plasiyerYetkileri[7] == true ||
                    listeler.plasiyerYetkileri[8] == true ||
                    listeler.plasiyerYetkileri[9] == true
                ? ExpansionTile(
                    onExpansionChanged: (value) {
                      stokAcikmi = value;
                    },
                    leading: stokAcikmi == false
                        ? creatBadge(
                            child: Icon(Icons.category),
                            belgeTipi: "stokIslemToplam",
                            top: -10,
                            end: -12,
                            size: 10)
                        : Icon(Icons.category),
                    title: Text("Stok İşlemleri",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: [
                      listeler.plasiyerYetkileri[7] == true
                          ? Padding(
                              padding:
                                  EdgeInsets.only(left: ekranGenisligi / 50),
                              child: ListTile(
                                leading: Icon(
                                  Icons.app_registration_outlined,
                                  color: Colors.white,
                                  size: 19,
                                ),
                                title: Text("Stok Kart Listesi",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => stok_kart_listesi(
                                              widgetListBelgeSira: 7,
                                            )),
                                  );
                                },
                              ),
                            )
                          : Container(),
                      listeler.plasiyerYetkileri[8] == true
                          ? Padding(
                              padding:
                                  EdgeInsets.only(left: ekranGenisligi / 50),
                              child: ListTile(
                                leading: creatBadge(
                                    child: Icon(Icons.local_shipping,
                                        color: Colors.white, size: 19),
                                    belgeTipi: "Depo_Transfer",
                                    top: -10,
                                    end: -12,
                                    size: 10),
                                title: Text("Depo Transfer",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                onTap: () {
                                  fisEx
                                      .listFisGetir(belgeTip: "Depo_Transfer")
                                      .then((value) =>
                                          Get.to(() => depo_transfer_main_page(
                                                belgeTipi: "Depo_Transfer",
                                                widgetListBelgeSira: 8,
                                              )));
                                },
                              ),
                            )
                          : Container(),
                      listeler.plasiyerYetkileri[9] == true
                          ? Padding(
                              padding:
                                  EdgeInsets.only(left: ekranGenisligi / 50),
                              child: ListTile(
                                leading: creatBadge(
                                    child: Icon(
                                        Icons.content_paste_search_rounded,
                                        color: Colors.white,
                                        size: 19),
                                    belgeTipi: "Sayim",
                                    top: -10,
                                    end: -12,
                                    size: 10),
                                title: Text("Sayım Kayıt Fişi",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                onTap: () {
                                  sayimEx.listSayimGetir().then((value) =>
                                      Get.to(() => sayim_fisi_main_page(
                                            widgetListBelgeSira: 9,
                                          )));
                                },
                              ),
                            )
                          : Container(),
                    ],
                  )
                : Container(),
            listeler.plasiyerYetkileri[10] == true
                ? ExpansionTile(
                    onExpansionChanged: (value) {
                      perAcikmi = value;
                    },
                    leading: perAcikmi == false
                        ? creatBadge(
                            child: Icon(Icons.store_mall_directory),
                            belgeTipi: "perakendeToplam",
                            top: -10,
                            end: -12,
                            size: 10)
                        : Icon(Icons.store_mall_directory),
                    title: Text(
                      "Perakende İşlemler",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: ListTile(
                          leading: creatBadge(
                              child: Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 19,
                              ),
                              belgeTipi: "Perakende_Satis",
                              top: -10,
                              end: -12,
                              size: 10),
                          title: Padding(
                            padding: EdgeInsets.only(left: ekranGenisligi / 50),
                            child: Text("Perakende Satış Fişi",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                          ),
                          onTap: () {
                            fisEx
                                .listFisGetir(belgeTip: "Perakende_Satis")
                                .then((value) =>
                                    Get.to(() => const genel_belge_main_page(
                                          belgeTipi: "Perakende_Satis",
                                          widgetListBelgeSira: 10,
                                        )));
                            //MaterialPageRoute(builder: (context) => cari_islemler_page());
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
            listeler.plasiyerYetkileri[11] == true ||
                    listeler.plasiyerYetkileri[12] == true ||
                    listeler.plasiyerYetkileri[13] == true
                ? ExpansionTile(
                    onExpansionChanged: (value) {
                      tahAcikmi = value;
                    },
                    leading: tahAcikmi == false
                        ? creatBadge(
                            child: Icon(Icons.wallet),
                            belgeTipi: "tahsilatOdemeToplam",
                            top: -10,
                            end: -12,
                            size: 10)
                        : Icon(Icons.wallet),
                    title: Text("Tahsilat ve Ödeme İşlemleri",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: [
                      listeler.plasiyerYetkileri[11] == true
                          ? Padding(
                              padding:
                                  EdgeInsets.only(left: ekranGenisligi / 50),
                              child: ListTile(
                                leading: creatBadge(
                                    child: Icon(Icons.add_card_outlined,
                                        color: Colors.white, size: 19),
                                    belgeTipi: "Tahsilat",
                                    top: -10,
                                    end: -12,
                                    size: 10),
                                title: Text("Tahsilat",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                onTap: () {
                                  tahsilatEx
                                      .listTahsilatGetir(belgeTip: "Tahsilat")
                                      .then((value) =>
                                          Get.to(() => const tahsilat_main_page(
                                                widgetListBelgeSira: 11,
                                              )));
                                },
                              ),
                            )
                          : Container(),
                      listeler.plasiyerYetkileri[12] == true
                          ? Padding(
                              padding:
                                  EdgeInsets.only(left: ekranGenisligi / 50),
                              child: ListTile(
                                leading: creatBadge(
                                    child: Icon(Icons.payments,
                                        color: Colors.white, size: 19),
                                    belgeTipi: "Odeme",
                                    top: -10,
                                    end: -12,
                                    size: 10),
                                title: Text("Ödeme",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                onTap: () {
                                  tahsilatEx
                                      .listTahsilatGetir(belgeTip: "Odeme")
                                      .then((value) =>
                                          Get.to(() => const odeme_main_page(
                                                widgetListBelgeSira: 12,
                                              )));
                                },
                              ),
                            )
                          : Container(),
                      /*
                      listeler.plasiyerYetkileri[13] == true
                          ? Padding(
                              padding:
                                  EdgeInsets.only(left: ekranGenisligi / 50),
                              child: ListTile(
                                leading: Icon(Icons.view_stream_rounded,
                                    color: Colors.white, size: 19),
                                title: Text("Virman",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            cari_virman_main_page(
                                              widgetListBelgeSira: 13,
                                            ))),
                                  );
                                },
                              ),
                            )
                          : Container(),
                          */
                    ],
                  )
                : Container(),
            listeler.plasiyerYetkileri[14] == true
                ? ExpansionTile(
                    leading: Icon(Icons.data_saver_off_sharp),
                    title: Text("Veri İşlemleri",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: [
                        Padding(
                          padding: EdgeInsets.only(left: ekranGenisligi / 50),
                          child: ListTile(
                            leading: Icon(Icons.storage_rounded,
                                color: Colors.white, size: 19),
                            title: Text("Veri Kayıt",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          veri_kayit_main_page(
                                            widgetListBelgeSira: 14,
                                          ))));
                            },
                          ),
                        ),
                      ])
                : Container(),
            listeler.plasiyerYetkileri[16] == true ||
                    listeler.plasiyerYetkileri[17] == true ||
                    listeler.plasiyerYetkileri[18] == true ||
                    listeler.plasiyerYetkileri[19] == true ||
                    listeler.plasiyerYetkileri[20] == true ||
                    listeler.plasiyerYetkileri[21] == true ||
                    listeler.plasiyerYetkileri[22] == true
                ? ExpansionTile(
                    leading: Icon(Icons.insert_chart_outlined_sharp),
                    title: Text("Raporlar",
                        style: TextStyle(fontSize: 15, color: Colors.white)),
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    children: [
                        listeler.plasiyerYetkileri[16] == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: ekranGenisligi / 50),
                                child: ListTile(
                                  leading: Icon(Icons.badge,
                                      color: Colors.white, size: 19),
                                  title: Text("Cari Raporları",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                cari_raporlari_main_page(
                                                  widgetListBelgeSira: 16,
                                                ))));
                                  },
                                ),
                              )
                            : Container(),
                        listeler.plasiyerYetkileri[17] == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: ekranGenisligi / 50),
                                child: ListTile(
                                  leading: Icon(Icons.query_stats,
                                      color: Colors.white, size: 19),
                                  title: Text("Stok Raporları",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                stok_raporlari_main_page(
                                                  widgetListBelgeSira: 17,
                                                ))));
                                  },
                                ),
                              )
                            : Container(),
                        listeler.plasiyerYetkileri[18] == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: ekranGenisligi / 50),
                                child: ListTile(
                                  leading: Icon(Icons.trending_up,
                                      color: Colors.white, size: 19),
                                  title: Text("Sipariş Raporları",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                siparis_raporlari_main_page(
                                                  widgetListBelgeSira: 18,
                                                  cariGonderildiMi: false,
                                                ))));
                                  },
                                ),
                              )
                            : Container(),
                        listeler.plasiyerYetkileri[19] == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: ekranGenisligi / 50),
                                child: ListTile(
                                  leading: Icon(Icons.bar_chart,
                                      color: Colors.white, size: 19),
                                  title: Text("Fatura Raporları",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                fatura_raporlari_main_page(
                                                  widgetListBelgeSira: 19,
                                                  cariGonderildiMi: false,
                                                ))));
                                  },
                                ),
                              )
                            : Container(),
                        listeler.plasiyerYetkileri[20] == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: ekranGenisligi / 50),
                                child: ListTile(
                                  leading: Icon(Icons.timeline,
                                      color: Colors.white, size: 19),
                                  title: Text("İrsaliye Raporları",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                irsaliye_raporlari_main_page(
                                                  widgetListBelgeSira: 20,
                                                  cariGonderildiMi: false,
                                                ))));
                                  },
                                ),
                              )
                            : Container(),
                        listeler.plasiyerYetkileri[21] == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: ekranGenisligi / 50),
                                child: ListTile(
                                  leading: Icon(Icons.bar_chart,
                                      color: Colors.white, size: 19),
                                  title: Text("Yönetimsel Raporlar",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                  onTap: () async {
                                    if (await Connectivity()
                                            .checkConnectivity() ==
                                        ConnectivityResult.none) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomAlertDialog(
                                              align: TextAlign.center,
                                              title: 'Hata',
                                              message:
                                                  "İnternet Bağlantısı Bulunamadı!",
                                              onPres: () {
                                                Navigator.pop(context);
                                              },
                                              buttonText: 'Tamam',
                                            );
                                          });
                                    } else {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return LoadingSpinner(
                                            color: Colors.black,
                                            message:
                                                "Yönetimsel Raporlar Hazırlanıyor...",
                                          );
                                        },
                                      );
                                      try {
                                        List<List<dynamic>> gelenNakitDurum =
                                            await bs.getirFinansNakitDurum(
                                                sirket: Ctanim.sirket!);
                                        List<List<dynamic>> gelenSatisDurum =
                                            await bs.getirFinansSatisDurum(
                                                sirket: Ctanim.sirket!);
                                        List<List<dynamic>>
                                            gelenSiparisTeklifDurum = await bs
                                                .getirFinansSiparisTeklifDurum(
                                                    sirket: Ctanim.sirket!);
                                        List<List<dynamic>> gelenCekSenetDurum =
                                            await bs.getirFinansCekSenetDurum(
                                                sirket: Ctanim.sirket!);
                                        List<List<dynamic>> gelenCariDurum =
                                            await bs.getirFinansCariDurum(
                                                sirket: Ctanim.sirket!);
                                        String genelHata = "";
                                        if (gelenNakitDurum[0].length == 1 &&
                                            gelenNakitDurum[1].length == 0 &&
                                            gelenNakitDurum[2].length == 0) {
                                          genelHata = genelHata +
                                              "\n" +
                                              gelenNakitDurum[0][0];
                                        }
                                        if (gelenSatisDurum[0].length == 1 &&
                                            gelenSatisDurum[1].length == 0 &&
                                            gelenSatisDurum[2].length == 0) {
                                          genelHata = genelHata +
                                              "\n" +
                                              gelenSatisDurum[0][0];
                                        }
                                        if (gelenSiparisTeklifDurum[0].length == 1 &&
                                            gelenSiparisTeklifDurum[1].length ==
                                                0 &&
                                            gelenSiparisTeklifDurum[2].length ==
                                                0) {
                                          genelHata = genelHata +
                                              "\n" +
                                              gelenSiparisTeklifDurum[0][0];
                                        }
                                        if (gelenCekSenetDurum[0].length == 1 &&
                                            gelenCekSenetDurum[1].length == 0 &&
                                            gelenCekSenetDurum[2].length == 0) {
                                          genelHata = genelHata +
                                              "\n" +
                                              gelenCekSenetDurum[0][0];
                                        }
                                        if (gelenCariDurum[0].length == 1 &&
                                            gelenCariDurum[1].length == 0 &&
                                            gelenCariDurum[2].length == 0) {
                                          genelHata = genelHata +
                                              "\n" +
                                              gelenCekSenetDurum[0][0];
                                        }
                                        if (genelHata != "") {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CustomAlertDialog(
                                                  align: TextAlign.left,
                                                  title: 'Hata',
                                                  message:
                                                      'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                                                          genelHata,
                                                  onPres: () async {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: ((context) =>
                                                                yonetimselRaporlarMainPage(
                                                                  nakitDurumGelenVeri:
                                                                      gelenNakitDurum,
                                                                  widgetListBelgeSira:
                                                                      21,
                                                                  satisDurumGelenVeri:
                                                                      gelenSatisDurum,
                                                                  siparisTeklifDurumGelenVeri:
                                                                      gelenSiparisTeklifDurum,
                                                                  cekSenetDurumGelenVeri:
                                                                      gelenCekSenetDurum,
                                                                  cariDurumGelenVeri:
                                                                      gelenCariDurum,
                                                                )))).then(
                                                        (value) {
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  buttonText: 'Devam Et',
                                                );
                                              });
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      yonetimselRaporlarMainPage(
                                                        nakitDurumGelenVeri:
                                                            gelenNakitDurum,
                                                        widgetListBelgeSira: 22,
                                                        satisDurumGelenVeri:
                                                            gelenSatisDurum,
                                                        siparisTeklifDurumGelenVeri:
                                                            gelenSiparisTeklifDurum,
                                                        cekSenetDurumGelenVeri:
                                                            gelenCekSenetDurum,
                                                        cariDurumGelenVeri:
                                                            gelenCariDurum,
                                                      )))).then((value) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                        }
                                      } catch (error) {
                                        print("Hata: $error");
                                        const snackBar = SnackBar(
                                          content: Text(
                                            'Raporlar Çekilirken Hata Oluştu.',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          showCloseIcon: true,
                                          backgroundColor: Colors.blue,
                                          closeIconColor: Colors.white,
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    }
                                  },
                                ),
                              )
                            : Container(),
                        listeler.plasiyerYetkileri[22] == true
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: ekranGenisligi / 50),
                                child: ListTile(
                                  leading: Icon(Icons.show_chart,
                                      color: Colors.white, size: 19),
                                  title: Text("İnteraktif Rapor",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                  onTap: () async {
                                    if (await Connectivity()
                                            .checkConnectivity() ==
                                        ConnectivityResult.none) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomAlertDialog(
                                              align: TextAlign.center,
                                              title: 'Hata',
                                              message:
                                                  "İnternet Bağlantısı Bulunamadı!",
                                              onPres: () {
                                                Navigator.pop(context);
                                              },
                                              buttonText: 'Tamam',
                                            );
                                          });
                                    } else {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return LoadingSpinner(
                                            color: Colors.black,
                                            message:
                                                "İnteraktif Raporlar Getiriliyor...",
                                          );
                                        },
                                      );
                                    }
                                    String genelHata =
                                        await bs.getirInteraktifRaporBilgi(
                                            sirket: Ctanim.sirket!,
                                            kullaniciKodu:
                                                Ctanim.kullanici!.KOD!);

                                    if (genelHata != "") {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomAlertDialog(
                                              align: TextAlign.left,
                                              title: 'Hata',
                                              message:
                                                  'Web Servisten Veri Alınırken Bazı Hatalar İle Karşılaşıldı:\n' +
                                                      genelHata,
                                              onPres: () async {
                                                Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: ((context) =>
                                                                interaktif_rapor_main_page())))
                                                    .then((value) {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              buttonText: 'Devam Et',
                                            );
                                          });
                                    } else {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      interaktif_rapor_main_page())))
                                          .then((value) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      });
                                    }
                                  },
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.only(left: ekranGenisligi / 50),
                          child: ListTile(
                            leading: Icon(Icons.cloud_upload_rounded,
                                color: Colors.white, size: 19),
                            title: Text("Gönderilmiş Belgeler",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            onTap: () async {
                              List<Fis> gidenFisler = [];
                              try {
                                gidenFisler =
                                    await fisEx.listGidenFisleriGetir();
                              } catch (e) {
                                print(e);
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          gonderilmisBelgeler(
                                            gidenFisler: gidenFisler,
                                          ))));
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: ekranGenisligi / 50),
                          child: ListTile(
                            leading: Icon(Icons.cloud_upload_rounded,
                                color: Colors.white, size: 19),
                            title: Text("Gönderilmiş Tahsilat & Ödemeler",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            onTap: () async {
                              List<Tahsilat> gidenFisler = [];
                              try {
                                gidenFisler =
                                    (await tahsilatEx.listGidenTahsilatGetir())
                                        as List<Tahsilat>;
                              } catch (e) {
                                print(e);
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          gonderilmisTahsilatOdemeler(
                                            gidenFisler: gidenFisler,
                                          ))));
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: ekranGenisligi / 50),
                          child: ListTile(
                            leading: Icon(Icons.cloud_upload_rounded,
                                color: Colors.white, size: 19),
                            title: Text("Gönderilmiş Sayımlar",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            onTap: () async {
                              List<Sayim> gidenFisler = [];
                              try {
                                gidenFisler =
                                    (await sayimEx.listGidenFisleriGetir());
                              } catch (e) {
                                print(e);
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          gonderilmisSayimlar(
                                            gidenFisler: gidenFisler,
                                          ))));
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: ekranGenisligi / 50),
                          child: ListTile(
                            leading:
                                Icon(Icons.save, color: Colors.white, size: 19),
                            title: Text("Kaydedilmiş Faturalar",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            onTap: () async {
                              List<Fis> gidenFisler = [];
                              try {
                                gidenFisler =
                                    await fisEx.listKaydedilmisFisleriGetir();
                              } catch (e) {
                                print(e);
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          kaydedilmisBelgeler(
                                            gidenFisler: gidenFisler,
                                          ))));
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: ekranGenisligi / 50),
                          child: ListTile(
                            leading:
                                Icon(Icons.save, color: Colors.white, size: 19),
                            title: Text("Kaydedilmiş Tahsilat & Ödemeler",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            onTap: () async {
                              List<Tahsilat> gidenFisler = [];
                              try {
                                gidenFisler = (await tahsilatEx
                                        .listKaydedilenTahsilatGetir())
                                    as List<Tahsilat>;
                              } catch (e) {
                                print(e);
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          kaydedilmisTahsilatOdemeler(
                                            gidenFisler: gidenFisler,
                                          ))));
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: ekranGenisligi / 50),
                          child: ListTile(
                            leading:
                                Icon(Icons.save, color: Colors.white, size: 19),
                            title: Text("Kaydedilmiş Sayımlar",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)),
                            onTap: () async {
                              List<Sayim> gidenFisler = [];
                              try {
                                gidenFisler = (await sayimEx
                                    .listKaydedilenFisleriGetir());
                              } catch (e) {
                                print(e);
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          kaydedilmisSayimlar(
                                            gidenFisler: gidenFisler,
                                          ))));
                            },
                          ),
                        ),
                      ])
                : Container(),
          ],
        ),
      ),
    );
  }
}
