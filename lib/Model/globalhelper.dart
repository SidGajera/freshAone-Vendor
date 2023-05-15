// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'firebaseOperations.dart';

class GlobalHelper with ChangeNotifier {
  bool isOnline = true;

  showSnackbar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Widget nodatta() {
    return Center(
      child: Column(
        children: const [
          Icon(
            Icons.mood_bad_outlined,
            color: Colors.grey,
            size: 60,
          ),
          SizedBox(
            height: 5,
          ),
          Text('No Data To Display')
        ],
      ),
    );
  }

  String gettime(int t) {
    var format = DateFormat("kk:mm");
    String str = format.format(DateTime.fromMillisecondsSinceEpoch(t));
    return str;
  }

  /*  Future callNumber(String number) async {
    return await FlutterPhoneDirectCaller.callNumber(number);
  }  */

  /*  Widget switchB(BuildContext context) {
    return FlutterSwitch(
      width: 70,
      height: 30,
      value: Provider.of<GlobalHelper>(context, listen: true).isOnline,
      activeColor: Colors.green,
      inactiveColor: primary,
      showOnOff: true,
      onToggle: (val) async {
        await toggleOnline(context, val);
        notifyListeners();
      },
    );
  } */

  toggleOnline(BuildContext context, bool val) async {
    await Provider.of<FirebaseOperation>(context, listen: false)
        .changeOnlineStatus(val);

    Provider.of<GlobalHelper>(context, listen: false).isOnline = val;

    notifyListeners();
  }
}
