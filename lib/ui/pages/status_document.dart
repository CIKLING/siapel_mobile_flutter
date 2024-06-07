import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siapel_mobile/shared/theme.dart';

class StatusDocument extends StatefulWidget {
  const StatusDocument({Key? key}) : super(key: key);

  @override
  State<StatusDocument> createState() => _StatusDocumentState();
}

class _StatusDocumentState extends State<StatusDocument> {
  late Response response;
  var dio = Dio();
  bool isLoading = false;
  List datane = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    setState(() {
      isLoading = true;
      EasyLoading.show(status: 'Loading...', dismissOnTap: true);
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email') ?? '';
      response = await dio.get('http://10.101.1.154:8000/permohonan/list');
      print(response.data.toString());
      if (mounted) {
        setState(() {
          if (response.data['success']) {
            datane = response.data['data'];
          } else {
            EasyLoading.showError(response.data['error']['description'],
                dismissOnTap: true);
          }

          isLoading = false;
          EasyLoading.dismiss();
        });
      }
    } catch (error) {
      EasyLoading.showError('Gagal Mendapatkan Data', dismissOnTap: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: datane.length,
                itemBuilder: (context, index) {
                  return _buildDocumentCard(datane[index]);
                },
              ),
      ),
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> documentData) {
    return GestureDetector(
      onTap: () {
        _showDocumentDetails(documentData['token']);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                documentData['jenis'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Status: ${documentData['status']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: documentData['status'] == 'Approved'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
              SizedBox(height: 5),
              QrImage(
                data: documentData['token'],
                version: QrVersions.auto,
                size: 100.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDocumentDetails(String token) {
    Alert(
      context: context,
      title: 'QR Code',
      content: Column(
        children: [
          QrImage(
            data: token,
            version: QrVersions.auto,
            size: 200.0,
          ),
          SizedBox(height: 10),
          Text(
            'Token: $token',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      buttons: [],
    ).show();
  }
}
