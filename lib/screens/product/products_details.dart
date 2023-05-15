import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../utils/constant.dart';

class ProductsDetails extends StatefulWidget {
  final Map data;
  const ProductsDetails({super.key, required this.data});

  @override
  State<ProductsDetails> createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: const BackButton(),
        title: Text("Products Details",
            style: headline1ExtraLarge(context: context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: scHeight(context) * 0.25,
                width: width(context) * 0.6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.data['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            addVerticalSpace(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: scWidth(context) * 0.64,
                  child: Text(
                    widget.data['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(),
                Text(
                  'Price : ',
                  style: TextStyle(color: black.withOpacity(0.5)),
                ),
                Text(
                  'Rs.${widget.data['price']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            addVerticalSpace(10),
            Text(
              "Description :",
              style: TextStyle(color: black.withOpacity(0.5)),
            ),
            addVerticalSpace(4),
            Text(
              widget.data['discription'],
            )
          ],
        ),
      ),
    );
  }
}
