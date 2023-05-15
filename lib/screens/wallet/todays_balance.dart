import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import 'package:meat4u_vendor/utils/constant.dart';
import 'package:provider/provider.dart';

import '../../component/custom_app_bar.dart';
import 'withdrawalwallet.dart';

class TodaysBalance extends StatefulWidget {
  TodaysBalance({super.key});

  @override
  State<TodaysBalance> createState() => _TodaysBalanceState();
}

class _TodaysBalanceState extends State<TodaysBalance> {
  List paymentList = [];
  List transactions = [];
  List<double> dataSum = <double>[];

  double totalAmnt = 0;
  double discountPrice = 0.0;
  double finalPrice = 0;
  Future<void> _getPamentsCalculation() async {
    print(FirebaseAuth.instance.currentUser!.uid.substring(0, 20));
    await FirebaseFirestore.instance
        .collection("Orders")
        .where('vendorId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .where('orderRejected', isEqualTo: false)
        .where('orderAccept', isEqualTo: true)
        // .where('isPaid', isEqualTo: true)
        .get()
        .then((value) {
      paymentList.clear();
      // paymentDocId.clear();

      for (var doc in value.docs) {
        // log(DateFormat('dd-MM-yyyy').format(doc.data()["time"].toDate()));
        // log(DateFormat('dd-MM-yyyy').format(DateTime.now()));
        // log(DateFormat('dd-MM-yyyy').format(doc['createdAt'].toDate()));
        print(DateTime.fromMillisecondsSinceEpoch(doc.data()["orderTime"]));
        if (DateFormat('dd-MM-yyyy').format(
                DateTime.fromMillisecondsSinceEpoch(doc.data()["orderTime"])) ==
            DateFormat('dd-MM-yyyy').format(DateTime.now())) {
          finalPrice += (double.parse(doc.data()['productPrice'].toString()) *
              doc.data()['orderQuantity']);
        }
      }

      setState(() {});
      // }

      // notifyListeners();
    });
  }

  @override
  void initState() {
    _getPamentsCalculation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Wallet'),
          backgroundColor: white,
          foregroundColor: black,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            height: height(context) * 0.12,
            width: width(context) * 0.95,
            decoration: BoxDecoration(
                color: primary,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2,
                      offset: const Offset(1, 5)),
                ],
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Your Balance',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rs ${finalPrice} ',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600)),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.pushNamed(context, WithdrawalScrn.routeName);
                    //     // Navigator.push(
                    //     //     context,
                    //     //     MaterialPageRoute(
                    //     //         builder: (context) => WithDrawScreen()));
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(25),
                    //     ),
                    //     elevation: 15.0,
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       Icon(
                    //         Icons.wallet,
                    //         color: black,
                    //       ),
                    //       const SizedBox(
                    //         width: 5,
                    //       ),
                    //       Text('Withdraw', style: bodytext12Bold(color: black)),
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Orders')
                  .where('vendorId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid
                          .substring(0, 20))
                  // .where('isPaid', isEqualTo: true)
                  .where('orderRejected', isEqualTo: false)
                  .where('orderAccept', isEqualTo: true)
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  // final data = snapshot.data!.docs;
                  final temp = snapshot.data!.docs;
                  final data = temp
                      .where((element) =>
                          DateFormat('dd-MM-yyyy').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  element["orderTime"])) ==
                          DateFormat('dd-MM-yyyy').format(DateTime.now()))
                      .toList();
                  log(data.toString());
                  return SizedBox(
                    height: height(context) * 0.7,
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, i) {
                          final paymentDate =
                              DateTime.fromMillisecondsSinceEpoch(
                                  data[i]["orderTime"]);
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            padding: const EdgeInsets.symmetric(
                                vertical: 1, horizontal: 12),
                            height: height(context) * 0.12,
                            width: width(context) * 0.92,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(color: Colors.grey, blurRadius: 5)
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 21,
                                    ),
                                    const Icon(
                                      Icons.credit_score_outlined,
                                      size: 40,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(paymentDate),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: black.withOpacity(0.4)),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Received from',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      data[i]['userName'],
                                      style: TextStyle(),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Rs. ${data[i]['productPrice'] * data[i]['orderQuantity']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: 'Credited to ',
                                            style: TextStyle(
                                                color: black.withOpacity(0.4))),
                                        TextSpan(
                                            text: 'XXXX',
                                            style: TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.w500)),
                                      ]))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              })
        ])));
  }
}
