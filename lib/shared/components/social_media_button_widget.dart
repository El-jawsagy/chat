import 'package:chat_app/shared/themes/light_theme.dart';
import 'package:flutter/material.dart';

class SocialRoundedButtonWidget extends StatelessWidget {
  final String text;
  final String imagePath;
  final double buttonHeight;
  final double buttonwidth;
  final Color backgroungColor;
  final Color textColor;

  final VoidCallback onButtonPress;
  const SocialRoundedButtonWidget({
    Key key,
    this.text = "defualt Text",
    this.imagePath = "assets/images/crowd.png",
    this.buttonHeight = .07,
    this.buttonwidth = .8,
    this.backgroungColor = ThemeShared.backGround,
    this.textColor = ThemeShared.textLightColor,
    this.onButtonPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * buttonwidth,
      height: MediaQuery.of(context).size.height * buttonHeight,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            spreadRadius: .15,
            color: ThemeShared.textDarkColor,
          ),
        ],
        color: backgroungColor,
        borderRadius: BorderRadius.circular(
          9,
        ),
      ),
      child: Row(
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              imagePath,
              width: 50,
              height: 50,
            ),
          ),
          Spacer(
            flex: 1,
          ),
          TextButton(
            onPressed: onButtonPress,
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headline3
                  .copyWith(color: textColor),
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
            ),
          ),
          Spacer(
            flex: 4,
          ),
        ],
      ),
    );
  }
}
