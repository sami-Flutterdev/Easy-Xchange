import 'package:flutter/material.dart';
import 'package:easy_xchange/utils/images.dart';
import 'package:easy_xchange/utils/widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("Chat"),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios)),
        actions: const [Icon(Icons.notifications_none)],
      ),
      body:const Center(child: Text("Comming Soon"),)
    
    );
  }
}

