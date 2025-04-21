import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/viewModel/complaint_controller.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:easy_xchange/components/textfield.dart';
import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/widget.dart';

class ComplaintSubmissionScreen extends StatefulWidget {
  ComplaintSubmissionScreen({super.key});

  @override
  State<ComplaintSubmissionScreen> createState() =>
      _ComplaintSubmissionScreenState();
}

class _ComplaintSubmissionScreenState extends State<ComplaintSubmissionScreen> {
  @override
  void initState() {
    var complainProvider =
        Provider.of<ComplaintProvider>(context, listen: false);
    complainProvider.selectedCategory = null;

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  final _titleController = TextEditingController();
  final _usernameController = TextEditingController();
  final _cnicController = TextEditingController();

  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: text("Complaint",
            fontSize: textSizeLargeMedium, fontWeight: FontWeight.w600),
      ),
      body: Consumer<ComplaintProvider>(
        builder: (context, formState, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: spacing_standard_new),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Field
                  text("Title", fontSize: 14.0),
                  CustomTextFormField(
                    hintText: 'Enter complaint title',
                    context,
                    controller: _titleController,
                    onChanged: (_) => formState.clearTitleError(),
                  ).paddingTop(spacing_middle),
                  text("User name", fontSize: 14.0).paddingTop(spacing_twinty),
                  CustomTextFormField(
                    hintText: 'Enter user name',
                    context,
                    controller: _usernameController,
                    onChanged: (_) => formState.clearTitleError(),
                  ).paddingTop(spacing_middle),
                  text("CNIC Number", fontSize: 14.0)
                      .paddingTop(spacing_twinty),
                  CustomTextFormField(
                    hintText: 'Enter 13 digits of CNIC number',
                    context,
                    maxLength: 13,
                    keyboardType: TextInputType.number,
                    controller: _cnicController,
                    onChanged: (_) => formState.clearTitleError(),
                  ).paddingTop(spacing_middle),

                  // Category Dropdown
                  text("Category", fontSize: 14.0),
                  CustomDropdownButton(
                    hint: "Select category",
                    value: formState.selectedCategory,
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        child:
                            text("Select category", color: AppColors.greyColor),
                      ),
                      ...[
                        'Technical',
                        'Payment',
                        'Account',
                        'Service',
                        'Fraud',
                        'Misbehave',
                        'Physical torture',
                        'Other'
                      ].map((value) => DropdownMenuItem<String>(
                            value: value,
                            child: text(value),
                          ))
                    ],
                    onChanged: (value) {
                      formState.updateCategory(value);
                    },
                  ).paddingTop(spacing_middle),
                  // Description Field
                  text("Description", fontSize: 14.0)
                      .paddingTop(spacing_twinty),
                  CustomTextFormField(
                    hintText: 'Describe your issue in detail',
                    context,
                    controller: _descriptionController,
                    maxLines: 5,
                    maxLength: 300,
                    onChanged: (_) => formState.clearDescriptionError(),
                  ).paddingTop(spacing_middle),

                  // Submit Button
                  Consumer<ComplaintProvider>(
                    builder: (context, complaintProvider, _) {
                      return elevatedButton(
                        context,
                        loading: complaintProvider.isLoading,
                        onPress: () => _submitForm(
                          context,
                        ),
                        child: text('Submit Complaint',
                            color: AppColors.whiteColor),
                      ).paddingTop(spacing_thirty);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm(BuildContext context) {
    final complaintProvider =
        Provider.of<ComplaintProvider>(context, listen: false);

    // Validate all fields
    complaintProvider.validate(
      _titleController.text,
      _descriptionController.text,
    );

    // Check if any field is empty
    if (_titleController.text.isEmpty) {
      complaintProvider.titleError = 'Please enter a title';
    }

    if (_descriptionController.text.isEmpty) {
      complaintProvider.descriptionError = 'Please enter description';
    }
    if (_usernameController.text.isEmpty) {
      complaintProvider.descriptionError = 'Please enter username';
    }
    if (_cnicController.text.isEmpty) {
      complaintProvider.descriptionError = 'Please enter CNIC number';
    }

    if (complaintProvider.selectedCategory == null) {
      complaintProvider.categoryError = 'Please select a category';
    }

    // Only proceed if all fields are filled
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        complaintProvider.selectedCategory != null) {
      // Additional validation for description length
      if (_descriptionController.text.length < 20) {
        complaintProvider.descriptionError =
            'Description should be at least 20 characters';
        utils().toastMethod("Description too short",
            backgroundColor: AppColors.redColor);
        return;
      }

      // All validations passed - submit the complaint
      complaintProvider
          .submitComplaint(
        title: _titleController.text,
        username: _usernameController.text,
        cnicNo: _cnicController.text,
        description: _descriptionController.text,
        category: complaintProvider.selectedCategory!,
      )
          .then((_) {
        Navigator.pop(context);
        utils().toastMethod("Complaint submitted successfully!");
      }).catchError((e) {
        utils().toastMethod(e.toString(), backgroundColor: AppColors.redColor);
      });
    } else {
      // Show error for empty fields
      utils().toastMethod("Please fill all fields",
          backgroundColor: AppColors.redColor);
      complaintProvider.notifyListeners();
    }
  }
}
