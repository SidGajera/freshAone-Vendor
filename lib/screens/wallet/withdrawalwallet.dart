// ignore_for_file: prefer_final_fields, depend_on_referenced_packages

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meat4u_vendor/screens/wallet/wallet_scrn.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:intl/intl.dart';
import '../../component/custom_button.dart';
import '../../utils/constant.dart';

class WithdrawalScrn extends StatefulWidget {
  static String routeName = '/WithdrawalScrn';

  final dynamic? totalAmount;
  const WithdrawalScrn({Key? key, this.totalAmount}) : super(key: key);

  @override
  State<WithdrawalScrn> createState() => _WithdrawalScrnState();
}

class _WithdrawalScrnState extends State<WithdrawalScrn> {
  Razorpay? _razorpay;
  TextEditingController _amountController = TextEditingController(text: '100');
  var totalAmount = 0;
  Map? vendorData;

  String formatDate = DateFormat('yyyy-MM-dd | kk:mm').format(DateTime.now());

  _getProfileData() async {
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

  @override
  void initState() {
    log(widget.totalAmount.toString());
    super.initState();
    _getProfileData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Withdrawal Wallet',
          style: headline1(context: context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Text(
              'Enter the amount of withdrawal',
              style: bodyText2(context: context),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: headline1ExtraLarge(color: primary, context: context),
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: primary)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(color: primary)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 2.2),
              children: [
                buildAmountCard('100' == _amountController.text, "100"),
                buildAmountCard('200' == _amountController.text, "200"),
                buildAmountCard('300' == _amountController.text, "300"),
                buildAmountCard('400' == _amountController.text, "400"),
                buildAmountCard('500' == _amountController.text, "500"),
                buildAmountCard('600' == _amountController.text, "600"),
                buildAmountCard('700' == _amountController.text, "700"),
                buildAmountCard('800' == _amountController.text, "800"),
                buildAmountCard('900' == _amountController.text, "900"),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
                text: 'Continue',
                ontap: () {
                  log(double.parse(widget.totalAmount.toString()).toString());
                  if (double.parse(_amountController.text) >
                      double.parse(widget.totalAmount.toString())) {
                    Fluttertoast.showToast(
                        msg:
                            'Your balance is less than withdrawal amount please enter valid amount');
                  } else if (int.parse(_amountController.text) > 0) {
                    FirebaseFirestore.instance
                        .collection('VendorWithdrawRequest')
                        .doc()
                        .set({
                      "amount": double.parse(_amountController.text.trim()),
                      "date": Timestamp.now(),
                      "vendorName": vendorData!['accountName'],
                      'vendorId': FirebaseAuth.instance.currentUser!.uid
                          .substring(0, 20),
                      'withdrawalSuccess': false,
                      'paymentId': DateTime.now().millisecondsSinceEpoch
                    }).then((value) {
                      Fluttertoast.showToast(
                          msg: 'Withdrawal request has been send successfully');
                      Navigator.pop(context);
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }

  InkWell buildAmountCard(bool selected, String amount) {
    return InkWell(
        onTap: () {
          _amountController.text = amount;
          setState(() {});
        },
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: primary,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: const BorderSide(color: primary))),
          onPressed: () {
            _amountController.text = amount;
            setState(() {});
          },
          child: Text("Rs. $amount", style: bodyText2(context: context)),
        ));
  }
}

class WalletModal {
  String text;
  WalletModal({required this.text});
}

List walletAmountList = [
  WalletModal(text: 'Rs.10'),
  WalletModal(text: 'Rs.100'),
  WalletModal(text: 'Rs.300'),
  WalletModal(text: 'Rs.400'),
  WalletModal(text: 'Rs.500'),
  WalletModal(text: 'Rs.600'),
  WalletModal(text: 'Rs.700'),
  WalletModal(text: 'Rs.800'),
  WalletModal(text: 'Rs.900'),
];
