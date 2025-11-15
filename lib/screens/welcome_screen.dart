import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  ThemeData dark = darks;
  var light = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: dark.primaryColorDark,
      body:
          width <= 1200
              ? Padding(
                padding: EdgeInsets.only(top: 106.r),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 93.w,
                          height: 93.h,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(79, 52, 34, 1),
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox(
                            width: 32.w,
                            height: 32.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: 0.r,
                                  child: Container(
                                    width: 12.44.w,
                                    height: 12.44.h,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF926247),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0.r,
                                  child: Container(
                                    width: 12.44.w,
                                    height: 12.44.h,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF926247),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0.r,
                                  child: Container(
                                    width: 12.44.w,
                                    height: 12.44.h,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF926247),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0.r,
                                  child: Container(
                                    width: 12.44.w,
                                    height: 12.44.h,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF926247),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: 35.r,
                            left: 48.r,
                            right: 48.r,
                          ),
                          child: Column(
                            spacing: 18.h,
                            children: [
                              Text(
                                "Selamat datang di Klasifikasi Terbaik!",
                                style: dark.textTheme.headlineLarge,
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Temukan dan identifikasi spesies kucing Anda dengan Ai",
                                style: dark.textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                              Image(
                                image: AssetImage("assets/Frame.png"),
                                width: 300.w,
                                height: 300.h,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.r,
                                  vertical: 16.r,
                                ),
                                decoration: ShapeDecoration(
                                  shape: StadiumBorder(),
                                  color: Color(0xFF926247),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 10.h,
                                  children: [
                                    Text(
                                      "Memulai",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'Serif',
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_right_alt_outlined,
                                      size: 22.r,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
      fontSize: 30.sp,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.normal,
      fontFamily: 'Serif',
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontFamily: 'Serif',
    ),
    bodySmall: TextStyle(
      color: Colors.white54,
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontFamily: 'Serif',
    ),
  ),
);
