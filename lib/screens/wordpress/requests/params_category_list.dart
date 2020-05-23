import '../constants.dart';

/// This class holds all arguments which can be used to filter Categories when using
/// [WordPress.fetchCategories] method.
///
/// [List Categories' Arguments](https://developer.wordpress.org/rest-api/reference/categories/#list-categories)
class ParamsCategoryList {
  final WordPressContext context;
  final int pageNum;
  final int perPage;
  final String searchQuery;
  final List<int> excludeCategoryIDs;
  final List<int> includeCategoryIDs;
  final Order order;
  final CategoryTagOrderBy orderBy;
  final bool hideEmpty;
  final int parent;
  final int post;
  final String slug;

  ParamsCategoryList({
    this.context = WordPressContext.view,
    this.pageNum = 1,
    this.perPage = 10,
    this.searchQuery = '',
    this.excludeCategoryIDs,
    this.includeCategoryIDs,
    this.order = Order.asc,
    this.orderBy = CategoryTagOrderBy.name,
    this.hideEmpty,
    this.parent,
    this.post,
    this.slug = '',
  });

  Map<String, String> toMap() {
    return {
      'context': '${enumStringToName(this.context.toString())}',
      'page': '${this.pageNum}',
      'per_page': '${this.perPage}',
      'search': '${this.searchQuery}',
      'exclude': '${listToUrlString(this.excludeCategoryIDs)}',
      'include': '${listToUrlString(this.includeCategoryIDs)}',
      'order': '${enumStringToName(this.order.toString())}',
      'orderby': '${enumStringToName(this.orderBy.toString())}',
      'hide_empty': '${this.hideEmpty == null ? '' : this.hideEmpty}',
      'parent': '${this.parent == null ? '' : this.parent}',
      'post': '${this.post == null ? '' : this.post}',
      'slug': '${this.slug}',
    };
  }

  @override
  String toString() {
    return constructUrlParams(toMap());
  }
}
