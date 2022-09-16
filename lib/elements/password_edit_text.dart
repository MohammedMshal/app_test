import 'package:flutter/material.dart';
import 'package:kokylive/helper/app_config.dart';
import 'package:kokylive/helper/strings.dart';

bool obscurePassword = true;

class EditTextPassword extends StatefulWidget {
  final Function updatePassword;
  final bool autoValidate;
  final Function validateFunc;

  EditTextPassword(
      {this.updatePassword, this.autoValidate = false, this.validateFunc});

  @override
  _EditTextPasswordState createState() => _EditTextPasswordState();
}

class _EditTextPasswordState extends State<EditTextPassword> {
  @override
  Widget build(BuildContext context) {
    String passwordHint = YemString().passwordHint;

    void changePasswordVisibility() {
      setState(() {
        obscurePassword = !obscurePassword;
      });
    }

    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.all(Radius.circular(4)),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.always,
        decoration: InputDecoration(
            border: InputBorder.none,
            errorStyle: TextStyle(fontSize: 10),
            labelStyle: TextStyle(fontSize: 14),
            hintStyle: TextStyle(fontSize: 14),
            hintText: passwordHint,
            suffixIcon: GestureDetector(
              child: Material(
                elevation: 0,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                child: Icon(
                    obscurePassword ? Icons.remove_red_eye : Icons.security),
              ),
              onTap: changePasswordVisibility,
            ),
            prefixIcon: Material(
              elevation: 0,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              child: Icon(
                Icons.lock_outline,
                color: AppColors().primaryColor(),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
        obscureText: obscurePassword,
        keyboardType: TextInputType.text,
        validator: widget.validateFunc,
        onSaved: widget.updatePassword,
      ),
    );
  }
}
