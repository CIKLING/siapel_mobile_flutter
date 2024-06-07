import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:siapel_mobile/ui/pages/bonus_page.dart';
import 'package:siapel_mobile/ui/pages/bottom_tab.dart';
import 'package:siapel_mobile/ui/pages/forgot_pasword_page.dart';
import 'package:siapel_mobile/ui/pages/form/form_akta_kematian.dart';
import 'package:siapel_mobile/ui/pages/form/form_akta_lahir_telat.dart';
import 'package:siapel_mobile/ui/pages/form/form_akta_lahir_umum.dart';
import 'package:siapel_mobile/ui/pages/form/form_akta_perceraian.dart';
import 'package:siapel_mobile/ui/pages/form/form_akta_perkawinan.dart';
import 'package:siapel_mobile/ui/pages/form/form_kia_baru.dart';
import 'package:siapel_mobile/ui/pages/form/form_kia_rusak.dart';
import 'package:siapel_mobile/ui/pages/form/form_ktp_baru.dart';
import 'package:siapel_mobile/ui/pages/form/form_ktp_hilang.dart';
import 'package:siapel_mobile/ui/pages/form/form_ktp_rusak.dart';
import 'package:siapel_mobile/ui/pages/form/form_Paket_Akta_Kelahiran.dart';
import 'package:siapel_mobile/ui/pages/form/form_pindah_keluar.dart';
import 'package:siapel_mobile/ui/pages/form/form_pindah_masuk.dart';
import 'package:siapel_mobile/ui/pages/form_layanan_disabilitas_anak.dart';
import 'package:siapel_mobile/ui/pages/get_started_page.dart';
import 'package:siapel_mobile/ui/pages/kategori_kia.dart';
import 'package:siapel_mobile/ui/pages/kategori_kk.dart';
import 'package:siapel_mobile/ui/pages/kategori_ktp.dart';
import 'package:siapel_mobile/ui/pages/form_layanan_disabilitas_anak.dart';
import 'package:siapel_mobile/ui/pages/kategori_pencatatan_sipil.dart';
import 'package:siapel_mobile/ui/pages/kategori_surat_pindah.dart';
import 'package:siapel_mobile/ui/pages/kategori_kk.dart';
import 'package:siapel_mobile/ui/pages/login_page.dart';
import 'package:siapel_mobile/ui/pages/main_page.dart';
import 'package:siapel_mobile/ui/pages/account_screen.dart';
import 'package:siapel_mobile/ui/pages/sign_up_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siapel_mobile/ui/pages/slider_page.dart';
import 'package:siapel_mobile/notifications.dart';
import 'package:siapel_mobile/ui/pages/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:siapel_mobile/ui/pages/status_document.dart';
// import 'package:siapel_mobile/ui/pages/splash_page.dart';

void main() => runApp(MyApp());

class MySharedPreferences {
  MySharedPreferences._privateConstructor();

  static final MySharedPreferences instance =
      MySharedPreferences._privateConstructor();
  setBooleanValue(String key, bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(key, value);
  }

  Future<bool> getBooleanValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool(key) ?? false;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFirstLaunch = false;

  SharedState() {
    MySharedPreferences.instance
        .getBooleanValue("isfirstRun")
        .then((value) => setState(() {
              isFirstLaunch = value;
            }));
  }

