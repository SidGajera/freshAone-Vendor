import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:meat4u_vendor/utils/constant.dart';
import 'package:meat4u_vendor/screens/order/Delivered.dart';
import 'package:meat4u_vendor/screens/order/neworder.dart';
import 'package:meat4u_vendor/screens/order/oder_full_detail.dart';
import 'package:meat4u_vendor/screens/order/Processed.dart';
import 'package:meat4u_vendor/screens/order/cancelled_order.dart';
import 'package:meat4u_vendor/screens/order/received_order.dart';
import 'package:meat4u_vendor/screens/order/returned.dart';
import 'package:meat4u_vendor/screens/order/shipped.dart';
import 'package:provider/provider.dart';

import '../../Model/globalhelper.dart';

class OrdersScrn extends StatefulWidget {
  static String routeName = '/OrdersScrn';
  const OrdersScrn({
    Key? key,
  }) : super(key: key);

  @override
  State<OrdersScrn> createState() => _OrdersScrnState();
}

class _OrdersScrnState extends State<OrdersScrn> {
  Map usersData = {};
  bool? isvendorOnline;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: primary,
              )),
        ],
        title: Text("Orders", style: headline1ExtraLarge(context: context)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 33,
            left: 25,
            right: 25,
          ),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomCard(
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NewOrderScreen()));
                  },
                  height: scHeight(context) / 10,
                  width: scWidth(context) / 5,
                  image: 'assets/images/order.png',
                  text: 'New Orders',
                  text2: Sneworder,
                ),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where("vendorId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20))
                        .where('orderAccept', isEqualTo: true)
                        .snapshots(),
                    builder: (cxt, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        return CustomCard(
                          ontap: () {
                            Navigator.pushNamed(
                                context, ReceivedoderScrn.routeName);
                          },
                          height: scHeight(context) / 10,
                          width: scWidth(context) / 5,
                          image: 'assets/images/oderresive.png',
                          text: 'Received',
                          text2: data!.size.toString(),
                        );
                      }
                      return CircularProgressIndicator();
                    }),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where('vendorId',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20))
                        .where('orderProcess', isEqualTo: true)
                        .snapshots(),
                    builder: (cxt, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        return CustomCard(
                          ontap: () {
                            Navigator.pushNamed(
                                context, ProcessedScrn.routeName);
                          },
                          height: scHeight(context) * 0.1,
                          width: scWidth(context) / 5,
                          image: 'assets/images/Proced.png',
                          text: 'Processed',
                          text2: data!.size.toString(),
                        );
                      }
                      return CircularProgressIndicator();
                    }),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where("vendorId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20))
                        .where('orderShipped', isEqualTo: true)
                        .where('orderAccept', isEqualTo: true)
                        .where('orderCancelled', isEqualTo: false)
                        .snapshots(),
                    builder: (cxt, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        return CustomCard(
                          ontap: () {
                            Navigator.pushNamed(context, ShippedScrn.routeName);
                          },
                          height: scHeight(context) / 10,
                          width: scWidth(context) / 5,
                          image: 'assets/images/shhiped.png',
                          text: 'Shipped',
                          text2: data!.size.toString(),
                        );
                      }
                      return CircularProgressIndicator();
                    }),
              ],
            ),
            const SizedBox(
              height: 26,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where("vendorId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20))
                        .where('orderCompleted', isEqualTo: true)
                        .snapshots(),
                    builder: (cxt, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        return CustomCard(
                          ontap: () {
                            Navigator.pushNamed(
                                context, DeliveredScrn.routeName);
                          },
                          height: scHeight(context) / 9,
                          width: scWidth(context) / 3.6,
                          image: 'assets/images/deliverd.png',
                          text: 'Delivered',
                          text2: data!.size.toString(),
                        );
                      }
                      return CircularProgressIndicator();
                    }),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where("vendorId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20))
                        .where('orderCancelled', isEqualTo: true)
                        .snapshots(),
                    builder: (cxt, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        return CustomCard(
                          ontap: () {
                            Navigator.pushNamed(
                                context, CancelledorderScrn.routeName);
                          },
                          height: scHeight(context) / 9,
                          width: scWidth(context) / 3.6,
                          image: 'assets/images/Cancle.png',
                          text: ' Cancelled',
                          text2: data!.size.toString(),
                        );
                      }
                      return CircularProgressIndicator();
                    }),
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('Orders')
                        .where("vendorId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid
                                .substring(0, 20))
                        .where('orderReturn', isEqualTo: true)
                        .snapshots(),
                    builder: (cxt, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        return CustomCard(
                          ontap: () {
                            Navigator.pushNamed(
                                context, ReturnedScrn.routeName);
                          },
                          height: scHeight(context) / 9,
                          width: scWidth(context) / 3.6,
                          image: 'assets/images/return.png',
                          text: 'Returned',
                          text2: data!.size.toString(),
                        );
                      }
                      return CircularProgressIndicator();
                    }),
              ],
            ),
            const SizedBox(
              height: 26,
            ),
            const SizedBox(
              height: 26,
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection("Orders")
                  .where("vendorId",
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid
                          .substring(0, 20))
                  .orderBy('orderId', descending: true)
                  .snapshots(),
              // .where("orderCompleted", isEqualTo: true)

              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  Text(snapshot.error.toString());
                }
                if (snapshot.hasData) {
                  final data = snapshot.data!.docs;

                  return SizedBox(
                    height: scHeight(context) * 0.5,
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (ctx, i) {
                          var orderTime = DateTime.fromMillisecondsSinceEpoch(
                              data[i]['orderTime']);
                          var date = DateFormat('dd-MM-yyyy').format(orderTime);
                          return Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.only(
                              top: 10,
                              left: 20,
                              right: 20,
                            ),
                            height: 170,
                            width: 370,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: textLightColor.withOpacity(0.3),
                                    blurRadius: 8.0,
                                  ),
                                ],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order ID- ${data[i]['orderId']}',
                                      style: bodyText2(context: context),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 17, vertical: 7),
                                      decoration: BoxDecoration(
                                          color: data[i]['orderCancelled'] ==
                                                  true
                                              ? Colors.red
                                              : data[i]['orderCompleted'] ==
                                                      true
                                                  ? const Color(0xFF4AAF57)
                                                  : data[i]['orderAccept'] ==
                                                          true
                                                      ? Colors.blue
                                                      : Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Text(
                                        data[i]['orderCancelled'] == true
                                            ? 'Cancelled'
                                            : data[i]['orderCompleted'] == true
                                                ? 'Completed'
                                                : data[i]['orderAccept'] == true
                                                    ? 'Receive'
                                                    : 'New',
                                        style: bodyText3(
                                            color: Colors.white,
                                            context: context),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      //  ?? '',
                                      data[i]['userName'].toString(),
                                      style: bodyText1Bold(context: context),
                                    ),
                                    Text(
                                      // snapshot.data()['userMobile'] ?? '',
                                      data[i]['userNumber'].toString(),
                                      style: headline1Normal(context: context),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: data[i]['userName'].toString(),
                                          style: bodyText(
                                              color: Colors.grey,
                                              context: context),
                                          children: [
                                            TextSpan(
                                                text:
                                                    'Rs.${(double.parse(data[i]['productPrice']) * data[i]['orderQuantity'])}',
                                                style:
                                                    bodyText(context: context))
                                          ]),
                                    ),
                                    // Text(
                                    //   snapshot.data()['paymentMode'],
                                    //   style: headline1Normal(context: context),
                                    // )
                                  ],
                                ),
                                RichText(
                                  text: TextSpan(
                                      text: "Order Date:    ",
                                      style: bodyText(
                                          color: Colors.grey, context: context),
                                      children: [
                                        TextSpan(
                                            text: date,

                                            /* '${_numberToMonthMap[date.month]} ${date.day} ${date.year}' */
                                            style: bodyText(context: context))
                                      ]),
                                ),
                              ],
                            ),
                          );
                        }),
                  );
                }
                // if (snapshot.data!.docs.length == 0) {
                //   return Provider.of<GlobalHelper>(context, listen: false)
                //       .nodatta();
                // }

                // return ListView(
                //   shrinkWrap: true,
                //   children: snapshot.data!.docs.map((e) {
                //     return OrderPlaced(
                //       snapshot: e,
                //       index: 1,
                //     );
                //   }).toList(),
                // );
                return CircularProgressIndicator();
              },
            )
          ]),
        ),
      ),
    );
  }
}

