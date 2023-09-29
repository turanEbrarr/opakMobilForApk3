import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../webservis/base.dart';
import '../stok_kart/Spinkit.dart';
import '../widget/customAlertDialog.dart';
import '../widget/login2.dart';
import '../widget/kullaniciModel.dart';
import '../widget/ctanim.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import '../localDB/veritabaniIslemleri.dart';
import '../widget/modeller/sharedPreferences.dart';

class settings_page extends StatefulWidget {
  const settings_page({super.key});

  @override
  State<settings_page> createState() => _settings_pageState();
}

class _settings_pageState extends State<settings_page> {
  BaseService bs = BaseService();
  bool resimSeciliMi = false;

  int radioDeger = 0;
  final _formKey = GlobalKey<FormState>();
  List<String> donenAPIler = [];
  TextEditingController lisans = TextEditingController();
  TextEditingController kullanici = TextEditingController();
  TextEditingController sirket = TextEditingController();
  TextEditingController deneme = TextEditingController();
  bool enable = false;
  String? sirketKullaniciDoluMu;
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
      resimSeciliMi = true;
      setState(() {});
    } else {
      resimSeciliMi = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPrefsHelper.lisansNumarasiGetir().then((value) {
      if (value != "") {
        enable = true;
        lisans.text = value;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    double ekranYuksekligi = ekranBilgisi.size.height;
    double ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/sj1.jpg"), fit: BoxFit.cover)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: ekranGenisligi / 1.5,
                            height: ekranYuksekligi / 5,
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: ekranGenisligi / 3),
                              child: Image.asset('images/opaklogo2.png'),
                            )),
                        Container(
                          height: enable == true
                              ? ekranYuksekligi / 1.8
                              : ekranYuksekligi / 6.5,
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(0.5), // Şeffaf arka plan rengi
                            borderRadius:
                                BorderRadius.circular(10.0), // Kenar yuvarlatma
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.confirmation_num_outlined),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: TextFormField(
                                          cursorColor:
                                              Color.fromARGB(255, 60, 59, 59),
                                          controller: lisans,
                                          onChanged: (value) {
                                            lisans.value =
                                                lisans.value.copyWith(
                                              text: value,
                                              selection:
                                                  TextSelection.collapsed(
                                                      offset: value.length),
                                            );
                                          },
                                          validator: (value) {
                                            if (value == "") {
                                              return "Bu Alan Boş Bırakılamaz";
                                            }
                                          },
                                          decoration: InputDecoration(
                                            labelText:
                                                "Lisans Numarası Giriniz",
                                            labelStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 60, 59, 59),
                                              fontSize: 15,
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          if (await Connectivity()
                                                  .checkConnectivity() ==
                                              ConnectivityResult.none) {
                                            showAlertDialog(
                                              context,
                                              "İnternet bağlantısı bulunamadı.",
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return LoadingSpinner(
                                                  color: Colors.blue,
                                                  message:
                                                      'Lisans Sorgulanıyor...',
                                                );
                                              },
                                            );

                                            donenAPIler = await bs
                                                .makeSoapRequest(lisans.text);

                                            Navigator.pop(context);

                                            if (donenAPIler.length > 1) {
                                              enable = true;
                                              await SharedPrefsHelper
                                                  .lisansNumarasiKaydet(
                                                      lisans.text);
                                              setState(() {});
                                            } else {
                                              showAlertDialog(
                                                context,
                                                "IP Tanımlaması Yapılmamıştır. Temsilcinizle Görüşünüz.",
                                              );
                                            }
                                          }
                                        },
                                        icon: Icon(Icons.search),
                                        color: Color.fromARGB(255, 60, 59, 59),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              enable == true
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.assignment_ind,
                                              color: enable == true
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: TextFormField(
                                                enabled: enable,
                                                cursorColor: Color.fromARGB(
                                                    255, 60, 59, 59),
                                                controller: kullanici,
                                                onChanged: (value) {
                                                  kullanici.value =
                                                      kullanici.value.copyWith(
                                                    text: value,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset:
                                                                value.length),
                                                  );
                                                },
                                                validator: (value) {
                                                  if (value == "") {
                                                    return "Bu Alan Boş Bırakılamaz";
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  labelText:
                                                      "Kullanıcı Kodu Giriniz",
                                                  labelStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 60, 59, 59),
                                                    fontSize: 15,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),
                              enable == true
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.9),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.business,
                                              color: enable == true
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: TextFormField(
                                                enabled: enable,
                                                cursorColor: Color.fromARGB(
                                                    255, 60, 59, 59),
                                                controller: sirket,
                                                onChanged: (value) {
                                                  sirket.value =
                                                      sirket.value.copyWith(
                                                    text: value,
                                                    selection:
                                                        TextSelection.collapsed(
                                                            offset:
                                                                value.length),
                                                  );
                                                },
                                                validator: (value) {
                                                  if (value == "") {
                                                    return "Bu Alan Boş Bırakılamaz";
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  labelText:
                                                      "Şirket İsmi Giriniz",
                                                  labelStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 60, 59, 59),
                                                    fontSize: 15,
                                                  ),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(),

                              /*
                          SizedBox(
                            width: ekranGenisligi / 1.5,
                            height: ekranYuksekligi / 15,
                            child: RadioListTile(
                              activeColor: Colors.white,
                              title: Text(
                                "Yazıcı",
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              value: 1,
                              groupValue: radioDeger,
                              onChanged: (int? veri) {
                                setState(() {
                                  radioDeger = veri!;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: ekranGenisligi / 1.5,
                            height: ekranYuksekligi / 15,
                            child: RadioListTile(
                              activeColor: Colors.white,
                              title: Text(
                                "Termal Yazıcı, Post vb",
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              value: 2,
                              groupValue: radioDeger,
                              onChanged: (int? veri) {
                                setState(() {
                                  radioDeger = veri!;
                                });
                              },
                            ),
                          ),
                          */
                              Spacer(),
                              enable == true
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 20.0),
                                          child: SizedBox(
                                            width: ekranGenisligi / 1.2,
                                            height: ekranYuksekligi / 12,
                                            child: ElevatedButton(
                                              child: Text(
                                                "Kaydet",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          192, 192, 192, 1),
                                                  shadowColor: Colors.black,
                                                  elevation: 10,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                  )),
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  _formKey.currentState!.save();
                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder:
                                                        (BuildContext context) {
                                                      return LoadingSpinner(
                                                        color: Colors.black,
                                                        message:
                                                            "Kullanıcı ve Şirket Bilgileri Sorgulanıyor...",
                                                      );
                                                    },
                                                  );
                                                  KullaniciModel.clearUser();
                                                  Ctanim.kullanici = null;
                                                  sirketKullaniciDoluMu =
                                                      await bs.getKullanicilar(
                                                          kullaniciKodu:
                                                              kullanici.text,
                                                          sirket: sirket.text);
                                                  if (sirketKullaniciDoluMu ==
                                                      "") {
                                                    await KullaniciModel
                                                        .saveUser(
                                                            Ctanim.kullanici!);
                                                    SharedPrefsHelper
                                                        .sirketSil();
                                                    SharedPrefsHelper
                                                        .sirketKaydet(
                                                            sirket.text);
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CustomAlertDialog(
                                                            textColor: Colors.green,
                                                            align:
                                                                TextAlign.left,
                                                            title:
                                                                'Kayıt Başarılı',
                                                            message:
                                                                'Şirket ve Kullanıcı Bilgileri Başarıyla Alındı. Giriş Sayfasına Yönlendiriliyorsunuz.',
                                                            onPres: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            LoginPage(
                                                                              title: '',
                                                                            )),
                                                              );
                                                              setState(() {});
                                                            },
                                                            buttonText: 'Tamam',
                                                          );
                                                        });
                                                  } else {
                                                    showAlertDialog(
                                                      ikinciGeri: true,
                                                      context,
                                                      "Şirket Adı Veya Kullanıcı Kodu Yanlış Girildi.Tekrar Kontrol Ediniz.",
                                                    );
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            size: 28,
          ),
          backgroundColor: Color.fromRGBO(181, 182, 184, 1),
          mini: true,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}

showAlertDialog(BuildContext context, String mesaj, {bool ikinciGeri = false}) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      if (ikinciGeri == true) {
        Navigator.pop(context);
      }
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Hatalı İşlem!",style: TextStyle(color: Colors.red),),
    content: Text(mesaj),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
