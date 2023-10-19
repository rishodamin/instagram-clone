import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/chat_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variables.dart';

class SearchScreen extends StatefulWidget {
  final bool fromMessage;
  const SearchScreen({
    super.key,
    required this.fromMessage,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool searched = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => (widget.fromMessage)
              ? Navigator.of(context).pop()
              : setState(
                  () {
                    _searchController.text = '';
                    searched = false;
                  },
                ),
        ),
        backgroundColor: mobileBackgroundColor,
        title: Container(
          margin:
              EdgeInsets.only(left: width > webScreenWidth ? width / 4.8 : 0),
          width: width > webScreenWidth ? width / 2 : 0,
          child: TextFormField(
            autofocus: true,
            focusNode: _searchFocus,
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Search Users',
            ),
            onFieldSubmitted: (value) {
              setState(() {
                searched = true;
              });
            },
          ),
        ),
      ),
      body: searched
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: _searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                    snapshot.data!.docs;
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width > webScreenWidth ? width / 3 : 0),
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => widget.fromMessage
                                    ? ChatScreen(
                                        dudeName: data[index]['username'],
                                        dudePic: data[index]['photoUrl'])
                                    : ProfileScreen(uid: data[index]['uid']))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(data[index]['photoUrl']),
                                radius: 24,
                              ),
                              title: Text(
                                data[index]['username'],
                                style: const TextStyle(fontSize: 22),
                              )),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : widget.fromMessage
              ? Container()
              : FutureBuilder(
                  future: FirebaseFirestore.instance.collection('posts').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> data =
                        snapshot.data!.docs;
                    data.shuffle();
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: width > webScreenWidth ? width / 3 : 0),
                      child: StaggeredGridView.countBuilder(
                        crossAxisCount: 3,
                        itemCount: data.length,
                        itemBuilder: (context, index) => Image(
                          image: NetworkImage(data[index]['postUrl']),
                          fit: BoxFit.cover,
                        ),
                        staggeredTileBuilder: (index) {
                          return StaggeredTile.count(
                            (index % 7 == 0) ? 2 : 1,
                            (index % 7 == 0) ? 2 : 1,
                          );
                        },
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                    );
                  },
                ),
    );
  }
}
