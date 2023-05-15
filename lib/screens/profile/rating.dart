import 'package:flutter/material.dart';
import 'package:meat4u_vendor/utils/constant.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class RatingScrn extends StatefulWidget {
  static String routeName = '/RatingScrn';
  const RatingScrn({Key? key}) : super(key: key);

  @override
  State<RatingScrn> createState() => _RatingScrnState();
}

class _RatingScrnState extends State<RatingScrn> {
  @override
  List<double> ratings = [0.02, 0.07, 0.1, 0.3, 0.4];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(top: 91, right: 27, left: 27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Customer Reviews",
              style: bodyText2Bold(context: context),
            ),
            const SizedBox(
              height: 30,
            ),
            Text.rich(
              TextSpan(children: [
                TextSpan(text: "4.20", style: headline1ExtraLarge(context: context)),
                TextSpan(text: "/5", style: headline1ExtraLarge(context: context)),
              ]),
            ),
            const SizedBox(
              height: 18,
            ),
            Container(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 30, right: 30),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 217, 231, 245),
                  borderRadius: BorderRadius.circular(20)),
              child: SmoothStarRating(
                starCount: 5,
                rating: 4.80,
                size: 28.0,
                color: Colors.orange,
                borderColor: Colors.orange,
              ),
            ),
            const Text("2,133 Ratings"),
            Container(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 23),
                shrinkWrap: true,
                reverse: true,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Text("${index + 1}star"),
                      LinearPercentIndicator(
                        lineHeight: 12.0,
                        width: scHeight(context) / 3.5,
                        animation: true,
                        animationDuration: 250,
                        percent: ratings[index],
                        progressColor: Colors.orange,
                        // ignore: deprecated_member_use
                        linearStrokeCap: LinearStrokeCap.roundAll,
                      ),
                      Text("$index%"),
                      const SizedBox(
                        height: 23,
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
