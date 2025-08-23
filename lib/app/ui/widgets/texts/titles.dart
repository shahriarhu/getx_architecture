import 'package:flutter/material.dart';

class TitleExtraLarge extends StatelessWidget {
  final String? text;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const TitleExtraLarge({
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
      text ?? '',
      textAlign: align ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontSize: 18),
    );
  }
}

class TitleLarge extends StatelessWidget {
  final String? text;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const TitleLarge({
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
      text ?? '',
      textAlign: align ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color),
    );
  }
}

class TitleMedium extends StatelessWidget {
  final String? text;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const TitleMedium({
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
      text ?? '',
      textAlign: align ?? TextAlign.left,
      overflow: overflow ?? TextOverflow.visible,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
    );
  }
}

class TitleSmall extends StatelessWidget {
  final String? text;
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
      text ?? '',
      textAlign: align ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color),
    );
  }
}

class TitleExtraSmall extends StatelessWidget {
  final String? text;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const TitleExtraSmall({
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
      text ?? '',
      textAlign: align ?? TextAlign.left,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.visible,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color, fontSize: 10),
    );
  }
}
