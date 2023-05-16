import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meat4u_vendor/Model/firebaseOperations.dart';
import 'package:meat4u_vendor/Model/globalhelper.dart';
import 'package:meat4u_vendor/Model/order_provider.dart';
import 'package:meat4u_vendor/Model/providerservice.dart';
import 'package:meat4u_vendor/controller/auth_controller.dart';
import 'package:meat4u_vendor/screens/profile/edit_profile_scrn.dart';
import 'package:meat4u_vendor/screens/profile/my_profile_screen.dart';
import 'package:meat4u_vendor/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'Model/services.dart';
import 'module/LocalNotification.dart';
/* import 'package:flutter_local_notifications/flutter_local_notifications.dart'; */

const simpleTaskKey = "FreshaAOneVendorAPP";

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title

  description: 'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

// firebase background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification!.body.toString().toLowerCase().contains("New Order from".toLowerCase())) {
    await Firebase.initializeApp();
    print('Player Start------}');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification!.android;

    print('A bg message just showed up: ${message.notification!.body}');
    if (notification != null && android != null) {
      await FlutterRingtonePlayer.play(fromAsset: "assets/buzzer.mp3").then((value) {
        int cnt = 0;
        Timer(Duration(seconds: 5), () async {
          await FlutterRingtonePlayer.stop();
        });
      });
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions();

  await FlutterBackground.initialize();
  FlutterBackground.enableBackgroundExecution();
  MyBackgroundTask().onStart();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  late FlutterLocalNotificationsPlugin fltNotification;
  //with WidgetsBindingObserver
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  // }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     MyBackgroundTask().onStart();
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initMessaging();
    pushFCMtoken();
  }

  void pushFCMtoken() async {
    String? token = await messaging.getToken();
    print("===TOKEN===${token}");
  }

  void initMessaging() {
    var androiInit = AndroidInitializationSettings('@mipmap/ic_launcher'); //for logo
    var iosInit = IOSInitializationSettings();
    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
    fltNotification = FlutterLocalNotificationsPlugin();
    fltNotification.initialize(initSetting);
    var androidDetails = const AndroidNotificationDetails('channelName', 'channel Description');
    var iosDetails = IOSNotificationDetails();
    var generalNotificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //     //   RemoteNotification? notification = message.notification;
    //     //   AndroidNotification? android = message.notification?.android;
    //     //   if (notification != null && android != null) {
    //     //     FlutterRingtonePlayer.play(fromAsset: "assets/buzzer.mp3");
    //     //     print('A bg message just showed up: ${message.messageId}');
    //     //     fltNotification.show(notification.hashCode, notification.title, notification.body, generalNotificationDetails);
    //     //   }
    //     // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('A bg message just showed up: ${message.messageId}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

      print('A bg message just showed up: ${message.notification!.body}');
      if (notification != null && android != null) {
        print("---- flutterLocalNotificationsPlugin");
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                playSound: false,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
      // if (notification!.body.toString().contains("New Order From")) {
      //   await Firebase.initializeApp();
      //   print('Player Start------}');
      //   await FlutterRingtonePlayer.play(fromAsset: "assets/buzzer.mp3").then((value) {
      //     int cnt = 0;
      //     Timer.periodic(Duration(seconds: 1), (timer) async {
      //       Future.delayed(Duration(seconds: 1));
      //       await FlutterRingtonePlayer.stop();
      //     });
      //   });
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: VendorService()),
        ChangeNotifierProvider.value(value: GlobalHelper()),
        ChangeNotifierProvider.value(value: FirebaseOperation()),
        ChangeNotifierProvider.value(value: ProductProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Meat4u Vendor',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
                elevation: 0,
                centerTitle: true,
                // toolbarTextStyle: font1Headline1(),
                color: Colors.white,
                systemOverlayStyle:
                    SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.dark, statusBarColor: Colors.white)),
          ),
          routes: routes,
          home: const InitializerFirebaseUser()),
    );
    // const CustomBottomNavigation());
  }
}
