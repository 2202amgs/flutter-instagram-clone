class User {
  late String uid;
  late String username;
  late String email;
  late String bio;
  late String photo;
  late List followers = [];
  late List following = [];

  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.photo,
    required this.bio,
  });

  User.fromJson(Map<dynamic, dynamic> json) {
    uid = json['uid'];
    username = json['username'];
    email = json['email'];
    bio = json['bio'];
    photo = json['photo'];
    followers = json['followers'];
    following = json['following'];
  }
}
