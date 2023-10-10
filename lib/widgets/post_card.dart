import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/comments_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
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
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser!;
    final bool isLiked = widget.snap['likes'].contains(user.uid);
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
                                  children: ['Delete']
                                      .map((e) => InkWell(
                                            onTap: () {},
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
              FirestoreMethods().likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
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
                  FirestoreMethods().likePost(
                    widget.snap['postId'],
                    user.uid,
                    widget.snap['likes'],
                    fromHeart: true,
                  );
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
              onTap: () {},
              child: const Text(
                'View all 200 comments',
                style: TextStyle(
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
