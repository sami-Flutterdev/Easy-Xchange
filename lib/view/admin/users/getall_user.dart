import 'package:easy_xchange/utils/colors.dart';
import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/view/admin/posts/overall_post.dart';
import 'package:easy_xchange/view/user_app/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nb_utils/nb_utils.dart';

class GetAllUsersScreen extends StatefulWidget {
  const GetAllUsersScreen({super.key});

  @override
  State<GetAllUsersScreen> createState() => _GetAllUsersScreenState();
}

class _GetAllUsersScreenState extends State<GetAllUsersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        title: text("Users Management",
            fontSize: textSizeLargeMedium, fontWeight: FontWeight.bold),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search users...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: text("Error loading users",
                          color: AppColors.redColor));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs.where((user) {
                  final data = user.data() as Map<String, dynamic>;
                  final query = _searchController.text.toLowerCase();
                  return data['username']
                          .toString()
                          .toLowerCase()
                          .contains(query) ||
                      data['email'].toString().toLowerCase().contains(query);
                }).toList();

                if (users.isEmpty) {
                  return Center(child: text("No users found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final userData = user.data() as Map<String, dynamic>;

                    return _UserCard(
                      userData: userData,
                      onDisable: () => _toggleUserStatus(
                          user.id, !(userData['isActive'] ?? true)),
                      onDelete: () => _deleteUser(context, user.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleUserStatus(String userId, bool isActive) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isActive': isActive,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      toast(isActive ? "User enabled" : "User disabled");
    } catch (e) {
      toast("Error updating user status");
    }
  }

  Future<void> _deleteUser(BuildContext context, String userId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: text("Delete User"),
        content: text("Are you sure you want to delete this user account?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _firestore.collection('users').doc(userId).delete();
                toast("User deleted successfully");
              } catch (e) {
                toast("Error deleting user");
              }
            },
            child: text("Delete", color: AppColors.redColor),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onDisable;
  final VoidCallback onDelete;

  const _UserCard({
    required this.userData,
    required this.onDisable,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = userData['isActive'] ?? true;
    var size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border:
              Border.all(color: AppColors.primaryColor.withValues(alpha: .3))),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Avatar
                CircleAvatar(
                  radius: size.width * .055,
                  backgroundColor: AppColors.primaryColor,
                  child: ClipOval(
                    child: buildUserImage(userData, size),
                  ),
                ),
                const SizedBox(width: 12),
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      text(userData['username'] ?? 'No username',
                          fontWeight: FontWeight.bold),
                      const SizedBox(height: 4),
                      text(userData['email'] ?? 'No email',
                          fontSize: textSizeSmall),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.circle,
                              size: 12,
                              color: isActive ? Colors.green : Colors.red),
                          const SizedBox(width: 4),
                          text(isActive ? "Active" : "Disabled",
                              fontSize: textSizeSmall),
                        ],
                      ),
                    ],
                  ),
                ),
                // Action Buttons
                PopupMenuButton<String>(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'toggle',
                      child: text(isActive ? "Disable User" : "Enable User"),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: text("Delete User"),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'toggle') onDisable();
                    if (value == 'delete') onDelete();
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Additional Info
            if (userData['phone'] != null || userData['cnic'] != null) ...[
              const Divider(height: 1),
              const SizedBox(height: 8),
              if (userData['phone'] != null)
                _buildInfoRow(Icons.phone, userData['phone']),
              if (userData['cnic'] != null)
                _buildInfoRow(Icons.credit_card, userData['cnic']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textcolorSecondary),
          const SizedBox(width: 8),
          Expanded(child: text(title, fontSize: textSizeSmall)),
        ],
      ),
    );
  }
}
