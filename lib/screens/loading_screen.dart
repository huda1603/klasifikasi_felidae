import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klasifikasi_felidae/screens/splash_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int loadingNum = 0;
  ThemeData dark = darks;

  @override
  void initState() {
    super.initState();
    startLoading();
  }

  /// ====== PROSES LOADING REALTIME ======
  void startLoading() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (loadingNum >= 100) {
        timer.cancel();
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
          );
        });
      } else {
        setState(() {
          loadingNum += 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: dark.primaryColorDark,
      body:
          width <= 1200
              ? Stack(
                alignment: Alignment.center,
                children: [
                  circleDraw(72, 75),
                  circleDraw(591, 75),
                  circleDraw(333, 295),
                  circleDraw(333, -145),
                  Center(
                    child: Text(
                      "$loadingNum%",
                      style: dark.textTheme.headlineLarge,
                    ),
                  ),
                ],
              )
              : Container(),
    );
  }

  Positioned circleDraw(double t, double l) {
    return Positioned(
      top: t.h,
      left: l.w,
      child: Container(
        width: 290.w,
        height: 290.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF4F3422),
        ),
      ),
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
  ),
);
