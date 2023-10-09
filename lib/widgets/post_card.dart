import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(profileUrl),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'username',
                          style: TextStyle(fontWeight: FontWeight.bold),
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
          SizedBox(
            width: double.infinity,
            child: Image.network(
              'https://d1qxviojg2h5lt.cloudfront.net/images/01E4CFF623M99BXP6HHSVF10D7/friends570.webp',
              fit: BoxFit.cover,
            ),
          ),

          // Like Comment Section
          Row(
            children: [
              IconButton(
                iconSize: 32,
                onPressed: () {},
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () {},
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
            child: Text('1,231 likes',
                style: Theme.of(context).textTheme.bodyMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: RichText(
              text: TextSpan(
                text: 'username',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                children: [
                  TextSpan(
                    text:
                        ' This is some caption I need to mention.. Hey Human!! How You Doin?',
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              '22/12/2021',
              style: TextStyle(
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