class OrderPlaced extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> snapshot;
  int index;
  OrderPlaced({Key? key, required this.snapshot, required this.index})
      : super(key: key);

  List items = [];
  @override
  Widget build(BuildContext context) {
    Timestamp t = snapshot.data()['orderedOn'];
    DateTime date = t.toDate();
    items = snapshot.data()["order"];
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
      ),
      height: 170,
      width: 370,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: textLightColor.withOpacity(0.3),
              blurRadius: 8.0,
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order ID- ${snapshot.id}',
                style: bodyText2(context: context),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                decoration: BoxDecoration(
                    color: const Color(0xFF4AAF57),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  "Completed",
                  style: bodyText3(color: Colors.white, context: context),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                snapshot.data()['userName'] ?? '',
                style: bodyText1Bold(context: context),
              ),
              Text(
                snapshot.data()['userMobile'] ?? '',
                style: headline1Normal(context: context),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                    text: snapshot.data()['userName'],
                    style: bodyText(color: Colors.grey, context: context),
                    children: [
                      TextSpan(
                          text: "Rs${snapshot.data()['price']}",
                          style: bodyText(context: context))
                    ]),
              ),
              Text(
                snapshot.data()['paymentMode'],
                style: headline1Normal(context: context),
              )
            ],
          ),
          RichText(
            text: TextSpan(
                text: "Order Date:    ",
                style: bodyText(color: Colors.grey, context: context),
                children: [
                  TextSpan(
                      text: snapshot.data()['orderedOn'].toDate().toString(),

                      /* '${_numberToMonthMap[date.month]} ${date.day} ${date.year}' */
                      style: bodyText(context: context))
                ]),
          ),
        ],
      ),
    );
  }
}
