// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meat4u_vendor/utils/constant.dart';
import 'package:provider/provider.dart';

import '../../Model/globalhelper.dart';
import 'oder_full_detail.dart';

class DeliveredScrn extends StatefulWidget {
  static String routeName = '/DeliveredScrn';
  const DeliveredScrn({Key? key}) : super(key: key);

  @override
  State<DeliveredScrn> createState() => _DeliveredScrnState();
}

class _DeliveredScrnState extends State<DeliveredScrn> {
  bool isOpen = false;
  bool isReadMore = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const BackButton(),
          title:
              Text("Delivered", style: headline1ExtraLarge(context: context)),
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("Orders")
              .where("vendorId",
                  isEqualTo:
                      FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
              .where("orderCompleted", isEqualTo: true)
              .orderBy('orderId', descending: true)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Provider.of<GlobalHelper>(context, listen: false)
                  .nodatta();
            }
            if (snapshot.hasData) {
              final docs = snapshot.data!.docs;
              // Scancelled = '0';
              log(docs.toString());

              return SizedBox(
                  height: scHeight(context) * 0.86,
                  child: ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (ctx, i) {
                        final data = docs[i].data();
                        var orderTime = DateTime.fromMillisecondsSinceEpoch(
                            data['orderTime']);
                        var date = DateFormat('dd-MM-yyyy').format(orderTime);
                        // log(data['orderId'].toString());
                        final itemPrice =
                            data['orderPrice'] * data['orderQuantity'];
                        final totalPrice = itemPrice + data['deliveryFees'];
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.all(10),
                              height: !isOpen
                                  ? height(context) * 0.16
                                  : height(context) * 0.57,
                              width: width(context) * 0.93,
                              decoration: shadowDecoration(10, 2),
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Order ID- ${data['orderId']}',
                                            style: bodyText14w600(color: black),
                                          ),
                                          Container(
                                            height: 33,
                                            width: width(context) * 0.3,
                                            decoration: myFillBoxDecoration(
                                                0, Colors.green, 10),
                                            child: Center(
                                              child: Text(
                                                'Completed',
                                                style: bodyText14w600(
                                                    color: white),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      // Text(
                                      //   '${data['orderQuantity']} Item(s) Order Placed',
                                      //   style: bodyText14w600(color: black),
                                      // ),
                                      const Divider(
                                        thickness: 1,
                                      ),
                                      if (isOpen)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Date & Time',
                                                  style: bodyText12Small(
                                                      color: black
                                                          .withOpacity(0.5)),
                                                ),
                                                Text(
                                                  '${date}',
                                                  style: bodytext12Bold(
                                                      color: black),
                                                ),
                                              ],
                                            ),
                                            addVerticalSpace(10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Your Order',
                                                  style: bodyText16w600(
                                                      color: black),
                                                ),
                                              ],
                                            ),
                                            addVerticalSpace(10),
                                            SizedBox(
                                              height: height(context) * 0.12,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            shadowDecoration(
                                                                15, 0),
                                                        height:
                                                            height(context) *
                                                                0.08,
                                                        width: width(context) *
                                                            0.18,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          child: Image.network(
                                                            data['orderImage'],
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                      addHorizontalySpace(10),
                                                      SizedBox(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: scWidth(
                                                                      context) *
                                                                  0.5,
                                                              child: Text(
                                                                data[
                                                                    'orderName'],
                                                                style: bodyText14w600(
                                                                    color:
                                                                        black),
                                                              ),
                                                            ),
                                                            Text(
                                                              "${data['orderWeight']}",
                                                              style: bodyText11Small(
                                                                  color: black
                                                                      .withOpacity(
                                                                          0.5)),
                                                            ),
                                                            addVerticalSpace(5),
                                                            Row(
                                                              children: [
                                                                // Text(
                                                                //   'Rs.${data['originalPrice']}',
                                                                //   style: const TextStyle(
                                                                //       fontSize:
                                                                //           12,
                                                                //       decoration:
                                                                //           TextDecoration
                                                                //               .lineThrough,
                                                                //       fontWeight:
                                                                //           FontWeight
                                                                //               .w500,
                                                                //       color: Colors
                                                                //           .black26),
                                                                // ),
                                                                // addHorizontalySpace(
                                                                //     5),
                                                                Text(
                                                                  'Rs.${(double.parse(data['productPrice']) * data['orderQuantity'])}',
                                                                  style: bodyText14w600(
                                                                      color:
                                                                          primary),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 30,
                                                        width: width(context) *
                                                            0.16,
                                                        decoration:
                                                            shadowDecoration(
                                                                7, 1),
                                                        child: Center(
                                                            child: Text(
                                                          'Qty-${data['orderQuantity']}',
                                                          style: bodytext12Bold(
                                                              color: black),
                                                        )),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(
                                                    thickness: 1,
                                                    height: 30,
                                                  )
                                                ],
                                              ),
                                            ),
                                            addVerticalSpace(20),
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.all(1),
                                              height: height(context) * 0.16,
                                              width: width(context) * 0.93,
                                              decoration:
                                                  shadowDecoration(10, 2),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Discount',
                                                        style: bodyText14w600(
                                                            color: black),
                                                      ),
                                                      Text(
                                                        'Rs.${data['discount']}%',
                                                        style: bodyText14w600(
                                                            color: black),
                                                      )
                                                    ],
                                                  ),
                                                  const Divider(
                                                    thickness: 1,
                                                  ),
                                                  // Row(
                                                  //   mainAxisAlignment:
                                                  //       MainAxisAlignment
                                                  //           .spaceBetween,
                                                  //   children: [
                                                  //     Text(
                                                  //       'Delivery',
                                                  //       style: bodyText14w600(
                                                  //           color: black),
                                                  //     ),
                                                  //     Text(
                                                  //       'Rs.${data['deliveryFees']}',
                                                  //       style: bodyText14w600(
                                                  //           color: black),
                                                  //     )
                                                  //   ],
                                                  // ),
                                                  // const Divider(
                                                  //   thickness: 1,
                                                  // ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Total',
                                                        style: bodyText16w600(
                                                            color: black),
                                                      ),
                                                      Text(
                                                        'Rs.${(double.parse(data['productPrice']) * data['orderQuantity'])}'
                                                            .toString(),
                                                        style: bodyText16w600(
                                                            color: primary),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            addVerticalSpace(15),
                                            // Center(child: widget.showDetailAndTrackButton),
                                          ],
                                        ),
                                      Center(
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                isOpen = !isOpen;
                                              });
                                            },
                                            child: Icon(
                                              isOpen
                                                  ? Icons.expand_less
                                                  : Icons.expand_more,
                                              size: 40,
                                              color: black.withOpacity(0.6),
                                            )),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }));
            } else {
              Scancelled = snapshot.data!.docs.length.toString();
            }
            if (snapshot.data!.docs.isEmpty) {
              return Provider.of<GlobalHelper>(context, listen: false)
                  .nodatta();
            }
            log(snapshot.data!.docs.toString());
            return CircularProgressIndicator();

            // return ListView(
            //   shrinkWrap: true,
            //   children: snapshot.data!.docs.map((e) {
            //     return Readybody(
            //       snapshot: e,
            //       index: 1,
            //     );
            //   }).toList(),
            // );
          },
        )

        /*Column(
        children: [
          Readybody(
            text: "Ready", 
            color: Color(0xfffFF9C06))
        ],
      ),*/

        );
  }
}

