import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:siapel_mobile/ui/pages/login_page.dart';
import '../../shared/theme.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

Future<void> saveUserInfo(
  String email,
  String phone,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
  await prefs.setString('phone', phone);
  // await prefs.setString('user_id', userId);
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _kecController = TextEditingController();
  final TextEditingController _kelController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isObscure2 = true;

  final List<String> PilihKecamatan = [
    'BELIMBING',
    'KLOJEN',
    'KEDUNGKANDANG',
    'SUKUN',
    'LOWOKWARU',
    // Add more categories as needed
  ];
  final Map<String, List<String>> pilihKelurahan = {
    'BELIMBING': [
      'BALEARJOSARI',
      'ARJOSARI',
      'POLOWIJEN',
      'PURWODADI',
      'BLIMBING',
      'PANDANWANGI',
      'PURWANTORO',
      'BUNULREJO',
      'KESATRIAN',
      'POLEHAN',
      'JODIPAN'
    ],
    'KLOJEN': [
      'KLOJEN',
      'RAMPAL CELAKET',
      'SAMAAN',
      'KIDUL DALEM',
      'SUKOHARJO',
      'KASIN',
      'KAUMAN',
      'ORO ORO DOWO',
      'BARENG',
      'GADINGKASRI',
      'PENANGGUNAGAN'
    ],
    'KEDUNGKANDANG': [
      'KOTA LAMA',
      'MERGOSONO',
      'BUMIAYU',
      'WONOKOYO',
      'BURING',
      'KEDUNGKANDANG',
      'LESANPURO',
      'SAWOJAJAR',
      'MADYOPURO',
      'CEMOROKANDANG',
      'ARJOWINANGUN',
      'TLOGOWARU'
    ],
    'SUKUN': [
      'CIPTOMULYO',
      'GADANG',
      'KEBONSARI',
      'BANDUNGREJOSARI',
      'SUKUN',
      'TANJUNGREJO',
      'PISANG CANDI',
      'BANDULAN',
      'KARANG BESUKI',
      'MULYOREJO',
      'BAKALAN KRAJAN',
    ],
    'LOWOKWARU': [
      'TUNGGULWULUNG',
      'MERJOSARI',
      'TLOGOMAS',
      'DINOYO',
      'SUMBERSARI',
      'KETAWANGGEDE',
      'JATIMULYO',
      'TUNJUNGSEKAR',
      'MOJOLANGU',
      'TULUSREJO',
      'LOWOKWARU',
      'TASIKMADU',
    ],
  };

  String? Kecamatan;
  String? Kelurahan;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _nikController.dispose();
    _phoneController.dispose();
    _kecController.dispose();
    _kelController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String nik = _nikController.text;
      String email = _emailController.text;
      String phone = _phoneController.text;
      String kec = _kecController.text;
      String kel = _kelController.text;
      String password = _passwordController.text;
      String username1 = 'admin';
      String password1 = 'admin';
      String basicAuth =
          'Basic ' + base64.encode(utf8.encode('$username1:$password1'));

      try {
        Dio dio = Dio();
        log("text kecamatan :" + kec);
        final response = await Dio().post(
          'http://10.101.1.154:8000/autentikasi/register',
          data: {
            'name': name,
            'nik': nik,
            'email': email,
            'phone': phone,
            'kec': Kecamatan, // Menggunakan nilai dari _kecController
            'kel': Kelurahan, // Menggunakan nilai dari _kelController
            'password': password,
          },
          options: Options(
            validateStatus: (_) => true,
            headers: <String, String>{
              //'authorization': authe,
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': basicAuth,
            },
          ),
        );

        // Handle response
        if (response.statusCode == 200) {
          await saveUserInfo(email, phone);
          // Login berhasil, navigasi ke halaman berikutnya
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (Route<dynamic> route) => false,
          );
        } else if (response.statusCode == 401) {
          // Unauthorized, tampilkan pesan kesalahan
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Pendaftaran Gagal'),
                content: Text('Kembali Periksa Data Anda $response'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Tampilkan pesan kesalahan umum
          throw Exception(
              'HTTP request failed with status: ${response.statusCode} | ${response}');
        }
      } catch (e) {
        print('Error: $e');
        Navigator.pop(context); // Tutup loading dialog
        // Tampilkan pesan kesalahan umum
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Terjadi kesalahan. Silakan coba lagi nanti.$e'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget title() {
      return Container(
        margin: EdgeInsets.only(
          top: 120,
          left: 10,
          right: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            'Pendaftaran Akun',
            style: blackTextStyle.copyWith(
              fontSize: 24,
              fontWeight: semiBold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    Widget inputSection() {
      Widget nameInput() {
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nama Lengkap',
                style: blackTextStyle,
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                controller: _nameController,
                style: blackTextStyle,
                cursorColor: kBlackColor,
                decoration: InputDecoration(
                  hintText: 'Masukkan Nama Lengkap',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Nama Lengkap';
                  }
                  // Check if the first character is uppercase
                  if (value[0] != value[0].toUpperCase()) {
                    return 'Nama harus diawali dengan huruf besar';
                  }
                  return null;
                },
              )
            ],
          ),
        );
      }

      Widget nikInput() {
        return Container(
          margin: EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NIK',
                style: blackTextStyle,
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                controller: _nikController,
                style: blackTextStyle,
                cursorColor: kBlackColor,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan NIK Anda',
                  prefixIcon: const Icon(Icons.document_scanner_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan NIK Anda';
                  }
                  // Check if the length of the NIK is at least 16
                  if (value.length < 16) {
                    return 'NIK harus terdiri dari minimal 16 digit';
                  }
                  return null;
                },
              )
            ],
          ),
        );
      }

      Widget emailInput() {
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email Address',
                style: blackTextStyle,
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                controller: _emailController,
                style: blackTextStyle,
                cursorColor: kBlackColor,
                decoration: InputDecoration(
                  hintText: 'Your email address',
                  prefixIcon: const Icon(Icons.mail),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Email Address';
                  }
                  // Check if the email address ends with "@gmail.com"
                  if (!value.endsWith('@gmail.com')) {
                    return 'Alamat email harus diakhiri dengan @gmail.com';
                  }
                  return null;
                },
              )
            ],
          ),
        );
      }

      Widget noInput() {
        return Container(
          margin: EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No Whatsapp',
                style: blackTextStyle,
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                controller: _phoneController,
                style: blackTextStyle,
                cursorColor: kBlackColor,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan No. Whatsapp',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan No Whatsapp';
                  }
                  if (value.length < 12) {
                    return 'Minimal 12 digit';
                  }
                  return null;
                },
              )
            ],
          ),
        );
      }

      Widget dropdownButton1() {
        TextFormField(
          controller: _kecController,
        );
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Kecamatan',
                style: blackTextStyle,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: Kecamatan,
                decoration: InputDecoration(
                  hintText: 'Pilih Kecamatan',
                  prefixIcon: const Icon(Icons.location_pin),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                  ),
                ),
                items: PilihKecamatan.map((String kategori) {
                  return DropdownMenuItem<String>(
                    value: kategori,
                    child: Text(
                      kategori,
                      style: TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  log("on change : " + value.toString());
                  setState(() {
                    Kecamatan = value;
                    Kelurahan = pilihKelurahan[value!]![
                        0]; // Set Kelurahan ke nilai awal yang unik saat Kecamatan berubah
                  });
                },
                validator: (value) {
                  log("validator :" + value.toString());
                  if (value == null || value.isEmpty) {
                    return 'Pilih Kecamatan';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      }

      Widget dropdownButton2() {
        TextFormField(
          controller: _kecController,
        );
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Kelurahan',
                style: blackTextStyle,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: Kelurahan,
                decoration: InputDecoration(
                  hintText: 'Pilih Kelurahan',
                  prefixIcon: const Icon(Icons.location_pin),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                  ),
                ),
                items: Kecamatan != null
                    ? pilihKelurahan[Kecamatan!]!.map((String kelurahan) {
                        return DropdownMenuItem<String>(
                          value: kelurahan,
                          child: Text(kelurahan),
                        );
                      }).toList()
                    : [],
                onChanged: (String? value) {
                  setState(() {
                    Kelurahan = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih Kelurahan';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      }

      Widget passwordInput() {
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Password',
                style: blackTextStyle,
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                style: blackTextStyle,
                cursorColor: kBlackColor,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    child: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                  ),
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Masukkan password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 7, 37, 77),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your password';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      }

      // Widget passwordConfirmInput() {
      //   return Container(
      //     margin: EdgeInsets.only(bottom: 20),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Text(
      //           'Confirm Password',
      //           style: blackTextStyle,
      //         ),
      //         SizedBox(
      //           height: 10,
      //         ),
      //         TextFormField(
      //           style: blackTextStyle,
      //           cursorColor: kBlackColor,
      //           obscureText: _isObscure2,
      //           decoration: InputDecoration(
      //             prefixIcon: const Icon(Icons.lock),
      //             suffixIcon: GestureDetector(
      //               onTap: () {
      //                 setState(() {
      //                   _isObscure2 = !_isObscure2;
      //                 });
      //               },
      //               child: Icon(
      //                 _isObscure2 ? Icons.visibility : Icons.visibility_off,
      //                 color: Colors.grey,
      //               ),
      //             ),
      //             hintStyle: TextStyle(color: Colors.black),
      //             hintText: 'Confirm your password',
      //             border: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(10),
      //             ),
      //             focusedBorder: OutlineInputBorder(
      //               borderRadius: BorderRadius.circular(10),
      //               borderSide: BorderSide(
      //                 color: Color.fromARGB(255, 7, 37, 77),
      //               ),
      //             ),
      //           ),
      //           validator: (value) {
      //             if (value == null || value.isEmpty) {
      //               return 'Confirm your password';
      //             }
      //             return null;
      //           },
      //         ),
      //       ],
      //     ),
      //   );
      // }

      Widget submitButton() {
        return Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: kPrimaryColor.withOpacity(0.10),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: TextButton(
            onPressed: () {
              // Panggil fungsi signUp
              _signUp();
            },
            style: TextButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Submit',
              style: whiteTextStyle.copyWith(
                fontSize: 18,
                fontWeight: medium,
              ),
            ),
          ),
        );
      }

      return Container(
        margin: EdgeInsets.only(top: 30),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(defaultRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              nameInput(),
              nikInput(),
              emailInput(),
              noInput(),
              dropdownButton1(),
              dropdownButton2(),
              passwordInput(),
              // passwordConfirmInput(),
              submitButton(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Transform.rotate(
              angle: -3.14,
              child: WaveWidget(
                config: CustomConfig(
                  colors: [
                    Color.fromARGB(255, 10, 59, 122),
                    Color(0xFF0C438D),
                    Color.fromARGB(255, 9, 45, 94),
                  ],
                  durations: [5000, 4000, 3000],
                  heightPercentages: [0.10, 0.20, 0.30],
                ),
                backgroundColor: Colors.transparent,
                size: Size(MediaQuery.of(context).size.width,
                    MediaQuery.of(context).size.height * 0.25),
                waveAmplitude: 0,
              ),
            ),
          ),
          ListView(
            padding: EdgeInsets.symmetric(
              horizontal: defaultMargin,
            ),
            children: [
              Column(
                children: [
                  title(),
                  inputSection(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
