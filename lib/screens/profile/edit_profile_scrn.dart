import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meat4u_vendor/screens/bottom_bar/custom_bottom_nav.dart';
import 'package:meat4u_vendor/component/custom_button.dart';
import 'package:meat4u_vendor/utils/constant.dart';
import 'package:meat4u_vendor/screens/profile/address_search.dart';
import 'package:provider/provider.dart';

import '../../Model/globalhelper.dart';
import '../../Model/providerservice.dart';
import '../../component/drop_down _button.dart';

enum Gender { male, female, others }

class EditProfileScrn extends StatefulWidget {
  static String routeName = '/EditProfileScrn';

  const EditProfileScrn({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfileScrn> createState() => _EditProfileScrnState();
}

class _EditProfileScrnState extends State<EditProfileScrn> {
  ImagePicker picker = ImagePicker();
  var _image;
  String _imgUrl = '';
  bool isUploaded = false;

  // Future selectPhoto(BuildContext context, double d, int i) async {
  //   return showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return BottomSheet(
  //             builder: (context) {
  //               return Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   ListTile(
  //                     leading: const Icon(Icons.camera),
  //                     title: const Text("Camera"),
  //                     onTap: () async {
  //                       Navigator.pop(context);

  //                       getImage(ImageSource.camera);
  //                     },
  //                   ),
  //                   ListTile(
  //                     leading: const Icon(Icons.album),
  //                     title: const Text("Gallery"),
  //                     onTap: () async {
  //                       Navigator.pop(context);
  //                       getImage(ImageSource.gallery);
  //                     },
  //                   )
  //                 ],
  //               );
  //             });
  //       });
  // }

  // Future getImage(ImageSource source) async {
  //   try {
  //     FirebaseStorage storage = FirebaseStorage.instance;
  //     final XFile? image =
  //         await ImagePicker().pickImage(source: source, imageQuality: 60);
  //     setState(() {});

  //     if (image == null) return;
  //     final imageTemp = File(image.path);
  //     Reference reference = storage.ref().child("gallery");
  //     /* .child(FirebaseAuth.instance.currentUser!.uid); */

  //     UploadTask uploadTask = reference.putFile(File(image.path));
  //     TaskSnapshot snapshot = await uploadTask;
  //     url = await (await snapshot).ref.getDownloadURL();
  //     print(url);
  //   } on PlatformException catch (e) {
  //     print('Failed to pick image: $e');
  //   }
  // }

  String url = '';
  // final ImagePicker picker = ImagePicker();
  var nameController = TextEditingController();
  var surnameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var marketnameController = TextEditingController();
  var marketlocationController = TextEditingController();
  var marketopeningtimeController = TextEditingController();
  var marketclosingtimeController = TextEditingController();
  var marketemailController = TextEditingController();
  var marketphoneController = TextEditingController();
  var banknameController = TextEditingController();
  var accountnumberController = TextEditingController();
  var ifsccodeController = TextEditingController();
  var marketEstablish = TextEditingController();
  var dateOfBirthController = TextEditingController();
  String? gender = 'male';
  Gender genderVal = Gender.male;
  DateTime? _marketDate;
  DateTime? _dateTime;
  Map<String, dynamic>? vendorData;
  List<dynamic> filtercoupon = [];
  Map? productItems;
  List<dynamic> products = [];

  bool isEdit = false;
  String selectedItems = 'Select';

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  callApi() async {
    await FirebaseFirestore.instance
        .collection('productItems')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get()
        .then((value) {
      productItems = value.data();
      if (productItems != null) {
        products = productItems!['list'];
        filtercoupon = productItems!['list'];
        filtercoupon.forEach((element) {});
      }
      // log(productItems.toString());
      // countDiscount();
      setState(() {});
    });
  }

  _getProfileData() async {
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(FirebaseAuth.instance.currentUser!.uid.substring(0, 20))
        .get()
        .then((value) {
      if (value.exists) {
        setState(() {
          vendorData = value.data()!.cast<String, dynamic>();
          marketnameController.text = vendorData?["marketName"] ?? '';
          marketEstablish.text = vendorData?["marketEstablishment"] ?? '';
          marketemailController.text = vendorData?["marketEmail"] ?? '';
          marketphoneController.text = vendorData?["marketPhone"] ?? '';
          nameController.text = vendorData?["ownerName"] ?? '';
          dateOfBirthController.text = vendorData?["date of birth"] ?? '';
          emailController.text = vendorData?["ownerEmail"] ?? '';
          marketopeningtimeController.text = vendorData?["openingTime"] ?? '';
          marketclosingtimeController.text = vendorData?["closingTime"] ?? '';
          marketlocationController.text = vendorData?["marketLocation"] ?? '';

          phoneController.text = vendorData?["ownerPhone"] ?? '';
          banknameController.text = vendorData?["accountName"] ?? '';
          accountnumberController.text = vendorData?["accountNumber"] ?? '';
          ifsccodeController.text = vendorData?["ifscCode"] ?? '';
          _imgUrl = vendorData?['image'];
          // _marketDate = vendorData?["marketEstablishment"] ?? '';
          gender = vendorData?['gender'];

          // log(vendorData.toString());
        });
      }
    });
  }

  Map categoryItem = {};
  List category = [];
  List<String> categoryName = [];
  _getCategories() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc('FMZcGZDuso9BQcMLvfXO')
        .get()
        .then((value) {
      categoryItem = value.data()!;
      if (categoryItem != null) {
        category = categoryItem['category'];
        // for (var doc in category) {
        //   categoryName.add(doc['name']);
        // }
        log("sumit patil knddnid$category");
        setState(() {});
      }
    });
  }

  String userToken = '';
  getToken() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      userToken = value!;
    });
  }

  @override
  void initState() {
    callApi();
    getToken();
    _getProfileData();
    _getCategories();

    super.initState();
  }

  TimeOfDay currentTime = TimeOfDay.now();
  TimeOfDay openTime = TimeOfDay.now();
  TimeOfDay closeTime = TimeOfDay.now();

  double? latitude;
  double? longitude;
  @override
  Widget build(BuildContext context) {
    final vendor = Provider.of<VendorService>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const BackButton(
              onPressed: null,
            ),
            SizedBox(
              width: scWidth(context) * 0.1,
            ),
            Text("Fill your profile",
                style: headline1ExtraLarge(context: context)),
          ],
        ),
      ),
      body: vendorData == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Stack(children: [
                      Center(
                          child: _imgUrl == ''
                              ? CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.black38,
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                    color: white,
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.black38,
                                  backgroundImage: NetworkImage(_imgUrl))),
                      Positioned(
                          bottom: -5,
                          right: 85,
                          child: RawMaterialButton(
                              onPressed: () {
                                // selectPhoto(context, 1.0, 0);
                                _imagePickerBuilder(context);
                              },
                              elevation: 2.0,
                              fillColor: primary,
                              padding: const EdgeInsets.all(1.0),
                              shape: const CircleBorder(),
                              child: Icon(
                                Icons.edit,
                                color: white,
                                size: 20,
                              ))),
                    ]),
                    const SizedBox(
                      height: 21,
                    ),
                    Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Store Details",
                            style: headline1(context: context),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          TextFormField(
                            controller: marketnameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 240, 235, 235),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 12,
                                    color: Color.fromARGB(255, 240, 235, 235),
                                  ),
                                  borderRadius: BorderRadius.circular(35)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 12,
                                    color: Color.fromARGB(255, 240, 235, 235),
                                  ),
                                  borderRadius: BorderRadius.circular(35)),
                              hintText: "Name of the market",
                            ),
                          ),
                          const SizedBox(
                            height: 21,
                          ),

                          Container(
                              height: scHeight(context) / 13,
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 240, 235, 235),
                                  borderRadius: BorderRadius.circular(35)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: scWidth(context) * 0.71,
                                    child: TextField(
                                      onTap: () async {
                                        await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1972),
                                                lastDate: DateTime(2044))
                                            .then((date) {
                                          setState(() {
                                            _marketDate = date;
                                          });
                                          marketEstablish.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(_marketDate!);
                                        });
                                      },
                                      controller: marketEstablish,
                                      decoration: InputDecoration(
                                          hintText: vendorData![
                                                  "marketEstablishment"] ??
                                              "Market Since",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.date_range,
                                    color: primary,
                                    size: 30,
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 21,
                          ),
                          TextFormField(
                            controller: marketemailController,
                            onChanged: ((value) {
                              _formkey.currentState?.validate();
                            }),
                            validator: ((value) {
                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                              RegExp regex = RegExp(pattern.toString());
                              if (!regex.hasMatch(value.toString())) {
                                return 'Please Enter Valid Email';
                              }
                            }),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 240, 235, 235),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                hintText:
                                    vendorData!['marketEmail'] ?? "Email"),
                          ),
                          const SizedBox(
                            height: 21,
                          ),
                          TextFormField(
                            controller: marketphoneController,
                            keyboardType: TextInputType.number,
                            onChanged: ((value) {
                              _formkey.currentState?.validate();
                            }),
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return 'Please Enter a Phone Number';
                              } else if (value.length <= 9 ||
                                  value.length > 10) {
                                return 'Please enter valid mobile number';
                              }
                            }),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 240, 235, 235),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                hintText: vendorData!['marketPhone'] ??
                                    "Phone Number"),
                          ),
                          const SizedBox(
                            height: 21,
                          ),
                          Container(
                              height: scHeight(context) / 13,
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 240, 235, 235),
                                  borderRadius: BorderRadius.circular(35)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: scWidth(context) * 0.68,
                                    child: TextField(
                                      readOnly: true,
                                      onTap: () async {
                                        await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddressSearch()))
                                            .then((value) {
                                          marketlocationController.text =
                                              value['marketLocation'];
                                          latitude = value['latitude'];
                                          longitude = value['longitude'];
                                        });
                                      },
                                      controller: marketlocationController,
                                      decoration: InputDecoration(
                                          hintText:
                                              vendorData!["marketLocation"] ??
                                                  "Address",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.location_pin,
                                    color: primary,
                                    size: 30,
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 21,
                          ),
                          Container(
                              height: scHeight(context) / 13,
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 240, 235, 235),
                                  borderRadius: BorderRadius.circular(35)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: scWidth(context) * 0.71,
                                    child: TextField(
                                      readOnly: true,
                                      onTap: () async {
                                        await showTimePicker(
                                          context: context,
                                          initialTime: currentTime,
                                        ).then((value) {
                                          log(value.toString());
                                          setState(() {
                                            openTime = value!;
                                          });
                                          marketopeningtimeController.text =
                                              openTime.format(context);
                                        });
                                      },
                                      controller: marketopeningtimeController,
                                      decoration: InputDecoration(
                                          hintText:
                                              vendorData!["openingTime"] ??
                                                  "Opening Timing",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.access_time,
                                    color: primary,
                                    size: 30,
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 21,
                          ),
                          Container(
                              height: scHeight(context) / 13,
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 240, 235, 235),
                                  borderRadius: BorderRadius.circular(35)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: scWidth(context) * 0.71,
                                    child: TextField(
                                      readOnly: true,
                                      onTap: () async {
                                        await showTimePicker(
                                          context: context,
                                          initialTime: currentTime,
                                        ).then((value) {
                                          log(value.toString());
                                          setState(() {
                                            closeTime = value!;
                                          });
                                          marketclosingtimeController.text =
                                              closeTime.format(context);
                                        });
                                      },
                                      controller: marketclosingtimeController,
                                      decoration: InputDecoration(
                                          hintText:
                                              vendorData!["closingTime"] ??
                                                  "Closing Timing",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.access_time,
                                    color: primary,
                                    size: 30,
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 21,
                          ),
                          Text(
                            "Owner Details",
                            style: headline1(context: context),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 240, 235, 235),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                hintText: vendorData!['ownerName'] ?? "Name"),
                          ),
                          const SizedBox(
                            height: 21,
                          ),

                          Container(
                              height: scHeight(context) / 13,
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 240, 235, 235),
                                  borderRadius: BorderRadius.circular(35)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: scWidth(context) * 0.71,
                                    child: TextField(
                                      onTap: () async {
                                        await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1972),
                                                lastDate: DateTime(2044))
                                            .then((date) {
                                          setState(() {
                                            _dateTime = date!;
                                          });
                                          dateOfBirthController.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(_dateTime!);
                                        });
                                      },
                                      controller: dateOfBirthController,
                                      decoration: InputDecoration(
                                          hintText:
                                              vendorData!["date of birth"] ??
                                                  "Date of Birth",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.date_range,
                                    color: primary,
                                    size: 30,
                                  ),
                                ],
                              )),

                          const SizedBox(
                            height: 21,
                          ),
                          TextFormField(
                            controller: emailController,
                            onChanged: ((value) {
                              _formkey.currentState?.validate();
                            }),
                            validator: ((value) {
                              Pattern pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

                              RegExp regex = RegExp(pattern.toString());
                              if (!regex.hasMatch(value.toString())) {
                                return 'Please Enter Valid Email';
                              }
                            }),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 240, 235, 235),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                hintText: vendorData!['ownerEmail'] ?? "Email"),
                          ),
                          const SizedBox(
                            height: 21,
                          ),
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            onChanged: ((value) {
                              _formkey.currentState?.validate();
                            }),
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return 'Please Enter a Phone Number';
                              } else if (value.length <= 9 ||
                                  value.length > 10) {
                                return 'Please enter valid mobile number';
                              }
                            }),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 240, 235, 235),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                hintText: vendorData!['ownerPhone'] ??
                                    "Phone Number"),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Bank Details",
                            style: headline1(context: context),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: banknameController,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 240, 235, 235),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                hintText: vendorData!['accountName'] ??
                                    "Name as per Bank Account"),
                          ),
                          const SizedBox(
                            height: 21,
                          ),
                          TextFormField(
                            controller: accountnumberController,
                            // onChanged: ((value) {
                            //   _formkey.currentState?.validate();
                            // }),
                            // validator: ((value) {
                            //   Pattern pattern = ' ^\d{9,18}';

                            //   RegExp regex = RegExp(pattern.toString());
                            //   if (!regex.hasMatch(value.toString())) {
                            //     return 'Please Enter Valid Account Number';
                            //   }
                            // }),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 240, 235, 235),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                hintText: vendorData!['accountNumber'] ??
                                    "Account Number"),
                          ),
                          const SizedBox(
                            height: 21,
                          ),
                          TextFormField(
                            controller: ifsccodeController,
                            onChanged: ((value) {
                              _formkey.currentState?.validate();
                            }),
                            validator: ((value) {
                              Pattern pattern = "^[A-Za-z]{4}[a-zA-Z0-9]{7}";

                              RegExp regex = RegExp(pattern.toString());
                              if (!regex.hasMatch(value.toString())) {
                                return 'Please Enter Valid IFSC Code';
                              }
                            }),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 240, 235, 235),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      width: 12,
                                      color: Color.fromARGB(255, 240, 235, 235),
                                    ),
                                    borderRadius: BorderRadius.circular(35)),
                                hintText:
                                    vendorData!['ifscCode'] ?? "IFSC Code"),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          // vendorData!['categoryName'] == ""
                          isEdit
                              ? Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Category',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12.0,
                                    ),
                                    ListView.builder(
                                        itemCount: category.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (ctx, i) {
                                          return ListTile(
                                            leading: Text(category[i]['name']),
                                            trailing: Icon(
                                              category[i]['isComingsoon']
                                                  ? Icons.check_circle
                                                  : Icons.circle_outlined,
                                              color: category[i]['isComingsoon']
                                                  ? primary
                                                  : Colors.grey,
                                            ),
                                            onTap: () {
                                              category[i]['isComingsoon'] =
                                                  !category[i]['isComingsoon'];
                                              setState(() {});

                                              if (category[i]['isComingsoon'] ==
                                                  true) {
                                                categoryName
                                                    .add(category[i]['name']);
                                              } else if (category[i]
                                                      ['isComingsoon'] ==
                                                  false) {
                                                categoryName.remove(
                                                    category[i]['name']);
                                              }
                                              log(categoryName.toString());
                                            },
                                          );
                                        })
                                    // Padding(
                                    //   padding: const EdgeInsets.all(2.0),
                                    //   child: Container(
                                    //     height: scHeight(context) / 13,
                                    //     width: scWidth(context),
                                    //     margin: const EdgeInsets.only(top: 10),
                                    //     decoration: BoxDecoration(
                                    //         color: textLightColor
                                    //             .withOpacity(0.15),
                                    //         borderRadius:
                                    //             BorderRadius.circular(35)),
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.symmetric(
                                    //           vertical: 16, horizontal: 20),
                                    //       child: DropdownButton<String>(
                                    //           underline: SizedBox(),
                                    //           value: selectedItems,
                                    //           isExpanded: true,
                                    //           iconSize: 36,
                                    //           // disabledHint: const Text(
                                    //           //   'Select',
                                    //           //   style: TextStyle(
                                    //           //     fontFamily: 'NunitoSans',
                                    //           //     fontWeight: FontWeight.w400,
                                    //           //     fontSize: 14.0,
                                    //           //     color: Color(0xff94A3B8),
                                    //           //   ),
                                    //           // ),
                                    //           dropdownColor: Colors.white,
                                    //           icon: Icon(
                                    //             Icons
                                    //                 .keyboard_arrow_down_rounded,
                                    //             size: 25.0,
                                    //             color: Colors.grey[500],
                                    //           ),
                                    //           items: categoryName.map<
                                    //               DropdownMenuItem<String>>(
                                    //             (String country) {
                                    //               return DropdownMenuItem<
                                    //                   String>(
                                    //                 value: country,
                                    //                 child: Text(
                                    //                   country,
                                    //                   style: const TextStyle(
                                    //                       fontFamily: 'Nunito',
                                    //                       fontSize: 16.0),
                                    //                 ),
                                    //               );
                                    //             },
                                    //           ).toList(),
                                    //           onChanged: (String? newValue) {
                                    //             setState(() {
                                    //               selectedItems = newValue!;
                                    //               // isEdit = true;
                                    //             });
                                    //             // if (widget.label ==
                                    //             //     'Category') {
                                    //             //   categoryName = selectedItems;
                                    //             //   categoryId = widget.listItems
                                    //             //       .indexOf(selectedItems);
                                    //             // }
                                    //           }),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                )
                              : Container(
                                  height: scHeight(context) / 13,
                                  width: scWidth(context),
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      color: textLightColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: scWidth(context) * 0.7,
                                        child: Text(
                                          'Category Name: ${vendorData!['categoryName']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {
                                            isEdit = true;
                                            setState(() {});
                                          },
                                          child: Icon(Icons.edit))
                                    ],
                                  )),

                          const SizedBox(
                            height: 30,
                          ),
                          // vendorData!['gender'] == null
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender preference",
                                style: headline1(context: context),
                              ),
                              RadioListTile(
                                title: const Text("Male"),
                                value: "male",
                                groupValue: gender,
                                activeColor: primary,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value.toString();
                                    log(gender.toString());
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("Female"),
                                value: "female",
                                groupValue: gender,
                                activeColor: primary,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value.toString();
                                    log(gender.toString());
                                  });
                                },
                              ),
                              RadioListTile(
                                title: const Text("Other"),
                                value: "other",
                                groupValue: gender,
                                tileColor: primary,
                                activeColor: primary,
                                onChanged: (value) {
                                  setState(() {
                                    gender = value.toString();
                                    log(gender.toString());
                                  });
                                },
                              ),
                            ],
                          )
                          // : Container(
                          //     height: scHeight(context) / 13,
                          //     width: scWidth(context),
                          //     margin: const EdgeInsets.only(top: 10),
                          //     decoration: BoxDecoration(
                          //         color: textLightColor.withOpacity(0.15),
                          //         borderRadius: BorderRadius.circular(8)),
                          //     padding: const EdgeInsets.symmetric(
                          //         vertical: 16, horizontal: 20),
                          //     child: Text(
                          //       'Gender: ${vendorData!['gender']}',
                          //       style: bodyText1Bold(context: context),
                          //     )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButton(
                        ontap: () {
                          setState(() {
                            // FirebaseFirestore.instance
                            //     .collection("productItems")
                            //     .doc(FirebaseAuth.instance.currentUser!.uid
                            //         .substring(0, 20))
                            //     .set({
                            //   'list': FieldValue.arrayUnion([
                            //     {
                            //       "categoryName": categoryName,
                            //       "vendorId": FirebaseAuth
                            //           .instance.currentUser!.uid
                            //           .substring(0, 20),
                            //       "lowStock": false,
                            //       "inStock": true,
                            //       "vendorName":
                            //           marketnameController.text.trim(),
                            //     }
                            //   ])

                            // });
                            if (_imgUrl != '' &&
                                marketnameController.text != '' &&
                                marketEstablish.text != '' &&
                                marketemailController.text != '' &&
                                marketphoneController.text != '' &&
                                marketlocationController.text != '' &&
                                marketopeningtimeController.text != '' &&
                                marketclosingtimeController.text != '' &&
                                nameController.text != '' &&
                                dateOfBirthController.text != '' &&
                                emailController.text != '' &&
                                phoneController.text != '' &&
                                banknameController.text != '' &&
                                accountnumberController.text != '' &&
                                ifsccodeController.text != '') {
                              FirebaseFirestore.instance
                                  .collection("vendors")
                                  .doc(FirebaseAuth.instance.currentUser!.uid
                                      .substring(0, 20))
                                  .set({
                                "ownerEmail": emailController.text.trim(),
                                "ownerName": nameController.text.trim(),
                                "ownerPhone": phoneController.text.trim(),
                                "marketName": marketnameController.text.trim(),
                                "marketEmail":
                                    marketemailController.text.trim(),
                                "marketPhone":
                                    marketphoneController.text.trim(),
                                "openingTime":
                                    marketopeningtimeController.text.trim(),
                                "closingTime":
                                    marketclosingtimeController.text.trim(),
                                "accountName": banknameController.text.trim(),
                                "accountNumber":
                                    accountnumberController.text.trim(),
                                "ifscCode": ifsccodeController.text.trim(),
                                "marketEstablishment": _marketDate.toString(),
                                "marketLocation":
                                    marketlocationController.text.trim(),
                                'latitude': latitude,
                                'longitude': longitude,
                                "date of birth": _dateTime.toString(),
                                "gender": gender,
                                "image": _imgUrl,
                                "token": userToken,
                                "categoryName": categoryName,
                                "isVerified": true,
                                "isBlocked": false,
                                "vendorId": FirebaseAuth
                                    .instance.currentUser!.uid
                                    .substring(0, 20)
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please Fill All Details!');
                            }
                            // vendor.addVendorData(
                            //     categoryName: categoryName,
                            //     vendorAddress: marketlocationController.text,
                            //     vendorClosingTime:
                            //         marketclosingtimeController.text,
                            //     vendorEmail: marketemailController.text.trim(),
                            //     vendorId: FirebaseAuth.instance.currentUser!.uid
                            //         .substring(0, 20),
                            //     vendorImage: url,
                            //     vendorName: marketnameController.text,
                            //     vendorOnline: Provider.of<GlobalHelper>(context,
                            //             listen: false)
                            //         .isOnline,
                            //     vendorOpeningTime:
                            //         marketopeningtimeController.text,
                            //     vendorPhone: marketphoneController.text,
                            //     vendorProducts: products);
                          });

                          _imgUrl == ''
                              ? Fluttertoast.showToast(
                                  msg: 'Please select the Profile picture')
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomBottomNavigation()));
                        },
                        text: "Proceed")
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _imagePickerBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Choose option',
          ),
          content: isUploaded
              ? const SizedBox(
                  height: 50, width: 50, child: CircularProgressIndicator())
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: width(context) * 0.25,
                        height: height(context) * 0.1,
                        decoration: myOutlineBoxDecoration(1, primary, 30),
                        child: IconButton(
                            onPressed: () async {
                              XFile? image = await picker.pickImage(
                                  source: ImageSource.camera);
                              setState(() {
                                _image = File(image!.path);
                              });
                              log(image!.path.toString());
                            },
                            icon: const Icon(Icons.camera))),
                    Container(
                      width: width(context) * 0.25,
                      height: height(context) * 0.1,
                      decoration: myOutlineBoxDecoration(1, primary, 30),
                      child: IconButton(
                          onPressed: () async {
                            XFile? image = await picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              _image = File(image!.path);
                            });
                            log(image!.path.toString());
                          },
                          icon: const Icon(Icons.add_photo_alternate)),
                    ),
                  ],
                ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Upload'),
              onPressed: () async {
                if (_image.path.toString().isNotEmpty) {
                  var imageFile = File(_image!.path);
                  FirebaseStorage storage = FirebaseStorage.instance;
                  Reference ref = storage
                      .ref()
                      .child("Products/${DateTime.now().toString()}");

                  UploadTask uploadTask = ref.putFile(imageFile);
                  setState(() {
                    isUploaded = true;
                  });
                  await uploadTask.whenComplete(() async {
                    var url = await ref.getDownloadURL();
                    setState(() {
                      _imgUrl = url.toString();
                      isUploaded = false;
                      log(_imgUrl);
                    });
                    Navigator.pop(context);
                  }).catchError((onError) {
                    log(onError.toString());
                  });
                } else {
                  Fluttertoast.showToast(msg: "Please choose an image");
                }
              },
            ),
          ],
        );
      },
    );
  }
}
