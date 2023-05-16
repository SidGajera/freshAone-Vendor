// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:meat4u_vendor/screens/profile/my_profile_screen.dart';
import 'package:meat4u_vendor/screens/wallet/todays_balance.dart';

//import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:meat4u_vendor/utils/constant.dart';
import 'package:meat4u_vendor/screens/profile/edit_profile_scrn.dart';
import 'package:meat4u_vendor/screens/home/low_stock.dart';
import 'package:meat4u_vendor/screens/order/order_scrn.dart';
import 'package:meat4u_vendor/screens/home/out_of_stock.dart';
import 'package:meat4u_vendor/screens/product/products.dart';
import 'package:meat4u_vendor/screens/profile/rating.dart';
import 'package:meat4u_vendor/screens/wallet/wallet_scrn.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import '../../Model/firebaseOperations.dart';
import '../../Model/globalhelper.dart';

double latitude = 0.0;
double longitude = 0.0;

class HomeScrn extends StatefulWidget with ChangeNotifier {
  static String routeName = '/home_Screen';

  HomeScrn({Key? key}) : super(key: key);

  @override
  State<HomeScrn> createState() => _HomeScrnState();
}

class _HomeScrnState extends State<HomeScrn> with ChangeNotifier {
  Map<String, dynamic> vendorData = {};
  bool? isvendorOnline;

