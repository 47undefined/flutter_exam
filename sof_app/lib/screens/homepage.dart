import 'package:flutter/material.dart';
import 'package:sof_app/screens/sofuser_info.dart';
import 'package:sof_app/widget/common/scafold_template.dart';
import 'package:sof_app/services/sof_user.dart';
import 'package:sof_app/models/sof_model.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final scrollController = ScrollController();
  dynamic users;
  int page = 1;
  bool isLoadingMore = false;
  List<dynamic> bookmarkedUsers = [];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollControllerEventListener);
    // Calling SOF Service to hit the api
    SOFs.getSOFUsers(page).then((resolve) {
      // print(resolve);
      setState(() {
        users = resolve;
      });
    });
    getBookmarkedUsers();
  }

  void scrollControllerEventListener() {
    if (isLoadingMore) return;

    if (scrollController.position.pixels >
        scrollController.position.maxScrollExtent - 100) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      // Calling SOF Service to hit the api
      SOFs.getSOFUsers(page).then((resolve) {
        setState(() {
          users = users + resolve;
        });
      });

      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void addToListOfBookmarkIds(bookmarkUser) async {
    try {
      // Calling  model functin to add in database
      SOFModel.addBookmarkUser(bookmarkUser);
      getBookmarkedUsers();
    } catch (ex) {
      print(ex);
    }
  }

  void getBookmarkedUsers() async {
    // Calling  model functin to add in database
    var list = await SOFModel.getBookmarkedUsers();
    setState(() {
      bookmarkedUsers = list;
    });
  }

  void removeBookMarkedUser(userid) async {
    try {
      // Calling  model functin to add in database
      SOFModel.removeBookMarkedUser(userid);
      getBookmarkedUsers();
    } catch (ex) {
      print(ex);
    }
  }

  Widget isBookMarked(dynamic user) {
    // bookmarkedUsers.map((item) => {print(item)});

    for (int i = 0; i < bookmarkedUsers.length; i++) {
      if (bookmarkedUsers[i]['id'] == user['user_id']) {
        return GestureDetector(
          onTap: () {
            removeBookMarkedUser(user['user_id']);
          },
          child: const Icon(
            Icons.bookmark,
            size: 30.0,
          ),
        );
      }
    }
    return GestureDetector(
      onTap: () {
        addToListOfBookmarkIds(user);
      },
      child: const Icon(
        Icons.bookmark_add_outlined,
        size: 30.0,
      ),
    );
    // print(bookmarkedUsers);
  }

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      screenContent: users != null
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    controller: scrollController,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UserInfo(userid: user['user_id']),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Image.network(user['profile_image']),
                            ),
                            subtitle: Text(
                              'Reputation:${user['reputation'].toString()}',
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                user['location'] != null
                                    ? Text(
                                        user['location'],
                                      )
                                    : const Text('NA'),
                                isBookMarked(user),
                              ],
                            ),
                            title: Text(user['display_name']),
                          ),
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
      pageTitle: 'Stack Overflow User Stastics',
      tabActiveIndex: 0,
    );
  }
}
