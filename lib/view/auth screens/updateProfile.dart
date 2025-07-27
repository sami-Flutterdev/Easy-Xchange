import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_xchange/view_model/authViewModel.dart';
import 'package:easy_xchange/view_model/userViewModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/components/textfield.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/images.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String username;
  final String id;

  const UpdateProfileScreen(
      {required this.username, required this.id, super.key});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();

  @override
  void initState() {
    super.initState();
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);
    userViewModel.selectedImage = null;
    _nameController.text = widget.username;
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (mounted) {
        _nameController.text = userDoc['username'] ?? '';
        _cnicController.text = userDoc['cnic'] ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      appBar: AppBar(title: const Text('Update Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: FutureBuilder<DocumentSnapshot>(
                  future:
                      users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return Consumer<UserViewModel>(
                        builder: (context, value, child) => Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: size.width * .14,
                                  backgroundColor: AppColors.primaryColor,
                                  child: value.selectedImage == null
                                      ? snapshot.data!['userImage'] == null ||
                                              snapshot
                                                  .data!['userImage']!.isEmpty
                                          ? ClipOval(
                                              child: Image.asset(
                                                image_profile,
                                                height: size.width * .24,
                                                width: size.width * .24,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : ClipOval(
                                              child: Image.network(
                                                snapshot.data!['userImage']
                                                    .toString(),
                                                height: size.width * .24,
                                                width: size.width * .24,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                      : ClipOval(
                                          child: Image.file(
                                            value.selectedImage!,
                                            height: size.width * .24,
                                            width: size.width * .24,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                )
                              ],
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle),
                              child: IconButton(
                                alignment: Alignment.center,
                                onPressed: () {
                                  value.getProductImage();
                                },
                                icon: const Icon(Icons.edit_outlined),
                                color: Colors.white,
                                iconSize: 15,
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ).paddingTop(40),
              ),
              text("Name", fontSize: 14.0),
              textField(
                hint: "Update your's Name",
                controller: _nameController,
                labell: text("Name"),
                maxline: 1,
              ).paddingTop(5),
              const SizedBox(height: 10),
              text("Update your's CNIC", fontSize: 14.0),
              textField(
                hint: "Enter CNIC Number",
                controller: _cnicController,
                labell: text("CNIC"),
                maxline: 1,
                keyboardtype: TextInputType.number,
              ).paddingTop(5),
              const SizedBox(height: 20),
              Consumer<AuthViewModel>(
                builder: (context, authView, child) => elevatedButton(
                  context,
                  onPress: () {
                    authView.updateProfile(
                      context: context,
                      id: widget.id.toString(),
                      name: _nameController.text.toString(),
                      cnic: _cnicController.text.toString(),
                    );
                  },
                  child: text("Update Profile", color: Colors.white),
                ).paddingTop(30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
