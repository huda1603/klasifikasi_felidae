import 'dart:convert' show base64Encode;
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show rootBundle;

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> regis(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final byteData = await rootBundle.load('assets/logo.png');
      final bytes = byteData.buffer.asUint8List();
      final base64String = base64Encode(bytes);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
            'username': 'User ${Random().nextInt(1000)}',
            'img': base64String,
            'uid': cred.user!.uid,
            'createdAt': FieldValue.serverTimestamp(),
          });
      return true;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      //print('Error during login: $e');
      return false;
    }
  }
}
