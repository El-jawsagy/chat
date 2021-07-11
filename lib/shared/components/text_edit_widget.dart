//core and pub package

import 'package:chat_app/shared/themes/light_theme.dart';
import 'package:flutter/material.dart';

class TextEditWidget extends StatelessWidget {
  final String title;
  final bool isObscure;
  final TextInputType type;

  final bool isPassword;
  final TextEditingController textEditingController;
  final Function onValidate;
  final Function onSubmit;
  final Function onChange;
  final Function onTap;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final Function suffixPressed;
  TextEditWidget({
    Key key,
    this.title = "Defualt Text",
    @required this.textEditingController,
    this.type = TextInputType.text,
    this.onChange,
    this.onTap,
    this.onSubmit,
    this.isPassword = false,
    this.isObscure = false,
    this.prefixIcon = Icons.edit,
    this.suffixIcon = Icons.visibility,
    this.suffixPressed,
    @required this.onValidate,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      keyboardType: type,
      obscureText: isObscure,
      // enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      enableInteractiveSelection: false,
      onTap: onTap,
      validator: onValidate,
      decoration: InputDecoration(
        labelText: title,
        prefixIcon: Icon(
          prefixIcon,
        ),
        suffixIcon: isPassword
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffixIcon,
                ),
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );
  }
}
