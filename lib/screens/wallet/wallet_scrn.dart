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

import 'withdrawalwallet.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List paymentList = [];
  List<double> dataSum = <double>[];

  double totalAmnt = 0;
  double discountPrice = 0.0;
  double finalPrice = 0;
  Future<void> _getPamentsCalculation() async {
    await FirebaseFirestore.instance
        .collection("Orders")
        .where('vendorId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .where('orderRejected', isEqualTo: false)
        // .where('isPaid', isEqualTo: true)

        // .orderBy("createdAt", descending: true)
        .get()
        .then((value) {
      paymentList.clear();

      for (var doc in value.docs) {
        paymentList.add(doc.data()['orderPrice']);

        // log(paymentList.toString());
        int numLists = paymentList.length;

        double sum;

        for (var i = 0; i < numLists; i++) {
          sum = 0.0;
          for (var j = 0; j < numLists; j++) {
            sum += paymentList[j];
          }
          dataSum.add(sum);
        }

        totalAmnt = dataSum.last;
        discountPrice = ((totalAmnt * 15) / 100);
        finalPrice = totalAmnt - discountPrice;
        _getProfileData().then((value) {
          _getWithdrawalAmount().then((value) {
            updateVendorBalance().then((value) {
              getVendorIncome();
            });
          });
        });

        // output
        log(finalPrice.toString());
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  var totalAmount = 0;
  Map? vendorData = {};
  Future<void> _getProfileData() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          vendorData = value.data()!;
          // totalAmount = vendorData!['walletAmount'];
          // ignore: avoid_print

          log(vendorData!['accountName'].toString());
        });
      }
    });
  }

  double withdrawalAmount = 0.0;
  List<dynamic> dataSum2 = <dynamic>[];

  List<dynamic> withdrawalAmountList = [];
  Future<void> _getWithdrawalAmount() async {
    await FirebaseFirestore.instance
        .collection("VendorWithdrawRequest")
        .where('vendorId',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .where('withdrawalSuccess', isEqualTo: true)
        .get()
        .then((value) {
      withdrawalAmountList.clear();
      for (var doc in value.docs) {
        withdrawalAmountList.add(doc.data()['amount']);
        log('sssss${doc.data()}');

        if (mounted) {
          setState(() {});
        }

        int numLists = withdrawalAmountList.length;

        double sum;
        for (var i = 0; i < numLists; i++) {
          sum = 0.0;
          for (var j = 0; j < numLists; j++) {
            sum += withdrawalAmountList[j];
          }
          dataSum2.add(sum);
        }

        withdrawalAmount = dataSum2.last;

        // var riderAmnt = 0.0;
        // for (var element in withdrawalAmountList) {
        //   log('mmmmm${element}');

        //   riderAmnt += element;
        //   if (mounted) {
        //     setState(() {});
        //   }
        // }

        log('mmmmm$withdrawalAmount');
      }
    });
  }

  Future<void> updateVendorBalance() async {
    await FirebaseFirestore.instance
        .collection('VendorTotalAmount')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "amount": finalPrice - withdrawalAmount,
      "vendorName": vendorData!['accountName'],
      "date": Timestamp.now(),
      'vendorId': FirebaseAuth.instance.currentUser!.uid.substring(0, 20)
    }).then((value) {
      log(vendorData!['accountName'].toString());
    });
  }

  Map? VendorIncomeData = {};
  double vendorAmnt = 0.0;

  bool isLoaded = false;

  Future<void> getVendorIncome() async {
    await FirebaseFirestore.instance
        .collection('VendorTotalAmount')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          VendorIncomeData = value.data()!;
          isLoaded = true;
          // totalAmount = vendorData!['walletAmount'];
          // ignore: avoid_print
          vendorAmnt = VendorIncomeData!['amount'];

          log(VendorIncomeData!['amount'].toString());
        });
      }
    });
  }
  // double walletBalance = 0.0;

  // bool isLoaded = false;

  // Future<void> getVendorIncome() async {
  //   await FirebaseFirestore.instance
  //       .collection('VendorTotalAmount')
  //       .where('vendorId',
  //           isEqualTo: FirebaseAuth.instance.currentUser!.uid.substring(0, 20))

  //       .get()
  //       .then((value) {
  //     if (value.docs.isNotEmpty) {
  //       setState(() {
  //         walletBalance = 0;

  //         for (var docs in value.docs) {
  //           walletBalance +=
  //               double.parse(docs['productPrice']) * docs['orderQuantity'];
  //         }
  //         isLoaded = true;
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    // _getWithdrawalAmount();
    _tabController = TabController(length: 2, vsync: this);

    _getPamentsCalculation();
    super.initState();
  }

  List _tabList = ['Payment history', 'Withdrawal history'];

  @override
  Widget build(BuildContext context) {
    // final double totalBalance = (VendorIncomeData!.isEmpty
    //     ? 0.0
    //     : VendorIncomeData!['amount'] - withdrawalAmount);
    // log('ssssss$totalBalance');
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Your Balance',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                      Text(
                        'Admin Commission 15%',
                        style: bodyText12Small(color: white),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dataSum.isEmpty || VendorIncomeData!.isEmpty
                          ? const Text('Rs. 0.0',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600))
                          : Text('Rs ${vendorAmnt.toStringAsFixed(1)}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600)),
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, WithdrawalScrn.routeName);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WithdrawalScrn(
                                        totalAmount:
                                            VendorIncomeData!['amount'],
                                      )));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 15.0,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.wallet,
                              color: black,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text('Withdraw',
                                style: bodytext12Bold(color: black)),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: SizedBox(
              height: scHeight(context) * 0.041,
              // width: scWidth(context) * 0.95,
              child: TabBar(
                  controller: _tabController,
                  indicatorWeight: 0,
                  indicatorPadding: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  indicatorColor: textColor,
                  unselectedLabelColor: textColor,
                  indicator: BoxDecoration(
                      color: primary, borderRadius: BorderRadius.circular(8)),
                  labelStyle: bodyText2Bold(context: context, color: primary),
                  unselectedLabelStyle: bodyText2(context: context),
                  isScrollable: false,
                  tabs: _tabList.map((e) {
                    return Tab(
                      child: Container(
                          width: scWidth(context) * 0.6,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: primary)),
                          child: Text(e)),
                    );
                  }).toList()),
            ),
          ),
          isLoaded == true
              ? SizedBox(
                  height: scHeight(context) * 0.7,
                  child: TabBarView(controller: _tabController, children: [
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('Orders')
                            .where('vendorId',
                                isEqualTo: FirebaseAuth
                                    .instance.currentUser!.uid
                                    .substring(0, 20))
                            .where('orderAccept', isEqualTo: true)
                            .orderBy('orderId', descending: true)

                            // .where('isPaid', isEqualTo: true)
                            .where('orderRejected', isEqualTo: false)
                            .snapshots(),
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            final data = snapshot.data!.docs;
                            log(data.toString());
                            return SizedBox(
                              height: height(context) * 0.7,
                              child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, i) {
                                    final paymentDate =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            data[i]['orderTime']);

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 8),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 12),
                                      height: height(context) * 0.12,
                                      width: width(context) * 0.92,
                                      decoration: BoxDecoration(
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 5)
                                          ]),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                    color:
                                                        black.withOpacity(0.4)),
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Received from',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Text(
                                                data[i]['userName'],
                                                style: TextStyle(),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Rs. ${(double.parse(data[i]['productPrice']) * data[i]['orderQuantity']).toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                RichText(
                                                    text: TextSpan(children: [
                                                  TextSpan(
                                                      text: 'Credited to ',
                                                      style: TextStyle(
                                                          color:
                                                              black.withOpacity(
                                                                  0.4))),
                                                  TextSpan(
                                                      text: 'XXXX',
                                                      style: TextStyle(
                                                          color: black,
                                                          fontWeight:
                                                              FontWeight.w500)),
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
                        }),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('VendorWithdrawRequest')
                            .where('vendorId',
                                isEqualTo: FirebaseAuth
                                    .instance.currentUser!.uid
                                    .substring(0, 20))
                            .orderBy('paymentId', descending: true)
                            .snapshots(),
                        builder: (ctx, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            final data = snapshot.data!.docs;
                            log(data.toString());
                            return SizedBox(
                              height: height(context) * 0.7,
                              child: ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, i) {
                                    var stamp = data[i]['date'].toDate();
                                    var orderTime =
                                        DateFormat('dd-MM-yyyy').format(stamp);
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 8),
                                      height: scWidth(context) * 0.4,
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                textLightColor.withOpacity(0.3),
                                            blurRadius: 8.0,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Withdrawal Request',
                                                    style: bodyText1(
                                                        context: context),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 8,
                                                    left: 23,
                                                    right: 23),
                                                color: data[i]
                                                        ['withdrawalSuccess']
                                                    ? Colors.green
                                                    : Colors.orange,
                                                // color: modal.status != 'Pending'
                                                //     ? Colors.green
                                                //     : const Color(0xFFFEA968),
                                                child: Text(
                                                  data[i]['withdrawalSuccess']
                                                      ? 'Completed'
                                                      : 'Pending',
                                                  style: bodyText3(
                                                      color: Colors.white,
                                                      context: context),
                                                ),
                                              )
                                            ],
                                          ),
                                          const Divider(
                                            thickness: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Payment ID : ${data[i]['paymentId']}",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                              Text(orderTime.toString(),
                                                  style:
                                                      TextStyle(fontSize: 11)),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '',
                                                // data[i]['orderName'],
                                                style: bodyText1(
                                                  color: Colors.grey,
                                                  context: context,
                                                ),
                                              ),
                                              Text(
                                                'Rs.${data[i]['amount']}',
                                                style: bodyText1Bold(
                                                    context: context),
                                              )
                                            ],
                                          ),
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
                  ]),
                )
              : Center(child: CircularProgressIndicator()),
        ])));
  }
}
