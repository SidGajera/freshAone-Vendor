import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../utils/constant.dart';

class VendorService with ChangeNotifier {
  var orderId;

  void addVendorData({
    String? categoryName,
    String? vendorAddress,
    String? vendorClosingTime,
    String? vendorEmail,
    String? vendorId,
    String? vendorImage,
    String? vendorName,
    bool? vendorOnline,
    String? vendorOpeningTime,
    String? vendorPhone,
    List? vendorProducts,
  }) async {
    FirebaseFirestore.instance
        .collection('vendorsCategories')
        .doc(FirebaseAuth.instance.currentUser!.uid
        .substring(0, 20))

        // .collection(cartId.toString() + cartName!)
        // .doc()
        .update({
      'list': FieldValue.arrayUnion([
        {
          "categoryName": categoryName,
          "vendorAddress": vendorAddress,
          "vendorClosingTime": vendorClosingTime,
          "vendorEmail": vendorEmail,
          "vendorId": vendorId,
          "vendorImage": vendorImage,
          "vendorName": vendorName,
          "vendorOnline": vendorOnline,
          "vendorOpeningTime": vendorOpeningTime,
          "vendorPhone": vendorPhone,
          "vendorProducts": vendorProducts,
        }
      ])
    });

    notifyListeners();
  }

  /*  void OrderData({List? orderData}) async {
    // orderId = UniqueKey().toString().substring(0, 5);
    FirebaseFirestore.instance
        .collection('Orders')
        .doc(FirebaseAuth.instance.currentUser!.uid
            .substring(0, 20)) // + orderId
        // .collection(orderId)
        // .doc()
        .set(
      {'order': FieldValue.arrayUnion(orderData!)},
    );
    notifyListeners();
  } */

  deleteCartData() async {
    await FirebaseFirestore.instance
        .collection('Cart Details')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .delete();

    notifyListeners();
  }
}
