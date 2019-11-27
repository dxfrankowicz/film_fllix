import 'comment.dart';

class CommentsRsp {
  // ignore: conflicting_dart_import
  List<Comment> comments;

  CommentsRsp(this.comments);

  factory CommentsRsp.fromJson(json) {
    if (json == null) {
      return null;
    } else {
      List<Comment> l = new List();
      for (var value in json) {
        l.add(new Comment.fromJson(value));
      }
      return new CommentsRsp(l);
    }
  }
}