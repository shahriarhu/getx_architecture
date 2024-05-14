import 'package:flutter/material.dart';

enum DataState { loading, success, empty, error, offline, initial }

class ViewStateLayout extends StatelessWidget {
  final DataState dataState;
  final Widget loadingWidget;
  final Widget successWidget;
  final Widget? initialWidget;
  final Widget? emptyWidget;
  final Widget? errorWidget;
  final Widget? offlineWidget;

  const ViewStateLayout({
    super.key,
    required this.dataState,
    required this.loadingWidget,
    required this.successWidget,
    this.emptyWidget,
    this.errorWidget,
    this.offlineWidget,
    this.initialWidget,
  });

  @override
  Widget build(BuildContext context) {
    switch (dataState) {
      case DataState.loading:
        return loadingWidget;
      case DataState.success:
        return successWidget;
      case DataState.initial:
        return initialWidget ?? Container();
      case DataState.empty:
        return emptyWidget ?? Container();
      case DataState.error:
        return errorWidget ?? Container();
      case DataState.offline:
        return offlineWidget ?? Container();
      default:
        return loadingWidget;
    }
  }
}
