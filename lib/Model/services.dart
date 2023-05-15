import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class MyBackgroundTask extends FlutterBackground {
  late StreamSubscription<DocumentSnapshot> _subscription;

  @override
  Future<void> onStart() async {
    // Your background task implementation here

    while (true) {
      await Future.delayed(Duration(seconds: 10));
      print('this the vendor app log');
      FirebaseFirestore.instance
          .collection("Orders")
          .where('vendorId',
              isEqualTo:
                  FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
          .where('orderAccept', isEqualTo: false)
          .where('orderRejected', isEqualTo: false)
          .snapshots()
          .listen((event) {
        if (event.docs.isNotEmpty) {
          for (var doc in event.docs) {
            if (doc.data()["orderAccept"] == false ||
                doc.data()['orderRejected'] == false) {
              print('play-----------------');
              FlutterRingtonePlayer.play(
                fromAsset: 'assets/images/buzzer.wav.mp3',
                looping: true,
              );
            } else if (doc.data()['orderAccept'] == true ||
                doc.data()['orderRejected'] == true) {
              // setState(() {});
              FlutterRingtonePlayer.stop();
            }
          }
        }
      });
    }
  }
}
