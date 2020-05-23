/// This library uses [WordPress REST API V2](https://developer.wordpress.org/rest-api/)
/// to provide a way for your application to interact with your WordPress website.
///
/// We use terminologies similar to the [WordPress REST API](https://developer.wordpress.org/rest-api/)
///
/// For authentication and usage of administrator level APIs, we have implemented
/// two popular authentication plugins:
///
/// 1. [Application Passwords](https://wordpress.org/plugins/application-passwords/)
/// 2. [JWT Authentication for WP REST API](https://wordpress.org/plugins/jwt-authentication-for-wp-rest-api/)
library flutter_wordpress;

import 'dart:async' as async;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'constants.dart';
import 'requests/params_category_list.dart';
import 'requests/params_comment_list.dart';
import 'requests/params_media_list.dart';
import 'requests/params_page_list.dart';
import 'requests/params_post_list.dart';
import 'requests/params_tag_list.dart';
import 'requests/params_user_list.dart';
import 'schemas/category.dart';
import 'schemas/comment.dart';
import 'schemas/comment_hierarchy.dart';
import 'schemas/fetch_user_result.dart';
import 'schemas/jwt_response.dart';
import 'schemas/media.dart';
import 'schemas/page.dart';
import 'schemas/post.dart';
import 'schemas/tag.dart';
import 'schemas/user.dart';
import 'schemas/wordpress_error.dart';

export 'constants.dart';
export 'requests/params_category_list.dart';
export 'requests/params_comment_list.dart';
export 'requests/params_media_list.dart';
export 'requests/params_page_list.dart';
export 'requests/params_post_list.dart';
export 'requests/params_tag_list.dart';
export 'requests/params_user_list.dart';
export 'schemas/avatar_urls.dart';
export 'schemas/category.dart';
export 'schemas/comment.dart';
export 'schemas/comment_hierarchy.dart';
export 'schemas/content.dart';
export 'schemas/excerpt.dart';
export 'schemas/fetch_user_result.dart';
export 'schemas/guid.dart';
export 'schemas/jwt_response.dart';
export 'schemas/labels.dart';
export 'schemas/links.dart';
export 'schemas/media.dart';
export 'schemas/page.dart';
export 'schemas/post.dart';
export 'schemas/settings.dart';
export 'schemas/tag.dart';
export 'schemas/title.dart';
export 'schemas/user.dart';
export 'schemas/wordpress_error.dart';

/// All WordPress related functionality are defined under this class.
class WordPress {
  String _baseUrl;
  WordPressAuthenticator _authenticator;

  String _token = "";
  Map<String, String> _urlHeader = {
    'Authorization': '',
  };

  /// If [WordPressAuthenticator.ApplicationPasswords] is used as an authenticator,
  /// [adminName] and [adminKey] is necessary for authentication.
  /// https://wordpress.org/plugins/application-passwords/
  WordPress(
      {@required String baseUrl,
      WordPressAuthenticator authenticator,
      String adminName,
      String adminKey}) {
    this._baseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    this._authenticator = authenticator;

    if (adminName != null && adminKey != null && this._authenticator != null) {
      switch (this._authenticator) {
        case WordPressAuthenticator.ApplicationPasswords:
          String str = '$adminName:$adminKey';
          String base64 = base64Encode(utf8.encode(str));
          _urlHeader['Authorization'] = 'Basic $base64';
          break;
        case WordPressAuthenticator.JWT:
          //TODO: Implement JWT Admin authentication
          break;
      }
    }
  }

  /// This returns a [User] object when a user with valid [username] and [password]
  /// has been successfully authenticated.
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<User> authenticateUser(
      {@required username, @required password}) async {
    if (_authenticator == WordPressAuthenticator.ApplicationPasswords) {
      return _authenticateViaAP(username, password);
    } else if (_authenticator == WordPressAuthenticator.JWT) {
      return _authenticateViaJWT(username, password);
    } else
      return fetchUser(username: username);
  }

