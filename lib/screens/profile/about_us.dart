import 'package:flutter/material.dart';
import 'package:meat4u_vendor/utils/constant.dart';

class AboutScrn extends StatelessWidget {
  static String routeName = '/AboutScrn';
  const AboutScrn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const BackButton(),
            const SizedBox(width: 86),
            Text("About Us", style: headline1ExtraLarge(context: context)),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 38, left: 22, right: 22),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About app",
                  style: headline1ExtraLarge(context: context),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "The lorem ipsum is a placeholder text used in publishing and graphic design. This filler text is a short paragraph that contains all the letters of the alphabet. The characters are spread out evenly so that the reader's attention is focused on the layout of the text instead of its content.The lorem ipsum is a placeholder text used in publishing and graphic design. This filler text is a short paragraph that contains all the letters of the alphabet. The characters are spread out evenly so that the reader's attention is focused on the layout of the text instead of its content.",
                  style: bodyText2(context: context),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Introduction",
                  style: headline1ExtraLarge(context: context),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "The lorem ipsum is a placeholder text used in publishing and graphic design. This filler text is a short paragraph that contains all the letters of the alphabet. The characters are spread out evenly so that the reader's attention is focused on the layout of the text instead of its content.The lorem ipsum is a placeholder text used in publishing and graphic design. This filler text is a short paragraph that contains all the letters of the alphabet. The characters are spread out evenly so that the reader's attention is focused on the layout of the text instead of its content.",
                  style: bodyText2(context: context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
