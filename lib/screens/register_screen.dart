import 'package:flutter/material.dart';
import 'package:klasifikasi_felidae/screens/login_screen.dart';
import 'package:klasifikasi_felidae/provider/auth.dart';
//import 'package:klasifikasi_felidae/helpers/textfield_validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  ThemeData dark = darks;
  var light = ThemeData.light();

  bool _passObscure = true;
  bool _passConfObscure = true;

  bool _loading = false;
  late TextEditingController _ctrlEmail;
  late TextEditingController _ctrlPassword;
  late TextEditingController _ctrlPasswordConf;

  handleSubmit(context) async {
    String email = _ctrlEmail.text;
    String password = _ctrlPassword.text;
    String passwordConfirm = _ctrlPasswordConf.text;

    if (password != passwordConfirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Konfirmasi Harus Sama dengan Password!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (password == '' || passwordConfirm == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Tidak boleh kosong!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _loading = true);

    bool success = false;

    try {
      success = await Auth().regis(email, password);
    } catch (e) {
      print("ERROR REGIS: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }

    setState(() => _loading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registrasi berhasil!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registrasi gagal!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _ctrlEmail = TextEditingController();
    _ctrlPassword = TextEditingController();
    _ctrlPasswordConf = TextEditingController();
  }

  @override
  void dispose() {
    _ctrlEmail.dispose();
    _ctrlPassword.dispose();
    _ctrlPasswordConf.dispose();
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
                  Text("Sign Up", style: dark.textTheme.headlineLarge),
                  SizedBox(height: 27),
                  inputField(
                    "Email Address",
                    "Enter your email..",
                    Icons.email_outlined,
                    null,
                    _ctrlEmail,
                  ),
                  SizedBox(height: 5),
                  // Container(
                  //   padding: EdgeInsets.all(7),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(50),
                  //     border: Border.all(color: Color(0xFF8D4C0D), width: 1),
                  //     color: Color(0xFF432500),
                  //   ),
                  //   child: Row(
                  //     spacing: 5,
                  //     children: [
                  //       Icon(
                  //         Icons.warning_amber_outlined,
                  //         color: Color(0xFFED7E1C),
                  //         size: 15,
                  //       ),
                  //       Text(
                  //         "Invalid Address!!",
                  //         style: dark.textTheme.bodySmall,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(height: 14),
                  inputField(
                    "Password",
                    "Enter your password..",
                    Icons.lock,
                    Icons.remove_red_eye_outlined,
                    _ctrlPassword,
                    obscure: _passObscure,
                    onToggleObscure: () {
                      setState(() => _passObscure = !_passObscure);
                    },
                  ),
                  SizedBox(height: 14),
                  inputField(
                    "Password Confirmation",
                    "Enter your password..",
                    Icons.lock,
                    Icons.remove_red_eye_outlined,
                    _ctrlPasswordConf,
                    obscure: _passConfObscure,
                    onToggleObscure: () {
                      setState(() => _passConfObscure = !_passConfObscure);
                    },
                  ),
                  SizedBox(height: 17),
                  GestureDetector(
                    onTap: () => handleSubmit(context),
                    child:
                        _loading
                            ? const SizedBox(
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
                                    "Sign Up",
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
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: dark.textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: "Sign In",
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
    TextEditingController ctrl, {
    bool obscure = false,
    VoidCallback? onToggleObscure,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(l, style: dark.textTheme.bodySmall),
      SizedBox(height: 7),
      if (hint != null)
        TextField(
          controller: ctrl,
          obscureText: obscure,
          style: dark.textTheme.bodySmall,
          maxLength: 20,
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: Color(0xFF372315),
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white60,
              fontSize: 10,
              fontFamily: 'Serif',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Icon(prefixIcon, color: Colors.white, size: 15),

            /// 👇 tombol show/hide password
            suffixIcon:
                suffixIcon != null
                    ? GestureDetector(
                      onTap: onToggleObscure,
                      child: Icon(
                        obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.white54,
                        size: 15,
                      ),
                    )
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
