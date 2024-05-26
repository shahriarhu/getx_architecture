import 'package:flutter/material.dart';

class TitleLarge extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const TitleLarge(
      {super.key,
      required this.text,
      this.color,
      this.align,
      this.overflow,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color),
    );
  }
}

class TitleMedium extends StatelessWidget {
  final BuildContext? cntx;
  final String text;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const TitleMedium(
      {super.key,
      required this.text,
      this.color,
      this.align,
      this.cntx,
      this.overflow,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      overflow: overflow ?? TextOverflow.visible,
      maxLines: maxLines,
      style: Theme.of(cntx ?? context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class TitleSmall extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const TitleSmall({
    super.key,
    required this.text,
    this.color,
    this.align,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
      style: Theme.of(context)
          .textTheme
          .titleSmall
          ?.copyWith(color: color, height: 1.2),
    );
  }
}

class TitleExtraSmall extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const TitleExtraSmall(
      {super.key,
      required this.text,
      this.color,
      this.align,
      this.overflow,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
    );
  }
}
