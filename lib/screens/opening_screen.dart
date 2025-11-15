import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klasifikasi_felidae/screens/loading_screen.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  ThemeData dark = darks;
  var light = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: dark.primaryColorDark,
      body:
          width <= 1200
              ? Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoadingScreen();
                        },
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5.h,
                    children: [
                      Image(
                        width: 198.w,
                        height: 198.h,
                        image: AssetImage("logo.png"),
                      ),
                      Text(
                        "BIG CAT SPECIES",
                        style: dark.textTheme.headlineLarge,
                      ),
                      Text("CLASSIFIER", style: dark.textTheme.bodySmall),
                    ],
                  ),
                ),
              )
              : Container(),
    );
  }
}

ThemeData darks = ThemeData(
  useMaterial3: true,
  primaryColorDark: Color(0xFF251404),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF4F3422),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(50),
        bottomRight: Radius.circular(50),
      ),
    ),
    centerTitle: false,
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 38.sp,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontFamily: 'Serif',
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontSize: 22.h,
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontFamily: 'Serif',
    ),
  ),
);
