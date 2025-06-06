// complaint_provider.dart
import 'package:easy_xchange/viewModel/model/complaint_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? selectedCategory;
  String? titleError;
  String? descriptionError;
  String? categoryError;
  bool _isLoading = false;
  List<ComplaintModel> _complaints = [];
  String _selectedFilter = 'Pending';
  bool _hasError = false;

  bool get isLoading => _isLoading;
  List<ComplaintModel> get complaints => _complaints;
  String get selectedFilter => _selectedFilter;
  bool get hasError => _hasError;
  bool get isValid =>
      titleError == null && descriptionError == null && categoryError == null;

  // Add these filter options
  static const List<String> filterOptions = [
    'Pending',
    'In Progress',
    'Resolved'
  ];

  Future<void> submitComplaint({
    required String title,
    required String username,
    required String cnicNo,
    required String description,
    required String category,
    List<String>? images,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) {
        throw "Please login to submit a complaint";
      }

      final complaintId = _firestore.collection('complaints').doc().id;

      final newComplaint = ComplaintModel(
        id: complaintId,
        userId: user.uid,
        username: username,
        cnicNo: cnicNo,
        title: title,
        description: description,
        category: category,
        status: 'Pending',
        createdAt: DateTime.now(),
        images: images,
      );

      await _firestore
          .collection('complaints')
          .doc(complaintId)
          .set(newComplaint.toMap());
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchComplaints() async {
    try {
      _isLoading = true;
      _hasError = false;
      notifyListeners();

      final snapshot = await _firestore
          .collection('complaints')
          .where('status', isEqualTo: _selectedFilter)
          .get();

      _complaints = snapshot.docs
          .map((doc) => ComplaintModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      _hasError = true;
      print("error: ${e.toString()}");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateComplaintStatus(
      String complaintId, String newStatus) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _firestore.collection('complaints').doc(complaintId).update({
        'status': newStatus,
        'resolvedAt':
            newStatus == 'Resolved' ? FieldValue.serverTimestamp() : null,
      });

      // Refresh the list after update
      await fetchComplaints();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    _hasError = false;
    notifyListeners();
    fetchComplaints();
  }

  void updateCategory(String? value) {
    selectedCategory = value;
    categoryError = null;
    notifyListeners();
  }

  void clearTitleError() {
    titleError = null;
    notifyListeners();
  }

  void clearDescriptionError() {
    descriptionError = null;
    notifyListeners();
  }

  void validate(String title, String description) {
    titleError = title.isEmpty ? 'Please enter a title' : null;
    descriptionError = description.isEmpty
        ? 'Please enter description'
        : (description.length < 20
            ? 'Description should be at least 20 characters'
            : null);
    categoryError =
        selectedCategory == null ? 'Please select a category' : null;
    notifyListeners();
  }
}
