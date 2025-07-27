import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_xchange/view/auth%20screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AccountListener extends StatefulWidget {
  final Widget child;

  const AccountListener({super.key, required this.child});

  @override
  _AccountListenerState createState() => _AccountListenerState();
}

class _AccountListenerState extends State<AccountListener> {
  Stream<DocumentSnapshot>? userDocStream;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _initStream();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (userDocStream == null) {
      _initStream();
    }
  }

  //  User ka document listen karne ke liye stream initialize
  void _initStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userDocStream = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots();
    }
  }

  // Jab user ka account delete ho jaye, to dialog dikhaye aur logout kare
  void _showAccountDeletedDialog() async {
    if (_dialogShown || !mounted) return;

    _dialogShown = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Account Deleted"),
        content: const Text("Your account has been deleted by the admin."),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.remove("uid").then((value) {
                  const WelcomeScreen().launch(context, isNewTask: true);
                });
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return widget.child;
    }

    return StreamBuilder<DocumentSnapshot>(
      key: ValueKey(user.uid), // StreamBuilder ko force update karne ke liye
      stream: userDocStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // ❌ Document nahi mila ya delete ho chuka
          if (!snapshot.hasData || !snapshot.data!.exists) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Future.delayed(const Duration(milliseconds: 100), () {
                _showAccountDeletedDialog();
              });
            });

            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return widget.child;
        }

        // Jab tak data aa raha ho
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