  _getProfileData() async {
    await FirebaseFirestore.instance.collection('vendors').doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20)).get().then((value) {
      if (value.exists) {
        setState(() {
          vendorData = value.data()!;
          // ignore: avoid_print
          print(vendorData);
        });
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

  _addRiderNotificationData(String riderID, String title, String docId) async {
    await FirebaseFirestore.instance.collection('RiderNotifications').doc(docId).set({
      'content': title,
      'createdAt': Timestamp.now(),
      'riderId': riderID,
    });
  }

  void sendPushMessage(String body, String title, String token) async {
    log("NewwRiderToken$token");
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
            'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': 'done'},
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

  void sendNotification(String body, String title, List token) async {
    log("NewwRiderToken123$token");
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
            'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': 'done'},
            "registration_ids": token,
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

  void sendTestNotification(String body, String title, List token) async {
    log("NewwRiderToken123$token");
    String TestToken =
        "dLmlbnqgRBmSPGpmieaBl3:APA91bHrry47byUheEpCQzUVRH5PZ6-RUCZsXtG65MiMSDULqscIPmUqXOEWjFSlF74YvcYO_IDsT2P5moZgx_n-cKKdFdftyzJan9OcLSZWatAmCNl8z9BcWddweWdsqiNRNWya_qYc";
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAABrXMI_I:APA91bFJDmK_680sXhRjX7gjT8ho4J5zfobrTRcQwcsK2NqJgoFutZlVG_8daPhELHX83DbJ5gPn8ytLRqD4kMmKSjYAT71LNv7GRjnjV1goY434Wm-PM-tS-1zHg5tgADLDh-gXGd9g',
        },
        body: jsonEncode(
          {
            "notification": {
              "body": body,
              "title": title,
            },
            "priority": "high",
            "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"},
            "to": TestToken,
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

  stopPlayer() async {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      print("--");
      await FlutterRingtonePlayer.stop();
    });
  }
  // Future sendNotification(String title, String body, List token) async {
  //   log("NewwRiderToken$token");
  //   String url = 'https://fcm.googleapis.com/fcm/send';

  //   var data;
  //   data =
  //       '{"notification": {"body": "$body", "title": "$title"}, "priority": "high",'
  //       ' "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK"}, '
  //       '"registration_ids": "${token}"}';
  //   String mykey =
  //       "AAAABrXMI_I:APA91bFJDmK_680sXhRjX7gjT8ho4J5zfobrTRcQwcsK2NqJgoFutZlVG_8daPhELHX83DbJ5gPn8ytLRqD4kMmKSjYAT71LNv7GRjnjV1goY434Wm-PM-tS-1zHg5tgADLDh-gXGd9g";
  //   await http.post(Uri.parse(url),
  //       headers: <String, String>{
  //         "Content-Type": "application/json",
  //         "Keep-Alive": "timeout=5",
  //         "Authorization": "key=$mykey"
  //       },
  //       body: data);
  //   // .then((value) async {
  //   // await FirebaseFirestore.instance.collection("userNotification").add({
  //   //   "uid": FirebaseAuth.instance.currentUser?.uid.substring(0, 20),
  //   //   "createdAt": Timestamp.now(),
  //   //   "content": "$body  order : $title"
  //   // });
  //   // });

  //   // print(response.body);
  // }

  _getNewOrder() async {
    FirebaseFirestore.instance
        .collection("Orders")
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        for (var doc in event.docs) {
          if (doc.data()["orderAccept"] == false || doc.data()['orderRejected'] == false) {
            print('play-----------------');
            FlutterRingtonePlayer.play(
              fromAsset: 'assets/images/buzzer.wav.mp3',
              looping: true,
            );
          } else if (doc.data()['orderAccept'] == true || doc.data()['orderRejected'] == true) {
            // setState(() {});
            FlutterRingtonePlayer.stop();
          }
        }
      }
    });
  }

  Future<Position?> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else {
      // throw Exception('Error');
    }
    return await Geolocator.getCurrentPosition();
  }

  fetchCurrentLatLong() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).then((value) {
      latitude = value.latitude;
      longitude = value.longitude;

      log(value.latitude.toString());

      setState(() {});
    });

    print(latitude);
    print(longitude);
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = math.cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a));
  }

  List<String> riderToken = [];
  String riderId = '';
  bool riderAvailable = false;

  Future fetchRiderData() async {
    await FirebaseFirestore.instance.collection('rider').get().then((value) {
      for (var doc in value.docs) {
        // log(value.docs.toString());
        // log("Newwwdistance${calculateDistance(latitude, longitude, doc["lat"], doc["long"])}");
        //Geolocator.distanceBetween(latitude, longitude, latitude, longitude);
        // vendorsList.add(doc.data());
        // log("Newww ${doc.data()["token"]}");
        // riderToken.add(doc.data()["token"]);
        if ((calculateDistance(latitude, longitude, doc["lat"], doc["long"])) <= 5) {
          // log("Newww ${doc.data()["token"]}");
          riderToken.add(doc.data()["token"]);
          // log('riderTokeennnnnn${doc.data()["token"]}');

          // setState(() {
          riderAvailable = true;
          riderId = doc.data()['riderId'];
          // vendorNumber = doc.data()['ownerPhone'];
          // });
          setState(() {});
          break;
        } else {
          setState(() {
            riderAvailable = false;
          });
        }

        // log(calculateDistance(latitude, longitude, doc["lat"], doc["long"])
        //     .toString());
      }
      print("rider token is " + riderToken.length.toString());
    });
  }

  List paymentList = [];
  List transactions = [];
  List<double> dataSum = <double>[];

  double totalAmnt = 0;
  double discountPrice = 0.0;
  double finalPrice = 0;
  Future<void> _getPaymentsCalculation() async {
    await FirebaseFirestore.instance
        .collection("Orders")
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .where('orderRejected', isEqualTo: false)
        // .where('isPaid', isEqualTo: true)
        // .orderBy("createdAt", descending: true)
        .get()
        .then((value) {
      paymentList.clear();

      for (var doc in value.docs) {
        paymentList.add(doc.data()['orderPrice']);

        log(paymentList.toString());
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

        // output
        log('ssss$finalPrice');
      }

      setState(() {});
      // }

      // notifyListeners();
    });
  }

  toggleOnline(BuildContext context, bool val) async {
    await Provider.of<FirebaseOperation>(context, listen: false).changeOnlineStatus(val);

    Provider.of<GlobalHelper>(context, listen: false).isOnline = val;
    notifyListeners();
  }

  List TodayspaymentList = [];

  List<double> TodaysdataSum = <double>[];

  double totalAmntToday = 0;
  double discountPriceToday = 0.0;
  double finalPriceToday = 0;

  Future<void> _getTodaysPaymentsCalculation() async {
    await FirebaseFirestore.instance
        .collection("Orders")
        .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .where('orderRejected', isEqualTo: false)
        .where('orderAccept', isEqualTo: true)
        // .where('isPaid', isEqualTo: true)
        .get()
        .then((value) {
      TodayspaymentList.clear();
      // paymentDocId.clear();

      for (var doc in value.docs) {
        if (DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(doc.data()["orderTime"])) ==
            DateFormat('dd-MM-yyyy').format(DateTime.now())) {
          finalPriceToday += (double.parse(doc.data()['productPrice'].toString()) * doc.data()['orderQuantity']);
        }
      }

      setState(() {});
      // }

      // notifyListeners();
    });
  }

  double currentQty = 0;

  Future<void> getProductQty(String doc) async {
    await FirebaseFirestore.instance.collection("productitems").doc(doc).get().then((value) {
      currentQty = double.parse(value.data()!["quantity"].toString());
      log(currentQty.toString());
    });
  }

  Map? VendorIncomeData = {};

  bool isLoaded = false;

  Future<void> getVendorIncome() async {
    await FirebaseFirestore.instance.collection('VendorTotalAmount').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) {
      if (value.exists) {
        setState(() {
          VendorIncomeData = value.data()!;
          isLoaded = true;
          // totalAmount = vendorData!['walletAmount'];
          // ignore: avoid_print

          log(VendorIncomeData!['amount'].toString());
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    stopPlayer();
    getVendorIncome();
    fetchRiderData();
    determinePosition();
    fetchCurrentLatLong();
    _getProfileData();
    _getPaymentsCalculation();
    _getTodaysPaymentsCalculation();
    log(TodaysdataSum.toString());
    Slocation = vendorData['marketLocation'];
    Slong = vendorData['longitude'];
    Slat = vendorData['latitude'];
    get_Token();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  get_Token() async {
    String _token = "";
    await FirebaseMessaging.instance.getToken().then((value) {
      _token = value!;
    });
    print("---Token -- ${_token}");
  }

  void sendTest() async {
    var customerFcmToken =
        "fYIY_nVcQRC-VyFcvp-i5U:APA91bEpnciaDTPiFGVUck6srDzlsBzZhpKArNmdYNPnJejfEpA46OXSOYjK9YNLVx6RKILQwFXh4lYGiscMyRFA3MNG5a2qt-YisoczSRaCm1b-yxpVJHV0zmAcn32Q2B7fc5GSSyep";

    await http
        .post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization':
                  'key=AAAABrXMI_I:APA91bFJDmK_680sXhRjX7gjT8ho4J5zfobrTRcQwcsK2NqJgoFutZlVG_8daPhELHX83DbJ5gPn8ytLRqD4kMmKSjYAT71LNv7GRjnjV1goY434Wm-PM-tS-1zHg5tgADLDh-gXGd9g'
            },
            body: jsonEncode({
              'notification': <String, dynamic>{'title': 'test', 'body': 'New Order From xyz', 'sound': 'true'},
              'priority': 'high',
              'data': <String, dynamic>{'click_action': 'FLUTTER_NOTIFICATION_CLICK', 'id': '1', 'status': 'done'},
              'to': customerFcmToken
            }))
        .whenComplete(() {
//      print('sendOrderCollected(): message sent');
    }).catchError((e) {
      print('sendOrderCollected() error: $e');
    });
  }

  @override
  Widget build(BuildContext context) {
    // fetchRiderData();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: FlutterSwitch(
            width: scWidth(context) / 4.1,
            showOnOff: true,
            inactiveColor: primary,
            inactiveText: 'Offline',
            activeColor: Colors.green,
            activeText: 'Online',
            onToggle: (val) async {
              await toggleOnline(context, val);
              notifyListeners();
              setState(() {});
            },
            value: Provider.of<GlobalHelper>(context, listen: true).isOnline,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  sendTest();
                },
                icon: const Icon(
                  Icons.search,
                  color: primary,
                )),
            const SizedBox(
              width: 10,
            ),
            vendorData == null
                ? const Center(child: CircularProgressIndicator())
                : IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MyProfile()));
                    },
                    icon: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(vendorData['image'] == ""
                          ? "https://firebasestorage.googleapis.com/v0/b/"
                              "fresh4app-8c91e.appspot.com/o/other-image%2FSample_User_Icon.png?alt=media&token="
                              "ccbdab95-9976-47e8-8a55-06accddf97d0"
                          : vendorData['image'].toString()),
                    ))
          ],
        ),
        body: Provider.of<GlobalHelper>(context, listen: false).isOnline ? onlineWidget(context) : offlineWidget(context));
  }

  Widget offlineWidget(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Expanded(
          child: Image.asset(
            "assets/images/offline_scrn.png",
            width: 700,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Your outlet is temporarily closed',
          style: bodyText1Bold(context: context),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'You will go on ${DateTime.now().toString()}',
          style: bodyText2(context: context, color: textLightColor),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(primary: primary),
            onPressed: () async {
              await Provider.of<GlobalHelper>(context, listen: false).toggleOnline(context, true);
              setState(() {});
            },
            icon: const Icon(
              Icons.power_settings_new_outlined,
              color: Colors.white,
            ),
            label: Text(
              'Go online now',
              style: bodyText2(context: context, color: Colors.white),
            )),
        const Spacer(),
      ],
    );
  }

  Widget onlineWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 15,
          right: 15,
        ),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomCard(
                ontap: () {
                  Navigator.pushNamed(context, OrdersScrn.routeName);
                },
                height: scHeight(context) / 9,
                width: scWidth(context) / 4.6,
                image: 'assets/images/order.png',
                text: 'Orders',
                text2: '',
              ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('Orders')
                      .where('vendorId', isEqualTo: FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
                      .where('orderCompleted', isEqualTo: true)
                      .snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!;
                      double total = 0;

                      for (var docs in data.docs) {
                        total += double.parse(docs['productPrice']) * docs['orderQuantity'];
                      }

                      // double total = data.docs.isNotEmpty
                      //     ? double.parse(data.docs
                      //             .map((e) => e['productPrice'])
                      //             .reduce(
                      //                 (value, element) => value + element)) *
                      //         data.docs
                      //             .map((e) => e['orderQuantity'])
                      //             .reduce((value, element) => value + element)
                      //     : 0.0;

                      return CustomCard(
                          ontap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen()));
                          },
                          height: scHeight(context) / 9,
                          width: scWidth(context) / 3.4,
                          image: 'assets/images/cash.png',
                          text: 'Balance',
                          text2: 'Rs. ${VendorIncomeData!.isEmpty ? '0.0' : VendorIncomeData!['amount']}');
                    }
                    return CircularProgressIndicator();
                  }),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('productitems')
                      .where('vendorId', arrayContainsAny: [FirebaseAuth.instance.currentUser!.uid.substring(0, 20)]).snapshots(),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!;

                      return CustomCard(
                        ontap: () {
                          Navigator.pushNamed(context, ProductsScrn.routeName);
                        },
                        height: scHeight(context) / 9,
                        width: scWidth(context) / 3.4,
                        image: 'assets/images/gift.png',
                        text: 'Products',
                        text2: data.size.toString(),
                      );
                    }
                    return CircularProgressIndicator();
                  })
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomCard(
                ontap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TodaysBalance()));
                },
                height: scHeight(context) / 7.1,
                width: scWidth(context) / 2.4,
                image: 'assets/images/cash.png',
                text: 'Today Balance',
                text2: 'Rs. ${finalPriceToday}'.toString(),
              ),
              CustomCard(
                ontap: () {
                  Navigator.pushNamed(context, RatingScrn.routeName);
                },
                height: scHeight(context) / 7.1,
                width: scWidth(context) / 2.4,
                image: 'assets/images/rating.png',
                text: '        Rating',
                text2: '4.20/5',
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomCard(
                ontap: () {
                  Navigator.pushNamed(context, ProductoutScrn.routeName);
                },
                height: scHeight(context) / 7.1,
                width: scWidth(context) / 2.4,
                image: 'assets/images/sold.png',
                text: 'Sold Out Products',
                text2: '',
              ),
              CustomCard(
                ontap: () {
                  Navigator.pushNamed(context, ProductlowScrn.routeName);
                },
                height: scHeight(context) / 7.1,
                width: scWidth(context) / 2.4,
                image: 'assets/images/stock.png',
                text: 'Low Stock Product',
                text2: '',
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'New Orders',
            style: bodyText16w600(color: primary),
          ),
          SizedBox(
            // height: height(context) * 0.3,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Orders")
                  .where("vendorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
                  .where("orderAccept", isEqualTo: false)
                  .where('orderRejected', isEqualTo: false)
                  .where("orderCancelled", isEqualTo: false)
                  .orderBy('orderId', descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                print(FirebaseAuth.instance.currentUser!.uid.substring(0, 20));
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
                  return Provider.of<GlobalHelper>(context, listen: false).nodatta();
                }

                if (snapshot.hasData) {
                  final data = snapshot.data!.docs;

                  _getNewOrder();

                  return ListView.builder(
                      itemCount: data.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, i) {
                        final orderPrice = double.parse(data[i]['productPrice'].toString());

                        final orderQuantity = data[i]["orderQuantity"];
                        final orderWeight = data[i]["orderWeight"];
                        final itemTotal = orderPrice * orderQuantity;
                        // final orderPrice=double.parse(data[i]["orderPrice"])
                        return Padding(
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Container(
                            margin: const EdgeInsets.only(left: 1, right: 1),
                            width: scWidth(context),
                            decoration: BoxDecoration(
                                // border: Border.all(
                                //     color: Colors.grey.withOpacity(0.4)),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [BoxShadow(offset: const Offset(0, 5), blurRadius: 3, color: const Color(0xffd3d3d3).withOpacity(.9))]),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(8),
                                  height: scHeight(context) * 0.2,
                                  width: width(context) * 0.8,
                                  decoration: shadowDecoration(15, 3),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: width(context) * 0.5,
                                              child: Text(
                                                data[i]["orderName"],
                                                style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),
                                              ),
                                            ),
                                            Text(
                                              "Rs. $itemTotal",
                                              style: bodyText16w600(color: black),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          'Quantity : ${data[i]["orderQuantity"]}',
                                          style: TextStyle(color: black, fontSize: 16, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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

                                            _addNotificationData(data[i]['uid'], 'Order Rejected\nOrder Id: ${data[i].id}');
                                            sendPushMessage('Order Id: ${data[i].id}', 'Order Rejected',
                                                await Provider.of<FirebaseOperation>(context, listen: false).getToken(data[i]['uid']));
                                            await Provider.of<FirebaseOperation>(context, listen: false)
                                                .rejectOrder(data[i].id)
                                                .then((value) => FlutterRingtonePlayer.stop());
                                          },
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                          color: primary.withOpacity(0.5),
                                          child: Text("Reject", style: TextStyle(color: white)),
                                        ),
                                      ),
                                      MaterialButton(
                                        height: scHeight(context) / 27,
                                        minWidth: scWidth(context) * 0.4,
                                        onPressed: () async {
                                          Slocation = vendorData['marketLocation'];
                                          Slong = vendorData['longitude'];
                                          Slat = vendorData['latitude'];
                                          // _getNewOrder();
                                          _addNotificationData(data[i]['uid'], 'Order Accepted\nOrder Id: ${data[i].id}');
                                          sendPushMessage('Order Id: ${data[i].id}', 'Order Accepted',
                                              await Provider.of<FirebaseOperation>(context, listen: false).getToken(data[i]['uid']));
                                          log("Newww$riderToken");
                                          if (riderToken.isNotEmpty) {
                                            sendNotification('Order Id: ${data[i].id}', 'New Order From: ${data[i]['userName']}', riderToken);
                                            _addRiderNotificationData('', 'New Order From: ${data[i]['userName']}', data[i].id);
                                          }

                                          getProductQty(data[i]['productId']).then((value) {
                                            FirebaseFirestore.instance
                                                .collection("productitems")
                                                .doc(data[i]['productId'])
                                                .update({'quantity': currentQty - data[i]['orderQuantity']});
                                            log('smith${currentQty}');
                                          });

                                          await Provider.of<FirebaseOperation>(context, listen: false)
                                              .acceptOrder(data[i].id, vendorData['marketLocation'], vendorData['latitude'], vendorData['longitude'])
                                              .then((value) => FlutterRingtonePlayer.stop());
                                        },
                                        color: primary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                        child: Text("Accept", style: bodyText16w600(color: white)),
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
          ),

          /*Column(
        children: [
          NewOrderbody(text: "New", color: Color(0xfff0066FF), press: () {})
        ],
      ),*/

          //   Container(
          //     padding: const EdgeInsets.only(
          //       top: 14,
          //       left: 7,
          //     ),
          //     height: scHeight(context) / 2.79,
          //     width: scWidth(context) / 0.8,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         boxShadow: [
          //           BoxShadow(
          //             color: textLightColor.withOpacity(0.3),
          //             blurRadius: 8.0,
          //           ),
          //         ],
          //         borderRadius: const BorderRadius.all(Radius.circular(10))),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           "Fast selling products",
          //           style: headline1ExtraLarge(context: context),
          //         ),
          //         Row(
          //           children: [
          //             RichText(
          //               text: TextSpan(
          //                   text: "Details from ",
          //                   style: bodyText(context: context),
          //                   children: [
          //                     TextSpan(
          //                         text: "4th Jan 11 Jan 2022",
          //                         style:
          //                             bodyText(color: primary, context: context))
          //                   ]),
          //             ),
          //             InkWell(
          //               child: const Icon(
          //                 Icons.arrow_drop_down,
          //                 color: primary,
          //               ),
          //               onTap: () {
          //                 //TODO:drop down dates
          //               },
          //             )
          //           ],
          //         ),
          //         StreamBuilder(
          //           stream: FirebaseFirestore.instance
          //               .collection("Order Success")
          //               .where("vendorId",
          //                   isEqualTo: FirebaseAuth.instance.currentUser!.uid
          //                       .substring(0, 20))
          //               .snapshots(),
          //           builder: (BuildContext context,
          //               AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
          //                   snapshot) {
          //             if (snapshot.connectionState == ConnectionState.waiting) {
          //               return const Center(
          //                 child: CircularProgressIndicator(),
          //               );
          //             }

          //             if (snapshot.data!.docs.isEmpty) {
          //               return Provider.of<GlobalHelper>(context, listen: false)
          //                   .nodatta();
          //             }

          //             return ListView(
          //               shrinkWrap: true,
          //               children: snapshot.data!.docs.map((e) {
          //                 return maintable(
          //                   snapshot: e,
          //                 );
          //               }).toList(),
          //             );
          //           },
          //         )
          //       ],
          //     ),
          //   ),
          //   const SizedBox(
          //     height: 26,
          //   ),
          //   Container(
          //     padding: const EdgeInsets.only(
          //       top: 14,
          //       left: 7,
          //     ),
          //     height: scHeight(context) / 2.79,
          //     width: 391,
          //     decoration: BoxDecoration(
          //         color: Colors.white,
          //         boxShadow: [
          //           BoxShadow(
          //             color: textLightColor.withOpacity(0.3),
          //             blurRadius: 8.0,
          //           ),
          //         ],
          //         borderRadius: const BorderRadius.all(Radius.circular(10))),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           "Slow selling products",
          //           style: headline1ExtraLarge(context: context),
          //         ),
          //         Row(
          //           children: [
          //             RichText(
          //               text: TextSpan(
          //                   text: "Details from ",
          //                   style: bodyText(context: context),
          //                   children: [
          //                     TextSpan(
          //                         text: "4th Jan 11 Jan 2022",
          //                         style:
          //                             bodyText(color: primary, context: context))
          //                   ]),
          //             ),
          //             InkWell(
          //               child: const Icon(
          //                 Icons.arrow_drop_down,
          //                 color: primary,
          //               ),
          //               onTap: () {},
          //             )
          //           ],
          //         ),
          //         StreamBuilder(
          //           stream: FirebaseFirestore.instance
          //               .collection("Orders")
          //               .where("vendorId",
          //                   isEqualTo: FirebaseAuth.instance.currentUser!.uid
          //                       .substring(0, 20))
          //               .snapshots(),
          //           builder: (BuildContext context,
          //               AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
          //                   snapshot) {
          //             if (snapshot.connectionState == ConnectionState.waiting) {
          //               return const Center(
          //                 child: CircularProgressIndicator(),
          //               );
          //             }

          //             if (snapshot.data!.docs.isEmpty) {
          //               return Provider.of<GlobalHelper>(context, listen: false)
          //                   .nodatta();
          //             }

          //             return ListView(
          //               shrinkWrap: true,
          //               children: snapshot.data!.docs.map((e) {
          //                 return maintable(
          //                   snapshot: e,
          //                 );
          //               }).toList(),
          //             );
          //           },
          //         )
          //       ],
          //     ),
          //   )
        ]),
      ),
    );
  }
}
