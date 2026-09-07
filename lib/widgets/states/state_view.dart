import 'package:flutter/material.dart';

import '../../core/state/view_state.dart';
import 'status_views.dart';

/// Renders a [ViewState] and nothing else.
///
/// Screens supply only the success case; loading, empty and error get sane
/// defaults, which is what stops every feature inventing its own spinner and
/// error text. The `switch` is exhaustive, so a new [ViewState] variant will
/// not compile until it is handled here.
///
/// ```dart
/// Obx(() => StateView(
///       state: controller.articles.value,
///       onRetry: controller.load,
///       builder: (articles) => ArticleList(articles),
///     ))
/// ```
class StateView<T> extends StatelessWidget {
  const StateView({
    super.key,
    required this.state,
    required this.builder,
    this.onRetry,
    this.idleBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.emptyTitle,
    this.emptyMessage,
  });

  final ViewState<T> state;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;

  final WidgetBuilder? idleBuilder;
  final WidgetBuilder? loadingBuilder;
  final WidgetBuilder? emptyBuilder;
  final Widget Function(BuildContext context, ErrorState<T> state)?
  errorBuilder;

  final String? emptyTitle;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) => switch (state) {
    IdleState<T>() => idleBuilder?.call(context) ?? const SizedBox.shrink(),
    LoadingState<T>() => loadingBuilder?.call(context) ?? const LoadingView(),
    SuccessState<T>(:final data) => builder(data),
    EmptyState<T>() =>
      emptyBuilder?.call(context) ??
          EmptyView(
            title: emptyTitle,
            message: emptyMessage,
            onRetry: onRetry,
          ),
    final ErrorState<T> error =>
      errorBuilder?.call(context, error) ??
          ErrorView(
            error: error.error,
            onRetry:
                error.error.isRetryable || onRetry != null ? onRetry : null,
          ),
  };
}
