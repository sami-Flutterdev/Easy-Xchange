import 'package:easy_xchange/utils/Constant.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/images.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/view/admin/posts/delete_post.dart';
import 'package:easy_xchange/view/user_app/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OverallPost extends StatefulWidget {
  const OverallPost({super.key});

  @override
  State<OverallPost> createState() => _OverallPostState();
}

class _OverallPostState extends State<OverallPost> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        title: text("Posts Management",
            fontWeight: FontWeight.w600, fontSize: textSizeLargeMedium),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('posts')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, postSnapshot) {
            if (postSnapshot.hasError) {
              return Center(
                  child:
                      text('Error loading posts', color: AppColors.redColor));
            }

            if (postSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (postSnapshot.data!.docs.isEmpty) {
              return Center(
                  child: text("No posts found", fontSize: textSizeLargeMedium));
            }

            return ListView.builder(
              itemCount: postSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final post = postSnapshot.data!.docs[index];
                final postData = post.data() as Map<String, dynamic>;

                return FutureBuilder<DocumentSnapshot>(
                  future: _firestore
                      .collection('users')
                      .doc(postData['userId'])
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return _buildPostCard(postData, null, size,
                          () => deletePost(context, post.id));
                    }

                    final userData =
                        userSnapshot.data?.data() as Map<String, dynamic>?;
                    return _buildPostCard(postData, userData, size,
                        () => deletePost(context, post.id));
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> postData,
      Map<String, dynamic>? userData, Size size, VoidCallback onDelete) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor.withValues(alpha: .3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                CircleAvatar(
                  radius: size.width * .055,
                  backgroundColor: AppColors.primaryColor,
                  child: ClipOval(
                    child: buildUserImage(userData, size),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text(
                      userData?['username'] ?? 'Unknown User',
                      fontWeight: FontWeight.bold,
                    ),
                    text(
                      formatDateTime(postData['timestamp']),
                      fontSize: textSizeSmall,
                      color: AppColors.textcolorSecondary,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Post Details
            _buildPostDetail('Amount', postData['amount']?.toString()),
            _buildPostDetail('Payment Source', postData['paymentSource']),
            _buildPostDetail(
                'Description', postData['description'] ?? 'No description'),
            Row(
              children: [
                Image.asset(
                  imageWhatsapp,
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                ),
                _buildPostDetail('WhatsApp',
                    "0${postData['whatsAppNo']?.toString()}" ?? 'Not provided'),
              ],
            ),
            const SizedBox(height: 16),

            // Location and Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: text(
                    postData['paymentType'] ?? 'Unknown Type',
                    color: AppColors.whiteColor,
                    fontSize: textSizeSmall,
                  ),
                  backgroundColor: AppColors.primaryColor,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.redColor),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostDetail(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(
            label,
            fontSize: textSizeSmall,
            color: AppColors.textcolorSecondary,
          ),
          text(
            value ?? 'N/A',
            fontSize: textSizeMedium,
          ),
        ],
      ),
    );
  }
}

Widget buildUserImage(Map<String, dynamic>? userData, Size size) {
  final imageUrl = userData?['userImage']?.toString();

  if (imageUrl == null || imageUrl.isEmpty) {
    return Image.asset(
      placeholderProfile,
      fit: BoxFit.cover,
      height: size.width * .1,
      width: size.width * .1,
    );
  }

  return Image.network(
    imageUrl,
    height: size.width * .1,
    width: size.width * .1,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Image.asset(
        placeholderProfile,
        fit: BoxFit.cover,
      );
    },
  );
}
