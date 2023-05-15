import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meat4u_vendor/component/custom_button.dart';
import 'package:meat4u_vendor/utils/constant.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meat4u_vendor/screens/profile/edit_profile_scrn.dart';
import 'package:meat4u_vendor/screens/auth/otp.dart';
import 'package:meat4u_vendor/screens/auth/signup_screen.dart';
import 'package:meat4u_vendor/screens/auth/waiting_screen.dart';

import '../bottom_bar/custom_bottom_nav.dart';
import '../../controller/auth_controller.dart';

class LoginScrn extends StatefulWidget {
  static String routeName = '/LoginScrn';
  const LoginScrn({Key? key}) : super(key: key);

  @override
  State<LoginScrn> createState() => _LoginScrnState();
}

class _LoginScrnState extends State<LoginScrn> {
  var phoneController = TextEditingController();
  Map? userData;

  bool loader = false;

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
                builder: (context) => const WaitingScreen(),
              ),
            );
          }
        });
      } // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }

  Map vendorData = {};

  // ignore: prefer_typing_uninitialized_variables
  var userId;

  Future<void> _fetchUserData(mobile) async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .where("ownerPhone", isEqualTo: mobile)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        vendorData = doc.data();
        log(vendorData.toString());
        setState(() {});
      }
    });
  }

  @override
  initState() {
    // _fetchUserData();
    super.initState();
  }

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
                text: "Login",
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
              !loader
                  ? CustomButton(
                      ontap: () {
                        _fetchUserData(phoneController.text).then((value) {
                          if (vendorData['ownerPhone'] ==
                              phoneController.text) {
                            setState(() {
                              loader = true;
                            });
                            sendOTPForSignIN(context, phoneController);
                          } else {
                            showMySnackBar(context,
                                "You are not registered, Sign up first");
                          }
                        });

                        // if (vendorData['ownerPhone'] != phoneController.text) {
                        //   /* log(vendorData['mobile']); */
                        //   showMySnackBar(
                        //       context, "You are not registered, Sign up first");
                        // } else if (phoneController.text.isNotEmpty) {
                        //   if (phoneController.text.isEmpty) {
                        //     showMySnackBar(context, "Can not be empty!");
                        //   } else {
                        //     sendOTPForSignIN(context, phoneController);
                        //   }
                        // }
                      },
                      text: "Continue")
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              ListTile(
                title: Wrap(children: [
                  Text('Not a member? ',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.black)),
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, SignUpScreen.routeName);
                      },
                      child: Text(
                        'Signup here',
                        style: GoogleFonts.poppins(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.black),
                      )),
                ]),
              ),
              const LoginDriver(text: "OR"),
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
                      height: 15,
                    ),

                    /* const SizedBox(
                      height: 22,
                    ), */
                    Text(
                      "By continuing you about to agree to the terms and conditions,privacy policay",
                      style: bodyText2(color: Colors.grey, context: context),
                      textAlign: TextAlign.center,
                    )
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
