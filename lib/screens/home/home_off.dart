// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:meat4u_vendor/utils/constant.dart';

class HomeOffScrn extends StatelessWidget {
  static String routeName = '/homeOffScreen';
  const HomeOffScrn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(top: 150, right: 25, left: 25),
        child: Column(
          children: [
            Image.asset(
              "assets/images/offline_scrn.png",
              width: 700,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Your outlet is temporarily closed",
              style: headline1ExtraLarge(context: context),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "You will go on 11 Jan’22, 08:00 AM",
              style: headline1Normal(color: Colors.grey,context: context),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              padding: const EdgeInsets.only(left: 84, right: 84),
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: const Color(0xfffd21243),
                    //border: Border.all(width: 2, color: Colors.white),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/on-off-button 1.png",
                          scale: .8,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Go online now",
                          style: headline1ExtraLarge(color: Colors.white,context: context),
                        ),
                      ],
                    ),
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
