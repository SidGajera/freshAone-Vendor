import 'package:flutter/material.dart';
import 'package:meat4u_vendor/screens/bottom_bar/custom_bottom_nav.dart';
import 'package:meat4u_vendor/screens/profile/about_us.dart';
import 'package:meat4u_vendor/screens/profile/contact_us.dart';
import 'package:meat4u_vendor/screens/order/Delivered.dart';
import 'package:meat4u_vendor/screens/home/low_stock.dart';
import 'package:meat4u_vendor/screens/order/oder_full_detail.dart';
import 'package:meat4u_vendor/screens/order/order_scrn.dart';
import 'package:meat4u_vendor/screens/profile/privacy_policy.dart';
import 'package:meat4u_vendor/screens/order/Processed.dart';
import 'package:meat4u_vendor/screens/product/products.dart';
import 'package:meat4u_vendor/screens/product/product_update.dart';
import 'package:meat4u_vendor/screens/order/cancelled_order.dart';
import 'package:meat4u_vendor/screens/home/home_off.dart';
import 'package:meat4u_vendor/screens/home/home_scrn.dart';
import 'package:meat4u_vendor/screens/auth/login.dart';
import 'package:meat4u_vendor/screens/auth/otp.dart';
import 'package:meat4u_vendor/screens/home/out_of_stock.dart';
import 'package:meat4u_vendor/screens/profile/profile.dart';
import 'package:meat4u_vendor/screens/profile/rating.dart';
import 'package:meat4u_vendor/screens/order/received_order.dart';
import 'package:meat4u_vendor/screens/order/returned.dart';
import 'package:meat4u_vendor/screens/order/shipped.dart';
import 'package:meat4u_vendor/screens/auth/signup_screen.dart';
import 'package:meat4u_vendor/screens/profile/terms.dart';
import 'package:meat4u_vendor/screens/wallet/wallet_scrn.dart';
import 'package:meat4u_vendor/screens/profile/edit_profile_scrn.dart';
import 'package:meat4u_vendor/screens/wallet/withdrawalwallet.dart';

Map<String, WidgetBuilder> routes = {
  HomeScrn.routeName: (context) => HomeScrn(),
  LoginScrn.routeName: (context) => const LoginScrn(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  OtpScrn.routeName: (context) => const OtpScrn(
        phone: '',
        verificationId: '',
      ),
  CustomBottomNavigation.routeName: (context) => const CustomBottomNavigation(),
  WithdrawalScrn.routeName: (context) => const WithdrawalScrn(),
  ProfileScrn.routeName: (context) => const ProfileScrn(),
  // WalletScreen.routeName: (context) => const WalletModal(),
  AboutScrn.routeName: (context) => const AboutScrn(),
  PrivacyScrn.routeName: (context) => const PrivacyScrn(),
  TermsScrn.routeName: (context) => const TermsScrn(),
  ContactScrn.routeName: (context) => const ContactScrn(),
  ProductupScrn.routeName: (context) => const ProductupScrn(),
  ProductsScrn.routeName: (context) => const ProductsScrn(),
  ProductlowScrn.routeName: (context) => const ProductlowScrn(),
  ProductoutScrn.routeName: (context) => const ProductoutScrn(),
  OrdersScrn.routeName: (context) => const OrdersScrn(),
  // EditProfileScrn.routeName: (context) => const EditProfileScrn(statusOnline: tr,),
  CancelledorderScrn.routeName: (context) => const CancelledorderScrn(),
  ProcessedScrn.routeName: (context) => const ProcessedScrn(),
  RatingScrn.routeName: (context) => const RatingScrn(),
  HomeOffScrn.routeName: (context) => const HomeOffScrn(),
  ReturnedScrn.routeName: (context) => const ReturnedScrn(),
  OrderStatusScrn.routeName: (context) => const OrderStatusScrn(),
  ShippedScrn.routeName: (context) => const ShippedScrn(),
  DeliveredScrn.routeName: (context) => const DeliveredScrn(),
  ReceivedoderScrn.routeName: (context) => const ReceivedoderScrn(),
};
