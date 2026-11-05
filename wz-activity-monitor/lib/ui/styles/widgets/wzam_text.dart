import 'package:flutter/material.dart';
import 'package:wzam/ui/styles/text_styles.dart';

class WZAMText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  const WZAMText.styleOne(this.text,
      {super.key, this.textAlign = TextAlign.left})
      : style = styleOne;
  const WZAMText.styleTwo(this.text,
      {super.key, this.textAlign = TextAlign.left})
      : style = styleTwo;
  const WZAMText.styleThree(this.text,
      {super.key, this.textAlign = TextAlign.left})
      : style = styleThree;
  const WZAMText.styleFour(this.text,
      {super.key, this.textAlign = TextAlign.left})
      : style = styleFour;
  const WZAMText.styleFive(this.text,
      {super.key, this.textAlign = TextAlign.left})
      : style = styleFive;
  const WZAMText.body(this.text,
      {super.key, this.textAlign = TextAlign.left, this.style = styleBody});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
}

class ClickableText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Function()? onTap;

  const ClickableText({
    super.key,
    required this.text,
    required this.onTap,
    this.style = underlinedStyleTwo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(text, style: style),
    );
  }
}
