import 'package:flutter/material.dart';
import 'flutter_wordpress.dart' as wp;
//import 'package:flutter_html/flutter_html.dart';
import 'post_page.dart';

class PostListPage extends StatelessWidget {
  final wp.WordPress wordPress;

  PostListPage({Key key, @required this.wordPress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: Center(
        child: PostsBuilder(
          wordPress: wordPress,
        ),
      ),
    );
  }
}

class PostsBuilder extends StatefulWidget {
  final wp.WordPress wordPress;

  PostsBuilder({Key key, @required this.wordPress});

  @override
  PostsBuilderState createState() => PostsBuilderState();
}

class PostsBuilderState extends State<PostsBuilder> {
  final paddingCardsList = EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0);
  final padding_4 = EdgeInsets.all(4.0);
  final padding_8 = EdgeInsets.all(8.0);
  final padding_16 = EdgeInsets.all(16.0);

  Future<List<wp.Post>> posts;

  @override
  void initState() {
    super.initState();

    fetchPosts();
  }

  void createPost(wp.User user) {
    final post = widget.wordPress.createPost(
      post: new wp.Post(
        title: 'First post as a Chief Editor',
        content: 'Blah! blah! blah!',
        excerpt: 'Discussion about blah!',
        authorID: user.id,
        commentStatus: wp.PostCommentStatus.open,
        pingStatus: wp.PostPingStatus.closed,
        status: wp.PostPageStatus.publish,
        format: wp.PostFormat.standard,
        sticky: true,
      ),
    );

    post.then((p) {
      print('Post created successfully with ID: ${p.id}');
      postComment(user, p);
    }).catchError((err) {
      print('Failed to create post: $err');
    });
  }

  void postComment(wp.User user, wp.Post post) {
    final comment = widget.wordPress.createComment(
      comment: new wp.Comment(
        author: user.id,
        post: post.id,
        content: "First!",
        parent: 0,
      ),
    );

    comment.then((c) {
      print('Comment successfully posted with ID: ${c.id}');
    }).catchError((err) {
      print('Failed to comment: $err');
    });
  }

  Future<void> fetchPosts() {
    setState(() {
      posts = widget.wordPress.fetchPosts(
        postParams: wp.ParamsPostList(),
        fetchAuthor: true,
        fetchFeaturedMedia: true,
      );
    });
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<wp.Post>>(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            child: ListView.builder(
              itemBuilder: (context, i) {
                String title = snapshot.data[i].title.rendered;
                String author = snapshot.data[i].author.name;
                String content = snapshot.data[i].content.rendered;
                wp.Media featuredMedia = snapshot.data[i].featuredMedia;

                return Padding(
                  padding: paddingCardsList,
                  child: GestureDetector(
                    onTap: () {
                      openPostPage(snapshot.data[i]);
                    },
                    child: _buildPostCard(
                      author: author,
                      title: title,
                      content: content,
                      featuredMedia: featuredMedia,
                    ),
                  ),
                );
              },
              itemCount: snapshot.data.length,
            ),
            onRefresh: fetchPosts,
          );
        } else if (snapshot.hasError) {
          return Text(
            snapshot.error.toString(),
            style: TextStyle(color: Colors.red),
          );
        }

        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.blue),
        );
      },
    );
  }

  Widget _buildPostCard({
    String author,
    String title,
    String content,
    wp.Media featuredMedia,
  }) {
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          _buildFeaturedMedia(featuredMedia),
          featuredMedia == null
              ? Divider()
              : SizedBox(
                  width: 0,
                  height: 0,
                ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  author,
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedMedia(wp.Media featuredMedia) {
    if (featuredMedia == null) {
      return SizedBox(
        width: 0.0,
        height: 0.0,
      );
    }
    String imgSource = featuredMedia.mediaDetails.sizes.mediumLarge.sourceUrl;
    imgSource = imgSource.replaceAll('localhost', '192.168.6.165');
    return Center(
      child: Image.network(
        imgSource,
        fit: BoxFit.cover,
      ),
    );
  }

  void openPostPage(wp.Post post) {
    print('OnTapped');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return SinglePostPage(wordPress: widget.wordPress, post: post,);
      }),
    );
  }
}
