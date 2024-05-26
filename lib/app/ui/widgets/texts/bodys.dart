import 'package:flutter/material.dart';

class BodyLarge extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;

  const BodyLarge({super.key, required this.text, this.color, this.align});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.left,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
    );
  }
}

class BodyMedium extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const BodyMedium({
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
      overflow: overflow ?? TextOverflow.visible,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
    );
  }
}

class BodySmall extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const BodySmall({
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
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
    );
  }
}

class BodyExtraSmall extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  const BodyExtraSmall({
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
      overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines,
      style: Theme.of(context)
          .textTheme
          .bodySmall
          ?.copyWith(color: color, fontSize: 10),
    );
  }
}
