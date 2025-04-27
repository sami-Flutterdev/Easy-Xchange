import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

void deletePost(context, String postId) {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: text("Delete Post",
              fontSize: textSizeLargeMedium, fontWeight: FontWeight.w600)
          .center(),
      content: text("Are you sure you want to delete this post?",
          isCentered: true,
          fontWeight: FontWeight.w500,
          color: AppColors.textGreyColor),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: text("Cancel", fontWeight: FontWeight.w500),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await _firestore.collection('posts').doc(postId).delete();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Post deleted successfully")),
            );
          },
          child: text("Delete", color: Colors.red, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}
