import 'package:flutter/material.dart';
//import 'package:intro_slider/slide_object.dart';
import '../../shared/theme.dart';
import 'package:intro_slider/intro_slider.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Dhika",
        description:
            "Allow miles wound place the leave had. To sitting subject no improve studied limited",
        pathImage: "assets/ic_maskot_siapel.png",
        backgroundColor: Color(0xff189AB4),
      ),
    );
    slides.add(
      new Slide(
        title: "Dhika",
        description:
            "Ye indulgence unreserved connection alteration appearance",
        pathImage: "assets/ic_maskot_siapel.png",
        backgroundColor: Color(0xff203152),
      ),
    );
    slides.add(
      new Slide(
        title: "SIAPEL",
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
        pathImage: "assets/ic_maskot_siapel.png",
        backgroundColor: Color(0xff00A65A),
      ),
    );
  }

  void onDonePress() {
    // Do what you want
    print("End of slides");
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
    // Scaffold(
    //   body: Stack(
    //     children: [
    //       Container(
    //         width: double.infinity,
    //         height: double.infinity,
    //         // decoration: BoxDecoration(
    //         //     image: DecorationImage(
    //         //         image: AssetImage('assets/image_get_started.png'))),
    //       ),
    //       Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: [
    //             Container(
    //               height: 211,
    //               width: 300,
    //               padding: EdgeInsets.all(defaultMargin),
    //               decoration: BoxDecoration(
    //                   image: DecorationImage(
    //                       image: AssetImage('assets/ic_maskot_siapel.png')),
    //                   boxShadow: [
    //                     BoxShadow(
    //                         color: kPrimaryColor.withOpacity(0.5),
    //                         blurRadius: 50,
    //                         offset: Offset(0, 10))
    //                   ]),
    //             ),
    //             SizedBox(height: 40),
    //             Text(
    //               'SIAPEL',
    //               style:
    //                   blackTextStyle.copyWith(fontSize: 32, fontWeight: bold),
    //             ),
    //             SizedBox(height: 10),
    //             Text(
    //               '',
    //               style:
    //                   blackTextStyle.copyWith(fontSize: 16, fontWeight: light),
    //               textAlign: TextAlign.center,
    //             ),
    //             Container(
    //               width: 220,
    //               height: 55,
    //               decoration: BoxDecoration(boxShadow: [
    //                 BoxShadow(
    //                     color: kPrimaryColor.withOpacity(0.5),
    //                     blurRadius: 50,
    //                     offset: Offset(0, 10))
    //               ]),
    //               margin: EdgeInsets.only(top: 50, bottom: 80),
    //               child: TextButton(
    //                 onPressed: () {
    //                   Navigator.pushNamed(context, '/login');
    //                 },
    //                 style: TextButton.styleFrom(
    //                     backgroundColor: kPrimaryColor,
    //                     shape: RoundedRectangleBorder(
    //                         borderRadius:
    //                             BorderRadius.circular(defaultRadius))),
    //                 child: Text(
    //                   'Get Started',
    //                   style: whiteTextStyle.copyWith(
    //                       fontSize: 18, fontWeight: medium),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
