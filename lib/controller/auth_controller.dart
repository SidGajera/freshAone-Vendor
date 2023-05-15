// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meat4u_vendor/screens/profile/edit_profile_scrn.dart';
import 'package:meat4u_vendor/screens/auth/login.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../screens/bottom_bar/custom_bottom_nav.dart';
import '../screens/auth/otp.dart';
import '../screens/auth/waiting_screen.dart';

class InitializerFirebaseUser extends StatefulWidget {
  const InitializerFirebaseUser({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InitializerFirebaseUserState createState() =>
      _InitializerFirebaseUserState();
}

class _InitializerFirebaseUserState extends State<InitializerFirebaseUser> {
  late FirebaseAuth _auth;
  User? _user;
  bool isLoading = true;

  bool isVerified = false;
  final firebaseUser = FirebaseAuth.instance.currentUser;

  fetch() {
    try {
      FirebaseFirestore.instance
          .collection("vendors")
          .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
          .get()
          .then((value) {
        // log(value["isVerified"].toString());
        log(value.data().toString());
        setState(() {
          isVerified = value["isVerified"];
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    // if (firebaseUser != null) {
    fetch();
    // }
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (firebaseUser != null) {
      return isVerified
          ? const CustomBottomNavigation()
          : const WaitingScreen();
    }
    return const LoginScrn();
    /*return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : _user == null
            ? const LoginScrn()
            : const CustomBottomNavigation();*/
  }
}

//<------------------------------- Firebase Send Otp Method --------------------------->//
void sendOTPForSignIN(
    BuildContext context, TextEditingController controller) async {
  String phone = "+91${controller.text.trim()}";
  // var useId = FirebaseAuth.instance.currentUser!.uid.substring(0, 20);

  var appSignatureID = await SmsAutoFill().getAppSignature;
  Map sendOtpData = {
    "mobile_number": phone,
    "app_signature_id": appSignatureID
  };

  await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      codeSent: (verificationId, resendToken) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => OtpScrn(
                      phone: controller.text.trim(),
                      verificationId: verificationId,
                    )));
      },
      verificationCompleted: (credential) {},
      verificationFailed: (ex) {
        log(ex.code.toString());
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: const Duration(seconds: 30));
}

//<------------------------------- Firebase Send Otp Method --------------------------->//
void sendOTPForSignUp(
    BuildContext context, TextEditingController controller, String name) async {
  String phone = "+91${controller.text.trim()}";
  // var useId = FirebaseAuth.instance.currentUser!.uid.substring(0, 20);
  var appSignatureID = await SmsAutoFill().getAppSignature;
  Map sendOtpData = {
    "mobile_number": phone,
    "app_signature_id": appSignatureID
  };
  await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      codeSent: (verificationId, resendToken) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => OtpSignUp(
                      phone: controller.text.trim(),
                      name: name,
                      verificationId: verificationId,
                    )));
      },
      verificationCompleted: (credential) {},
      verificationFailed: (ex) {
        log(ex.code.toString());
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: const Duration(seconds: 30));
}

//<----------------------- Firebase Verify Otp Method --------------------------->//
void verifyOTPForSignIN(BuildContext context, String controller, String mobile,
    String verificationId) async {
  String otp = controller.trim();

  PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId, smsCode: otp);

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (userCredential.user != null) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const CustomBottomNavigation()));
    }
  } on FirebaseAuthException catch (ex) {
    log(ex.code.toString());
  }
}

void verifyOTPForSignUp(BuildContext context, String controller, String mobile,
    String verificationId, String name) async {
  String otp = controller.trim();

  PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId, smsCode: otp);

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.user != null) {
      var userId = FirebaseAuth.instance.currentUser!.uid.substring(0, 20);
      FirebaseFirestore.instance
          .collection("vendors")
          .doc(userId)
          .set({"name": name, "mobile": "+91$mobile", "uid": userId});
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const EditProfileScrn()));
    }
  } on FirebaseAuthException catch (ex) {
    log(ex.code.toString());
  }
}

//<--------------------- Firebase Logout Method ------------------------>//
Future<void> logOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const LoginScrn(),
    ),
  );
}
