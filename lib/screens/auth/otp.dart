import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meat4u_vendor/screens/bottom_bar/custom_bottom_nav.dart';
import 'package:meat4u_vendor/component/custom_button.dart';
import 'package:meat4u_vendor/utils/constant.dart';
import 'package:meat4u_vendor/screens/auth/login.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../controller/auth_controller.dart';

class OtpScrn extends StatefulWidget {
  static String routeName = '/OtpScrn';
  const OtpScrn({Key? key, required this.phone, required this.verificationId})
      : super(key: key);
  final String phone;
  final String verificationId;
  @override
  State<OtpScrn> createState() => _OtpScrnState();
}

bool isTapped = false;
bool loader = false;

class _OtpScrnState extends State<OtpScrn> {
  bool isResendTapped = false;
  int start = 30;
  final TextEditingController mobileController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final TextEditingController _pinPutController = TextEditingController();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    border: Border.all(color: isTapped ? primary : Colors.blue),
    color: isTapped ? Colors.white : Colors.white,
    boxShadow: const [
      BoxShadow(
        color: Colors.white,
        spreadRadius: 2,
      )
    ],
  );
  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          start = 30;
          isResendTapped = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  String codeValue = "";

  @override
  void codeUpdated() {
    // print("Update code $code");
    setState(() {
      print("codeUpdated");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenOtp();
  }

  void listenOtp() async {
    // await SmsAutoFill().unregisterListener();
    // listenForCode();
    await SmsAutoFill().listenForCode;
    print("OTP listen Called");
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    print("unregisterListener");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/otp.png",
                width: 285,
                height: 285,
              ),
              Container(
                padding: const EdgeInsets.only(right: 50, left: 50),
                child: Text(
                  "Verification Code",
                  style: hedline2(context: context),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const LoginDriver(
                text: "Verify Phone",
              ),
              const SizedBox(
                height: 42,
              ),
              Container(
                padding: const EdgeInsets.only(right: 50, left: 50),
                child: Text(
                  "We have sent to your registerd to your mobile number ",
                  style: headline2Normal(color: Colors.grey, context: context),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 70, left: 70),
                  ),
                  Text(
                    widget.phone,
                    style: bodyText1Bold(color: Colors.grey, context: context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: (() {
                      Navigator.pushNamed(context, LoginScrn.routeName);
                    }),
                    child: Container(
                      height: 20,
                      width: 18,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary,
                      ),
                      child: const Image(
                          image: AssetImage("assets/images/pencil.png")),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 57),
              //   child: PinPut(
              //     animationDuration: const Duration(seconds: 1),
              //     eachFieldHeight: 40,
              //     eachFieldWidth: 40,
              //     fieldsCount: 6,
              //     autofocus: true,
              //     submittedFieldDecoration: pinPutDecoration,
              //     selectedFieldDecoration: pinPutDecoration,
              //     followingFieldDecoration: pinPutDecoration,
              //     textStyle: const TextStyle(
              //         fontSize: 24,
              //         fontWeight: FontWeight.w400,
              //         color: primary),
              //     focusNode: _pinPutFocusNode,
              //     controller: _pinPutController,
              //     pinAnimationType: PinAnimationType.fade,
              //     onTap: () {
              //       setState(() {
              //         isTapped = true;
              //       });
              //     },
              //   ),
              // ),
              PinFieldAutoFill(
                currentCode: codeValue,
                codeLength: 6,
                onCodeChanged: (code) {
                  print("onCodeChanged $code");
                  setState(() {
                    codeValue = code.toString();
                  });
                },
                onCodeSubmitted: (val) {
                  print("onCodeSubmitted $val");
                },
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                    text: isResendTapped
                        ? 'Resend OTP in:  '
                        : 'Didn\'t receive an OTP?  ',
                    style: bodyText3(context: context),
                    children: [
                      TextSpan(
                        text: isResendTapped ? '00:${start}' : 'Resend OTP',
                        style: bodyText3(
                          color: primary,
                          context: context,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => setState(() {
                                startTimer();
                                isResendTapped = true;
                              }),
                      )
                    ]),
              ),
              const SizedBox(
                height: 40,
              ),
              CustomButton(
                  ontap: () {
                    if (widget.verificationId.isEmpty && widget.phone.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Wrong OTP")));
                    } else {
                      verifyOTPForSignIN(
                        context,
                        codeValue,
                        widget.phone,
                        widget.verificationId,
                      );
                    }
                  },
                  text: "Verify"),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OtpSignUp extends StatefulWidget {
  static String routeName = '/OtpScrn';
  const OtpSignUp(
      {Key? key,
      required this.phone,
      required this.verificationId,
      required this.name})
      : super(key: key);

  final String phone;
  final String verificationId;
  final String name;

  @override
  State<OtpSignUp> createState() => _OtpSignUpState();
}

bool isTapped1 = false;

class _OtpSignUpState extends State<OtpSignUp> {
  bool isResendTapped = false;
  int start = 30;
  final TextEditingController mobileController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final TextEditingController _pinPutController = TextEditingController();

  final BoxDecoration pinPutDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(30),
    border: Border.all(color: isTapped ? primary : Colors.blue),
    color: isTapped ? Colors.white : Colors.white,
    boxShadow: const [
      BoxShadow(
        color: Colors.white,
        spreadRadius: 2,
      )
    ],
  );
  void startTimer() {
    const onsec = Duration(seconds: 1);
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          start = 30;
          isResendTapped = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  String codeValue = "";

  @override
  void codeUpdated() {
    // print("Update code $code");
    setState(() {
      print("codeUpdated");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenOtp();
  }

  void listenOtp() async {
    // await SmsAutoFill().unregisterListener();
    // listenForCode();
    await SmsAutoFill().listenForCode;
    print("OTP listen Called");
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    print("unregisterListener");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/otp.png",
                width: 285,
                height: 285,
              ),
              Container(
                padding: const EdgeInsets.only(right: 50, left: 50),
                child: Text(
                  "Verification Code",
                  style: hedline2(context: context),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              const LoginDriver(
                text: "Verify Phone",
              ),
              const SizedBox(
                height: 42,
              ),
              Container(
                padding: const EdgeInsets.only(right: 50, left: 50),
                child: Text(
                  "We have sent to your registerd to your mobile number ",
                  style: headline2Normal(color: Colors.grey, context: context),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 70, left: 70),
                  ),
                  Text(
                    widget.phone,
                    style: bodyText1Bold(color: Colors.grey, context: context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    onTap: (() {
                      Navigator.pushNamed(context, LoginScrn.routeName);
                    }),
                    child: Container(
                      height: 20,
                      width: 18,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary,
                      ),
                      child: const Image(
                          image: AssetImage("assets/images/pencil.png")),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 57),
              //   child: PinPut(
              //     animationDuration: const Duration(seconds: 1),
              //     eachFieldHeight: 40,
              //     eachFieldWidth: 40,
              //     fieldsCount: 6,
              //     autofocus: true,
              //     submittedFieldDecoration: pinPutDecoration,
              //     selectedFieldDecoration: pinPutDecoration,
              //     followingFieldDecoration: pinPutDecoration,
              //     textStyle: const TextStyle(
              //         fontSize: 24,
              //         fontWeight: FontWeight.w400,
              //         color: primary),
              //     focusNode: _pinPutFocusNode,
              //     controller: _pinPutController,
              //     pinAnimationType: PinAnimationType.fade,
              //     onTap: () {
              //       setState(() {
              //         isTapped = true;
              //       });
              //     },
              //   ),
              // ),
              PinFieldAutoFill(
                currentCode: codeValue,
                codeLength: 6,
                onCodeChanged: (code) {
                  print("onCodeChanged $code");
                  setState(() {
                    codeValue = code.toString();
                  });
                },
                onCodeSubmitted: (val) {
                  print("onCodeSubmitted $val");
                },
              ),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                    text: isResendTapped
                        ? 'Resend OTP in:  '
                        : 'Didn\'t receive an OTP?  ',
                    style: bodyText3(context: context),
                    children: [
                      TextSpan(
                        text: isResendTapped ? '00:${start}' : 'Resend OTP',
                        style: bodyText3(
                          color: primary,
                          context: context,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => setState(() {
                                startTimer();
                                isResendTapped = true;
                              }),
                      )
                    ]),
              ),
              const SizedBox(
                height: 40,
              ),
              !loader
                  ? CustomButton(
                      ontap: () {
                        if (widget.verificationId.isEmpty &&
                            widget.phone.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Wrong OTP")));
                        } else {
                          setState(() {
                            loader = true;
                          });
                          verifyOTPForSignUp(
                            context,
                            codeValue,
                            widget.phone,
                            widget.verificationId,
                            widget.name.toString(),
                          );
                        }
                      },
                      text: "Verify")
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
