class Post {
  final String caption;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String? profImage;
  final List<dynamic> likes;

  const Post({
    required this.caption,
    required this.uid,
    required this.postId,
    required this.username,
    required this.datePublished,
    required this.profImage,
    required this.likes,
    required this.postUrl,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'caption': caption,
        'uid': uid,
        'postId': postId,
        'datePublished': datePublished,
        'postUrl': postUrl,
        'likes': likes,
        'profImage': profImage,
      };

  // static Post fromSnap(DocumentSnapshot snap) {
  //   var snapshot = snap.data() as Map<String, dynamic>;

  //   return Post(
  //     caption: snapshot["caption"],
  //     uid: snapshot["uid"],
  //     postId: snapshot["postId"],
  //     username: snapshot["username"],
  //     datePublished: snapshot["datePublished"],
  //     profImage: snapshot["profImage"],
  //     likes: snapshot["likes"],
  //     postUrl: snapshot["postUrl"],
  //   );
  // }
}
