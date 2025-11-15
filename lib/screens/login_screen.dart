import 'package:flutter/material.dart';
import 'package:klasifikasi_felidae/screens/home_screen.dart';
import 'package:klasifikasi_felidae/screens/register_screen.dart';
import 'package:klasifikasi_felidae/provider/auth.dart';
//import 'package:klasifikasi_felidae/helpers/textfield_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ThemeData dark = darks;
  var light = ThemeData.light();

  bool _loading = false;
  late TextEditingController _ctrlEmail;
  late TextEditingController _ctrlPassword;

  handleSubmit(context) async {
    final email = _ctrlEmail.value.text;
    final password = _ctrlPassword.value.text;
    setState(() => _loading = true);

    // Menangkap hasil login
    bool success = false;

    try {
      success = await Auth().login(email, password);
    } catch (e) {
      print("ERROR LOGIN: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }

    setState(() => _loading = false);

    // Menampilkan SnackBar berdasarkan hasil login
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login berhasil!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal!"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _ctrlEmail = TextEditingController();
    _ctrlPassword = TextEditingController();
  }

  @override
  void dispose() {
    _ctrlEmail.dispose();
    _ctrlPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark.primaryColorDark,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipPath(
                clipper: ProfileClipper(),
                child: Container(
                  color: Color(0xFF9BB168),
                  width: MediaQuery.of(context).size.width,
                  height: 160,
                ),
              ),
              Transform.translate(
                offset: Offset(0, -5),
                child: SizedBox(
                  width: 26,
                  height: 26,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 5,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 5,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 5,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 7),
              child: Column(
                children: [
                  Text("Sign In", style: dark.textTheme.headlineLarge),
                  SizedBox(height: 27),
                  inputField(
                    "Email Address",
                    "Enter your email..",
                    Icons.email_outlined,
                    null,
                    _ctrlEmail,
                  ),
                  SizedBox(height: 14),
                  inputField(
                    "Password",
                    "Enter your password..",
                    Icons.lock,
                    Icons.remove_red_eye_outlined,
                    _ctrlPassword,
                  ),
                  SizedBox(height: 17),
                  GestureDetector(
                    onTap: () => handleSubmit(context),
                    child:
                        _loading
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Container(
                              padding: EdgeInsets.symmetric(vertical: 7),
                              alignment: Alignment.center,
                              decoration: ShapeDecoration(
                                shape: StadiumBorder(),
                                color: Color(0xFF926247),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 3,
                                children: [
                                  Text(
                                    "Sign In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.normal,
                                      fontFamily: 'Serif',
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_right_alt_outlined,
                                    size: 11,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                  ),
                  SizedBox(height: 30),
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
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        text: "Dont have an account? ",
                        style: dark.textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                              color: Color(0xFFBB6416),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Serif',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column inputField(
    String l,
    String? hint,
    IconData? prefixIcon,
    IconData? suffixIcon,
    TextEditingController ctrl,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(l, style: dark.textTheme.bodySmall),
      SizedBox(height: 7),
      if (hint != null)
        TextField(
          controller: ctrl,
          style: dark.textTheme.bodySmall,
          textCapitalization: TextCapitalization.sentences,
          maxLength: 20,
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: Color(0xFF372315),
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontStyle: FontStyle.normal,
              fontFamily: 'Serif',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(prefixIcon, color: Colors.white, size: 15),
            suffixIcon:
                suffixIcon != null
                    ? Icon(suffixIcon, color: Colors.white54, size: 15)
                    : null,
          ),
        ),
    ],
  );

  Container accountType(String type, bool selected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: selected ? Color(0xFF9BB168) : Color(0xFF372315),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(type, style: dark.textTheme.bodySmall),
          SizedBox(width: 5),
          Container(
            width: 12,
            height: 12,
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? Color(0xFF9BB168) : Color(0xFF372315),
              border: Border.all(color: Colors.white, width: 1),
            ),
            child: CircleAvatar(
              backgroundColor: selected ? Colors.white : Color(0xFF372315),
            ),
          ),
        ],
      ),
    );
  }

  Container circleArt(double wh, double b) => Container(
    width: wh,
    height: wh,
    decoration: BoxDecoration(
      color: Color(0xFF9BB168),
      shape: BoxShape.circle,
      border: Border.all(color: Color(0xFF3D4A26), width: b),
    ),
  );
}

class ProfileClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    final lower = height;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, lower - 85);
    path.quadraticBezierTo(width / 2, lower, width, lower - 85);

    path.lineTo(width, 0);

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
      fontSize: 24,
      fontWeight: FontWeight.bold,
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
