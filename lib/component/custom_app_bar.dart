import 'package:flutter/material.dart';
//import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key,  required this.appBar})
      : super(key: key);
  
  final AppBar appBar;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      
      actions: const [
        // LiteRollingSwitch(
        //   value: true,
        //   textOn: "online",
        //   textOff: "offline",
        //   colorOn: buttons2,
        //   colorOff: buttons1,
        //   textSize: 18.0,
        //   onTap: () {},
        // )
      ],
    );
  }

   Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
