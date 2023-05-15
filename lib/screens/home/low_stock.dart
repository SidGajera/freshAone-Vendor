import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meat4u_vendor/utils/constant.dart';

import '../order/edit_products.dart';

class ProductlowScrn extends StatefulWidget {
  static String routeName = '/ProductlowScrn';
  const ProductlowScrn({Key? key}) : super(key: key);

  @override
  State<ProductlowScrn> createState() => _ProductlowScrnState();
}

class _ProductlowScrnState extends State<ProductlowScrn> {
  // List<dynamic> filtercoupon = [];
  // Map? productItems;
  // List<dynamic> products = [];

  // callApi() async {
  //   await FirebaseFirestore.instance
  //       .collection('productItems')
  //       .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
  //       .get()
  //       .then((value) {
  //     productItems = value.data();
  //     if (productItems != null) {
  //       products = productItems!['list'];
  //       filtercoupon = productItems!['list'];
  //       filtercoupon.forEach((element) {});
  //     }
  //     log(productItems.toString());
  //     // countDiscount();
  //     setState(() {});
  //   });
  // }

  // @override
  // void initState() {
  //   callApi();
  //   super.initState();
  // }

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
              Text("Low Stock Products",
                  style: headline1ExtraLarge(context: context)),
              const Icon(
                Icons.search,
                color: primary,
              ),
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Low Stock Products",
                  style: headline1ExtraLarge(context: context)),
              const SizedBox(
                height: 22,
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('productitems')
                      .where('vendorId', arrayContainsAny: [
                        FirebaseAuth.instance.currentUser!.uid.substring(0, 20)
                      ])
                      .where(
                        'quantity',
                        isLessThan: 5,
                      )
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    // log(snapshot.connectionState.toString());
                    if (snapshot.hasError) {
                      log(snapshot.error.toString());
                      return Text('Error = ${snapshot.error}');
                    }
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;

                      return Expanded(
                        child: GridView.builder(
                            padding: const EdgeInsets.only(top: 16),
                            itemCount: docs.length,
                            // physics: const NeverScrollableScrollPhysics(),

                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                    childAspectRatio: 0.58),
                            itemBuilder: (context, index) {
                              // final data = docs[index].data();

                              return Container(
                                height: scHeight(context) / 4.3,
                                width: scWidth(context),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: scHeight(context) * 0.2,
                                        width: scWidth(context) / 2.3,
                                        child: ClipRRect(
                                            clipBehavior: Clip.antiAlias,
                                            borderRadius:
                                                const BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8)),
                                            child: Image.network(
                                              docs[index]['image'],
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      addVerticalSpace(7),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            docs[index]['name'],
                                            style:
                                                bodyText2Bold(context: context),
                                          )),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 2),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.amber),
                                            child: Row(
                                              children: [
                                                Text(
                                                  '4.1',
                                                  style: bodyText3(
                                                      color: Colors.white,
                                                      context: context),
                                                ),
                                                const Icon(
                                                  Icons.star_rounded,
                                                  color: Colors.white,
                                                  size: 12,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Description : ',
                                            style: bodyText3(
                                                color: Colors.grey,
                                                context: context),
                                          ),
                                          SizedBox(
                                            width: width(context) * 0.21,
                                            child: Text(
                                              docs[index]['discription'],
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "In Stocks :",
                                            style: bodyText3(
                                                color: Colors.grey,
                                                context: context),
                                          ),
                                          Text(
                                            "${docs[index]['quantity']}",
                                            style:
                                                bodyText2Bold(context: context),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Rs.${docs[index]['price']}',
                                            style:
                                                bodyText2Bold(context: context),
                                          ),
                                          Spacer(),
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          EditProducts(
                                                              productDocId:
                                                                  docs[index]
                                                                      .id,
                                                              productData: docs[
                                                                      index]
                                                                  .data())));
                                            },
                                            child: Container(
                                              height: 25,
                                              width: scWidth(context) * 0.15,
                                              decoration:
                                                  BoxDecoration(color: primary),
                                              child: Center(
                                                child: Text(
                                                  'Edit',
                                                  style: bodyText13normal(
                                                      color: white),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  })
            ],
          ),
        ));
  }
}
