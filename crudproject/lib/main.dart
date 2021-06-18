import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
  const FirebaseCrud({Key key}) : super(key: key);

  @override
  _FirebaseCrudState createState() => _FirebaseCrudState();
}

class _FirebaseCrudState extends State<FirebaseCrud> {
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

  sayfaSayisiAl(sayfaSayisiDegeri) {
    this.sayfaSayisi = int.parse(sayfaSayisiDegeri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase CRUD Uygulamasi"),
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
                    labelText: "Kitap ID",
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black54, width: 2))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String isimDegeri) {
                  isimAl(isimDegeri);
                },
                decoration: InputDecoration(
                    labelText: "Kitap Adi",
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black54, width: 2))),
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
                        borderSide:
                            BorderSide(color: Colors.black54, width: 2))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (String kitapSayfasiDegeri) {
                  sayfaSayisiAl(kitapSayfasiDegeri);
                },
                decoration: InputDecoration(
                    labelText: "Kitap ID",
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black54, width: 2))),
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
                      veriGuncelle();
                    },
                    child: Text("Guncelle"),
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
              stream:
                  FirebaseFirestore.instance.collection('Kitaplik').snapshots(),
              builder: (context, alinanVeri) {
                if (alinanVeri.hasError) return Text("Aktarim Basarisiz");
                if (alinanVeri.data == null) return CircularProgressIndicator();

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: alinanVeri.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot satirVerisi = alinanVeri.data.docs[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(30, 8, 0, 8),
                      child: Row(
                        children: [
                          Expanded(child: Text(satirVerisi['kitapId'])),
                          Expanded(child: Text(satirVerisi['kitapAd'])),
                          Expanded(child: Text(satirVerisi['kitapKategori'])),
                          Expanded(child: Text(satirVerisi['kitapSayfaSayisi']))
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

  void veriEkle() {
    DocumentReference veriYolu = FirebaseFirestore.instance.collection("Kitaplik").doc(id);
    Map<String, dynamic> kitaplar = {
      "kitapId": id,
      "kitapAd" : ad,
      "kitapKategori":kategori,
      "kitapSayfaSayisi":sayfaSayisi.toString()
    };
    veriYolu.set(kitaplar).whenComplete(() {
      Fluttertoast.showToast(msg: id + " ID numarali kitap eklendi.");
    });
  }

  void veriOku() {
    DocumentReference veriOkumaYolu = FirebaseFirestore.instance.collection("Kitaplik").doc(id);
    veriOkumaYolu.get().then((alinanDeger) {
      Map<String,dynamic> alinanVeri = alinanDeger.data();
      String idTutucu = alinanVeri["kitapId"];
      String adTutucu = alinanVeri["kitapAd"];
      String kategoriTutucu = alinanVeri["kitapKategori"];
      String sayfaSayisiTutucu = alinanVeri["kitapSayfaSayisi"];

      Fluttertoast.showToast(
          msg:
          "ID "  + idTutucu +
          " Adi : " + adTutucu +
          " Kategori : " + kategoriTutucu +
          " Sayfa Sayisi : " + sayfaSayisiTutucu
      );
    });
  }

  void veriGuncelle() {
    DocumentReference veriGuncellemeYolu = FirebaseFirestore.instance.collection("Kitaplik").doc(id);
    Map<String,dynamic> guncellenecekVeri = {
      "kitapId": id,
      "kitapAd" : ad,
      "kitapKategori":kategori,
      "kitapSayfaSayisi":sayfaSayisi.toString()
    };

    veriGuncellemeYolu.update(guncellenecekVeri).whenComplete((){
      Fluttertoast.showToast(msg: id + " ID numarali kitap guncellendi.");
    });

  }

  void veriSil() {
    DocumentReference veriSilmeYolu = FirebaseFirestore.instance.collection("Kitaplik").doc(id);
    veriSilmeYolu.delete().whenComplete(() {
      Fluttertoast.showToast(msg: id + " ID numarali kitap silindi.");
    });
  }
}
