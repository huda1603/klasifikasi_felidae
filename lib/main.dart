import 'package:flutter/material.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klasifikasi_felidae/screens/login_screen.dart';
import 'package:tflite_web/tflite_web.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  await TFLiteWeb.initializeUsingCDN();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData dark = ThemeData(
      useMaterial3: true,
      primaryColorDark: Color(0xFF251404),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF4F3422),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        centerTitle: false,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontFamily: 'Serif',
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontStyle: FontStyle.normal,
          fontFamily: 'Serif',
        ),
        bodySmall: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontStyle: FontStyle.normal,
          fontFamily: 'Serif',
        ),
      ),
    );

    final ThemeData light = ThemeData(
      useMaterial3: true,
      primaryColorDark: Colors.white60,
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF4F3422),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        centerTitle: false,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontFamily: 'Serif',
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontStyle: FontStyle.normal,
          fontFamily: 'Serif',
        ),
        bodySmall: TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontStyle: FontStyle.normal,
          fontFamily: 'Serif',
        ),
      ),
    );

    return ScreenUtilInit(
      designSize: Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GlassMorphismThemeProvider(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Klasifikasi Kucing Besar',
            theme: light,
            darkTheme: dark,
            home: LoginScreen(),
          ),
        );
      },
    );
  }
}