  @override
  void initState() {
    // TODO: implement initState
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setString('action', 'token');
    //await localStorage.remove('localStorage');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SplashPage(),
      home: isFirstLaunch ? GetStartedPage() : SliderPage(),
      builder: EasyLoading.init(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/slider':
            return CupertinoPageRoute(
                builder: (_) => SliderPage(), settings: settings);
            break;
          case '/':
            return CupertinoPageRoute(
                builder: (_) => GetStartedPage(), settings: settings);
            break;
          case '/get-started':
            return CupertinoPageRoute(
                builder: (_) => GetStartedPage(), settings: settings);
            break;
          case '/sign-up':
            return CupertinoPageRoute(
                builder: (_) => SignUpPage(), settings: settings);
            break;
          case '/login':
            return CupertinoPageRoute(
                builder: (_) => LoginPage(), settings: settings);
            break;
          case '/lupapw':
            return CupertinoPageRoute(
                builder: (_) => ForgotPasswordPage(), settings: settings);
            break;
          case '/bonus':
            return CupertinoPageRoute(
                builder: (_) => BonusPage(), settings: settings);
            break;
          case '/main':
            return CupertinoPageRoute(
                builder: (_) => MainPage(), settings: settings);
            break;
          case '/bottom-tab':
            return CupertinoPageRoute(
                builder: (_) => BottomkTab(), settings: settings);
            break;
          case '/kategori_kk':
            return CupertinoPageRoute(
                builder: (_) => KategoriKK(), settings: settings);
            break;
          case '/kategori_ktp':
            return CupertinoPageRoute(
                builder: (_) => KategoriKTP(), settings: settings);
            break;
          case '/kategori_sp':
            return CupertinoPageRoute(
                builder: (_) => KategoriSuratPindah(), settings: settings);
            break;
          case '/kategori_kia':
            return CupertinoPageRoute(
                builder: (_) => KategoriKIA(), settings: settings);
            break;
          case '/form_layanan_disabilitas_anak':
            return CupertinoPageRoute(
                builder: (_) => FormLayananDisabilitasAnak(),
                settings: settings);
            break;
          case '/form_akta_lahir_umum':
            return CupertinoPageRoute(
                builder: (_) => FormAktaLahirUmum(), settings: settings);
            break;
          case '/form_akta_lahir_telat':
            return CupertinoPageRoute(
                builder: (_) => FormAktaLahirTelat(), settings: settings);
            break;
          case '/form_akta_mati':
            return CupertinoPageRoute(
                builder: (_) => FormAktaKematian(), settings: settings);
            break;
          case '/form_akta_kawin':
            return CupertinoPageRoute(
                builder: (_) => FormAktaPerkawinan(), settings: settings);
            break;
          case '/form_akta_cerai':
            return CupertinoPageRoute(
                builder: (_) => FormAktaPerceraian(), settings: settings);
            break;
          case '/form_ktp_baru':
            return CupertinoPageRoute(
                builder: (_) => FormKTPBaru(), settings: settings);
            break;
          case '/form_ktp_hilang':
            return CupertinoPageRoute(
                builder: (_) => FormKTPHilang(), settings: settings);
            break;
          case '/form_ktp_rusak':
            return CupertinoPageRoute(
                builder: (_) => FormKTPRusak(), settings: settings);
            break;
          case '/form_pindah_keluar':
            return CupertinoPageRoute(
                builder: (_) => FormPindahKeluar(), settings: settings);
            break;
          case '/form_pindah_masuk':
            return CupertinoPageRoute(
                builder: (_) => FormPindahMasuk(), settings: settings);
            break;
          case '/form_paket_akta_kelahiran':
            return CupertinoPageRoute(
                builder: (_) => FormPaketAktaKelahiran(), settings: settings);
            break;
          case '/form_kia_baru':
            return CupertinoPageRoute(
                builder: (_) => FormKIABaru(), settings: settings);
            break;
          case '/form_kia_rusak':
            return CupertinoPageRoute(
                builder: (_) => FormKIARusak(), settings: settings);
            break;
          case '/Profil':
            return CupertinoPageRoute(
                builder: (_) => AccountScreen(), settings: settings);
            break;
          case '/status_document':
            return CupertinoPageRoute(
                builder: (_) => StatusDocument(), settings: settings);
            break;

          default:
            return null;
        }
      },
      // routes: {
      //   // '/': (context) => SplashPage(),
      //   '/': (context) => GetStartedPage(),
      //   '/get-started': (context) => GetStartedPage(),
      //   '/sign-up': (context) => SignUpPage(),
      //   '/login': (context) => LoginPage(),
      //   '/bonus': (context) => BonusPage(),
      //   '/main': (context) => MainPage(),
      //   '/bottom-tab': (context) => BottomkTab(),
      //   '/kategori_ps': (context) => KategoriPencatatanSipil(),
      //   '/kategori_ktp': (context) => KategoriKTP(),
      //   '/kategori_sp': (context) => KategoriSuratPindah(),
      //   '/kategori_kia': (context) => KategoriKIA(),
      //   '/form_akta_lahir_umum': (context) => FormAktaLahirUmum(),
      //   '/form_akta_lahir_telat': (context) => FormAktaLahirTelat(),
      //   '/form_akta_mati': (context) => FormAktaKematian(),
      //   '/form_akta_kawin': (context) => FormAktaPerkawinan(),
      //   '/form_akta_cerai': (context) => FormAktaPerceraian(),
      //   '/form_ktp_baru': (context) => FormKTPBaru(),
      //   '/form_ktp_hilang': (context) => FormKTPHilang(),
      //   '/form_ktp_rusak': (context) => FormKTPRusak(),
      //   '/form_pindah_keluar': (context) => FormPindahKeluar(),
      //   '/form_pindah_masuk': (context) => FormPindahMasuk(),
      //   '/form_masalah_data': (context) => FormMasalahData(),
      //   '/form_kia_baru': (context) => FormKIABaru(),
      //   '/form_kia_rusak': (context) => FormKIARusak(),
      // },
    );
  }
}
