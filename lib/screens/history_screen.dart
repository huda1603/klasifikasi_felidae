import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:klasifikasi_felidae/screens/home_screen.dart';
import 'package:klasifikasi_felidae/screens/input_screen.dart';
import 'package:klasifikasi_felidae/screens/edit_profile_screen.dart';
import 'package:klasifikasi_felidae/screens/login_screen.dart';
import 'package:klasifikasi_felidae/widgets/history_result.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  ThemeData dark = darks;
  var light = ThemeData.light();

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

  Future<String> getUsername() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return doc.data()?['username'] ?? "";
  }

  CollectionReference? dataSpecies = FirebaseFirestore.instance.collection(
    "species_collection",
  );

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: dark.primaryColorDark,
      appBar: width <= 600 && width < height ? appBarMobile() : appBarDekstop(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          dataSpecies != null
              ? HistoryResult(dark: dark, width: width, height: height)
              : Text("Belum Ada Datanya", style: dark.textTheme.headlineLarge),
          if (width <= 600 && width < height)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  color: Color(0xFF4F3422),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HomeScreen();
                            },
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 38,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF4F3422),
                            ),
                            child: Icon(
                              Icons.home_outlined,
                              color: Colors.white24,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return InputScreen();
                            },
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 38,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF4F3422),
                            ),
                            child: Icon(
                              Icons.search_outlined,
                              color: Colors.white24,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 38,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF7D5133),
                          ),
                          child: Icon(
                            Icons.browse_gallery,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return EditProfileScreen();
                            },
                          ),
                        );
                      },
                      child: SizedBox(
                        width: 38,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF4F3422),
                            ),
                            child: Icon(
                              Icons.person_2_outlined,
                              color: Colors.white24,
                              size: 15,
                            ),
                          ),
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

  AppBar appBarMobile() {
    return AppBar(
      toolbarHeight: 110,
      automaticallyImplyLeading: false,

      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.date_range_outlined, size: 11, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  "Senin 3 Nov 2025",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Serif',
                  ),
                ),
              ],
            ),
            SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 18,
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
                            return Icon(Icons.person, size: 10);
                          }

                          Uint8List bytes = snapshot.data!;

                          return CircleAvatar(
                            radius: 18,
                            backgroundImage: MemoryImage(bytes),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<String>(
                          future: getUsername(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                "Loading...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Serif',
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Text(
                                "Error loading username",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontFamily: 'Serif',
                                ),
                              );
                            }

                            return Text(
                              "Hi, ${snapshot.data} 👋​",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Serif',
                              ),
                            );
                          },
                        ),
                        Text(
                          "Welcome back",
                          style: TextStyle(
                            color: Colors.white24,
                            fontSize: 12,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Serif',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                GestureDetector(
                  onTap: () async {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    child: Icon(Icons.logout_outlined),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBarDekstop() {
    return AppBar(
      toolbarHeight: 75,
      automaticallyImplyLeading: false,

      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 18, backgroundColor: Colors.white),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, Kelompok 2👋​",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Serif',
                      ),
                    ),
                    Text(
                      "Welcome back",
                      style: TextStyle(
                        color: Colors.white24,
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Serif',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 30,
              children: [
                Row(
                  spacing: 3,
                  children: [
                    Text(
                      "Home",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Serif',
                      ),
                    ),
                    Icon(Icons.home, size: 13, color: Colors.white54),
                  ],
                ),
                Row(
                  spacing: 3,
                  children: [
                    Text(
                      "Classification",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Serif',
                      ),
                    ),
                    Icon(
                      Icons.search_outlined,
                      size: 13,
                      color: Colors.white54,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                  decoration: ShapeDecoration(
                    shape: StadiumBorder(),
                    color: Color(0xFF7D5133),
                  ),
                  child: Row(
                    spacing: 3,
                    children: [
                      Text(
                        "History",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Serif',
                        ),
                      ),
                      Icon(Icons.browse_gallery, size: 13, color: Colors.white),
                    ],
                  ),
                ),
                Row(
                  spacing: 3,
                  children: [
                    Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Serif',
                      ),
                    ),
                    Icon(
                      Icons.person_2_outlined,
                      size: 13,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.date_range_outlined, size: 11, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  "Senin 3 Nov 2025",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 7,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Serif',
                  ),
                ),
                SizedBox(width: 11),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: Icon(Icons.notifications_none_outlined),
                ),
              ],
            ),
          ],
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
      fontSize: 20,
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
