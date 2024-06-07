import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter/src/services/asset_manifest.dart' as flutter_asset;
// import 'package:google_fonts/src/asset_manifest.dart' as google_fonts_asset;

double defaultMargin = 24.0;
double defaultRadius = 17.0;

Color primaryColor = Color(0xFF05103A);
Color blueColor = Colors.blue;
Color whiteColor = Colors.white;
Color dangerColor = Colors.red;

TextStyle dangerTextStyle = GoogleFonts.roboto(
    fontSize: 36, color: dangerColor, fontWeight: FontWeight.w500);
TextStyle whiteTextStyle = GoogleFonts.poppins(
    fontSize: 14, color: whiteColor, fontWeight: FontWeight.w500);

Color kPrimaryColor = Color(0xff002544);
Color kBlackColor = Color.fromARGB(255, 0, 0, 0);
Color kWhiteColor = Color(0xffFFFFFF);
Color kGreyColor = Color(0xff9698A9);
Color kGreenColor = Color(0xff0EC3AE);
Color kRedColor = Color(0xffEB70A5);
Color kBackgroundColor = Color(0xffFAFAFA);
Color kInactiveColor = Color(0xffDBD7EC);

TextStyle blackTextStyle = GoogleFonts.khula(
  color: kBlackColor,
);
TextStyle whiteText = GoogleFonts.baloo2(
  color: kWhiteColor,
);
TextStyle greyTextStyle = GoogleFonts.baloo2(
  color: kGreyColor,
);
TextStyle greenTextStyle = GoogleFonts.baloo2(
  color: kGreenColor,
);
TextStyle redTextStyle = GoogleFonts.baloo2(
  color: kRedColor,
);
TextStyle purpleTextStyle = GoogleFonts.baloo2(
  color: kPrimaryColor,
);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;
