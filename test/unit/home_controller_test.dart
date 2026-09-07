import 'package:flutter_test/flutter_test.dart';
import 'package:getx_architecture/core/errors/app_exception.dart';
import 'package:getx_architecture/core/session/session_service.dart';
import 'package:getx_architecture/core/session/token_store.dart';
import 'package:getx_architecture/core/state/view_state.dart';
import 'package:getx_architecture/core/storage/key_value_store.dart';
import 'package:getx_architecture/features/home/data/article.dart';
import 'package:getx_architecture/features/home/data/home_repository.dart';
import 'package:getx_architecture/features/home/home_controller.dart';
import 'package:getx_architecture/l10n/translation_keys.dart';

import '../helpers/test_app.dart';

class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository({this.articles = const [], this.error});

  final List<Article> articles;
  final AppException? error;
  int fetchCount = 0;

  @override
  Future<List<Article>> fetchArticles({int page = 1, int limit = 20}) async {
    fetchCount++;
    if (error != null) throw error!;
    return articles;
  }

  @override
  Future<Article> fetchArticle(String id) async =>
      articles.firstWhere((a) => a.id == id);
}

const _articles = [
  Article(id: '1', title: 'Flutter tips', body: 'Widgets all the way down'),
  Article(id: '2', title: 'Dart records', body: 'Tuples, finally'),
];

HomeController buildController(FakeHomeRepository repository) => HomeController(
  repository: repository,
  session: SessionService(
    tokenStore: InMemoryTokenStore(),
    store: InMemoryKeyValueStore(),
  ),
);

void main() {
  setUp(setUpTestApp);

  test('onInit loads articles into a success state', () async {
    final controller = buildController(
      FakeHomeRepository(articles: _articles),
    )..onInit();
    await Future<void>.delayed(Duration.zero);

    expect(controller.articles.value, isA<SuccessState<List<Article>>>());
    expect(controller.articles.value.dataOrNull, hasLength(2));
  });

  test('an empty response becomes an empty state, not an empty list', () async {
    final controller = buildController(FakeHomeRepository());

    await controller.load();

    expect(controller.articles.value, isA<EmptyState<List<Article>>>());
  });

  test('a failure becomes an error state carrying the exception', () async {
    final controller = buildController(
      FakeHomeRepository(
        error: const AppException(
          type: AppErrorType.server,
          messageKey: LocaleKeys.errorServer,
        ),
      ),
    );

    await controller.load();

    expect(controller.articles.value.errorOrNull?.type, AppErrorType.server);
  });

  test('refreshArticles does not flip back to loading', () async {
    final repository = FakeHomeRepository(articles: _articles);
    final controller = buildController(repository);
    await controller.load();

    final seen = <ViewState<List<Article>>>[];
    controller.articles.listen(seen.add);
    await controller.refreshArticles();

    expect(seen.whereType<LoadingState<List<Article>>>(), isEmpty);
    expect(repository.fetchCount, 2);
  });

  test('visible() filters by the debounced query', () async {
    final controller = buildController(
      FakeHomeRepository(articles: _articles),
    );
    await controller.load();

    expect(controller.visible(_articles), hasLength(2));

    controller.query.value = 'records';
    expect(controller.visible(_articles).single.id, '2');

    controller.query.value = 'WIDGETS';
    expect(controller.visible(_articles).single.id, '1');
  });
}
