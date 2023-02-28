import 'package:flutter/material.dart';
import 'package:sof_app/services/sof_user.dart';
import 'package:sof_app/widget/common/scafold_template.dart';

class UserInfo extends StatefulWidget {
  final Object userid;
  const UserInfo({super.key, required this.userid});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final scrollController = ScrollController();
  dynamic reputations;
  int page = 1;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollControllerEventListener);
    SOFs.getUserReputage(widget.userid, page).then((resolve) {
      setState(() {
        reputations = resolve;
      });
    });
  }

  void scrollControllerEventListener() {
    if (isLoadingMore) return;

    if (scrollController.position.pixels >
        scrollController.position.maxScrollExtent - 100) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      SOFs.getUserReputage(widget.userid, page).then((resolve) {
        setState(() {
          reputations = reputations + resolve;
        });
      });

      setState(() {
        isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
      screenContent: reputations != null
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    controller: scrollController,
                    itemCount: reputations.length,
                    itemBuilder: (context, index) {
                      final reputation = reputations[index];
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 15.0,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Reputation Type: ${reputation['reputation_history_type'].toString()}',
                              ),
                              Text(
                                'Created At: ${DateTime.fromMillisecondsSinceEpoch(reputation['creation_date'] * 1000)}',
                              ),
                              Text(
                                'Age: ${reputation['age'] ?? 'Not Given'}',
                              ),
                            ],
                          ),
                          title: reputation['post_id'] != null
                              ? Text(
                                  'Post ID: ${reputation['post_id'].toString()}')
                              : const Text('Post ID: NA'),
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
      pageTitle: 'SOF User Info',
      tabActiveIndex: 0,
    );
  }
}
