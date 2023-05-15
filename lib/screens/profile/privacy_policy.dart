import 'package:flutter/material.dart';
import 'package:meat4u_vendor/utils/constant.dart';

class PrivacyScrn extends StatelessWidget {
  static String routeName = '/PrivacyScrn';
  const PrivacyScrn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const BackButton(),
            Text("Privacy Policy", style: headline1ExtraLarge(context: context)),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 38, left: 22, right: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy",
              style: headline1ExtraLarge(context: context),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "The lorem ipsum is a placeholder text used in publishing and graphic design. This filler text is a short paragraph that contains all the letters of the alphabet. The characters are spread out evenly so that the reader's attention is focused on the layout of the text instead of its content.The lorem ipsum is a placeholder text used in publishing and graphic design. This filler text is a short paragraph that contains all the letters of the alphabet. The characters are spread out evenly so that the reader's attention is focused on the layout of the text instead of its content.",
              style: bodyText2(context: context),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "The lorem ipsum is a placeholder text used in publishing and graphic design. This filler text is a short paragraph that contains all the letters of the alphabet. The characters are spread out evenly so that the reader's attention is focused on the layout of the text instead of its content.The lorem ipsum is a placeholder text used in publishing and graphic design. This filler text is a short paragraph that contains all the letters of the alphabet. The characters are spread out evenly so that the reader's attention is focused on the layout of the text instead of its content.",
              style: bodyText2(context: context),
            )
          ],
        ),
      ),
    );
  }
}
