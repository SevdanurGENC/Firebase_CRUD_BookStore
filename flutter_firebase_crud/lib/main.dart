import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    home: FirebaseCrud(),
  ));
}

class FirebaseCrud extends StatefulWidget {
  FirebaseCrud({Key key}) : super(key: key);

  @override
  _FirebaseCrudState createState() => _FirebaseCrudState();
}

class _FirebaseCrudState extends State<FirebaseCrud> {
  // Metotlar
  String ad, id, kategori;
  int sayfaSayisi;

  idAl(idDegeri) {
    this.id = idDegeri;
  }

  isimAl(isimDegeri) {
    this.ad = isimDegeri;
  }

  kategoriAl(kategoriDegeri) {
    this.kategori = kategoriDegeri;
  }

  sayfaSayisiAl(sayfaDegeri) {
    this.sayfaSayisi = int.parse(sayfaDegeri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Crud Uygulaması"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String idDegeri) {
                  idAl(idDegeri);
                },
                decoration: InputDecoration(
                  labelText: "Kitap Id",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54, width: 2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String isimDegeri) {
                  isimAl(isimDegeri);
                },
                decoration: InputDecoration(
                  labelText: "Kitap Adı",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54, width: 2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String kategoriDegeri) {
                  kategoriAl(kategoriDegeri);
                },
                decoration: InputDecoration(
                  labelText: "Kitap Kategorisi",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54, width: 2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String sayfaDegeri) {
                  sayfaSayisiAl(sayfaDegeri);
                },
                decoration: InputDecoration(
                  labelText: "Kitap Sayfası",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black54, width: 2),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      veriEkle();
                    },
                    child: Text("Ekle"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      shadowColor: Colors.redAccent,
                      elevation: 5,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      veriOku();
                    },
                    child: Text("Oku"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shadowColor: Colors.redAccent,
                      elevation: 5,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      veriGunceller();
                    },
                    child: Text("Güncelle"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      onPrimary: Colors.white,
                      shadowColor: Colors.redAccent,
                      elevation: 5,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      veriSil();
                    },
                    child: Text("Sil"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      shadowColor: Colors.redAccent,
                      elevation: 5,
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder(
              //Veri Tabanından Akışın Olacağı Yoldaki Veriler(Snapshots)
              stream:
              FirebaseFirestore.instance.collection("Kitaplik").snapshots(),
              // İnşa Edici
              builder: (context, alinanVeri) {
                //Akışta Hata Varsa
                if (alinanVeri.hasError) {
                  return Text("Aktarim Basarisiz!");
                }
                //Hata Yoksa ListView İnşa Edici Döndürür
                return ListView.builder(
                  shrinkWrap: true,
                  //satır sayısı
                  itemCount: alinanVeri.data.docs.length,
                  //satır inşa edici
                  itemBuilder: (context, index) {
                    DocumentSnapshot satirVerisi = alinanVeri.data.docs[index];

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(30,8,0,8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              satirVerisi["kitapId"],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              satirVerisi["kitapAd"],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              satirVerisi["kitapKategori"],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              satirVerisi["kitapSayfaSayisi"],
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
      ),
    );
  }

  //Firebase ile etkileşime girecek metotlar
  void veriEkle() {
    //Veri Yolu Ekleme
    DocumentReference veriYolu =
    FirebaseFirestore.instance.collection("Kitaplik").doc(id);
    //Çoklu Veri İçin Map
    Map<String, dynamic> kitaplar = {
      "kitapId": id,
      "kitapAd": ad,
      "kitapKategori": kategori,
      "kitapSayfaSayisi": sayfaSayisi.toString(),
      //Veriyi Veri Tabanına Ekle
    };

    veriYolu.set(kitaplar).whenComplete(() {
      Fluttertoast.showToast(msg: id + " ID numarali kitap eklendi.");
    });
  }

  void veriOku() {
    DocumentReference veriOkumaYolu =
    FirebaseFirestore.instance.collection("Kitaplik").doc(id);
    //Veriyi Al ve alinanDeger Degiskenine Aktar
    veriOkumaYolu.get().then((alinanDeger) {
      //Çoklu Veriyi Map e Aktar
      //Alınan değerdeki verileri alinan veri olarak map e aktar.
      Map<String, dynamic> alinanVeri = alinanDeger.data();
      //Alınan verideki alanları tutuculara aktar
      String idTutucu = alinanVeri["kitapId"];
      String adTutucu = alinanVeri["kitapAd"];
      String kategoriTutucu = alinanVeri["kitapKategori"];
      String sayfaSayisiTutucu = alinanVeri["kitapSayfaSayisi"];
      // Tutucuları göster

      Fluttertoast.showToast(
          msg: "ID: " +
              idTutucu +
              " Ad: " +
              adTutucu +
              " Kategori: " +
              kategoriTutucu +
              " Sayfa Sayisi: " +
              sayfaSayisiTutucu);
    });
  }

  void veriGunceller() {
    // Veri Yolu
    DocumentReference veriGuncellemeYolu =
    FirebaseFirestore.instance.collection("Kitaplik").doc(id);

    // Çoklu Veri Map'i

    Map<String, dynamic> guncellenecekVeri = {
      "kitapId": id,
      "kitapAd": ad,
      "kitapKategori": kategori,
      "kitapSayfaSayisi": sayfaSayisi.toString(),
    };
    //Veriyi Guncelle

    veriGuncellemeYolu.update(guncellenecekVeri).whenComplete(() {
      Fluttertoast.showToast(msg: id + "ID numarali kitap guncellendi!");
    });
  }

  void veriSil() {
    //Veri Yolu
    DocumentReference veriSilmeYolu =
    FirebaseFirestore.instance.collection("Kitaplik").doc(id);

    //Veriyi Silme
    veriSilmeYolu.delete().whenComplete(() {
      Fluttertoast.showToast(msg: id + " ID numarali kitap silindi!");
    });
  }
}