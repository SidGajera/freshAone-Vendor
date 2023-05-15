// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../Model/firebaseOperations.dart';
import '../../Model/globalhelper.dart';
import '../../utils/constant.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({Key? key}) : super(key: key);

  @override
  NewOrderScreenState createState() => NewOrderScreenState();
}

class NewOrderScreenState extends State<NewOrderScreen> {
  void initState() {
    // _getNewOrder();

    _getProfileData();
    super.initState();
  }

  Map? vendorData;
  _getProfileData() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get()
        .then((value) {
      if (value.exists) {
        if (mounted) {
          setState(() {
            vendorData = value.data()!;
            // ignore: avoid_print
            // print(vendorData);
          });
        }
      }
    });
  }

  List<dynamic> items = [];

  _addNotificationData(String userId, String title) async {
    await FirebaseFirestore.instance.collection('userNotification').doc().set({
      'content': title,
      'createdAt': Timestamp.now(),
      'uid': userId,
    });
  }

  void sendPushMessage(String body, String title, String token) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAABrXMI_I:APA91bFJDmK_680sXhRjX7gjT8ho4J5zfobrTRcQwcsK2NqJgoFutZlVG_8daPhELHX83DbJ5gPn8ytLRqD4kMmKSjYAT71LNv7GRjnjV1goY434Wm-PM-tS-1zHg5tgADLDh-gXGd9g',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print(response.statusCode);
      print(response.body);
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }

  // _getNewOrder() async {
  //   FirebaseFirestore.instance
  //       .collection("Orders")

  //       // .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //       .snapshots()
  //       .listen((event) {
  //     if (event.docs.isNotEmpty) {
  //       for (var doc in event.docs) {
  //         if (doc.data()["orderAccept"] == false) {
  //           FlutterRingtonePlayer.play(
  //             fromAsset: 'assets/images/buzzer.wav.mp3',
  //             looping: true,
  //           );
  //         } else if (doc.data()['orderAccept'] == true) {
  //           FlutterRingtonePlayer.stop();
  //         }
  //       }
  //     }
  //   });
  // }

  double currentQty = 0;

  Future<void> getProductQty(String doc) async {
    await FirebaseFirestore.instance
        .collection("productitems")
        .doc(doc)
        .get()
        .then((value) {
      currentQty = double.parse(value.data()!["quantity"].toString());
      log(currentQty.toString());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Map ordersData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Orders")
              .where("vendorId",
                  isEqualTo:
                      FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
              .where("orderAccept", isEqualTo: false)
              .where('orderRejected', isEqualTo: false)
              .where("orderCancelled", isEqualTo: false)
              .orderBy('orderId', descending: true)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              FlutterRingtonePlayer.stop();

              Sneworder = '0';
            } else {
              FlutterRingtonePlayer.stop();
              Sneworder = snapshot.data!.docs.length.toString();
            }
            if (snapshot.data!.docs.isEmpty) {
              return Provider.of<GlobalHelper>(context, listen: false)
                  .nodatta();
            }

            if (snapshot.hasData) {
              final data = snapshot.data!.docs;
              // _getNewOrder();

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, i) {
                    final orderPrice =
                        double.parse(data[i]['productPrice'].toString());

                    final orderQuantity = data[i]["orderQuantity"];
                    final orderWeight = data[i]["orderWeight"];
                    final itemTotal = orderPrice * orderQuantity;
                    // final orderPrice=double.parse(data[i]["orderPrice"])
                    return Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Container(
                        margin:
                            const EdgeInsets.only(left: 5, right: 5, top: 10),
                        width: scWidth(context),
                        decoration: BoxDecoration(
                            // border: Border.all(
                            //     color: Colors.grey.withOpacity(0.4)),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 5),
                                  blurRadius: 3,
                                  color:
                                      const Color(0xffd3d3d3).withOpacity(.9))
                            ]),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(8),
                              height: scHeight(context) * 0.2,
                              width: width(context) * 0.8,
                              decoration: shadowDecoration(15, 3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      height: scHeight(context) * 0.12,
                                      width: width(context),
                                      child: Image.network(
                                        data[i]["orderImage"],
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data[i]["orderName"],
                                          style: bodyText16w600(color: black),
                                        ),
                                        Text(
                                          "Rs. $itemTotal",
                                          style: bodyText16w600(color: black),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 114,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: MaterialButton(
                                      height: scHeight(context) / 25,
                                      minWidth: scWidth(context) * 0.3,
                                      onPressed: () async {
                                        // FlutterRingtonePlayer.stop();

                                        _addNotificationData(data[i]['uid'],
                                            'Order Rejected\nOrder Id: ${data[i].id}');
                                        sendPushMessage(
                                            'Order Id: ${data[i].id}',
                                            'Order Rejected',
                                            await Provider.of<
                                                        FirebaseOperation>(
                                                    context,
                                                    listen: false)
                                                .getToken(data[i]['uid']));
                                        await Provider.of<FirebaseOperation>(
                                                context,
                                                listen: false)
                                            .rejectOrder(data[i].id)
                                            .then((value) =>
                                                FlutterRingtonePlayer.stop());
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      color: primary.withOpacity(0.5),
                                      child: Text("Reject",
                                          style: TextStyle(color: white)),
                                    ),
                                  ),
                                  MaterialButton(
                                    height: scHeight(context) / 27,
                                    minWidth: scWidth(context) * 0.4,
                                    onPressed: () async {
                                      Slocation = vendorData!['marketLocation'];
                                      Slong = vendorData!['longitude'];
                                      Slat = vendorData!['latitude'];
                                      // _getNewOrder();

                                      _addNotificationData(data[i]['uid'],
                                          'Order Accepted\nOrder Id: ${data[i].id}');
                                      sendPushMessage(
                                          'Order Id: ${data[i].id}',
                                          'Order Accepted',
                                          await Provider.of<FirebaseOperation>(
                                                  context,
                                                  listen: false)
                                              .getToken(data[i]['uid']));
                                      getProductQty(data[i]['productId'])
                                          .then((value) {
                                        FirebaseFirestore.instance
                                            .collection("productitems")
                                            .doc(data[i]['productId'])
                                            .update({
                                          'quantity': currentQty -
                                              data[i]['orderQuantity']
                                        });
                                        log('smith${currentQty}');
                                      });

                                      log('sppppp${currentQty}');
                                      log('message');

                                      await Provider.of<FirebaseOperation>(
                                              context,
                                              listen: false)
                                          .acceptOrder(
                                              data[i].id,
                                              vendorData!['marketLocation'],
                                              vendorData!['latitude'],
                                              vendorData!['longitude'])
                                          .then((value) =>
                                              FlutterRingtonePlayer.stop());
                                    },
                                    color: primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    child: Text("Accept",
                                        style: bodyText16w600(color: white)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
            return Text('Loading...');
          },
        ),
      )
      /*Column(
        children: [
          NewOrderbody(text: "New", color: Color(0xfff0066FF), press: () {})
        ],
      ),*/

      ,
    );
  }
}

// class NewOrderbody extends StatefulWidget {
//   final QueryDocumentSnapshot<Map<String, dynamic>> snapshot;

//   NewOrderbody({Key? key, required this.snapshot}) : super(key: key);

//   @override
//   State<NewOrderbody> createState() => _NewOrderbodyState();
// }

// class _NewOrderbodyState extends State<NewOrderbody> {
//   @override
//   Widget build(BuildContext context) {
//     items = widget.snapshot.data()['Orders'];
//     return}
// }