class Readybody extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> snapshot;
  int index;
  Readybody({Key? key, required this.snapshot, required this.index})
      : super(key: key);
  List items = [];
  @override
  Widget build(BuildContext context) {
    items = snapshot.data()["order"];
    return SingleChildScrollView(
        child: Column(children: [
      ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
                    decoration: boxDecoration(),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: Column(
                        children: [
                          ExpansionTile(
                            controlAffinity: ListTileControlAffinity.platform,
                            childrenPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            iconColor: primary,
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            title: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order ID- ${snapshot.id}',
                                      style: bodyText2(context: context),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: const Color(0XFF3879F0),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 6),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Delivered',
                                        style: bodyText2(
                                            context: context,
                                            color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  '${items.length} Item(s) Order Placed'
                                      .toString(),
                                  style: bodyText2Bold(context: context),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  color: textLightColor,
                                )
                              ],
                            ),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date & Time',
                                    style: bodyText3(
                                        color: textLightColor,
                                        context: context),
                                  ),
                                  Text(
                                    snapshot
                                        .data()['orderedOn']
                                        .toDate()
                                        .toString(),
                                    style: bodyText3(context: context),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Your Order',
                                style: bodyText2Bold(context: context),
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              //add list of order here
                              ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: items.map((e) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      trailing: Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: boxDecoration(),
                                        child: Text(
                                          'Qty-${e['orderQuantity']}'
                                              .toString(),
                                          style:
                                              bodyText2Bold(context: context),
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            e['orderWeight'],
                                            style: bodyText3(
                                                context: context,
                                                color: textLightColor),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          Text.rich(TextSpan(children: [
                                            TextSpan(
                                                style: bodyText2(
                                                    textDecoration:
                                                        TextDecoration
                                                            .lineThrough,
                                                    context: context,
                                                    color: textLightColor),
                                                text: 'Rs.${e['orderPrice']}   '
                                                    .toString()),
                                          ])),
                                        ],
                                      ),
                                      title: Text(
                                        e['orderName'],
                                        style: bodyText2(context: context),
                                      ),
                                      leading: Image.network(e['orderImage']),
                                    ),
                                  );
                                }).toList(),
                              ),

                              Container(
                                margin: const EdgeInsets.only(
                                    top: 15, left: 5, right: 5, bottom: 15),
                                decoration: boxDecoration(),
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Item Total',
                                        style: bodyText2Bold(context: context),
                                      ),
                                      Text(
                                        snapshot.data()['price'],
                                        // e['orderPrice'] * e['orderQuantity'],
                                        style: bodyText2Bold(context: context),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const Divider(
                                color: textLightColor,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
    ]));
  }
}
