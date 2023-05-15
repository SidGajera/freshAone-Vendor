import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meat4u_vendor/screens/order/add_products.dart';
import 'package:meat4u_vendor/screens/order/edit_products.dart';
import 'package:meat4u_vendor/screens/product/products_details.dart';
import 'package:meat4u_vendor/utils/constant.dart';

class ProductsScrn extends StatefulWidget {
  static String routeName = '/ProductsScrn';
  const ProductsScrn({Key? key}) : super(key: key);

  @override
  State<ProductsScrn> createState() => _ProductsScrnState();
}

class _ProductsScrnState extends State<ProductsScrn> {
  List<dynamic> filtercoupon = [];
  Map? productItems;
  List<dynamic> products = [];
  double productQuantity = 0;

  Map<String, dynamic> ordersData = {};
  bool? isvendorOnline;

  // _getProfileData() async {
  //   log('sumit');
  //   await FirebaseFirestore.instance
  //       .collection('Orders')
  //       .doc()
  //       .get()
  //       .then((value) {
  //     if (value.exists) {
  //       log(value.data().toString());
  //       setState(() {
  //         ordersData = value.data()!;

  //         log(ordersData.toString());
  //       });
  //     }
  //   });
  // }

  _getOrderData() {}

  @override
  void initState() {
    // log(ordersData.toString());
    _getOrderData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: const BackButton(),
          actions: [],
          title: Text("Products", style: headline1ExtraLarge(context: context)),
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Products in Stock",
                  style: headline1ExtraLarge(context: context)),
              const SizedBox(
                height: 22,
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('productitems')
                      .where('vendorId', arrayContainsAny: [
                    FirebaseAuth.instance.currentUser!.uid.substring(0, 20)
                  ]).snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError)
                      return Text('Error = ${snapshot.error}');
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      // log(docs.toString());
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
                              final data = docs[index].data();

                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => ProductsDetails(
                                                data: data,
                                              )));
                                },
                                child: Container(
                                  // height: scHeight(context) / 4.3,
                                  width: scWidth(context),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      // border: Border.all(
                                      //     color: Color.fromARGB(255, 189, 184, 184), width: 2),

                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                              textLightColor.withOpacity(0.3),
                                          blurRadius: 8.0,
                                        ),
                                      ],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
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
                                                      topLeft:
                                                          Radius.circular(8),
                                                      topRight:
                                                          Radius.circular(8)),
                                              child: Image.network(
                                                data['image'],
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                        addVerticalSpace(7),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              data['name'],
                                              style: bodyText2Bold(
                                                  context: context),
                                            )),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 2),
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
                                          height: 7,
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
                                                data['discription'],
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
                                            Spacer(),
                                            Text(
                                              '${data['quantity']}',
                                              style: bodyText2Bold(
                                                  context: context),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Rs.${data['price']}',
                                              style: bodyText2Bold(
                                                  context: context),
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
                                                                productData:
                                                                    data)));
                                              },
                                              child: Container(
                                                height: 25,
                                                width: scWidth(context) * 0.15,
                                                decoration: BoxDecoration(
                                                    color: primary),
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
                                ),
                              );
                            }),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  })
            ],
          ),
        ));
  }
}
