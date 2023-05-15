// ignore_for_file: unused_local_variable, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const primary = Color(0xFFD21243);
const secondary1 = Color(0xFFFFAABE);

const buttons1 = Color(0xFFFEA968);
const buttons2 = Color(0xFF2FA84E);

const textColor = Colors.black;
const textLightColor = Color(0xFF888888);

String categoryName = '';
num categoryId = 2;
String Sneworder = '0';
String Scancelled = '0';
String Sprocessed = '0';
String Sdelivered = '0';
String Sreceived = '0';
String Sreturned = '0';
String Sshipped = '0';
int Swalletamount = 0;
double? Slat;
double? Slong;
String? Slocation;

double? lat;
double? long;

showMySnackBar(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

///Media Query screen height
double scHeight(context) {
  return MediaQuery.of(context).size.height;
}

///media Query screen width
double scWidth(context) {
  return MediaQuery.of(context).size.width;
}

///hide keyboard
void hideKeyboard(context) => FocusScope.of(context).requestFocus(FocusNode());

//box decoration
BoxDecoration boxDecoration({double borderRadius = 8}) {
  return BoxDecoration(boxShadow: [
    BoxShadow(blurRadius: 5, color: textLightColor.withOpacity(0.4))
  ], color: Colors.white, borderRadius: BorderRadius.circular(borderRadius));
}

//=================//
TextStyle headline1({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;
  // log('${scHeight(context)}');
  double multiplier = 2.65;
  return GoogleFonts.lato(
      fontWeight: FontWeight.w800,
      // fontSize: 20,
      fontSize: multiplier * unitHeightValue,
      color: color);
}

TextStyle headline1Normal({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;

  double multiplier = 1.97;
  return GoogleFonts.lato(
      fontWeight: FontWeight.w500,
      //fontSize: 18,
      fontSize: multiplier * unitHeightValue,
      color: color);
}

TextStyle headline1ExtraLarge({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;
  double multiplier = 3.937;
  return GoogleFonts.lato(
      fontWeight: FontWeight.w700, fontSize: 22, color: color);
}

TextStyle headline1ExtraLarg({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;
  double multiplier = 3.937;
  return GoogleFonts.lato(
      fontWeight: FontWeight.w700,
      //fontSize: 36,
      fontSize: multiplier * unitHeightValue,
      color: color);
}

TextStyle bodyText1({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;

  double multiplier = 2.3;
  return GoogleFonts.lato(
      fontWeight: FontWeight.w500,
      // fontSize: 16, .
      fontSize: multiplier * unitHeightValue,
      color: color);
}

TextStyle bodyText1Bold({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) / 100;
  double multiplier = 1.8;
  return GoogleFonts.lato(
      fontWeight: FontWeight.w600,
      //fontSize: 16,
      fontSize: multiplier * unitHeightValue,
      color: color);
}

TextStyle bodyText1Bld({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;
  double multiplier = 1.21;
  return GoogleFonts.lato(
      fontWeight: FontWeight.w600,
      // fontSize: 11,
      fontSize: multiplier * unitHeightValue,
      color: color);
}

TextStyle bodyText1Bd({
  Color color = textColor,
  required context,
}) {
  double unitHeightValue = scHeight(context) * 0.01;
  double multiplier = 1.21;
  return GoogleFonts.lato(
      fontWeight: FontWeight.w400,
      // fontSize: 11,
      fontSize: multiplier * unitHeightValue,
      color: color,
      decoration: TextDecoration.lineThrough);
}

TextStyle bodyText2(
    {Color color = textColor,
    required context,
    TextDecoration textDecoration = TextDecoration.none}) {
  double unitHeightValue = scHeight(context) * 0.01;
  double multiplier = 1.55;
  return GoogleFonts.lato(
      fontWeight: FontWeight.w400,
      //fontSize: 14,
      decoration: textDecoration,
      fontSize: multiplier * unitHeightValue,
      color: color);
}

TextStyle bodyText2Bold({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;
  double multiplier = 1.55;
  return GoogleFonts.lato(
      fontWeight: FontWeight.w700,
      //fontSize: 14,
      fontSize: multiplier * unitHeightValue,
      color: color);
}

TextStyle bodyText3({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;
  // log('${scHeight(context)}');
  double multiplier = 1.55;
  return GoogleFonts.lato(
      fontWeight: FontWeight.w400,
      // fontSize: 14,
      fontSize: multiplier * unitHeightValue,
      color: color);
}

//==========text2===========
TextStyle hedline2({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;
  double multiplier = 3.31;
  return GoogleFonts.nunito(
      fontWeight: FontWeight.w800,
      //fontSize: 30,
      fontSize: multiplier * unitHeightValue,
      color: color);
}

TextStyle headline2Normal({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;
  double multiplier = 1.97;
  return GoogleFonts.nunito(
      fontWeight: FontWeight.w500,
      //fontSize: 18,
      fontSize: multiplier * unitHeightValue,
      color: color);
}

TextStyle headline2ExtraLarge({Color color = textColor}) {
  return GoogleFonts.nunito(
      fontWeight: FontWeight.w700, fontSize: 22, color: color);
}

TextStyle bodyText({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;
  double multiplier = 1.8;
  return GoogleFonts.nunito(
      fontWeight: FontWeight.w400,
      fontSize: multiplier * unitHeightValue,
      //fontSize: 16,
      color: color);
}

TextStyle bodyTextBold({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;
  double multiplier = 1.8;
  return GoogleFonts.nunito(
      fontWeight: FontWeight.w600,
      fontSize: multiplier * unitHeightValue,
      // fontSize: 16,
      color: color);
}

TextStyle bodyTextB({Color color = textColor, required context}) {
  double unitHeightValue = scHeight(context) * 0.01;
  double multiplier = 1.32;
  return GoogleFonts.nunito(
      fontWeight: FontWeight.w600,
      fontSize: multiplier * unitHeightValue,
      // fontSize: 12,
      color: color);
}

TextStyle bodyText4({Color color = textColor}) {
  return GoogleFonts.nunito(
      fontWeight: FontWeight.w400, fontSize: 14, color: color);
}

TextStyle bodyText4Bold({Color color = textColor}) {
  return GoogleFonts.nunito(
      fontWeight: FontWeight.w700, fontSize: 14, color: color);
}

TextStyle bodyText5({Color color = textColor}) {
  return GoogleFonts.nunito(
      fontWeight: FontWeight.w400, fontSize: 12, color: color);
}

TextStyle bodyText6({Color color = textColor}) {
  return GoogleFonts.nunito(
      fontWeight: FontWeight.w400, fontSize: 10, color: color);
}

class LoginDriver extends StatelessWidget {
  const LoginDriver({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: scWidth(context) / 1,
      child: Row(
        children: [
          buildDriver(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              text,
              style: bodyText1Bold(color: Colors.grey, context: context),
            ),
          ),
          buildDriver(),
        ],
      ),
    );
  }

  Expanded buildDriver() {
    return const Expanded(
        child: Divider(
      color: Color(0xFFD9D9D9),
      height: 1.5,
    ));
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    required this.image,
    required this.text,
    required this.text2,
    required this.height,
    required this.width,
    required this.ontap,
  }) : super(key: key);
  final String image;
  final String text;
  final String text2;
  final double height;
  final double width;
  final Function() ontap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: ontap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            height: height,
            width: width,
            decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(
                //     color: Color.fromARGB(255, 189, 184, 184), width: 2),

                boxShadow: [
                  BoxShadow(
                    color: textLightColor.withOpacity(0.3),
                    blurRadius: 8.0,
                  ),
                ],
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  scale: 1.6,
                ),
                Expanded(
                  child: Text(
                    text,
                    style: bodyText1(color: Colors.grey, context: context),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Text(
                    text2,
                    style: bodyText2(context: context),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

TableRow textRowWidget({
  required String Menu,
  required String Rev,
  required String order,
}) {
  return TableRow(children: [
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            Menu,
            style: bodyText6(),
          )
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            Rev,
            style: bodyText6(),
          )
        ],
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            order,
            style: bodyText6(color: Colors.green),
          )
        ],
      ),
    ),
  ]);
}

TextStyle bodyText14w600({required Color color}) {
  return TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w600);
}

TextStyle bodyText14normal({required Color color}) {
  return TextStyle(
    fontSize: 13,
    color: color,
  );
}

TextStyle bodyText13normal({required Color color}) {
  return TextStyle(
    fontSize: 13,
    color: color,
  );
}

TextStyle bodyText16w600({required Color color}) {
  return TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w700);
}

// small Size
TextStyle bodyText12Small({required Color color}) {
  return TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w400);
}

TextStyle bodyText11Small({required Color color}) {
  return TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w400);
}

TextStyle bodytext12Bold({required Color color}) {
  return TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w600);
}

TextStyle bodyText20w700({required Color color}) {
  return TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold);
}

TextStyle bodyText30W600({required Color color}) {
  return TextStyle(fontSize: 30, color: color, fontWeight: FontWeight.w700);
}

TextStyle bodyText30W400({required Color color}) {
  return TextStyle(
    fontSize: 30,
    color: color,
  );
}

// box decoration with Boxshadow
BoxDecoration shadowDecoration(double radius, double blur) {
  return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: blur,
        ),
      ]);
}

BoxDecoration myFillBoxDecoration(double width, Color color, double radius) {
  return BoxDecoration(
    color: color,
    border: Border.all(width: width, color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius) //
        ),
  );
}

BoxDecoration myOutlineBoxDecoration(double width, Color color, double radius) {
  return BoxDecoration(
    border: Border.all(width: width, color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius) //
        ),
  );
}

Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

Widget addHorizontalySpace(double width) {
  return SizedBox(width: width);
}

double height(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double width(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

bool isToggle = false;
bool isPremium = false;
bool isPosition = false;
// for gradient

// for custom

Color boxBgColor = const Color.fromRGBO(51, 51, 51, 1);
Color white = Colors.white;
Color blackLight = Color.fromRGBO(50, 50, 50, 1);
Color black = Colors.black;
