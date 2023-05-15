import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meat4u_vendor/component/custom_button.dart';
import 'package:meat4u_vendor/utils/constant.dart';
import 'package:meat4u_vendor/screens/profile/edit_profile_scrn.dart';
import 'package:meat4u_vendor/screens/auth/otp.dart';

import '../bottom_bar/custom_bottom_nav.dart';
import '../../controller/auth_controller.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  static String routeName = '/SignupScrn';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Map userData = {};

  // ignore: prefer_typing_uninitialized_variables
  var userId;
  bool loder = false;

  _fetchUserData() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        //
        .get()
        .then((value) {
      for (var doc in value.docs) {
        userData = doc.data();
        // log(userData.toString());
        setState(() {});
      }
    });
  }

  final auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  //google sign in

  Future<void> signupGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;

      if (result != null) {
        String randomUUDI = user!.uid;
        FirebaseFirestore.instance
            .collection("vendors")
            .where("email", isEqualTo: user.email)
            .get()
            .then((value) {
          if (value.docs.isEmpty) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const SignUpScreen(),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const EditProfileScrn(),
              ),
            );
          }
        });
      } // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }

  @override
  initState() {
    _fetchUserData();
    super.initState();
  }

  var phoneController = TextEditingController();
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/login.png",
                width: 285,
                height: 285,
              ),
              Container(
                padding: const EdgeInsets.only(right: 50, left: 50),
                child: Text(
                  "Welcome, manage your order",
                  style: hedline2(context: context),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const LoginDriver(
                text: "Signup",
              ),
              const SizedBox(
                height: 21,
              ),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 30),
                    hintText: 'Enter your business name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
              const SizedBox(
                height: 21,
              ),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 30),
                    hintText: 'Enter your mobile no',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
              const SizedBox(
                height: 22,
              ),
              !loder
                  ? CustomButton(
                      ontap: () {
                        if (userData['ownerPhone'] == phoneController.text) {
                          log(userData['ownerPhone']);
                          showMySnackBar(context, "You are already registered");
                        } else if (nameController.text.isNotEmpty &&
                            phoneController.text.isNotEmpty) {
                          if (nameController.text.isEmpty &&
                              phoneController.text.isEmpty) {
                            showMySnackBar(context, "Can not be empty!");
                          } else {
                            setState(() {
                              loder = true;
                            });
                            sendOTPForSignUp(
                                context, phoneController, nameController.text);
                          }
                        }
                      },
                      text: "Continue")
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              ListTile(
                title: Wrap(children: [
                  Text(
                    'Already a member? ',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, LoginScrn.routeName);
                      },
                      child: Text('Login here',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.black,
                              decoration: TextDecoration.underline))),
                ]),
              ),
              const SizedBox(
                height: 21,
              ),
              const LoginDriver(text: "OR"),
              const SizedBox(
                height: 22,
              ),
              const SizedBox(
                height: 22,
              ),
              SizedBox(
                width: scWidth(context) / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            right: 15,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            signupGoogle(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25,
                            child: SvgPicture.asset(
                              "assets/icons/google.svg",
                              height: 24,
                              width: 24,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 36,
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: SvgPicture.asset(
                            "assets/icons/facebook.svg",
                            height: 24,
                            width: 24,
                          ),
                        ),
                        const SizedBox(
                          width: 36,
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: SvgPicture.asset(
                            "assets/icons/apple.svg",
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Text(
                      "By continuing you about to agree to the terms and conditions,privacy policay",
                      style: bodyText2(color: Colors.grey, context: context),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
