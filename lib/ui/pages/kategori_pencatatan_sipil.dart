import 'package:flutter/material.dart';
import '../../shared/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KategoriPencatatanSipil extends StatefulWidget {
  const KategoriPencatatanSipil({Key? key}) : super(key: key);

  @override
  State<KategoriPencatatanSipil> createState() =>
      _KategoriPencatatanSipilState();
}

class _KategoriPencatatanSipilState extends State<KategoriPencatatanSipil> {
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget menuUtamaCard(
        String judul, String keterangan, String uri_gambar, String urinya) {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            isAuth
                ? Navigator.pushNamed(context, '$urinya')
                : Navigator.pushNamed(context, '/login');
          },
          child: Container(
            //height: 190,

            //width: double.infinity,
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
                //image: DecorationImage(image: AssetImage('assets/image_card.png')),
                boxShadow: [
                  BoxShadow(
                      color: kPrimaryColor.withOpacity(0.2),
                      blurRadius: 100,
                      offset: Offset(0, 10))
                ]),
            child: Card(
              color: kPrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultRadius)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //   'Akta Pencatatan Sipil',
                              //   style: blackTextStyle.copyWith(
                              //       fontWeight: medium, fontSize: 20),
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                            ],
                          ),
                        ),
                        // Text(
                        //   'Pay',
                        //   style: blackTextStyle.copyWith(
                        //       fontSize: 16, fontWeight: medium),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            '$uri_gambar',
                            width: 40,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      '$judul',
                      style: whiteTextStyle.copyWith(
                          fontWeight: medium, fontSize: 20),
                    ),
                    Text(
                      '$keterangan',
                      style: whiteTextStyle.copyWith(
                          fontWeight: medium, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'PELAYANAN AKTA',
                  style:
                      blackTextStyle.copyWith(fontWeight: medium, fontSize: 30),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Image.asset(
                'assets/p_akta.png',
                width: double.infinity,
                height: 150,
              )),
            ),
            Row(
              children: [
                menuUtamaCard(
                    'Akta Kelahiran Umum',
                    'Akta Kelahiran Umum (Umur Bayi 1-60 Hari)',
                    'assets/doc_white.png',
                    '/form_akta_lahir_umum'),
              ],
            ),
            Row(
              children: [
                menuUtamaCard(
                    'Akta Kelahiran Terlambat',
                    'Akta Kelahiran Terlambat (Umur Bayi >60 Hari)',
                    'assets/doc_white.png',
                    '/form_akta_lahir_telat'),
              ],
            ),
            Row(
              children: [
                menuUtamaCard('Akta Kematian', 'Akta Kematian Penduduk',
                    'assets/doc_white.png', '/form_akta_mati'),
              ],
            ),
            Row(
              children: [
                menuUtamaCard('Akta Perkawinan', 'Akta Perkawinan Non Muslim',
                    'assets/doc_white.png', '/form_akta_kawin'),
              ],
            ),
            Row(
              children: [
                menuUtamaCard('Akta Perceraian', 'Akta Perceraian Non Muslim',
                    'assets/doc_white.png', '/form_akta_cerai'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
