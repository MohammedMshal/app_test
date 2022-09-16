import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:kokylive/helper/app_config.dart';

class EditText extends StatelessWidget {
  final Function updateFunc;
  final Function validateFunc;
  final IconData iconData;
  final String suffixText;
  final String hint;
  final String value;
  final int lines;
  final double fontSize;
  final bool enable;
  final bool autoValidate;
  final TextInputType type;
  final List<TextInputFormatter> formatter;

  EditText({
    this.autoValidate = false,
    this.updateFunc,
    this.validateFunc,
    this.iconData,
    this.value,
    this.fontSize = 14,
    this.hint,
    this.suffixText,
    this.lines = 1,
    this.enable = true,
    this.formatter,
    this.type = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.all(Radius.circular(4)),
      child: TextFormField(
      autovalidateMode: AutovalidateMode.always,
        initialValue: value,
        decoration: InputDecoration(
            border: InputBorder.none,
            errorStyle: TextStyle(fontSize: 10),
            labelStyle: TextStyle(fontSize: fontSize),
            hintStyle: TextStyle(fontSize: fontSize),
//          labelText: namePlaceHolder,
            hintText: hint,
            counterStyle: TextStyle(color: Colors.green),
            suffixText: suffixText,
            prefixIcon: Material(
              elevation: 0,
              borderRadius: BorderRadius.all(Radius.circular(4)),
              child: Icon(
                iconData,
                color: AppColors().primaryColor(),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
        keyboardType: type,
        validator: (text) {
          if (validateFunc != null) return validateFunc(text);
          return null;
        },
        enabled: enable,
        maxLines: lines,
        inputFormatters: formatter,
        onSaved: (newValue) {
          if (updateFunc != null) return updateFunc(newValue);
          return () {};
        },
      ),
    );
  }
}
