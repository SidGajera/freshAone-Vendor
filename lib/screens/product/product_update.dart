// ignore: file_names
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meat4u_vendor/utils/constant.dart';
import 'package:provider/provider.dart';

import '../../Model/globalhelper.dart';

class ProductupScrn extends StatefulWidget {
  static String routeName = '/ProductupScrn';
  const ProductupScrn({Key? key}) : super(key: key);

  @override
  State<ProductupScrn> createState() => _ProductupScrnState();
}

class _ProductupScrnState extends State<ProductupScrn> {
  List<dynamic> filtercoupon = [];
  Map? productItems;
  List<dynamic> products = [];

  callApi() async {
    await FirebaseFirestore.instance
        .collection('productItems')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get()
        .then((value) {
      productItems = value.data();
      if (productItems != null) {
        products = productItems!['list'];
        filtercoupon = productItems!['list'];
        filtercoupon.forEach((element) {});
      }
      log(productItems.toString());
      // countDiscount();
      setState(() {});
    });
  }

  @override
  void initState() {
    callApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackButton(),
            // const SizedBox(
            //   width: 79,
            // ),
            Text("Product Update",
                style: headline1ExtraLarge(context: context)),
            const Icon(
              Icons.search,
              color: primary,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 42, left: 22, right: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product Update",
                style: headline1ExtraLarge(context: context),
              ),
              const SizedBox(
                height: 22,
              ),
              productItems == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: products.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 6,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.5),
                      itemBuilder: (context, index) {
                        return buildPageItem(index, context);
                      })
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPageItem(index, context) {
    return products[index]['productUpdated'] == false
        ? Container(
            height: scHeight(context) / 4.2,
            width: scWidth(context) / 2.35,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  products[index]['productImage'],
                  fit: BoxFit.contain,
                  scale: 0.8,
                ),
                Container(
                  padding:
                      const EdgeInsets.only(left: 11, right: 11, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Text(
                            products[index]['productName'],
                            style: bodyText2Bold(context: context),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        products[index]['productWeight'],
                        style: bodyText2Bold(context: context),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () async {
                          productItems!['list'][index]['productUpdated'] = true;

                          await FirebaseFirestore.instance
                              .collection('productItems')
                              .doc(FirebaseAuth.instance.currentUser!.uid
                                  .substring(0, 20))
                              .update(productItems as Map<String, dynamic>);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 34, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            // ignore: use_full_hex_values_for_flutter_colors
                            color: const Color(0xfffd21243),
                            //border: Border.all(width: 2, color: Colors.white),
                          ),
                          child: Center(
                            child: Text(
                              "Send Update",
                              style: bodyText3(
                                  color: Colors.white, context: context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const Text('');
  }
}

/* class ProductUpdateCard extends StatelessWidget {
  const ProductUpdateCard({
    Key? key,
    required this.image,
    required this.text,
    required this.text2,
    required this.text3,
  }) : super(key: key);
  final String image;
  final String text;
  final String text2;
  final String text3;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: scHeight(context) / 4.2,
          width: scWidth(context) / 2.35,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                image,
                scale: 0.8,
              ),
              Container(
                padding: const EdgeInsets.only(left: 11, right: 11, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              text,
                              style: bodyText1(context: context),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              text3,
                              style: bodyText1(context: context),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 41,
                        ),
                        Text(text2),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 34, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          // ignore: use_full_hex_values_for_flutter_colors
                          color: const Color(0xfffd21243),
                          //border: Border.all(width: 2, color: Colors.white),
                        ),
                        child: Center(
                          child: Text(
                            "Send Update",
                            style: bodyText3(color: Colors.white,context: context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  }
 */