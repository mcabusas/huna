import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TrailingButton extends StatelessWidget {
  TrailingButton({@required this.onPressed, @required this.buttonColor, @required this.buttonTitle, @required this.padding, @required this.icon, @required this.visible, this.setState});

  Function onPressed;
  Function setState;
  Color buttonColor;
  String buttonTitle;
  EdgeInsetsGeometry padding;
  Widget icon;
  bool visible;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Visibility(
        child: RaisedButton.icon(
          icon: icon,
          label: Text(buttonTitle),
          color: buttonColor,
          textColor: Colors.white,
          onPressed: onPressed,
        ),
        visible: visible,
      )
    );
  }
}

TrailingButton pretestBtn, acceptBtn, cancelBtn;