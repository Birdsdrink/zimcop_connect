import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zimcop_connect/main.dart';
import 'package:zimcop_connect/services/shared_pref.dart';
import 'package:zimcop_connect/views/pages/home_page.dart';
import '../models/police_officer.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //SIGNING IN/LOG IN
  Future<User?> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      navigatorKey.currentState!.pushReplacement(
          (MaterialPageRoute(builder: (context) => const HomePage())));

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //SIGNING UP -- REGISTER USER
  Future<User?> signUpWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //CHECKING IF USER IS LOGGED IN
  bool isLoggedIn() {
    User? user = _auth.currentUser;
    if (user == null) {
      return false;
    }
    return true;
  }

  //SIGNING OUT
  Future<void> signOut() async {
    await _auth.signOut();
    SharedPrefHelper().saveIsloggedIn(false);
  }

  //GETTING CURRENT USER ID
  String getCurrentUID() {
    return _auth.currentUser!.uid;
  }

  //GETTING USER BY UID
  Future<QuerySnapshot> getUserByUid(userUID) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where('uid', isEqualTo: userUID)
        .get();
  }

  //GETTING USER BY EMAIL
  Future<QuerySnapshot> getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .where('email', isEqualTo: email)
        .get();
  }

  //GETTING USER BY BY USER ID STREAM
  Stream<QuerySnapshot> getUserByUserID(String userID) {
    return FirebaseFirestore.instance
        .collection("Users")
        .where('uid', isEqualTo: userID)
        .snapshots();
  }

  //CREATING USER DETAILS
  Future<void> createUserDetails(
      String surname,
      String forceNo,
      String rank,
      String profilePicUrl,
      String situation,
      bool isOnline,
      DateTime lastSeen) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;

    PoliceOfficer newPoliceOfficer = PoliceOfficer(
      surname: surname,
      forceNo: forceNo,
      rank: rank,
      uid: currentUserID,
      email: currentUserEmail,
      profilePicUrl: profilePicUrl,
      situation: situation,
      isOnline: isOnline,
      lastSeen: lastSeen,
      fcmToken: "",
    );

    await _firestore
        .collection("Users")
        .doc(currentUserID)
        .set(newPoliceOfficer.toMap());
  }

  Future<void> updateUserDetails(Map<String, dynamic> updatedInfo) async {
    final String currentUserID = _auth.currentUser!.uid;
    await _firestore.collection("Users").doc(currentUserID).update(updatedInfo);
  }

  //Updating Firebase Cloud Messaging Token
  Future<void> updateFcmToken(fcmToken) async {
    return await _firestore
        .collection("Users")
        .doc(getCurrentUID())
        .update({'fcmToken': fcmToken});
  }
}
