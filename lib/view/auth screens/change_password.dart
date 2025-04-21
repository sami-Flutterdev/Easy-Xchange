import 'package:easy_xchange/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:easy_xchange/components/build_button.dart';
import 'package:easy_xchange/components/textfield.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:easy_xchange/utils/widget.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var active1 = true;
  var active2 = true;
  var active3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("Change Password"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textField(
              hint: "Old password",
              maxline: 1,
              labell: text(
                "enter old password",
              ),
              obscures: active1,
              suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      active1 == true ? active1 = false : active1 = true;
                    });
                  },
                  icon: active1 == true
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off)),
            ),
            textField(
              hint: "New password",
              maxline: 1,
              labell: text(
                "enter New password",
              ),
              obscures: active3,
              suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      active3 == true ? active3 = false : active3 = true;
                    });
                  },
                  icon: active3 == true
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off)),
            ),
            textField(
              hint: "conform password",
              maxline: 1,
              labell: text(
                "conform password",
              ),
              obscures: active2,
              suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      active2 == true ? active2 = false : active2 = true;
                    });
                  },
                  icon: active2 == true
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off)),
            ),
            BuildButton(
                    onPressed: () {
                      finish(context);
                    },
                    text: "Save")
                .paddingSymmetric(vertical: spacing_twinty)
          ],
        ).paddingAll(spacing_twinty),
      ),
    );
  }
}
