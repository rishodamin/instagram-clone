import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  final String postId;
  final String myUid;
  const CommentCard({
    super.key,
    required this.snap,
    required this.postId,
    required this.myUid,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    bool isLiked = widget.snap['likes'].contains(widget.myUid);
    int totalLikes = widget.snap['likes'].length;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.snap['name'],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                          DateFormat.yMMMd()
                              .format(widget.snap['datePublished'].toDate()),
                          style: const TextStyle(
                              fontSize: 13, color: secondaryColor)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.snap['text'],
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 4, top: 8),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    FirestoreMethods().likeComment(
                      widget.postId,
                      widget.snap['commentId'],
                      widget.myUid,
                      isLiked,
                    );
                  },
                  child: isLiked
                      ? const Icon(
                          Icons.favorite,
                          size: 22,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border),
                ),
                const SizedBox(height: 2),
                if (totalLikes > 0) Text(totalLikes.toString()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
