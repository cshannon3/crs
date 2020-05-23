import 'links.dart';
import 'content.dart';
import 'guid.dart';
import 'title.dart';
import 'excerpt.dart';

class Page {
  int id;
  String date;
  String dateGmt;
  Guid guid;
  String modified;
  String modifiedGmt;
  String password;
  String slug;
  String status;
  String type;
  String link;
  Title title;
  Content content;
  Excerpt excerpt;
  int author;
  int featuredMedia;
  int parent;
  int menuOrder;
  String commentStatus;
  String pingStatus;
  String template;
//  List<Null> meta;
  String permalinkTemplate;
  String generatedSlug;
  Links lLinks;

  Page(
      {this.id,
      this.date,
      this.dateGmt,
      this.guid,
      this.modified,
      this.modifiedGmt,
      this.password,
      this.slug,
      this.status,
      this.type,
      this.link,
      this.title,
      this.content,
      this.excerpt,
      this.author,
      this.featuredMedia,
      this.parent,
      this.menuOrder,
      this.commentStatus,
      this.pingStatus,
      this.template,
//        this.meta,
      this.permalinkTemplate,
      this.generatedSlug,
      this.lLinks});

  Page.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    dateGmt = json['date_gmt'];
    guid = json['guid'] != null ? new Guid.fromJson(json['guid']) : null;
    modified = json['modified'];
    modifiedGmt = json['modified_gmt'];
    password = json['password'];
    slug = json['slug'];
    status = json['status'];
    type = json['type'];
    link = json['link'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;
    excerpt =
        json['excerpt'] != null ? new Excerpt.fromJson(json['excerpt']) : null;
    author = json['author'];
    featuredMedia = json['featured_media'];
    parent = json['parent'];
    menuOrder = json['menu_order'];
    commentStatus = json['comment_status'];
    pingStatus = json['ping_status'];
    template = json['template'];
    /*if (json['meta'] != null) {
      meta = new List<Null>();
      json['meta'].forEach((v) {
        meta.add(new Null.fromJson(v));
      });
    }*/
    permalinkTemplate = json['permalink_template'];
    generatedSlug = json['generated_slug'];
    lLinks = json['_links'] != null ? new Links.fromJson(json['_links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['date_gmt'] = this.dateGmt;
    if (this.guid != null) {
      data['guid'] = this.guid.toJson();
    }
    data['modified'] = this.modified;
    data['modified_gmt'] = this.modifiedGmt;
    data['password'] = this.password;
    data['slug'] = this.slug;
    data['status'] = this.status;
    data['type'] = this.type;
    data['link'] = this.link;
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    if (this.excerpt != null) {
      data['excerpt'] = this.excerpt.toJson();
    }
    data['author'] = this.author;
    data['featured_media'] = this.featuredMedia;
    data['parent'] = this.parent;
    data['menu_order'] = this.menuOrder;
    data['comment_status'] = this.commentStatus;
    data['ping_status'] = this.pingStatus;
    data['template'] = this.template;
    /*if (this.meta != null) {
      data['meta'] = this.meta.map((v) => v.toJson()).toList();
    }*/
    data['permalink_template'] = this.permalinkTemplate;
    data['generated_slug'] = this.generatedSlug;
    if (this.lLinks != null) {
      data['_links'] = this.lLinks.toJson();
    }
    return data;
  }
}