  async.Future<User> _authenticateViaAP(username, password) async {
    //TODO: Implement Application Passwords User Authentication
    return fetchUser(username: username);
  }

  async.Future<User> _authenticateViaJWT(username, password) async {
    final body = {
      'username': username,
      'password': password,
    };

    final response = await http.post(
      _baseUrl + URL_JWT_TOKEN,
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      JWTResponse authResponse =
          JWTResponse.fromJson(json.decode(response.body));
      _token = authResponse.token;

      _urlHeader['Authorization'] = 'Bearer ${authResponse.token}';

      return fetchUser(email: authResponse.userEmail);
    } else {
      try {
        throw new WordPressError.fromJson(json.decode(response.body));
      } catch (e) {
        throw new WordPressError(message: response.body);
      }
    }
  }

  String getToken() {
    return _token;
  }

  async.Future<User> authenticateViaToken(String token) async {
    _urlHeader['Authorization'] = 'Bearer ${token}';

    final response =
        await http.post(_baseUrl + URL_JWT_TOKEN_VALIDATE, headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return fetchMeUser();
    } else {
      throw new WordPressError(message: response.body);
    }
  }

  /// This returns a [User] object if the user with [id], [email] or [username]
  /// exists. Otherwise throws [WordPressError].
  ///
  /// Only one parameter is enough to search for the user.
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<User> fetchUser({int id, String email, String username}) async {
    final StringBuffer url = new StringBuffer(_baseUrl + URL_USERS);
    final Map<String, String> params = {
      'search': '',
    };
    if (id != null) {
      params['search'] = '$id';
    } else if (email != null)
      params['search'] = email;
    else if (username != null) params['search'] = username;

    url.write(constructUrlParams(params));

    final response = await http.get(url.toString(), headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);
      if (jsonStr.length == 0)
        throw new WordPressError(
            code: 'wp_empty_list', message: "No users found");
      return User.fromJson(jsonStr[0]);
    } else {
      try {
        WordPressError err =
            WordPressError.fromJson(json.decode(response.body));
        throw err;
      } catch (e) {
        throw new WordPressError(message: response.body);
      }
    }
  }

  /// This returns the me [User] object with the current token. Otherwise throws [WordPressError].
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<User> fetchMeUser() async {
    final response =
        await http.get(_baseUrl + URL_USER_ME, headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonStr = json.decode(response.body);
      if (jsonStr.length == 0)
        throw new WordPressError(
            code: 'wp_empty_user', message: "No user found");
      return User.fromJson(jsonStr);
    } else {
      try {
        WordPressError err =
            WordPressError.fromJson(json.decode(response.body));
        throw err;
      } catch (e) {
        throw new WordPressError(message: response.body);
      }
    }
  }

  /// This returns a list of [Post] based on the filter parameters
  /// specified through [ParamsPostList] object. By default it returns only
  /// [ParamsPostList.perPage] number of posts in page [ParamsPostList.pageNum].
  ///
  /// [fetchAuthor], [fetchComments], [fetchCategories], [fetchTags],
  /// [fetchFeaturedMedia] and [fetchAttachments] will fetch and set [Post.author],
  /// [Post.comments], [Post.categories], [Post.tags], [Post.featuredMedia] and
  /// [Post.attachments] respectively. If they are non-existent, their values will
  /// null.
  ///
  /// (**Note:** *Set only those fetch boolean parameters which you need because
  /// the more information to fetch, the longer it will take to return all Posts*)
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<List<Post>> fetchPosts({
    @required ParamsPostList postParams,
    bool fetchAuthor = false,
    bool fetchComments = false,
    Order orderComments = Order.desc,
    CommentOrderBy orderCommentsBy = CommentOrderBy.date,
    bool fetchCategories = false,
    bool fetchTags = false,
    bool fetchFeaturedMedia = false,
    bool fetchAttachments = false,
  }) async {
    final StringBuffer url = new StringBuffer(_baseUrl + URL_POSTS);

    url.write(postParams.toString());

    final response = await http.get(url.toString(), headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<Post> posts = new List();
      final list = json.decode(response.body);

      for (final post in list) {
        posts.add(await _postBuilder(
          post: Post.fromJson(post),
          setAuthor: fetchAuthor,
          setComments: fetchComments,
          orderComments: orderComments,
          orderCommentsBy: orderCommentsBy,
          setCategories: fetchCategories,
          setTags: fetchTags,
          setFeaturedMedia: fetchFeaturedMedia,
          setAttachments: fetchAttachments,
        ));
      }
      return posts;
    } else {
      try {
        WordPressError err =
            WordPressError.fromJson(json.decode(response.body));
        throw err;
      } catch (e) {
        throw new WordPressError(message: response.body);
      }
    }
  }

  /// This function fetches post information such as author, comments, categories,
  /// tags, featuredMedia and attachments.
  Future<Post> _postBuilder({
    Post post,
    bool setAuthor = false,
    bool setComments = false,
    Order orderComments = Order.desc,
    CommentOrderBy orderCommentsBy = CommentOrderBy.date,
    bool setCategories = false,
    bool setTags = false,
    bool setFeaturedMedia = false,
    bool setAttachments = false,
  }) async {
    if (setAuthor) {
      User author = await fetchUser(id: post.authorID);
      if (author != null) post.author = author;
    }
    if (setComments) {
      List<Comment> comments = await fetchComments(
          params: ParamsCommentList(
        includePostIDs: [post.id],
        order: orderComments,
        orderBy: orderCommentsBy,
      ));
      if (comments != null && comments.length != 0) {
        post.comments = comments;

        post.commentsHierarchy = new List();
        post.comments.forEach((comment) {
          if (comment.parent == 0)
            post.commentsHierarchy
                .add(_commentHierarchyBuilder(post.comments, comment));
        });
      }
    }
    if (setCategories) {
      List<Category> categories =
          await fetchCategories(params: ParamsCategoryList(post: post.id));
      if (categories != null && categories.length != 0)
        post.categories = categories;
    }
    if (setTags) {
      List<Tag> tags = await fetchTags(params: ParamsTagList(post: post.id));
      if (tags != null && tags.length != 0) post.tags = tags;
    }
    if (setFeaturedMedia) {
      List<Media> media = await fetchMediaList(
        params: ParamsMediaList(
          includeMediaIDs: [post.featuredMediaID],
        ),
      );
      if (media != null && media.length != 0) post.featuredMedia = media[0];
    }
    if (setAttachments) {
      List<Media> media = await fetchMediaList(
        params: ParamsMediaList(
          includeParentIDs: [post.id],
        ),
      );
      if (media != null && media.length != 0) post.attachments = media;
    }
    return post;
  }

  ///This recursive function builds the hierarchy of comments for the given post
  ///and comment. Only parent comments (direct comments to post) need to be
  ///supplied.
  CommentHierarchy _commentHierarchyBuilder(
      List<Comment> commentList, Comment comment) {
    final childComments = commentList.where((ele) =>
        ele.id != comment.id && ele.parent != 0 && ele.parent == comment.id);

    if (childComments == null || childComments.length == 0) {
      return new CommentHierarchy(comment: comment, children: null);
    } else {
      List<CommentHierarchy> children = new List();
      childComments.forEach((c) {
        children.add(_commentHierarchyBuilder(commentList, c));
      });
      return new CommentHierarchy(
        comment: comment,
        children: children,
      );
    }
  }

  /// This returns a list of [Page] based on the filter parameters
  /// specified through [ParamsPageList] object. By default it returns only
  /// [ParamsPageList.perPage] number of pages in page [ParamsPageList.pageNum].
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<List<Page>> fetchPages({@required ParamsPageList params}) async {
    final StringBuffer url = new StringBuffer(_baseUrl + URL_PAGES);

    url.write(params.toString());

    final response = await http.get(url.toString(), headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<Page> pages = new List<Page>();
      final list = json.decode(response.body);
      list.forEach((page) {
        pages.add(Page.fromJson(page));
      });
      return pages;
    } else {
      try {
        WordPressError err =
            WordPressError.fromJson(json.decode(response.body));
        throw err;
      } catch (e) {
        throw new WordPressError(message: response.body);
      }
    }
  }

  /// This returns an object FetchUsersResult based on the filter parameters
  /// specified through [ParamsUserList] object. By default it returns only
  /// [ParamsUserList.perPage] number of users in page [ParamsUserList.pageNum].
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<FetchUsersResult> fetchUsers(
      {@required ParamsUserList params}) async {
    final StringBuffer url = new StringBuffer(_baseUrl + URL_USERS);

    url.write(params.toString());

    return _doUsersFetch(url);
  }

  /// This returns an object FetchUsersResult as defined by the input, based on the filter parameters
  /// specified through [ParamsUserList] object. The url it fetches to is defined by the input [String] path. By default it returns only
  /// [ParamsUserList.perPage] number of users in page [ParamsUserList.pageNum].
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<FetchUsersResult> fetchCustomUsers(
      {@required String path, @required ParamsUserList params}) async {
    final StringBuffer url = new StringBuffer(_baseUrl + path);

    url.write(params.toString());

    return _doUsersFetch(url);
  }

  async.Future<FetchUsersResult> _doUsersFetch(StringBuffer url) async {
    final response = await http.get(url.toString(), headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<User> users = new List<User>();
      final list = json.decode(response.body);
      int totalUsers = int.parse(response.headers['x-wp-total']);

      list.forEach((user) {
        users.add(User.fromJson(user));
      });
      return FetchUsersResult(users, totalUsers);//, params.pageNum
    } else {
      try {
        WordPressError err =
            WordPressError.fromJson(json.decode(response.body));
        throw err;
      } catch (e) {
        throw new WordPressError(message: response.body);
      }
    }
  }

  /// This returns a list of [Comment] based on the filter parameters
  /// specified through [ParamsCommentList] object. By default it returns only
  /// [ParamsCommentList.perPage] number of comments in page [ParamsCommentList.pageNum].
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<List<Comment>> fetchComments(
      {@required ParamsCommentList params}) async {
    final StringBuffer url = new StringBuffer(_baseUrl + URL_COMMENTS);

    url.write(params.toString());

    final response = await http.get(url.toString(), headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<Comment> comments = new List<Comment>();
      final list = json.decode(response.body);
      list.forEach((comment) {
        comments.add(Comment.fromJson(comment));
      });
      return comments;
    } else {
      try {
        WordPressError err =
            WordPressError.fromJson(json.decode(response.body));
        throw err;
      } catch (e) {
        throw new WordPressError(message: response.body);
      }
    }
  }

  /// This returns a list of [CommentHierarchy] based on the filter parameters
  /// specified through [ParamsCommentList] object. The list returned has all
  /// parent comments (i.e. comments directed towards posts) with
  /// [CommentHierarchy.children] containing the replies to that comment.
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<List<CommentHierarchy>> fetchCommentsAsHierarchy(
      {@required ParamsCommentList params}) async {
    final StringBuffer url = new StringBuffer(_baseUrl + URL_COMMENTS);

    url.write(params.toString());

    final response = await http.get(url.toString(), headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<Comment> comments = new List<Comment>();
      List<CommentHierarchy> commentsHierarchy = new List<CommentHierarchy>();
      final list = json.decode(response.body);
      list.forEach((comment) {
        comments.add(Comment.fromJson(comment));
      });

      comments.forEach((comment) {
        if (comment.parent == 0)
          commentsHierarchy.add(_commentHierarchyBuilder(comments, comment));
      });
      return commentsHierarchy;
    } else {
      try {
        WordPressError err =
            WordPressError.fromJson(json.decode(response.body));
        throw err;
      } catch (e) {
        throw new WordPressError(message: response.body);
      }
    }
  }

  /// This returns a list of [Category] based on the filter parameters
  /// specified through [ParamsCategoryList] object. By default it returns only
  /// [ParamsCategoryList.perPage] number of categories in page [ParamsCategoryList.pageNum].
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<List<Category>> fetchCategories(
      {@required ParamsCategoryList params}) async {
    final StringBuffer url = new StringBuffer(_baseUrl + URL_CATEGORIES);

    url.write(params.toString());

    final response = await http.get(url.toString(), headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<Category> categories = new List<Category>();
      final list = json.decode(response.body);
      list.forEach((category) {
        categories.add(Category.fromJson(category));
      });
      return categories;
    } else {
      try {
        WordPressError err =
            WordPressError.fromJson(json.decode(response.body));
        throw err;
      } catch (e) {
        throw new WordPressError(message: response.body);
      }
    }
  }

  /// This returns a list of [Tag] based on the filter parameters
  /// specified through [ParamsTagList] object. By default it returns only
  /// [ParamsTagList.perPage] number of tags in page [ParamsTagList.pageNum].
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<List<Tag>> fetchTags({@required ParamsTagList params}) async {
    final StringBuffer url = new StringBuffer(_baseUrl + URL_TAGS);

    url.write(params.toString());

    final response = await http.get(url.toString(), headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<Tag> tags = new List<Tag>();
      final list = json.decode(response.body);
      list.forEach((tag) {
        tags.add(Tag.fromJson(tag));
      });
      return tags;
    } else {
      try {
        WordPressError err =
            WordPressError.fromJson(json.decode(response.body));
        throw err;
      } catch (e) {
        throw new WordPressError(message: response.body);
      }
    }
  }

  /// This returns a list of [Media] based on the filter parameters
  /// specified through [ParamsMediaList] object. By default it returns only
  /// [ParamsMediaList.perPage] number of tags in page [ParamsMediaList.pageNum].
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<List<Media>> fetchMediaList(
      {@required ParamsMediaList params}) async {
    final StringBuffer url = new StringBuffer(_baseUrl + URL_MEDIA);

    url.write(params.toString());

    final response = await http.get(url.toString(), headers: _urlHeader);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<Media> media = new List<Media>();
      final list = json.decode(response.body);
      list.forEach((m) {
        media.add(Media.fromJson(m));
      });
      return media;
    } else {
      try {
        WordPressError err =
            WordPressError.fromJson(json.decode(response.body));
        throw err;
      } catch (e) {
        throw new WordPressError(message: response.body);
      }
    }
  }

  /// This is used to create a [Post] in the site. Before this method can be called,
  /// [User] creating the post needs to be authenticated first by calling
  /// [WordPress.authenticateUser]. On success, the [Post] object is returned containing
  /// post information.
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<Post> createPost({@required Post post}) async {
    final StringBuffer url = new StringBuffer(_baseUrl + URL_POSTS);

    final response = await http.post(
      url.toString(),
      headers: _urlHeader,
      body: post.toJson(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Post.fromJson(json.decode(response.body));
    } else {
      try {
        WordPressError err =
            WordPressError.fromJson(json.decode(response.body));
        throw err;
      } catch (e) {
        throw new WordPressError(message: response.body);
      }
    }
  }

  /// This is used to create a [Comment] for a [Post]. Before this method can be called,
  /// [User] writing the comment needs to be authenticated first by calling
  /// [WordPress.authenticateUser]. On success, the [Comment] object is returned containing
  /// comment information.
  ///
  /// In case of an error, a [WordPressError] object is thrown.
  async.Future<Comment> createComment({@required Comment comment}) async {
    final StringBuffer url = new StringBuffer(_baseUrl + URL_COMMENTS);

    final response = await http.post(
      url.toString(),
      headers: _urlHeader,
      body: comment.toJson(),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Comment.fromJson(json.decode(response.body));
    } else {
      try {
        WordPressError err =
            WordPressError.fromJson(json.decode(response.body));
        throw err;
      } catch (e) {
        throw new WordPressError(message: response.body);
      }
    }
  }
}
