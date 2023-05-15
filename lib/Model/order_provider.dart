import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  List totalItemsList = [];
  List outStockItemsList = [];

  List<String> totalProductIdsList = [];
  List<String> outStockProductIdsList = [];

  Future<void> fetchTotalProducts() async {
    await _firebaseFirestore
        .collection("products")
        .where("vendorId",
            isEqualTo: _firebaseAuth.currentUser?.uid.substring(0, 20))
        .get()
        .then((value) {
      totalItemsList.clear();
      totalProductIdsList.clear();
      for (var doc in value.docs) {
        totalItemsList.add(doc.data());
        totalProductIdsList.add(doc.id);
      }
      log(totalItemsList.toString());
    });
    notifyListeners();
  }

  Future<void> fetchOutOfStockProducts() async {
    await _firebaseFirestore
        .collection("products")
        .where("vendorId",
            isEqualTo: _firebaseAuth.currentUser?.uid.substring(0, 20))
        .where("quantity", isEqualTo: 0)
        .get()
        .then((value) {
      outStockItemsList.clear();
      outStockProductIdsList.clear();
      for (var doc in value.docs) {
        outStockItemsList.add(doc.data());
        outStockProductIdsList.add(doc.id);
      }
      log(outStockItemsList.toString());
    });
    notifyListeners();
  }

  // Add Product
  Future<void> addNewProduct(Map<String, dynamic> map, String docId) async {
    await _firebaseFirestore
        .collection("productitems")
        .doc(docId)
        .set(map)
        .then((value) {
      Fluttertoast.showToast(msg: "Product Added");
    });
    notifyListeners();
  }

  // Add Product

  Future<void> updateProduct(String docId, Map<String, dynamic> map) async {
    await _firebaseFirestore
        .collection("products")
        .doc(docId)
        .update(map)
        .then((value) {
      Fluttertoast.showToast(msg: "Updated");
    });
    notifyListeners();
  }

  // fetchCategory
  List categoryList = [];
  Future<void> fetchCategory() async {
    await _firebaseFirestore
        .collection("essentialCategory")
        .get()
        .then((value) {
      categoryList.clear();

      for (var doc in value.docs) {
        categoryList.add(doc.data());
      }
      log(categoryList.toString());
    });
    notifyListeners();
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class OrderProvider with ChangeNotifier {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

//   List totalOrderList = [];
//   List readyOrderList = [];
//   List pickedOrderList = [];
//   List totalOrderDocList = [];


//   Future<void> fetchTotalOrders() async {
//     await _firebaseFirestore
//         .collection("orders")
//         .where("vendorId",
//             isEqualTo: _firebaseAuth.currentUser?.uid.substring(0, 20))
//         .get()
//         .then((value) {
//       totalOrderList.clear();
//       totalOrderDocList.clear();
//       for (var doc in value.docs) {
//         totalOrderList.add(doc.data());
//         totalOrderDocList.add(doc.id);
//       }
//       notifyListeners();
//       log(totalOrderList.length.toString());
//     });

//   }
//   Future<void> fetchReadyOrders() async {
//     await _firebaseFirestore
//         .collection("orders")
//         .where("vendorId",
//             isEqualTo: _firebaseAuth.currentUser?.uid.substring(0, 20))
//         .where("status",
//             isEqualTo: "ready")
//         .get()
//         .then((value) {
//       readyOrderList.clear();
//       for (var doc in value.docs) {
//         readyOrderList.add(doc.data());
//       }
//       notifyListeners();
//       log(readyOrderList.length.toString());
//     });

//   }
//   Future<void> fetchPickedOrders() async {
//     await _firebaseFirestore
//         .collection("orders")
//         .where("vendorId",
//             isEqualTo: _firebaseAuth.currentUser?.uid.substring(0, 20))
//         .where("status",
//         isEqualTo: "picked")
//         .get()
//         .then((value) {
//       pickedOrderList.clear();
//       for (var doc in value.docs) {
//         pickedOrderList.add(doc.data());
//       }
//       notifyListeners();
//       log(pickedOrderList.length.toString());
//     });

//   }






//   List paymentList = [];

//   Future<void> fetchPaymentHistory() async {
//     await _firebaseFirestore
//         .collection("payments")
//         .where("vendorId",
//             isEqualTo: _firebaseAuth.currentUser?.uid.substring(0, 20))
//         .get()
//         .then((value) {
//       paymentList.clear();
//       for (var doc in value.docs) {
//         paymentList.add(doc.data());
//       }
//       log(paymentList.toString());
//     });
//     notifyListeners();
//   }

//   // updating order

//  Future<void> updateOrder(String doc,Map<String,dynamic> data)async {
//     await _firebaseFirestore.collection("orders").doc(doc).update(data);
//  }
// }