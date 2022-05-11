class Post {
  late String desc;
  late String uid;
  late String username;
  late String postId;
  late DateTime date;
  late String photourl;
  late String avatar;
  late List<String> likes;

  Post({
    required this.postId,
    required this.username,
    required this.desc,
    required this.uid,
    required this.avatar,
    required this.photourl,
    required this.date,
    required this.likes,
  });

  Post.fromJson(Map<dynamic, dynamic> json) {
    postId = json['postId'];
    username = json['username'];
    desc = json['desc'];
    uid = json['uid'];
    avatar = json['avatar'];
    photourl = json['photourl'];
    date = json['date'];
    likes = json['likes'];
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'username': username,
      'desc': desc,
      'avatar': avatar,
      'uid': uid,
      'photourl': photourl,
      'date': date,
      'likes': likes,
    };
  }
}
