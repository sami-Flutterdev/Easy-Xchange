import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/view/user_app/near_posts/cash_to_E_Money.dart';
import 'package:easy_xchange/view/user_app/post/post_card.dart';
import 'package:easy_xchange/view/user_app/post/post_screen.dart';
import 'package:easy_xchange/view/user_app/post/update_post.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/view_model/userViewModel.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class YourPosts extends StatefulWidget {
  const YourPosts({super.key});

  @override
  _YourPostsState createState() => _YourPostsState();
}

class _YourPostsState extends State<YourPosts> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;
  List<Map<String, dynamic>> _posts = [];
  String _error = '';

  // Assuming you have the current user's UID stored in a variable.

  @override
  void initState() {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    super.initState();
    _queryUserPosts(
      userViewModel.currentLocation!.latitude ?? 0.0,
      userViewModel.currentLocation!.longitude ?? 0.0,
    );
  }

  void _queryUserPosts(double lat, double lng) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    var collectionReference = _firestore.collection('posts');

    collectionReference
        .where("userId", isEqualTo: userViewModel.userId.toString())
        .snapshots()
        .listen((snapshot) async {
      List<Map<String, dynamic>> postsWithUserDetails = [];

      for (var document in snapshot.docs) {
        var postData = document.data();

        // Fetch user details
        var userDoc = await _firestore
            .collection('users')
            .doc(userViewModel.userId.toString())
            .get();
        var userData = userDoc.data();

        if (userData != null) {
          postsWithUserDetails.add({
            'post': postData,
            'user': userData,
          });
        }
      }

      setState(() {
        _posts = postsWithUserDetails;
        _isLoading = false;
        if (_posts.isEmpty) {
          _error = 'No posts found for the current user.';
        }
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
        _error = 'Error querying posts: $error';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance.collection('posts');

    return Scaffold(
      appBar: AppBar(
        title: text('User Posts',
            fontSize: textSizeLargeMedium, fontWeight: FontWeight.w600),
      ),
      body: _isLoading
          ? Center(child: CustomLoadingIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : _posts.isEmpty
                  ? const Center(
                      child: Text('No posts found for the current user.'))
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _posts.length,
                            padding:
                                const EdgeInsets.only(bottom: spacing_middle),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var postData = _posts[index]['post'];
                              var userData = _posts[index]['user'];
                              return PostCard(
                                isUpdate: true,
                                title: '${userData['username']}',
                                createdAt: DateFormat('dd MMM yyyy, hh:mm a')
                                    .format(postData['timestamp'].toDate()),
                                desc: '${postData['description']}',
                                type:
                                    'Payment Source: ${postData['paymentSource']}',
                                amount: 'Amount: ${postData['amount']}',
                                deleteOnTap: () async {
                                  //OnPress Delete
                                  await firestore
                                      .doc(postData["_id"])
                                      .delete()
                                      .then((value) {
                                    utils().toastMethod(
                                        "Your post has been deleted succussfuly.");
                                  });
                                },
                                updateOnTap: () {
                                  //OnPress update
                                  UpdatePostScreen(
                                    postdata: postData,
                                  ).launch(context);
                                },
                                distance: '',
                              ).paddingBottom(spacing_middle);
                            },
                          ),
                        )
                      ],
                    ).paddingAll(spacing_twinty),
    );
  }
}

//
