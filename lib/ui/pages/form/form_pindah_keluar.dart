import 'package:flutter/material.dart';
import '../../../shared/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormPindahKeluar extends StatefulWidget {
  const FormPindahKeluar({Key? key}) : super(key: key);

  @override
  State<FormPindahKeluar> createState() => _FormPindahKeluarState();
}

class _FormPindahKeluarState extends State<FormPindahKeluar> {
  final _formKey = GlobalKey<FormState>();
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
  String nik_pelapor = '';
  String nama_pelapor = '';
  FileType _pickingType = FileType.any;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
    });
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
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              'Pindah Keluar',
              style:
                  blackTextStyle.copyWith(fontSize: 24, fontWeight: semiBold),
            ),
          ],
        ),
      );
    }

    Widget inputSection() {
      Widget formInput(
        String Judul,
        String Caption,
      ) {
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$Judul',
                style: blackTextStyle,
              ),
              SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Data tidak boleh kosong';
                  }
                  return null;
                },
                style: blackTextStyle,
                cursorColor: kBlackColor,
                decoration: InputDecoration(
                    hintText: '$Caption',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(defaultRadius)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(defaultRadius),
                        borderSide: BorderSide(color: kPrimaryColor))),
              )
            ],
          ),
        );
      }

      Widget submitButton() {
        return Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: kPrimaryColor.withOpacity(0.5),
                blurRadius: 50,
                offset: Offset(0, 10))
          ]),
          child: TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pushNamed(context, '/bottom-tab');
              }
            },
            style: TextButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultRadius))),
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

      Widget uploadButton(String Judul) {
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$Judul'),
              SizedBox(
                height: 6,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.circular(defaultRadius)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // width: 160,
                      // height: 55,
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: kPrimaryColor.withOpacity(0.5),
                            blurRadius: 50,
                            offset: Offset(0, 10))
                      ]),
                      child: TextButton(
                        onPressed: () {
                          _pickFiles();
                        },
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(10),
                            backgroundColor: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(defaultRadius))),
                        child: Text(
                          '📝 Upload File',
                          style: whiteTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: medium,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '$Judul.pdf',
                      style: blackTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(defaultRadius)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              formInput('NIK Pelapor', 'Masukkan NIK Pelapor'),
              formInput('Nama Pelapor', 'Masukkan Nama Pelapor'),
              uploadButton('Kartu Keluarga (KK)'),
              uploadButton('KTP-el'),
              uploadButton('Surat Pernyataan Pindah'),
              uploadButton('Formulir F1-03'),
              uploadButton('Dokumen Pendukung (Untuk Perubahan Elemen Data)'),
              submitButton(),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: defaultMargin,
          ),
          children: [
            title(),
            inputSection(),
          ],
        ),
      ),
    );
  }
}
