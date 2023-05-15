import 'package:flutter/material.dart';

import '../utils/constant.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.ontap,
    required this.text,
  }) : super(key: key);
  final VoidCallback ontap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: primary,
          //border: Border.all(width: 2, color: Colors.white),
        ),
        child: Center(
          child: Text(
            text,
            style: headline1ExtraLarge(color: Colors.white,context: context),
          ),
        ),
      ),
    );
  }
}
