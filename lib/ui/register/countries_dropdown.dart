import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';

import 'items_model.dart';

class CountriesDropDown extends StatelessWidget {
  final Function updateFunction;
  final Function validateFunction;
  final String
   value;
  final bool autoValidate;
  final List<ItemsModel> items;

  CountriesDropDown(
      {this.updateFunction,
      this.autoValidate = false,
      this.value,
      this.validateFunction,
      this.items});

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> _dropDownMenuItems = items.map((item) {
      return DropdownMenuItem<String>(
        value: '${item.id}',
        child: Container(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
          '${item.name}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12),
        ),
                  SizedBox(width: 8),
                  CachedNetworkImage(
                    imageUrl: item.other != null?item.other.isNotEmpty?item.other:'':'',
                    height: 30,
                  )
                ],
              ),
            )),
      );
    }).toList();

    String holder = YemString().countryHolder;
    String hint = YemString().countryHint;
    // ignore: unused_local_variable
    String error = YemString().countrySelect;

    return DropdownButtonFormField<String>(
      isDense: true,
      autovalidateMode: AutovalidateMode.always,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[700], width: 0.2)),
        errorStyle: TextStyle(color: Colors.deepOrange),
        hintStyle: TextStyle(fontSize: 12),
//        suffixIcon: Icon(Icons.done, color: Colors.green),
        labelText: holder,
        labelStyle: TextStyle(fontSize: 12),
        hintText: hint,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            child: Icon(
              Icons.flag,
              color: AppColors().primaryColor(),
            ),
          ),
        ),
      ),
      items: _dropDownMenuItems,
      value: value,
      onChanged: updateFunction,
      onSaved: updateFunction,
      validator: validateFunction,
    );
  }
}
