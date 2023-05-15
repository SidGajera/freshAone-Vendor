import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meat4u_vendor/component/custom_button.dart';
import 'package:meat4u_vendor/utils/constant.dart';

class ContactScrn extends StatefulWidget {
  static String routeName = '/ContactScrn';
  const ContactScrn({Key? key}) : super(key: key);

  @override
  State<ContactScrn> createState() => _ContactScrnState();
}

class _ContactScrnState extends State<ContactScrn> {
  Map? terms;
  var fromController = TextEditingController();
  var helpController = TextEditingController();
  _getProfileData() async {
    await FirebaseFirestore.instance
        .collection('contactus')
        .doc('number')
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
          children: [
            const BackButton(),
            Text("Contact Us", style: headline1ExtraLarge(context: context)),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 22, left: 17, right: 25),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.call,
                  color: primary,
                ),
                const SizedBox(
                  width: 21,
                ),
                terms != null
                    ? Text(
                        terms!['number'],
                        style: headline1ExtraLarge(context: context),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
                const Spacer(),
                const Icon(Icons.arrow_right)
              ],
            ),
            const SizedBox(
              height: 22.15,
            ),
            const Divider(),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: fromController,
              decoration: const InputDecoration(
                prefixText: "From:",
                fillColor: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              controller: helpController,
              keyboardType: TextInputType.multiline,
              maxLines: 7,
              decoration: InputDecoration(
                  hintText: "Tell us how we can help",
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1.5,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  )),
            ),
            const SizedBox(
              height: 79,
            ),
            CustomButton(
                ontap: () {
                  FirebaseFirestore.instance
                      .collection("contactus")
                      .doc('query')
                      .collection('forms')
                      .doc(FirebaseAuth.instance.currentUser!.uid
                          .substring(0, 20))
                      .set({
                    "date": DateTime.now(),
                    "vendorId":
                        FirebaseAuth.instance.currentUser!.uid.substring(0, 20),
                    "from": fromController.text.trim(),
                    "msg": helpController.text.trim(),
                  });
                  Navigator.pop(context);
                },
                text: "Send")
          ],
        ),
      ),
    );
  }
}
