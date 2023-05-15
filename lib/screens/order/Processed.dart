import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';
import 'package:meat4u_vendor/utils/constant.dart';
import 'package:provider/provider.dart';

import '../../Model/firebaseOperations.dart';
import '../../Model/globalhelper.dart';
import 'oder_full_detail.dart';

class ProcessedScrn extends StatefulWidget {
  static String routeName = '/ProcessedScrn';
  const ProcessedScrn({Key? key}) : super(key: key);

  @override
  State<ProcessedScrn> createState() => _ProcessedScrnState();
}

class _ProcessedScrnState extends State<ProcessedScrn> {
  bool isReadMore = false;
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const BackButton(),
          title:
              Text("Processed", style: headline1ExtraLarge(context: context)),
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("Orders")
              .where("vendorId",
                  isEqualTo:
                      FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
              .where('orderProcess', isEqualTo: true)
              .where("orderAccept", isEqualTo: true)
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
                        // log(data['orderId'].toString());\
                        var orderTime = DateTime.fromMillisecondsSinceEpoch(
                            data['orderTime']);
                        var date = DateFormat('dd-MM-yyyy').format(orderTime);
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
                                                0, Colors.orange, 10),
                                            child: Center(
                                              child: Text(
                                                'Process',
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
          },
        ));
  }
}
