import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meat4u_vendor/screens/order/add_products.dart';
import 'package:meat4u_vendor/utils/constant.dart';
import 'package:meat4u_vendor/controller/auth_controller.dart';
import 'package:meat4u_vendor/screens/profile/about_us.dart';
import 'package:meat4u_vendor/screens/profile/contact_us.dart';
import 'package:meat4u_vendor/screens/product/products.dart';
import 'package:meat4u_vendor/screens/product/product_update.dart';
import 'package:meat4u_vendor/screens/order/neworder.dart';
import 'package:meat4u_vendor/screens/profile/privacy_policy.dart';
import 'package:meat4u_vendor/screens/profile/terms.dart';

class ProfileScrn extends StatefulWidget {
  static String routeName = '/ProfileScrn';
  const ProfileScrn({Key? key}) : super(key: key);

  @override
  State<ProfileScrn> createState() => _ProfileScrnState();
}

class _ProfileScrnState extends State<ProfileScrn> {
  Map? vendorData;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  _getProfileData() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          vendorData = value.data()!;
          // ignore: avoid_print
          print(vendorData);
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
      appBar: AppBar(),
      body: Container(
        color: Colors.white24,
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                top: 5,
                left: 15,
              ),
              child: vendorData == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(vendorData!['image']),
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              vendorData!['marketName'] ?? '',
                              style: headline1ExtraLarge(context: context),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              FirebaseAuth.instance.currentUser!.phoneNumber!,
                              style: bodyText1Bold(
                                  color: textLightColor, context: context),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            Listprofile(
              image: 'assets/images/Product.png',
              text: 'Products',
              ontap: () {
                Navigator.pushNamed(context, ProductsScrn.routeName);
              },
            ),
            // Listprofile(
            //   image: 'assets/images/Product.png',
            //   text: 'Add Products',
            //   ontap: () {
            //     Navigator.push(context,
            //         MaterialPageRoute(builder: (ctx) => AddProducts()));
            //   },
            // ),
            // Listprofile(
            //   image: 'assets/images/update.png',
            //   text: 'Product Update',
            //   ontap: () {
            //     Navigator.pushNamed(context, ProductupScrn.routeName);
            //   },
            // ),
            Listprofile(
              image: 'assets/images/Trems.png',
              text: 'Terms & Conditions',
              ontap: () {
                Navigator.pushNamed(context, TermsScrn.routeName);
              },
            ),
            Listprofile(
              image: 'assets/images/Privacy.png',
              text: 'Privacy Policy',
              ontap: () {
                Navigator.pushNamed(context, PrivacyScrn.routeName);
              },
            ),
            Listprofile(
              image: 'assets/images/us.png',
              text: 'Contact us',
              ontap: () {
                Navigator.pushNamed(context, ContactScrn.routeName);
              },
            ),
            Listprofile(
              image: 'assets/images/about.png',
              text: 'About us',
              ontap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AboutScrn()));
              },
            ),
            Listprofile(
              image: 'assets/images/logout.png',
              text: 'Logout',
              ontap: () {
                logOut(context);
              },
            ),
          ]),
        ),
      ),
    );
  }
}

class Listprofile extends StatelessWidget {
  const Listprofile({
    Key? key,
    required this.image,
    required this.text,
    required this.ontap,
  }) : super(key: key);
  final String image;
  final String text;
  final Function() ontap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: InkWell(
        onTap: ontap,
        child: Container(
          padding:
              const EdgeInsets.only(top: 24, left: 25, right: 15, bottom: 20),
          color: Colors.white,
          child: Row(
            children: [
              Image.asset(
                image,
                width: 20,
                height: 20,
              ),
              const SizedBox(
                width: 29,
              ),
              Text(
                text,
                style: bodyText1Bold(context: context),
              ),
              const Spacer(),
              const Icon(Icons.arrow_right)
            ],
          ),
        ),
      ),
    );
  }
}
