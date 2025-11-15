//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glass_morphism/flutter_glass_morphism.dart';
import 'package:klasifikasi_felidae/models/species.dart';
import 'package:klasifikasi_felidae/screens/input_screen.dart';
import 'package:klasifikasi_felidae/screens/history_screen.dart';
import 'package:klasifikasi_felidae/screens/edit_profile_screen.dart';
import 'package:klasifikasi_felidae/screens/login_screen.dart';
import 'package:klasifikasi_felidae/widgets/species_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ThemeData dark = darks;
  var light = ThemeData.light();

  Species selectedSpecies = species[0];

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: dark.primaryColorDark,
      appBar: width <= 600 && width < height ? appBarMobile() : appBarDekstop(),
      body: width <= 600 && width < height ? bodyMobile() : bodyDekstop(),
    );
  }

  Stack bodyMobile() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 30, right: 30, top: 25, bottom: 100),
          child: SingleChildScrollView(
            primary: true,
            child: Column(
              spacing: 22,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Classify now using\nadvanced applications",
                  style: dark.textTheme.headlineLarge,
                ),
                SpeciesCard(
                  dark: dark,
                  onSelected: (index) {
                    setState(() {
                      selectedSpecies = species[index];
                    });
                  },
                ),
                SizedBox(height: 10),
                AspectRatio(
                  aspectRatio: 3 / 2,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image(
                          image: selectedSpecies.imgWild,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: GlassMorphismContainer(
                          enableGlassBorder: true,
                          opacity: 0,
                          blurIntensity: 3,
                          border: Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.circular(50),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          child: Column(
                            spacing: 5,
                            children: [
                              Center(
                                child: Text(
                                  selectedSpecies.name,
                                  style: dark.textTheme.bodyMedium,
                                ),
                              ),
                              Text(
                                selectedSpecies.desc,
                                style: dark.textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
                        Icons.home_outlined,
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HistoryScreen();
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
                          Icons.browse_gallery,
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
    );
  }

  Padding bodyDekstop() {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, top: 25, bottom: 25),
      child: SingleChildScrollView(
        primary: true,
        child: Column(
          spacing: 22,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Classify now using advanced applications",
              style: dark.textTheme.headlineLarge,
            ),
            SpeciesCard(
              dark: dark,
              onSelected: (index) {
                setState(() {
                  selectedSpecies = species[index];
                });
              },
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: AspectRatio(
                  aspectRatio: 3 / 1.7,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image(
                          image: selectedSpecies.imgWild,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: GlassMorphismContainer(
                          enableGlassBorder: true,
                          opacity: 0,
                          blurIntensity: 3,
                          border: Border.all(color: Colors.black, width: 5),
                          borderRadius: BorderRadius.circular(50),
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          child: Column(
                            spacing: 5,
                            children: [
                              Center(
                                child: Text(
                                  selectedSpecies.name,
                                  style: dark.textTheme.bodyMedium,
                                ),
                              ),
                              Text(
                                selectedSpecies.desc,
                                style: dark.textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
                        "Home",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Serif',
                        ),
                      ),
                      Icon(Icons.home, size: 13, color: Colors.white),
                    ],
                  ),
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
                Row(
                  spacing: 3,
                  children: [
                    Text(
                      "History",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontStyle: FontStyle.normal,
                        fontFamily: 'Serif',
                      ),
                    ),
                    Icon(Icons.browse_gallery, size: 13, color: Colors.white54),
                  ],
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
