import 'package:flutter/material.dart';
import 'package:sof_app/widget/common/scafold_template.dart';
import 'package:sof_app/models/sof_model.dart';

class UserBookmark extends StatefulWidget {
  const UserBookmark({super.key});

  @override
  State<UserBookmark> createState() => _UserBookmarkState();
}

class _UserBookmarkState extends State<UserBookmark> {
  final scrollController = ScrollController();
  dynamic users;
  bool isLoadingMore = false;
  List<dynamic> bookmarkedUsers = [];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollControllerEventListener);
    getBookmarkedUsers();
  }

  void getBookmarkedUsers() async {
    try {
      // Calling SOF Model to load data from database
      var list = await SOFModel.getBookmarkedUsers();
      setState(() {
        bookmarkedUsers = list;
      });
    } catch (ex) {
      print(ex);
    }
  }

  void removeBookMarkedUser(userid) async {
    try {
      // Calling SOF Model to remove data from database
      SOFModel.removeBookMarkedUser(userid);
      getBookmarkedUsers();
    } catch (ex) {
      print(ex);
    }
  }

  void scrollControllerEventListener() {
    if (isLoadingMore) return;

    if (scrollController.position.pixels >
        scrollController.position.maxScrollExtent - 100) {
      setState(() {
        isLoadingMore = true;
      });
      getBookmarkedUsers();
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      screenContent: bookmarkedUsers != null
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    controller: scrollController,
                    itemCount: bookmarkedUsers.length,
                    itemBuilder: (context, index) {
                      final user = bookmarkedUsers[index];
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 15.0,
                          ),
                          leading: CircleAvatar(
                            child: Image.network(user['profile_image']),
                          ),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Reputation:${user['reputation'].toString()}',
                                ),
                                user['location'] != null
                                    ? Text(
                                        user['location'],
                                      )
                                    : const Text(''),
                              ]),
                          trailing: GestureDetector(
                            onTap: () {
                              removeBookMarkedUser(user['id']);
                            },
                            child: const Icon(
                              Icons.bookmark,
                              size: 30.0,
                            ),
                          ),
                          title: Text(user['display_name']),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      pageTitle: 'Bookmarked Users',
      tabActiveIndex: 1,
    );
  }
}
