import 'package:get/get.dart';

import '../../core/session/session_service.dart';
import '../../core/session/user.dart';
import '../../core/state/view_state.dart';
import '../../core/utils/debouncer.dart';
import 'data/article.dart';
import 'data/home_repository.dart';

/// Home screen logic.
///
/// The whole load/empty/error dance is one call to [ViewStateRunner.runAsync];
/// there is no try/catch or manual `isLoading` flag to keep in sync.
class HomeController extends GetxController {
  HomeController({
    required HomeRepository repository,
    required SessionService session,
  }) : _repository = repository,
       _session = session;

  final HomeRepository _repository;
  final SessionService _session;
  final _searchDebouncer = Debouncer();

  final Rx<ViewState<List<Article>>> articles = Rx<ViewState<List<Article>>>(
    const IdleState(),
  );

  final RxString query = ''.obs;

  User? get user => _session.user.value;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() => articles.runAsync(
    () => _repository.fetchArticles(),
    isEmpty: (items) => items.isEmpty,
  );

  /// Pull-to-refresh keeps the current list visible while reloading.
  /// Named `refreshArticles` rather than `refresh` so it does not shadow
  /// `GetxController.refresh()`, which rebuilds `GetBuilder` listeners.
  Future<void> refreshArticles() => articles.runAsync(
    () => _repository.fetchArticles(),
    isEmpty: (items) => items.isEmpty,
    showLoading: false,
  );

  /// Debounced so a fast typist triggers one filter pass, not one per keypress.
  void onSearchChanged(String value) =>
      _searchDebouncer.run(() => query.value = value.trim());

  /// Applies the active query. Called inside the reactive builder so the list
  /// updates when either the data or the query changes.
  List<Article> visible(List<Article> items) {
    final needle = query.value;
    if (needle.isEmpty) return items;
    return items.where((article) => article.matches(needle)).toList();
  }

  @override
  void onClose() {
    _searchDebouncer.dispose();
    super.onClose();
  }
}
