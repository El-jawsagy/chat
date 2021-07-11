import 'package:chat_app/shared/themes/light_theme.dart';
import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onButtonPress;
  const RoundedButtonWidget({
    Key key,
    this.text = "defualt Text",
    this.onButtonPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onButtonPress,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline3,
      ),
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: 12,
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(
            MediaQuery.of(context).size.width * 0.3,
            48,
          ),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(
          ThemeShared.backGround,
        ),
      ),
    );
  }
}
