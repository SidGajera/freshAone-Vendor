import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meat4u_vendor/utils/constant.dart';

class TermsScrn extends StatefulWidget {
  static String routeName = '/TermsScrn';
  const TermsScrn({Key? key}) : super(key: key);

  @override
  State<TermsScrn> createState() => _TermsScrnState();
}

class _TermsScrnState extends State<TermsScrn> {
  Map? terms;
  _getProfileData() async {
    await FirebaseFirestore.instance
        .collection('TandC')
        .doc('tc')
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          terms = value.data()!;
          // ignore: avoid_print
          print(terms);
        });
      }
    });
  }

  @override
  void initState() {
    _getProfileData();
    super.initState();
  }

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
            Text("Terms & Conditions",
                style: headline1ExtraLarge(context: context)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 38, left: 22, right: 22),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Acceptance",
                    style: headline1ExtraLarge(context: context),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  terms != null
                      ? Text(
                          terms!['data'],
                          style: bodyText2(context: context),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
