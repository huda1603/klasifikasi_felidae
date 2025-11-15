import 'dart:ui' show ImageByteFormat, instantiateImageCodec;
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:klasifikasi_felidae/screens/home_screen.dart';
import 'package:klasifikasi_felidae/screens/history_screen.dart';
import 'package:klasifikasi_felidae/screens/edit_profile_screen.dart';

import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:convert';

import 'package:klasifikasi_felidae/screens/login_screen.dart';
import 'package:tflite_web/tflite_web.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  bool isClassification = false;
  ThemeData dark = darks;
  var light = ThemeData.light();

  String? resultClass;
  String? resultDesc;

  bool isLoadingClassification = false;

  Uint8List? _imageData;

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

  void pickImageFromWeb(Function(Uint8List) onImagePicked) {
    final input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();

    input.onChange.listen((event) {
      final file = input.files?.first;
      final reader = html.FileReader();

      reader.readAsArrayBuffer(file!);
      reader.onLoadEnd.listen((event) {
        final data = reader.result as Uint8List;
        onImagePicked(data);
      });
    });
  }

  Future<void> addDataClassification() async {
    try {
      await FirebaseFirestore.instance.collection('species_collection').add({
        'img_class': base64Encode(_imageData!),
        'species': resultClass ?? 'Puma',
        'createdAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Berhasil menambah data!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print(e);
    }
  }

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
          if (!isClassification) uploadImg(width, height),
          if (!isClassification) classificationButton(width, height),
          if (isClassification) result(width, height),
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
                            Icons.search_outlined,
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
                        "Classification",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Serif',
                        ),
                      ),
                      Icon(
                        Icons.search_outlined,
                        size: 13,
                        color: Colors.white,
                      ),
                    ],
                  ),
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

  Positioned classificationButton(double width, double height) => Positioned(
    bottom: width <= 600 && width < height ? 100 : 160,
    left: width <= 600 && width < height ? 35 : width * 0.3,
    right: width <= 600 && width < height ? 35 : width * 0.3,
    child:
        _imageData != null
            ? Row(
              children: [
                Expanded(
                  flex: 3,
                  child:
                      isLoadingClassification == false
                          ? GestureDetector(
                            onTap: () async {
                              setState(() {
                                isLoadingClassification = true;
                              });
                              await addDataClassification();
                              setState(() {
                                isLoadingClassification = false;
                              });
                              setState(() {
                                isClassification = !isClassification;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 12,
                              ),
                              decoration: ShapeDecoration(
                                shape: StadiumBorder(),
                                color: Color(0xFF926247),
                              ),
                              child: Text(
                                "Start Classification",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Serif',
                                ),
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
                ),
                SizedBox(width: 7),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _imageData = null;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 12,
                      ),
                      decoration: ShapeDecoration(
                        shape: StadiumBorder(),
                        color: Color(0xFF926247),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'Serif',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
            : SizedBox(),
  );

  Positioned uploadImg(double width, double height) {
    return Positioned(
      top: 70,
      left: width <= 600 && width < height ? 20 : width * 0.3,
      right: width <= 600 && width < height ? 20 : width * 0.3,
      child:
          _imageData == null
              ? GestureDetector(
                onTap: () {
                  pickImageFromWeb((data) {
                    setState(() {
                      _imageData = data;
                    });
                  });
                },
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(35),
                  color: Colors.white54,
                  padding: EdgeInsets.symmetric(vertical: 35),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage("upload.png"),
                          width: 40,
                          height: 40,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Tap to upload foto",
                          style: TextStyle(
                            color: Color(0xFF1D4BFF),
                            fontSize: 12,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Serif',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "PNG, JPG, JPEG",
                          style: TextStyle(
                            color: Colors.white24,
                            fontSize: 12,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Serif',
                          ),
                        ),
                        SizedBox(height: 10),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Divider(color: Colors.white54),
                            SizedBox(height: 5),
                            Container(
                              color: dark.primaryColorDark,
                              alignment: Alignment.center,
                              width: 30,
                              child: Text(
                                "OR",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Serif',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 7),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF1D4BFF),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "Open Camera",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontStyle: FontStyle.normal,
                              fontFamily: 'Serif',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              : ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Image.memory(_imageData!, fit: BoxFit.cover),
              ),
    );
  }

  Padding result(double width, double height) {
    return Padding(
      padding: EdgeInsets.only(left: 35, right: 35, top: 30, bottom: 110),
      child: SingleChildScrollView(
        primary: true,
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: AspectRatio(
                aspectRatio: 3 / 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.memory(_imageData!),
                ),
              ),
            ),
            Center(
              child: Text(
                "Image Detected ~",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Serif',
                  color: Colors.white,
                ),
              ),
            ),
            ClipPath(
              clipper: ResultClipper(),
              child: Container(
                padding: EdgeInsets.only(
                  left: 6,
                  right: 6,
                  top: 10,
                  bottom: 25,
                ),
                width:
                    width <= 600 && width < height ? width - 60 : width * 0.65,
                height:
                    width <= 600 && width < height ? (width - 60) * 0.75 : 180,
                decoration: BoxDecoration(
                  color: Color(0xFF9BB168),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  spacing: 7,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image(
                      width: 38,
                      height: 38,
                      image: AssetImage("assets/logo.png"),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 7),
                        Text(
                          resultClass ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Serif',
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          resultDesc ??
                              "Juga dikenal sebagai Cougar atau Mountain Lion.\nPuma adalah kucing besar yang sangat adaptif dan\nmemiliki rentang habitat terluas di antara\nsemua mamalia darat liar di belahan Barat.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontStyle: FontStyle.normal,
                            fontFamily: 'Serif',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: width <= 600 && width < height ? 15 : 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  isClassification = !isClassification;
                });
              },
              child: Container(
                width:
                    width <= 600 && width < height
                        ? double.infinity
                        : width * 0.25,
                alignment: Alignment.center,
                height: 40,
                decoration: ShapeDecoration(
                  shape: StadiumBorder(),
                  color: Color(0xFF926247),
                ),
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'Serif',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final width = size.width;
    final height = size.height;
    final radius = 30;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, height);
    path.quadraticBezierTo(14, height - 5, 16, height - 18);
    path.lineTo(width - radius, height - 18);
    path.quadraticBezierTo(width, height - 18, width, height - 18 - radius);

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
