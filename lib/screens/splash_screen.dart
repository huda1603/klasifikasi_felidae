import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klasifikasi_felidae/screens/welcome_screen.dart';
import 'package:klasifikasi_felidae/screens/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int splashIndex = 0;
  final PageController _pageViewController = PageController();
  ThemeData dark = darks;
  var light = ThemeData.light();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          splashIndex == 0
              ? Color(0xFF3D4A26)
              : splashIndex == 1
              ? Color(0xFF3F3C36)
              : splashIndex == 2
              ? Color(0xFF705601)
              : Color(0xFF251404),
      body:
          width <= 1200
              ? PageView(
                controller: _pageViewController,
                onPageChanged: (index) {
                  if (index != 0) {
                    setState(() => splashIndex = index - 1);
                  }
                },
                children: [
                  WelcomeScreen(),
                  bodyMobile(0),
                  bodyMobile(1),
                  bodyMobile(2),
                ],
              )
              : Container(),
    );
  }

  Stack bodyMobile(int splashIndex) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (splashIndex == 0)
          splashDraw(-13, 132, "assets/drawSplash1/Cloud (3).png", 175, 74),
        if (splashIndex == 0)
          splashDraw(128, -16, "assets/drawSplash1/Cloud.png", 131, 56),
        if (splashIndex == 0)
          splashDraw(85, 279, "assets/drawSplash1/Cloud (1).png", 168, 71),
        if (splashIndex == 0)
          splashDraw(206, 236, "assets/drawSplash1/Cloud (2).png", 248, 105),
        if (splashIndex == 0)
          splashDraw(
            343,
            -36,
            "assets/drawSplash1/Cloud (4).png",
            158.29,
            66.7,
          ),
        if (splashIndex == 0)
          splashDraw(
            247.86,
            94.61,
            "assets/drawSplash1/Vector.png",
            235.64,
            235.64,
          ),
        if (splashIndex == 0)
          splashDraw(
            229,
            261.92,
            "assets/drawSplash1/Group (10).png",
            47.88,
            51.99,
          ),
        if (splashIndex == 0)
          splashDraw(
            311.02,
            320.73,
            "assets/drawSplash1/Group (11).png",
            59.02,
            40.01,
          ),
        if (splashIndex == 0)
          splashDraw(
            273.41,
            74,
            "assets/drawSplash1/Group (7).png",
            47.86,
            36.04,
          ),
        if (splashIndex == 0)
          splashDraw(
            431.69,
            77.32,
            "assets/drawSplash1/Group (9).png",
            64.02,
            30.52,
          ),
        if (splashIndex == 0)
          splashDraw(
            466.48,
            24.46,
            "assets/drawSplash1/Vector (1).png",
            382.29,
            150.37,
          ),
        if (splashIndex == 0)
          splashDraw(
            349.48,
            155.82,
            "assets/drawSplash1/Group.png",
            114.88,
            182.91,
          ),
        if (splashIndex == 0)
          splashDraw(
            449.18,
            2,
            "assets/drawSplash1/Group (1).png",
            232.37,
            207.67,
          ),
        if (splashIndex == 0)
          splashDraw(
            450.32,
            207.64,
            "assets/drawSplash1/Group (2).png",
            232.37,
            207.67,
          ),
        if (splashIndex == 0)
          splashDraw(
            552.49,
            50,
            "assets/drawSplash1/Group (5).png",
            18.48,
            6.71,
          ),
        if (splashIndex == 0)
          splashDraw(
            521.37,
            31.91,
            "assets/drawSplash1/Group (3).png",
            102.97,
            56.03,
          ),
        if (splashIndex == 0)
          splashDraw(
            550.17,
            368.88,
            "assets/drawSplash1/Group (6).png",
            14.68,
            7.04,
          ),
        if (splashIndex == 0)
          splashDraw(
            522.94,
            305.03,
            "assets/drawSplash1/Group (4).png",
            88.83,
            47.29,
          ),
        if (splashIndex == 1)
          splashDraw(42, 0, "assets/drawSplash2/Frame (1).png", 440, 641),
        if (splashIndex == 2)
          splashDraw(0, 0, "assets/drawSplash3/Vector (2).png", 440, 410),
        if (splashIndex == 2)
          splashDraw(193, 0, "assets/drawSplash3/Vector (3).png", 440, 453.56),
        if (splashIndex == 2)
          splashDraw(
            462.33,
            82,
            "assets/drawSplash3/Vector (4).png",
            440,
            202.2,
          ),
        if (splashIndex == 2)
          splashDraw(112, 0, "assets/drawSplash3/Group (12).png", 440, 596.97),
        Positioned(
          top: 85.r,
          child: Container(
            alignment: Alignment.center,
            width: 111.w,
            height: 46.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              color: Colors.transparent,
              border: Border.all(color: Colors.white, width: 1.r),
            ),
            child: Text(
              "Step ${splashIndex == 0
                  ? 'One'
                  : splashIndex == 1
                  ? 'Two'
                  : 'Three'}",
              style: dark.textTheme.bodySmall,
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: ClipPath(
            clipper: BottomSheetClipper(),
            child: Container(
              width: double.infinity,
              height: (956 - 580).h,
              padding: EdgeInsets.only(top: 70.r),
              decoration: BoxDecoration(color: Color(0xFF251404)),
              child: Column(
                spacing: 25.r,
                children: [
                  Container(
                    width: 180.w,
                    decoration: ShapeDecoration(shape: StadiumBorder()),
                    child: LinearProgressIndicator(
                      value:
                          splashIndex == 0
                              ? 0
                              : splashIndex == 1
                              ? 0.5
                              : 0.95,
                      minHeight: 8.h,
                      backgroundColor: Color(0xFF4F3422),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF926247),
                      ),
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          splashIndex == 0
                              ? "Siapkan "
                              : splashIndex == 1
                              ? "Pilih menu "
                              : "AI akan memproses gambar\ndan ",
                      style: dark.textTheme.headlineLarge,
                      children: [
                        TextSpan(
                          text:
                              splashIndex == 0
                                  ? "gambar "
                                  : splashIndex == 1
                                  ? "Klasifikasi "
                                  : "menampilkan ",
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Serif',
                            color:
                                splashIndex == 0
                                    ? Color(0xFF9BB168)
                                    : splashIndex == 1
                                    ? Color(0xFF73706B)
                                    : Color(0xFFFFBD19),
                          ),
                        ),
                        TextSpan(
                          text:
                              splashIndex == 0
                                  ? "yang\ningin anda klasifikasikan"
                                  : splashIndex == 1
                                  ? "dan\nmasukkan gambar"
                                  : "hasilnya",
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Serif',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return RegisterScreen();
                          },
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: Color(0xFF926247),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_right_alt_outlined,
                        size: 35.r,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Positioned splashDraw(double t, double l, String img, double wi, double he) {
    return Positioned(
      top: t.h,
      left: l.w,
      child: Image(image: AssetImage(img), width: wi.w, height: he.h),
    );
  }
}

class BottomSheetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;

    final path = Path();

    path.moveTo(0, height);
    path.lineTo(width, height);
    path.lineTo(width, 60);
    path.quadraticBezierTo((width / 2), 0, 0, 60);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
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
      color: Colors.white,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.normal,
      fontFamily: 'Serif',
    ),
  ),
);
