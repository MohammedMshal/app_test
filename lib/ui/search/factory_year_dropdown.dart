import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';

class FactoryYearDropDown extends StatelessWidget {
  final Function updateFunction;
  final Function validateFunction;
  final String value;
  final bool autoValidate;
  final List<String> items;

  FactoryYearDropDown(
      {this.updateFunction,
      this.autoValidate = false,
      this.value,
      this.validateFunction,
      this.items});

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<String>> _dropDownMenuItems = items.map((item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Container(
            child: Text(
          item,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12),
        )),
      );
    }).toList();

    String holder = YemString().factoryYear;
    String hint = YemString().factoryYear;

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
              Icons.date_range,
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
