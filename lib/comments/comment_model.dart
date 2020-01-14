
import 'package:cshannon3/screens/gui2/lrtb.dart';
enum COMMENTTYPE{
  BUG, 
  SUGGESTION,
  FEEDBACK,
  PRAISE
}
class Comment {
  final String commenter;
  LRTB location;
  final String comment;

  bool isHidden;
  COMMENTTYPE type;
  List<Comment> replies;

  Comment({this.commenter="", this.comment=""});
}