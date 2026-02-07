import 'package:flutter/material.dart';

class HeadlineLarge extends StatelessWidget {
  final String? text;
  final Color? color;
  final TextAlign? align;

  const HeadlineLarge(
    this.text, {
    super.key,
    this.color,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      textAlign: align ?? TextAlign.left,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: color),
    );
  }
}

class HeadlineMedium extends StatelessWidget {
  final String? text;
  final Color? color;
  final TextAlign? align;

  const HeadlineMedium(
    this.text, {
    super.key,
    this.color,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      textAlign: align ?? TextAlign.left,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: color),
    );
  }
}

class HeadlineSmall extends StatelessWidget {
  final String? text;
  final Color? color;
  final TextAlign? align;

  const HeadlineSmall(
    this.text, {
    super.key,
    this.color,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      textAlign: align ?? TextAlign.left,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color),
    );
  }
}

class HeadlineExtraSmall extends StatelessWidget {
  final String? text;
  final Color? color;
  final TextAlign? align;

  const HeadlineExtraSmall(
    this.text, {
    super.key,
    this.color,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      textAlign: align ?? TextAlign.left,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontSize: 20),
    );
  }
}
