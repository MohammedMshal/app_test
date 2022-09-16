import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';
import 'package:kokylive/network_models/response_main_data.dart';

class CategoriesDropDown extends StatelessWidget {
  final Function updateFunction;
  final Function validateFunction;
  final String value;
  final bool autoValidate;
  final List<Category> items;

  CategoriesDropDown(
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
            child: Text(
          '${item.name}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12),
        )),
      );
    }).toList();

    String holder = YemString().categories;

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
        hintText: holder,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            child: Icon(
              Icons.category,
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
