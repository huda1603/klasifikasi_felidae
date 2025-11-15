import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';
import 'package:klasifikasi_felidae/screens/edit_profile_screen.dart';
import 'package:klasifikasi_felidae/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:html' as html;
import 'dart:typed_data';

class SelectFotoProfileScreen extends StatefulWidget {
  const SelectFotoProfileScreen({super.key});

  @override
  State<SelectFotoProfileScreen> createState() =>
      _SelectFotoProfileScreenState();
}

class _SelectFotoProfileScreenState extends State<SelectFotoProfileScreen> {
  ThemeData dark = darks;
  var light = ThemeData.light();
  bool isLoadingImage = false;
  Uint8List? _imageData;
  String? selectedAvatarPath;

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

  CollectionReference dataDiri = FirebaseFirestore.instance.collection("users");
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot> getCurrentUser() async {
    if (currentUser == null) {
      throw Exception("Pengguna tidak login");
    }

    final String userUid = currentUser!.uid;

    return dataDiri.doc(userUid).get();
  }

  Future<void> saveSelectedAvatar() async {
    if (selectedAvatarPath == null) return;

    ByteData bytes = await rootBundle.load(selectedAvatarPath!);
    Uint8List avatarData = bytes.buffer.asUint8List();
    String base64Image = base64Encode(avatarData);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection("users").doc(user.uid).update({
      "img": base64Image,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil update foto profil!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<String?> saveImageToFirestore() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return 'Pengguna tidak login.';
    }
    setState(() => isLoadingImage = true);
    final String userUid = currentUser.uid;
    String base64Image = base64Encode(_imageData!);
    await dataDiri.doc(userUid).update({'img': base64Image});
    print('Berhasil Update Foto Profile');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Update Foto Profile berhasil!"),
        backgroundColor: Colors.green,
      ),
    );
    setState(() => isLoadingImage = false);
  }

  @override
  void initState() {
    super.initState();
    _imageData = null;
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
                    children: [
                      SizedBox(height: 80, width: double.infinity),
                      Positioned(
                        top: 8,
                        left: 10,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 10,
                          children: [
                            GestureDetector(
                              onTap: (() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(),
                                  ),
                                ).then((_) {
                                  setState(() {});
                                });
                              }),
                              child: Container(
                                width: 35,
                                height: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: dark.primaryColorDark,
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
                  Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        viewportFraction: 0.32,
                      ),
                      items:
                          [
                            "assets/cheetah.png",
                            "assets/leopard.png",
                            "assets/lion.png",
                          ].map((path) {
                            final isSelected = selectedAvatarPath == path;

                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTapUp: (_) {
                                setState(() {
                                  selectedAvatarPath = path;
                                  _imageData = null;
                                });
                              },
                              child: CircleAvatar(
                                radius: isSelected ? 90 : 80,
                                backgroundColor:
                                    isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(path),
                                  radius: 80,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_up_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  SizedBox(height: 80),
                  Text("Select your avatar", style: dark.textTheme.bodyMedium),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: (() {
                      pickImageFromWeb((data) {
                        setState(() {
                          _imageData = data;
                          selectedAvatarPath = null;
                        });
                      });
                    }),
                    child:
                        _imageData == null
                            ? DottedBorder(
                              padding: EdgeInsets.all(17),
                              color: Colors.white60,
                              borderType: BorderType.Circle,
                              child: Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.white60,
                              ),
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.memory(
                                _imageData!,
                                width: 70,
                                height: 70,
                              ),
                            ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Or upload your profile",
                    style: dark.textTheme.bodySmall,
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      if (_imageData != null) {
                        await saveImageToFirestore(); // upload dari file
                      } else if (selectedAvatarPath != null) {
                        await saveSelectedAvatar(); // pilih avatar
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Pilih avatar atau upload foto"),
                          ),
                        );
                      }
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 35, right: 35, bottom: 7),
                      child:
                          isLoadingImage == false
                              ? Container(
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
                                      "Save",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.normal,
                                        fontFamily: 'Serif',
                                      ),
                                    ),
                                    Icon(
                                      Icons.check_outlined,
                                      size: 11,
                                      color: Colors.white,
                                    ),
                                  ],
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
                  ),
                  SizedBox(height: 8),
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
                                SizedBox(height: 80, width: double.infinity),
                                Icon(
                                  Icons.arrow_drop_down_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 120,
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      enlargeCenterPage: true,
                                      viewportFraction: 0.32,
                                    ),
                                    items:
                                        [
                                          "assets/cheetah.png",
                                          "assets/leopard.png",
                                          "assets/lion.png",
                                        ].map((path) {
                                          final isSelected =
                                              selectedAvatarPath == path;

                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedAvatarPath = path;
                                                _imageData = null;
                                              });
                                            },
                                            child: CircleAvatar(
                                              radius: isSelected ? 90 : 80,
                                              backgroundColor:
                                                  isSelected
                                                      ? Colors.white
                                                      : Colors.transparent,
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                  path,
                                                ),
                                                radius: 80,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_up_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                SizedBox(height: 80),
                                Text(
                                  "Select your avatar",
                                  style: dark.textTheme.bodyMedium,
                                ),
                                SizedBox(height: 8),
                                GestureDetector(
                                  onTap: (() {
                                    pickImageFromWeb((data) {
                                      setState(() {
                                        _imageData = data;
                                        selectedAvatarPath = null;
                                      });
                                    });
                                  }),
                                  child:
                                      _imageData == null
                                          ? DottedBorder(
                                            padding: EdgeInsets.all(17),
                                            color: Colors.white60,
                                            borderType: BorderType.Circle,
                                            child: Icon(
                                              Icons.add,
                                              size: 20,
                                              color: Colors.white60,
                                            ),
                                          )
                                          : ClipOval(
                                            child: Image.memory(
                                              _imageData!,
                                              width: 50,
                                              height: 50,
                                            ),
                                          ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Or upload your profile",
                                  style: dark.textTheme.bodySmall,
                                ),
                                Spacer(),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 35,
                                    right: 35,
                                    bottom: 7,
                                  ),
                                  child:
                                      isLoadingImage == false
                                          ? GestureDetector(
                                            onTap: () async {
                                              if (_imageData != null) {
                                                await saveImageToFirestore(); // upload dari file
                                              } else if (selectedAvatarPath !=
                                                  null) {
                                                await saveSelectedAvatar(); // pilih avatar
                                              } else {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Pilih avatar atau upload foto",
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
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
                                                mainAxisSize: MainAxisSize.min,
                                                spacing: 3,
                                                children: [
                                                  Text(
                                                    "Save",
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
                                                    Icons.check_outlined,
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
                                ),
                                SizedBox(height: 8),
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
                            color: dark.primaryColorDark,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: Colors.white,
                              size: 15,
                            ),
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
      fontSize: 17,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontFamily: 'Serif',
    ),
    bodySmall: TextStyle(
      color: Color(0xFF1E44E0),
      fontSize: 10,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.normal,
      fontFamily: 'Serif',
    ),
  ),
);
