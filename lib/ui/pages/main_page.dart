import 'dart:async';

import 'package:flutter/material.dart';
import 'package:siapel_mobile/ui/pages/form/form_Paket_Akta_Kelahiran.dart';
import 'package:siapel_mobile/ui/pages/form_layanan_disabilitas_anak.dart';
import 'package:siapel_mobile/ui/pages/kategori_kia.dart';
import 'package:siapel_mobile/ui/pages/kategori_kk.dart';
import 'package:siapel_mobile/ui/pages/kategori_ktp.dart';
import 'package:siapel_mobile/ui/pages/kategori_surat_pindah.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => MainPage(),
      '/kategori_kk': (context) => KategoriKK(),
      '/kategori_kia': (context) => KategoriKIA(),
      '/kategori_ktp': (context) => KategoriKTP(),
      '/kategori_sp': (context) => KategoriSuratPindah(),
      '/form_paket_akta_kelahiran': (context) => FormPaketAktaKelahiran(),
      '/form_layanan_disabilitas_anak': (context) =>
          FormLayananDisabilitasAnak(),
    },
    initialRoute: '/',
  ));
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Timer _timer;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  List<String> slideImages = [
    'assets/7.png',
    'assets/8.png',
    'assets/9.png',
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < slideImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> layanan = [
      "Kartu Keluarga",
      "Kartu Indentitas Anak",
      "KTP Elektronik",
      "Pindah Masuk/Keluar",
      "Paket Akta Kelahiran",
      "Layanan Disabilitas",
    ];

    List<Color> layananColors = [
      Color.fromARGB(255, 9, 45, 94),
      Color.fromARGB(255, 9, 45, 94),
      Color.fromARGB(255, 9, 45, 94),
      Color.fromARGB(255, 9, 45, 94),
      Color.fromARGB(255, 9, 45, 94),
      Color.fromARGB(255, 9, 45, 94),
    ];

    List<Icon> layananIcon = [
      Icon(Icons.category, color: Colors.white, size: 25),
      Icon(Icons.perm_identity, color: Colors.white, size: 25),
      Icon(Icons.card_membership, color: Colors.white, size: 25),
      Icon(Icons.nordic_walking, color: Colors.white, size: 25),
      Icon(Icons.baby_changing_station, color: Colors.white, size: 25),
      Icon(Icons.disabled_by_default, color: Colors.white, size: 25),
    ];

    List<String> layananRoutes = [
      '/kategori_kk',
      '/kategori_kia',
      '/kategori_ktp',
      '/kategori_sp',
      '/form_paket_akta_kelahiran',
      '/form_layanan_disabilitas_anak',
    ];

    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 10),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 9, 45, 94),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.dashboard,
                      size: 30,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.notifications,
                      size: 30,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 3, bottom: 15),
                  child: Text(
                    "",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      wordSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search here....",
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: slideImages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  slideImages[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: GridView.builder(
              itemCount: layanan.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, layananRoutes[index]);
                  },
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: layananColors[index],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: layananIcon[index],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        layanan[index],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Survei Kepuasan Masyarakat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman website
                    launch(
                        'https://dispendukcapil.malangkota.go.id/index.php/skm/');
                  },
                  child: Image.asset(
                    'assets/7.png',
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Pengumuman',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman website
                    launch(
                        'https://dispendukcapil.malangkota.go.id/index.php/skm/');
                  },
                  child: Image.asset(
                    'assets/7.png',
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Berita',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Navigasi ke halaman website
                    launch(
                        'https://dispendukcapil.malangkota.go.id/index.php/berita/');
                  },
                  child: Image.asset(
                    'assets/7.png',
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
