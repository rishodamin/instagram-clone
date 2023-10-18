import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getCommentLen();
  }

  void getCommentLen() async {
    try {
      QuerySnapshot comment = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentLen = comment.docs.length;
      });
    } catch (e) {
      print('something bad happen');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = Provider.of<UserProvider>(context).isGuest;
    late User user;
    bool isLiked;
    bool isMyPost;
    if (!isGuest) {
      user = Provider.of<UserProvider>(context).getUser!;
      isLiked = widget.snap['likes'].contains(user.uid);
      isMyPost = user.uid == widget.snap['uid'] ? true : false;
    } else {
      isLiked = false;
      isMyPost = false;
    }

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: (isMyPost ? ['Delete'] : ['Report'])
                                      .map((e) => InkWell(
                                            onTap: () async {
                                              if (e == 'Delete') {
                                                FirestoreMethods().deletePost(
                                                  widget.snap['postId'],
                                                  widget.snap['storageId'],
                                                );
                                              }
                                              Navigator.of(context).pop();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 12,
                                                horizontal: 16,
                                              ),
                                              child: Text(e),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),

          // Image Section
          GestureDetector(
            onDoubleTap: () {
              if (!isGuest) {
                FirestoreMethods().likePost(
                  widget.snap['postId'],
                  user.uid,
                  isLiked,
                );
                setState(() {
                  isLikeAnimating = true;
                });
              } else {
                showSnackBar('Login required to like', context);
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Like Comment Section
          Row(
            children: [
              IconButton(
                iconSize: 32,
                onPressed: () {
                  if (!isGuest) {
                    FirestoreMethods().likePost(
                      widget.snap['postId'],
                      user.uid,
                      isLiked,
                      fromHeart: true,
                    );
                  } else {
                    showSnackBar('Login required to like', context);
                  }
                },
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                icon: isLiked
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(Icons.favorite_border),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(snap: widget.snap),
                  ),
                ),
                iconSize: 28,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 28,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(child: Container()),
              IconButton(
                onPressed: () {},
                iconSize: 32,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                icon: const Icon(
                  Icons.bookmark_border,
                ),
              )
            ],
          ),

          // Caption and comments
          Padding(
            padding: const EdgeInsets.only(left: 14, bottom: 5),
            child: Text('${widget.snap['likes'].length} likes',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: RichText(
              text: TextSpan(
                text: widget.snap['username'],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                children: [
                  TextSpan(
                    text: ' ${widget.snap['caption']}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CommentsScreen(snap: widget.snap),
                ),
              ),
              child: Text(
                'View all $commentLen comments',
                style: const TextStyle(
                  fontSize: 15,
                  color: secondaryColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
              style: const TextStyle(
                fontSize: 15,
                color: secondaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
