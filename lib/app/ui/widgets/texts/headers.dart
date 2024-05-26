import 'package:flutter/material.dart';

class LargeHeader extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;

  const LargeHeader({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: color,
          ),
    );
  }
}

class MediumHeader extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;

  const MediumHeader({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(color: color),
    );
  }
}

class SmallHeader extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;

  const SmallHeader({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      style: TextStyle(
        color: color,
        fontSize: 36,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class ExtraSmallHeader extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;

  const ExtraSmallHeader(
      {super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color),
    );
  }
}
