import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wave/wave.dart';
// import 'package:wave/config.dart';
import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// Function to save user info to shared preferences

Future<void> saveUserId(int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('id', id);
  print('User ID tersimpan: $id');
}

// Function to get user ID from shared preferences
Future<int?> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('id');
  print('User ID yang diambil: $id');
  return id;
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  Future<void> SaveUserInfo(String email, String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    print('Phone saved: $phone'); // Tambahkan print statement untuk debug
  }

  Future<void> LoadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? phone = prefs.getString('phone');
    print('Phone loaded: $phone'); // Tambahkan print statement untuk debug
    if (email != null) {
      setState(() {
        _emailController.text = email;
      });
    }
    if (phone != null) {
      setState(() {
        _phoneController.text = phone;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to show loading dialog
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Proses Masuk Tunggu Sebentar...'),
            ],
          ),
        );
      },
    );
  }

  // Function to handle login button press
  // Function to handle login button press
  Future<void> _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String phone = _phoneController.text;
      String password = _passwordController.text;
      String username1 = 'admin';
      String password1 = 'admin';
      String basicAuth =
          'Basic ' + base64.encode(utf8.encode('$username1:$password1'));

      _showLoadingDialog(context);

      try {
        Dio dio = Dio();
        final response = await dio.post(
          'http://10.101.1.154:8000/autentikasi/login',
          data: {
            'email': email,
            'password': password,
          },
          options: Options(
            validateStatus: (_) => true,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': basicAuth,
            },
          ),
        );

        Navigator.pop(context);
        print('Response from login: ${response.data}');
        if (response.statusCode == 200) {
          String phone = ''; // Default phone number

          // Try to get phone number from response
          Map<String, dynamic> responseData = response.data;
          if (responseData.containsKey('data') &&
              responseData['data'].containsKey('phone')) {
            phone = responseData['data']['phone'];
          }

          await SaveUserInfo(email, phone);
          print('Nomor Telepon: $phone');

          // Navigate to next screen or do other actions

          // Navigate to next screen or do other actions

          // Ambil user_id dari respons
          int userId = response.data['id'];
          print('User ID dari response: $userId');

          // Simpan user_id ke SharedPreferences
          await saveUserId(userId);
          print('User ID tersimpan: $userId');

          // Periksa kembali nilai ID pengguna dari SharedPreferences
          int? savedUserId = await getUserId();
          print('User ID dari SharedPreferences: $savedUserId');

          // Navigasi ke halaman berikutnya
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/bottom-tab',
            (Route<dynamic> route) => false,
          );
        } else if (response.statusCode == 401) {
          // Unauthorized, tampilkan pesan kesalahan
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Login Gagal'),
                content: Text('Email atau password salah.'),
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
              'HTTP request failed with status: ${response.statusCode}');
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
              content: Text('Terjadi kesalahan. Silakan coba lagi nanti.'),
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
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Positioned(
          //   left: 0,
          //   top: 0,
          //   child: Transform.rotate(
          //     angle: -3.14,
          //     child: WaveWidget(
          //       config: CustomConfig(
          //         colors: [
          //           Color.fromARGB(255, 10, 59, 122),
          //           Color(0xFF0C438D),
          //           Color.fromARGB(255, 9, 45, 94),
          //         ],
          //         durations: [5000, 4000, 3000],
          //         heightPercentages: [0.10, 0.20, 0.30],
          //       ),
          //       backgroundColor: Colors.transparent,
          //       size: Size(size.width, size.height * 0.25),
          //       waveAmplitude: 0,
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width,
                    height: 200,
                    child: Image.asset(
                      "assets/LOGO KOTA MALANG.png", // Ganti dengan path gambar Anda
                      fit: BoxFit
                          .contain, // Sesuaikan dengan kebutuhan tata letak gambar
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Selamat Datang Di Aplikasi SIAPEL",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          onChanged: (value) {},
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: const Icon(Icons.mail),
                            hintStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color(0xFF0C438D),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 7, 37, 77),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.endsWith('@gmail.com')) {
                              return 'Alamat email harus diakhiri dengan @gmail.com';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _passwordController,
                          onChanged: (value) {},
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              child: Icon(
                                _isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Color.fromARGB(255, 7, 37, 77),
                              ),
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 7, 37, 77),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color.fromARGB(255, 7, 37, 77),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 8) {
                              return 'Password harus terdiri dari minimal 8 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/lupapw');
                          },
                          child: Text(
                            "Lupa Password?",
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    minWidth: size.width,
                    height: 50,
                    color: Color.fromARGB(255, 7, 37, 77),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: () {
                      _handleLogin(context);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  MaterialButton(
                    minWidth: size.width,
                    height: 50,
                    color: Color.fromARGB(255, 7, 37, 77),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/sign-up',
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text(
                      "Daftar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // const SizedBox(height: 20),
                  // Text(
                  //   "Atau Login dengan ",
                  //   style: TextStyle(color: Colors.black),
                  // ),
                  // SizedBox(height: 20),
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     // Handle login with Google
                  //   },
                  //   icon: CircleAvatar(
                  //     backgroundColor: Color.fromARGB(255, 7, 37, 77),
                  //     child: Image.asset(
                  //       'assets/google.png',
                  //       height: 24,
                  //       width: 24,
                  //     ),
                  //   ),
                  //   label: Text("Login dengan Google"),
                  //   style: ElevatedButton.styleFrom(
                  //     primary: Color.fromARGB(255, 7, 37, 77),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(100),
                  //     ),
                  //   ),
                  //),
                ],
              ),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: IgnorePointer(
          //     ignoring: true,
          //     child: WaveWidget(
          //       config: CustomConfig(
          //         colors: [
          //           Color.fromARGB(255, 10, 59, 122),
          //           Color(0xFF0C438D),
          //           Color.fromARGB(255, 9, 45, 94),
          //         ],
          //         durations: [5000, 4000, 3000],
          //         heightPercentages: [0.50, 0.60, 0.70],
          //       ),
          //       backgroundColor: Colors.transparent,
          //       size: Size(size.width, size.height * 0.25),
          //       waveAmplitude: 0,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
