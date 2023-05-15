import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class MyProfile extends StatefulWidget {
  static String routeName = '/EditProfileScrn';

  const MyProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  ImagePicker picker = ImagePicker();
  var _image;
  String _imgUrl = '';
  bool isUploaded = false;

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
  List itemList = [];
  List category = [];
  List<String> categoryName = ['Select'];
  _getCategories() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc('FMZcGZDuso9BQcMLvfXO')
        .get()
        .then((value) {
      categoryItem = value.data()!;
      if (categoryItem != null) {
        category = categoryItem['category'];
        for (var doc in category) {
          categoryName.add(doc['name']);
        }
        log("sumit patil knddnid$categoryName");
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    callApi();
    _getProfileData();
    _getCategories();

    super.initState();
  }

  var marketSince;

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
            const BackButton(),
            SizedBox(
              width: scWidth(context) * 0.1,
            ),
            Text("My Profile", style: headline1ExtraLarge(context: context)),
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
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Market Name : ${vendorData!['marketName']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 12),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Market Since : ${vendorData!['marketEstablishment']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 12),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Market Email : ${vendorData!['marketEmail']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 12),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Market Phone no : ${vendorData!['marketPhone']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 18),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Address : ${vendorData!['marketLocation']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 18),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Opening Time : ${vendorData!['openingTime']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 18),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Closing Time : ${vendorData!['closingTime']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 30,
                          ),

                          Text(
                            "Owner Details",
                            style: headline1(context: context),
                          ),

                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 18),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Owner Name : ${vendorData!['ownerName']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 18),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Date of Birth : ${vendorData!['date of birth']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 18),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Owner Email : ${vendorData!['ownerEmail']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 18),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Owner Phone : ${vendorData!['ownerPhone']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 18),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Gender : ${vendorData!['gender']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Bank Details",
                            style: headline1(context: context),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 18),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Name as Per Bank : ${vendorData!['accountName']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 18),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Account Number : ${vendorData!['accountNumber']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: scHeight(context) * 0.06,
                            width: scWidth(context) * 0.95,
                            decoration: shadowDecoration(30, 4),
                            padding: EdgeInsets.only(left: 12),
                            margin: EdgeInsets.only(top: 18),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'IFSC Code : ${vendorData!['ifscCode']}',
                                    style: bodyText16w600(color: black),
                                  ),
                                ],
                              ),
                            ),
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
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        height: scHeight(context) / 13,
                                        width: scWidth(context),
                                        margin: const EdgeInsets.only(top: 10),
                                        decoration: BoxDecoration(
                                            color: textLightColor
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(35)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16, horizontal: 20),
                                          child: DropdownButton<String>(
                                              underline: SizedBox(),
                                              value: selectedItems,
                                              isExpanded: true,
                                              iconSize: 36,
                                              // disabledHint: const Text(
                                              //   'Select',
                                              //   style: TextStyle(
                                              //     fontFamily: 'NunitoSans',
                                              //     fontWeight: FontWeight.w400,
                                              //     fontSize: 14.0,
                                              //     color: Color(0xff94A3B8),
                                              //   ),
                                              // ),
                                              dropdownColor: Colors.white,
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: 25.0,
                                                color: Colors.grey[500],
                                              ),
                                              items: categoryName.map<
                                                  DropdownMenuItem<String>>(
                                                (String country) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: country,
                                                    child: Text(
                                                      country,
                                                      style: const TextStyle(
                                                          fontFamily: 'Nunito',
                                                          fontSize: 16.0),
                                                    ),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedItems = newValue!;
                                                  // isEdit = true;
                                                });
                                                // if (widget.label ==
                                                //     'Category') {
                                                //   categoryName = selectedItems;
                                                //   categoryId = widget.listItems
                                                //       .indexOf(selectedItems);
                                                // }
                                              }),
                                        ),
                                      ),
                                    ),
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
                                      vertical: 16, horizontal: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Category Name: ${vendorData!['categoryName']}',
                                        style: bodyText1Bold(context: context),
                                      ),
                                      // IconButton(
                                      //     onPressed: () {
                                      //       isEdit = true;
                                      //       setState(() {});
                                      //     },
                                      //     icon: Icon(Icons.edit))
                                    ],
                                  )),

                          // SizedBox(
                          //   height: scHeight(context) * 0.5,
                          //   child: ListView.builder(
                          //       itemCount: categoryName.length,
                          //       itemBuilder: (ctx, i) {
                          //         return ListTile(
                          //           onTap: () {
                          //             itemList.add(categoryName[i]);
                          //             // categoryName.add(itemList[i]);
                          //             log(itemList[i].toString());
                          //           },
                          //           title: Text(categoryName[i]),
                          //           trailing: Icon(Icons.circle_outlined),
                          //         );
                          //       }),
                          // )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
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
