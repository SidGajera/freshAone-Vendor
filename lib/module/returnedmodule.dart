import 'package:flutter/material.dart';
import 'package:meat4u_vendor/utils/constant.dart';

class Order extends StatelessWidget {
  const Order({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          "assets/images/chicken.png",
          scale: 2.5,
        ),
        const SizedBox(
          width: 17,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Polutry Chicken",
              style: bodyText1Bold(context: context),
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              "900gms I Net: 450gms",
              style: bodyText1Bld(color: Colors.grey, context: context),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                      text: "Rs.250 ",
                      style: bodyText1Bd(color: Colors.grey, context: context),
                      children: [
                        TextSpan(
                            text: "Rs.200",
                            style:
                                bodyText1Bld(color: primary, context: context))
                      ]),
                ),
                const SizedBox(
                  width: 100,
                ),
                Container(
                  height: 24,
                  width: 70,
                  padding: const EdgeInsets.only(
                      top: 5, left: 20, right: 20, bottom: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: textLightColor.withOpacity(0.3),
                        blurRadius: 8.0,
                      ),
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: const Text("Qty-2"),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
