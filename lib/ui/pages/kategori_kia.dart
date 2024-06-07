import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:siapel_mobile/shared/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KategoriKIA extends StatefulWidget {
  const KategoriKIA({Key? key}) : super(key: key);

  @override
  State<KategoriKIA> createState() => _FormPaketAktaKelahiran();
}

class _FormPaketAktaKelahiran extends State<KategoriKIA> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _produkController = TextEditingController();
  final TextEditingController _kecController = TextEditingController();
  final TextEditingController _kelController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _nikpelaporController = TextEditingController();
  final TextEditingController _namapelaporController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kkController = TextEditingController();
  final TextEditingController _ktpController = TextEditingController();
  final TextEditingController _aktaanakController = TextEditingController();
  final TextEditingController _surathilangController = TextEditingController();
  final TextEditingController _usiaanakController = TextEditingController();
  final TextEditingController _selfieController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    selectedFiles = {};
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? phone = prefs.getString('phone');
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

  Future<void> _saveUserInfo(String email, String phone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
  }

  Future<void> saveUserId(int user_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', user_id);
    print('User ID tersimpan: $user_id');
  }

  Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');
    print('User ID yang diambil: $id');
    return id;
  }

  Map<String, String> selectedFiles = {};
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String judul) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        selectedFiles[judul] = pickedFile.path;
      });
      print('File terpilih: ${pickedFile.path}');
    } else {
      print('No image selected.');
    }
  }

  Future<MultipartFile?> validateAndPrepareFile(String? path) async {
    if (path != null && path.isNotEmpty) {
      return MultipartFile.fromFile(path);
    }
    return null;
  }

  // Future<void> _saveUserId(int userId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('user_id', userId);
  // }

  final Map<int, String> produkItems = {
    151: 'KIA BARU',
    152: 'KIA RUSAK',
    153: 'KIA HILANG',
    154: 'KIA RUBAH',
    155: 'KIA KELAHIRAN',
    156: 'KIA + KK',
  };

  int? selectedProductId;

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

  String? selectedValue;
  String? selectedValue2;
  String? selectedValue3;
  String? Kecamatan;
  String? Kelurahan;
  // String? kk;
  // String? ktp;
  // String? aktaanak;
  // String? kehilangan;
  // String? fotoanak;
  // String? selfie;
  String? selectedFileName;
  // int? user_id;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _produkController.dispose();
    _kecController.dispose();
    _kelController.dispose();
    _keteranganController.dispose();
    _nikpelaporController.dispose();
    _namapelaporController.dispose();
    _nikController.dispose();
    _namaController.dispose();
    // _kkController.dispose();
    // _ktpController.dispose();
    // _aktaanakController.dispose();
    // _surathilangController.dispose();
    // _usiaanakController.dispose();
    // _selfieController.dispose();
    super.dispose();
  }

  Future<void> _kategorikia() async {
    if (_formKey.currentState!.validate()) {
      // Mengambil user_id dari SharedPreferences
      int? user_id = await getUserId();
      if (user_id == null) {
        // Handle jika user_id null
        print('Error: User ID tidak ditemukan di SharedPreferences');
        return;
      }

      String email = _emailController.text;
      String phone = _phoneController.text;
      String keterangan = _keteranganController.text;
      String nikpelapor = _nikpelaporController.text;
      String namapelapor = _namapelaporController.text;
      String nik = _nikController.text;
      String nama = _namaController.text;

      String username1 = 'admin';
      String password1 = 'admin';
      String basicAuth =
          'Basic ' + base64.encode(utf8.encode('$username1:$password1'));

      // Cetak nilai variabel sebelum dikirimkan
      print('User ID: $user_id');
      print('Email: $email');
      print('Phone: $phone');
      print('Keterangan: $keterangan');
      print('NIK Pelapor: $nikpelapor');
      print('Nama Pelapor: $namapelapor');
      print('NIK: $nik');
      print('Nama: $nama');
      print('Selected Product ID: $selectedProductId');
      print('Kecamatan: $Kecamatan');
      print('Kelurahan: $Kelurahan');
      print('Selected Files: $selectedFiles');

      try {
        Dio dio = Dio();

        // Buat form data
        FormData formData = FormData.fromMap({
          'user_id': user_id, // Menggunakan user_id dari SharedPreferences
          'pelapor_email': email,
          'pelapor_phone': phone,
          'layanan_id': selectedProductId,
          'kecamatanya': Kecamatan,
          'kelurahan': Kelurahan,
          'fm1': nikpelapor,
          'fm2': namapelapor,
          'fm3': nik,
          'fm4': nama,
          'fm5': keterangan,
          'img1': await validateAndPrepareFile(
              selectedFiles['Kartu Keluarga Terbaru']),
          'img2': await validateAndPrepareFile(selectedFiles['KTP']),
          'img3': await validateAndPrepareFile(selectedFiles['Akta Anak']),
          'img4': await validateAndPrepareFile(
              selectedFiles['Surat Kehilanagan Jika Hilang/Akta Perekaman']),
          'img5': await validateAndPrepareFile(
              selectedFiles['jika usia anak lebih dari 5 tahun']),
          'selfie':
              await validateAndPrepareFile(selectedFiles['Upload Foto Selfie']),
        });

        final response = await dio.post(
          'http://10.101.1.154:8000/kia/create',
          data: formData,
          options: Options(
            validateStatus: (_) => true,
            headers: <String, String>{
              'Authorization': basicAuth,
            },
          ),
        );

        // Cetak respons dari server
        print('Response status: ${response.statusCode}');
        print('Response data: ${response.data}');

        // Handle response
        if (response.statusCode == 200) {
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
                )
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _pickFiles(String judul) async {
    try {
      var pickedFiles = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg'],
      );

      if (pickedFiles != null && pickedFiles.files.isNotEmpty) {
        var file = pickedFiles.files.first;

        if (file.size > 2 * 1024 * 1024) {
          // File size exceeds 2MB
          print("File terlalu besar. Maksimal ukuran file adalah 2MB.");
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('File Terlalu Besar'),
                content: Text('Ukuran file tidak boleh lebih dari 2MB.'),
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
          return;
        }

        setState(() {
          selectedFiles[judul] = file.path!;
        });

        print('File berhasil diunggah: ${selectedFiles[judul]}');
      } else {
        print("Tidak ada file yang dipilih.");
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      // _fileName = null;
      _paths = null;
      //  _saveAsFileName = null;
      _userAborted = false;
    });
  }

  void _launchURL(String url) async {
    try {
      await launch(url);
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  Widget title() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Kembali',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget inputSection() {
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
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan Email Address';
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
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan No Whatsapp';
                }
                return null;
              },
            )
          ],
        ),
      );
    }

    Widget Keteranganinput() {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Keterangan',
              style: blackTextStyle,
            ),
            SizedBox(
              height: 6,
            ),
            TextFormField(
              controller: _keteranganController,
              style: blackTextStyle,
              cursorColor: kBlackColor,
              decoration: InputDecoration(
                hintText: 'Masukkan Keterangan',
                prefixIcon: const Icon(Icons.perm_device_information),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan Keterangan';
                }
                return null;
              },
            )
          ],
        ),
      );
    }

    Widget NIKInput() {
      return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No NIK',
              style: blackTextStyle,
            ),
            SizedBox(
              height: 6,
            ),
            TextFormField(
              controller: _nikpelaporController,
              style: blackTextStyle,
              cursorColor: kBlackColor,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan No NIK',
                prefixIcon: const Icon(Icons.document_scanner),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan No NIK';
                }
                return null;
              },
            )
          ],
        ),
      );
    }

    Widget NamaInput() {
      return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Pelapor',
              style: blackTextStyle,
            ),
            SizedBox(
              height: 6,
            ),
            TextFormField(
              controller: _namapelaporController,
              style: blackTextStyle,
              cursorColor: kBlackColor,
              decoration: InputDecoration(
                hintText: 'Masukkan Nama',
                prefixIcon: const Icon(Icons.pentagon),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan Nama';
                }
                return null;
              },
            )
          ],
        ),
      );
    }

    Widget nikanakInput() {
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
                hintText: 'Masukkan NIK Anak',
                prefixIcon: const Icon(Icons.document_scanner),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan NIK';
                }
                return null;
              },
            )
          ],
        ),
      );
    }

    Widget namaanakInput() {
      return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Anak',
              style: blackTextStyle,
            ),
            SizedBox(
              height: 6,
            ),
            TextFormField(
              controller: _namaController,
              style: blackTextStyle,
              cursorColor: kBlackColor,
              decoration: InputDecoration(
                hintText: 'Masukkan Nama Anak',
                prefixIcon: const Icon(Icons.document_scanner),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan Nama';
                }
                return null;
              },
            )
          ],
        ),
      );
    }

    Widget submitButton() {
      return Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5),
              blurRadius: 50,
              offset: Offset(0, 10),
            )
          ],
        ),
        child: TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              String email = _emailController.text;
              String phone = _phoneController.text;

              // Save email and phone to shared preferences
              await _saveUserInfo(
                email,
                phone,
              );

              // Get userId text from the controller
              // String? userIdText = _userIdController.text;

              // // Check if userIdText is not null and not empty
              // if (userIdText != null && userIdText.isNotEmpty) {
              //   // Convert userIdText to integer
              //   int userId = int.tryParse(userIdText) ??
              //       0; // Default value is 0 if conversion fails
              //   // Save userId to shared preferences
              //   await _saveUserId(userId);

              // Call function to send data to server after saving userId
              _kategorikia();
              // Show success alert
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Pengajuan Berhasil'),
                    content: Text('Pengajuan Anda telah berhasil dikirim.'),
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
          },
          style: TextButton.styleFrom(
            backgroundColor: kPrimaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Submit',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    Widget uploadKK(String judul) {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$judul',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickFiles(judul);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _pickFiles(judul);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_file,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Upload File',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8), // Added SizedBox for spacing
                  Text(
                    selectedFiles[judul] ??
                        'Belum ada file dipilih', // Gabungkan semua nama file dalam daftar menjadi satu string
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget uploadKTP(String judul) {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$judul',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickFiles(judul); // Memanggil fungsi untuk form KTP
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _pickFiles(judul); // Memanggil fungsi untuk form KTP
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_file,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Upload File',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    selectedFiles[judul] ??
                        'Belum ada file dipilih', // Gabungkan semua nama file dalam daftar menjadi satu string
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget uploadaktaanak(String judul) {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$judul',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickFiles(
                          judul); // Memanggil fungsi untuk form surat kehilangan
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _pickFiles(
                              judul); // Memanggil fungsi untuk form surat kehilangan
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_file,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Upload File',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    selectedFiles[judul] ??
                        'Belum ada file dipilih', // Gabungkan semua nama file dalam daftar menjadi satu string
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget uploadkehilangan(String judul) {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$judul',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickFiles(
                          judul); // Memanggil fungsi untuk form surat kehilangan
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _pickFiles(
                              judul); // Memanggil fungsi untuk form surat kehilangan
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_file,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Upload File',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    selectedFiles[judul] ??
                        'Belum ada file dipilih', // Gabungkan semua nama file dalam daftar menjadi satu string
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget uploadpasfoto(String judul) {
      return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$judul',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickFiles(
                          judul); // Memanggil fungsi untuk form surat kehilangan
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _pickFiles(
                              judul); // Memanggil fungsi untuk form surat kehilangan
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_file,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Upload File',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    selectedFiles[judul] ??
                        'Belum ada file dipilih', // Gabungkan semua nama file dalam daftar menjadi satu string
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget selfie(String judul) {
      // Ambil path file selfie dari selectedFiles
      String? selfiePath = selectedFiles['Upload Foto Selfie'];

      return Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$judul',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickImage(judul);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {
                          _pickImage(judul);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Ambil Foto',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    selfiePath ?? 'Belum ada file dipilih',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget dropdownButton() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0),
          Text(
            'Silahkan Pilih Kategori Produk',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          DropdownButtonFormField<int>(
            // Ubah tipe data DropdownButtonFormField menjadi int
            value:
                selectedProductId, // Ubah selectedValue menjadi selectedProductId
            decoration: InputDecoration(
              hintText: 'Pilih Kategori Produk',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            items: produkItems.entries.map((MapEntry<int, String> entry) {
              final int productId = entry.key;
              final String productName = entry.value;
              return DropdownMenuItem<int>(
                // Ubah tipe data DropdownMenuItem menjadi int
                value: productId,
                child: Text(
                  productName,
                  style: TextStyle(fontSize: 13),
                ),
              );
            }).toList(),
            onChanged: (int? value) {
              // Ubah tipe data value menjadi int?
              setState(() {
                selectedProductId = value;
              });
            },
          ),
        ],
      );
    }

    Widget dropdownButton2() {
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
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
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
                setState(() {
                  Kecamatan = value;
                  Kelurahan = pilihKelurahan[value!]![
                      0]; // Set Kelurahan ke nilai awal yang unik saat Kecamatan berubah
                });
              },
              validator: (value) {
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

    Widget dropdownButton3() {
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
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Color.fromARGB(255, 7, 37, 77)),
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

    Widget downloadFormsSection() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Download Formulir Yang Dibutuhkan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              _launchURL(
                'https://dispendukcapil.malangkota.go.id/wp-content/uploads/2022/01/FORMULIR_KIA.pdf',
              );
            },
            child: Row(
              children: [
                Icon(Icons.description, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Formulir KIA',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          )
        ],
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      downloadFormsSection(),
      SizedBox(height: 20),
      Text(
        'Tambah Identitas Anak',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      SizedBox(height: 10),
      Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            dropdownButton(),
            SizedBox(height: 10),
            dropdownButton2(),
            SizedBox(height: 10),
            dropdownButton3(),
            SizedBox(height: 10),
            emailInput(),
            noInput(),
            Keteranganinput(),
            NIKInput(),
            NamaInput(),
            nikanakInput(),
            namaanakInput(),
            uploadKK('Kartu Keluarga Terbaru'),
            uploadKTP('KTP'),
            uploadaktaanak('Akta Anak'),
            uploadkehilangan('Surat Kehilanagan Jika Hilang/Akta Perekaman'),
            uploadpasfoto('jika usia anak lebih dari 5 tahun'),
            selfie('Upload Foto Selfie'),
          ],
        ),
      ),
      SizedBox(height: 20),
      submitButton(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            title(),
            inputSection(),
          ],
        ),
      ),
    );
  }
}
