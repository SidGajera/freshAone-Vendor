import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:meat4u_vendor/utils/constant.dart';

class FirebaseOperation with ChangeNotifier {
  // String uid = FirebaseAuth.instance.currentUser!.uid.substring(0, 20);

  Future saveRestroDetails(Map<String, dynamic> data) async {
    return await FirebaseFirestore.instance
        .collection("vendors")
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .set(data);
  }

  Future acceptOrder(
      String docId, String address, double lat, double long) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(docId)
        .update({
      "orderAccept": true,
      'orderAccepted': true,
      "acceptTime": DateFormat('hh:mm a').format(DateTime.now()),
      "vendorLocation": address,
      "vendorLatitude": lat,
      "vendorLongitude": long
    });
  }

  // Map? productData;
  // _getProductData() {
  //   FirebaseFirestore.instance
  //       .collection('productitems')
  //       // .where("orderId",
  //       //     isEqualTo: "1670395534503073")
  //       .get()
  //       .then((value) {
  //     log(value.toString());
  //     productData = value.docs.first.data();
  //     log("mrunal${productData}");
  //   });
  //   log(productData!['quantity'].toString());
  //   // log(snapshot.hasData.toString());
  //   notifyListeners();
  // }

  // Future updateQuantity(String docId) async {
  //   return await FirebaseFirestore.instance
  //       .collection("productitems")
  //       .doc(docId)
  //       .update({
  //     'quantity': productData!['quantity'] - 1,
  //   });
  // }

  // notifyListeners();

  Future returnOrder(String docId) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(docId)
        .update({"orderReturn": true});
  }

  Future<String> getToken(String docId) async {
    String token = '';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .get()
        .then((value) {
      token = value.data()!['token'];
    });
    return token;
  }

  Future<String> getRiderToken(String docId) async {
    String token = '';
    await FirebaseFirestore.instance
        .collection('rider')
        .doc(docId)
        .get()
        .then((value) {
      token = value.data()!['token'];
    });
    return token;
  }

  Future rejectOrder(String docId) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(docId)
        .update({
      "orderRejected": true,
      "rejectTime": DateTime.now().millisecondsSinceEpoch
    });
  }

  Future shippedOrder(String docId) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(docId)
        .update(
            {"orderShipped": true, "shippedTime": DateTime.now().toString()});
  }

  Future readyOrder(String docId) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(docId)
        .update({
      "orderProcess": true,
      "readyTime": DateTime.now().millisecondsSinceEpoch
    });
  }

  Future deliveredOrder(String docId) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(docId)
        .update({
      "orderDelivered": true,
      "deliveredTime": DateTime.now().millisecondsSinceEpoch
    });
  }

  Future readOrder(String docId, List<Map<String, dynamic>> itemList) async {
    return await FirebaseFirestore.instance
        .collection("Orders")
        .doc(docId)
        .update({
      "orderActive": true,
      "order": itemList,
      "orderReadyTime": DateTime.now().millisecondsSinceEpoch
    });
  }

  saveToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return await FirebaseFirestore.instance
        .collection("vendors")
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .update({"token": token});
  }

  Future changeOnlineStatus(bool curr) async {
    return await FirebaseFirestore.instance
        .collection("vendors")
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .update({"isOnline": curr});
  }

  /* saveToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    return await FirebaseFirestore.instance
        .collection("vendors")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"token": token});
  } */
  /* Future saveRestroDetails(Map<String, dynamic> data) async {
    return await FirebaseFirestore.instance
        .collection("vendors")
        .doc(uid)
        .set(data);
  }

 Future acceptOrder(String docId) async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .doc(docId)
        .update({
      "cookingStatus": "PREPARING",
      "restaurantAcceptTime": DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<String> getToken(String docId) async {
    String token = '';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .get()
        .then((value) {
      token = value.data()!['token'];
    });
    return token;
  }

  Future rejectOrder(String docId) async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .doc(docId)
        .update({
      "cookingStatus": "REJECTED",
      "restaurantRejectTime": DateTime.now().millisecondsSinceEpoch
    });
  }

  Future readOrder(String docId, List<Map<String, dynamic>> itemList) async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .doc(docId)
        .update({
      "cookingStatus": "PREPARED",
      "items": itemList,
      "orderReadyTime": DateTime.now().millisecondsSinceEpoch
    });
  }
 */

}
