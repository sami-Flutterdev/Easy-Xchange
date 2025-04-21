import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintModel {
  String id;
  String userId;
  String title;
  String username;
  String cnicNo;
  String description;
  String category;
  String status;
  DateTime createdAt;
  List<String>? images;

  ComplaintModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.username,
    required this.cnicNo,
    required this.description,
    required this.category,
    this.status = 'Pending',
    required this.createdAt,
    this.images,
  });

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      username: map['username'],
      cnicNo: map['cnicNo'],
      description: map['description'],
      category: map['category'],
      status: map['status'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      images: List<String>.from(map['images'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'username': username,
      'cnicNo': cnicNo,
      'description': description,
      'category': category,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'images': images,
    };
  }
}
