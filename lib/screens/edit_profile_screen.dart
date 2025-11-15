import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:klasifikasi_felidae/screens/home_screen.dart';
import 'package:klasifikasi_felidae/screens/select_foto_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ThemeData dark = darks;
  var light = ThemeData.light();
  bool isLoadingUsername = false;
  bool isLoadingImage = false;

  late TextEditingController _ctrlUsername;

  CollectionReference dataDiri = FirebaseFirestore.instance.collection("users");
  Uint8List? profileImg;

  Future<DocumentSnapshot> getCurrentUser() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw Exception("Pengguna tidak login");
    }

    final String userUid = currentUser.uid;

    return dataDiri.doc(userUid).get();
  }

  Future<Uint8List?> getProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final imgBase64 = doc.data()?['img'];

    if (imgBase64 == null || imgBase64.isEmpty) {
      return null;
    }

    // decode base64 → Uint8List
    return base64Decode(imgBase64);
  }

  Future<String?> updateUser({String? newUsername}) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return null;
    }

    final String userUid = currentUser.uid;
    setState(() => isLoadingUsername = true);

    try {
      await dataDiri.doc(userUid).update({'username': newUsername});
      print('Berhasil Update Username');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Update Username berhasil!"),
          backgroundColor: Colors.green,
        ),
      );
      setState(() => isLoadingUsername = false);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
          'Gagal memperbarui: Silakan login ulang sebelum mengganti email atau password.',
        );
      }
      print(e.message);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _ctrlUsername = TextEditingController();
  }

  @override
  void dispose() {
    _ctrlUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: dark.primaryColorDark,
      body:
          width <= 600 && width < height
              ? Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipPath(
                        clipper: ProfileClipper(),
                        child: Container(
                          color: Color(0xFF9BB168),
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                        ),
                      ),
                      Positioned(left: 5, top: 8, child: circleArt(80, 10)),
                      Positioned(
                        right: MediaQuery.of(context).size.width / 2 + 5,
                        top: 0,
                        child: circleArt(60, 11),
                      ),
                      Positioned(
                        right: MediaQuery.of(context).size.width / 2 - 40,
                        top: 38,
                        child: circleArt(30, 6),
                      ),
                      Positioned(
                        right: MediaQuery.of(context).size.width / 2 - 120,
                        top: 50,
                        child: circleArt(50, 9),
                      ),
                      Positioned(
                        right: -20,
                        top: -50,
                        child: circleArt(115, 15),
                      ),
                      Positioned(
                        bottom: 32.5,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          child: FutureBuilder<Uint8List?>(
                            future: getProfile(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }

                              // Jika tidak ada gambar → tampilkan avatar default
                              if (!snapshot.hasData || snapshot.data == null) {
                                return Icon(Icons.person, size: 25);
                              }

                              Uint8List bytes = snapshot.data!;

                              return CircleAvatar(
                                radius: 50,
                                backgroundImage: MemoryImage(bytes),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SelectFotoProfileScreen();
                                },
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Color(0xFF4F3422),
                            foregroundColor: Colors.white,
                            child: Icon(Icons.edit_note_outlined, size: 20),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 10,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ),
                                ).then((_) {
                                  setState(() {});
                                });
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                            Text(
                              "Profile Setup",
                              style: dark.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 7,
                      ),
                      child: Column(
                        children: [
                          inputField(
                            "Your Name",
                            "Enter your name..",
                            Icons.person_2_outlined,
                            null,
                            _ctrlUsername,
                          ),
                          Spacer(),
                          isLoadingUsername == false
                              ? GestureDetector(
                                onTap:
                                    () => updateUser(
                                      newUsername: _ctrlUsername.value.text,
                                    ),
                                child: Container(
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
                                        "Continue",
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
                              )
                              : const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              )
              : Stack(
                children: [
                  Center(
                    child: Transform.scale(
                      scale: 0.95,
                      child: SizedBox(
                        width: 395,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white54,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ClipPath(
                                      clipper: ProfileClipper(),
                                      child: Container(
                                        color: Color(0xFF9BB168),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 200,
                                      ),
                                    ),
                                    Positioned(
                                      left: 5,
                                      top: 8,
                                      child: circleArt(80, 10),
                                    ),
                                    Positioned(
                                      left: 120,
                                      top: 5,
                                      child: circleArt(60, 10),
                                    ),
                                    Positioned(
                                      right: 140,
                                      top: 50,
                                      child: circleArt(30, 6),
                                    ),
                                    Positioned(
                                      right: 70,
                                      top: 60,
                                      child: circleArt(40, 8),
                                    ),
                                    Positioned(
                                      right: -20,
                                      top: -50,
                                      child: circleArt(115, 15),
                                    ),
                                    Positioned(
                                      bottom: 32.5,
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.grey[300],
                                        child: FutureBuilder<Uint8List?>(
                                          future: getProfile(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }

                                            // Jika tidak ada gambar → tampilkan avatar default
                                            if (!snapshot.hasData ||
                                                snapshot.data == null) {
                                              return Icon(
                                                Icons.person,
                                                size: 25,
                                              );
                                            }

                                            Uint8List bytes = snapshot.data!;

                                            return CircleAvatar(
                                              radius: 50,
                                              backgroundImage: MemoryImage(
                                                bytes,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 16,
                                      child: CircleAvatar(
                                        radius: 15,
                                        backgroundColor: Color(0xFF4F3422),
                                        foregroundColor: Colors.white,
                                        child: Icon(
                                          Icons.edit_note_outlined,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 35,
                                    ),
                                    child: Column(
                                      children: [
                                        Transform.scale(
                                          scale: 0.9,
                                          child: inputField(
                                            "Your Name",
                                            "Enter your name..",
                                            Icons.person_2_outlined,
                                            null,
                                            _ctrlUsername,
                                          ),
                                        ),
                                        Spacer(),
                                        isLoadingUsername == false
                                            ? GestureDetector(
                                              onTap:
                                                  () => updateUser(
                                                    newUsername:
                                                        _ctrlUsername
                                                            .value
                                                            .text,
                                                  ),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 7,
                                                ),
                                                alignment: Alignment.center,
                                                decoration: ShapeDecoration(
                                                  shape: StadiumBorder(),
                                                  color: Color(0xFF926247),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  spacing: 3,
                                                  children: [
                                                    Text(
                                                      "Continue",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontFamily: 'Serif',
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_right_alt_outlined,
                                                      size: 11,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            : const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            ),
                                        SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 11,
                    left: 11,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        Text("Profile Setup", style: dark.textTheme.bodyMedium),
                      ],
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
                    ? Icon(suffixIcon, color: Colors.white, size: 15)
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
    final lower = height - 25 - 7.5;

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
