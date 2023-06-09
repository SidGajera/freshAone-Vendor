// ignore_for_file: invalid_required_positional_param

import 'package:flutter/material.dart';
import 'package:meat4u_vendor/utils/constant.dart';

class DropDownSelector extends StatefulWidget {
  final String label;
  final List<String> listItems;
  final String? selectedItem;
  const DropDownSelector(@required this.label, @required this.listItems,
      @required this.selectedItem,
      {Key? key})
      : super(key: key);

  @override
  _DropDownSelectorState createState() => _DropDownSelectorState();
}

class _DropDownSelectorState extends State<DropDownSelector> {
  String selectedItems = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedItems = widget.selectedItem.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.label,
            style: const TextStyle(
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
                color: textLightColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(35)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: DropdownButton<String>(
                  value: selectedItems,
                  isExpanded: true,
                  iconSize: 36,
                  disabledHint: const Text(
                    'Select',
                    style: TextStyle(
                      fontFamily: 'NunitoSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                      color: Color(0xff94A3B8),
                    ),
                  ),
                  dropdownColor: Colors.white,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 25.0,
                    color: Colors.grey[500],
                  ),
                  items: widget.listItems.map<DropdownMenuItem<String>>(
                    (String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(
                          country,
                          style: const TextStyle(
                              fontFamily: 'Nunito', fontSize: 16.0),
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedItems = newValue!;
                      // isEdit = true;
                    });
                    if (widget.label == 'Category') {
                      categoryName = selectedItems;
                      categoryId = widget.listItems.indexOf(selectedItems);
                    }
                  }),
            ),
          ),
        ),
      ],
    );
  }
}
