import 'package:get/get.dart';

import '../errors/app_exception.dart';
import '../logging/app_logger.dart';

/// The state of one asynchronous piece of screen data.
///
/// Sealed, so `switch` over it is exhaustive: adding a state makes every widget
/// that renders it fail to compile until it is handled.
sealed class ViewState<T> {
  const ViewState();

  T? get dataOrNull =>
      this is SuccessState<T> ? (this as SuccessState<T>).data : null;

  AppException? get errorOrNull =>
      this is ErrorState<T> ? (this as ErrorState<T>).error : null;

  bool get isLoading => this is LoadingState<T>;

  bool get isSuccess => this is SuccessState<T>;

  bool get hasError => this is ErrorState<T>;
}

/// Nothing requested yet.
final class IdleState<T> extends ViewState<T> {
  const IdleState();
}

final class LoadingState<T> extends ViewState<T> {
  const LoadingState();
}

/// Loaded, with data.
final class SuccessState<T> extends ViewState<T> {
  const SuccessState(this.data);

  final T data;
}

/// Loaded, but there is nothing to show.
final class EmptyState<T> extends ViewState<T> {
  const EmptyState();
}

final class ErrorState<T> extends ViewState<T> {
  const ErrorState(this.error);

  final AppException error;
}

/// Runs an async task and maps its outcome onto a [ViewState].
///
/// This is the one piece of "framework" a controller needs — it removes the
/// try/catch/loading dance from every method:
///
/// ```dart
/// final articles = Rx<ViewState<List<Article>>>(const IdleState());
///
/// Future<void> load() => articles.runAsync(
///       () => _repository.fetchArticles(),
///       isEmpty: (list) => list.isEmpty,
///     );
/// ```
extension ViewStateRunner<T> on Rx<ViewState<T>> {
  Future<void> runAsync(
    Future<T> Function() task, {
    bool Function(T data)? isEmpty,

    /// Set to false for pull-to-refresh, so existing content stays on screen.
    bool showLoading = true,
  }) async {
    if (showLoading) value = LoadingState<T>();
    try {
      final data = await task();
      value =
          (isEmpty?.call(data) ?? false)
              ? EmptyState<T>()
              : SuccessState<T>(data);
    } catch (error, stackTrace) {
      final failure = AppException.from(error, stackTrace);
      AppLogger.e(
        'Async task failed',
        name: 'STATE',
        error: failure,
        stackTrace: stackTrace,
      );
      value = ErrorState<T>(failure);
    }
  }
}
