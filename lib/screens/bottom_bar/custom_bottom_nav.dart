import 'package:flutter/material.dart';

import 'package:meat4u_vendor/utils/constant.dart';
import 'package:meat4u_vendor/screens/order/order_scrn.dart';
import 'package:meat4u_vendor/screens/home/home_scrn.dart';
import 'package:meat4u_vendor/screens/wallet/wallet_scrn.dart';

import '../profile/profile.dart';

class CustomBottomNavigation extends StatefulWidget {
  static String routeName = '/custom_navigation';
  const CustomBottomNavigation({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _selectedIndex = 0;

  ///change color of floating actionbutton
  ///if true it will white else orange color
  bool floatingBtnColor = false;

  List<Widget> screens = [
    HomeScrn(),
    const OrdersScrn(),
    WalletScreen(),
    const ProfileScrn()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 10, color: textLightColor.withOpacity(0.5))
            ],
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        height: scHeight(context) * 0.09,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconBottomBar(
            selected: _selectedIndex == 0,
            onPressed: () {
              floatingBtnColor = false;

              setState(() {
                _selectedIndex = 0;
              });
            },
            selectIcon: 'assets/images/home.png',
            unselectIcon: 'assets/images/home_uff.png',
            // text: 'Home',
          ),
          IconBottomBar(
            selected: _selectedIndex == 1,
            onPressed: () {
              floatingBtnColor = true;
              setState(() {
                _selectedIndex = 1;
              });
            },
            selectIcon: 'assets/images/menu.png',
            unselectIcon: 'assets/images/menu_uff.png',
            // text: 'Menu',
          ),
          IconBottomBar(
            selected: _selectedIndex == 2,
            onPressed: () {
              floatingBtnColor = true;
              setState(() {
                _selectedIndex = 2;
              });
            },
            selectIcon: 'assets/images/wallet.png',
            unselectIcon: 'assets/images/wallete_uf.png',
            // text: 'Wallet',
          ),
          IconBottomBar(
            selected: _selectedIndex == 3,
            onPressed: () {
              floatingBtnColor = true;
              setState(() {
                _selectedIndex = 3;
              });
            },
            selectIcon: 'assets/images/profile.png',
            unselectIcon: 'assets/images/profile_uf.png',
            // text: 'Profile',
          ),
        ]),
      ),
      body: screens[_selectedIndex],
    );
  }
}

class IconBottomBar extends StatelessWidget {
  final bool selected;
  final String selectIcon;
  // final String text;
  final String unselectIcon;
  final Function() onPressed;

  const IconBottomBar({
    key,
    required this.selected,
    required this.onPressed,
    required this.selectIcon,
    required this.unselectIcon,
    // required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(
        onPressed: onPressed,
        icon: selected
            ? Image.asset(
                selectIcon,
                // height: 24,
                // width: 24,
              )
            : Image.asset(
                unselectIcon,
                // height: 24,
                // width: 24,
              ),
      ),
    );
  }
}
