import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/api_response.dart';
import 'article.dart';

/// Data access for the home feature.
class HomeRepository {
  const HomeRepository(this._api);

  final ApiClient _api;

  Future<List<Article>> fetchArticles({
    int page = 1,
    int limit = AppConstants.defaultPageSize,
  }) async {
    final response = await _api.get<dynamic>(
      ApiEndpoints.articles,
      query: {'_page': page, '_limit': limit},
    );

    return ApiResponse.fromJson(
      response.data,
      (data) => (data as List<dynamic>)
          .map((item) => Article.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
    ).requireData;
  }

  Future<Article> fetchArticle(String id) async {
    final response = await _api.get<dynamic>(ApiEndpoints.article(id));

    return ApiResponse.fromJson(
      response.data,
      (data) => Article.fromJson(data as Map<String, dynamic>),
    ).requireData;
  }
}
