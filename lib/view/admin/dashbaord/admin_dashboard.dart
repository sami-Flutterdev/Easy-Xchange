import 'package:easy_xchange/utils/constant.dart';
import 'package:easy_xchange/utils/widget.dart';
import 'package:easy_xchange/view/user_app/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        title: text('Admin Dashboard',
            fontSize: textSizeLargeMedium, fontWeight: FontWeight.w600),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              'Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Stats Cards Row
            Row(
              children: [
                // Total Users Card
                Expanded(
                  child: _StatCard(
                    title: 'Total Users',
                    icon: Icons.people,
                    color: Colors.blue,
                    stream: _firestore
                        .collection('users')
                        .snapshots()
                        .map((snap) => snap.size),
                  ),
                ),
                const SizedBox(width: 10),

                // Active Posts Card
                Expanded(
                  child: _StatCard(
                    title: 'Active Posts',
                    icon: Icons.post_add,
                    color: Colors.green,
                    stream: _firestore
                        .collection('posts')
                        .snapshots()
                        .map((snap) => snap.size),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                // Pending Complaints Card
                Expanded(
                  child: _StatCard(
                    title: 'Pending Complaints',
                    icon: Icons.warning,
                    color: Colors.orange,
                    stream: _firestore
                        .collection('complaints')
                        .where('status', isEqualTo: 'Pending')
                        .snapshots()
                        .map((snap) => snap.size),
                  ),
                ),
                const SizedBox(width: 10),

                // Resolved Complaints Card
                Expanded(
                  child: _StatCard(
                    title: 'Resolved Complaints',
                    icon: Icons.check_circle,
                    color: Colors.green,
                    stream: _firestore
                        .collection('complaints')
                        .where('status', isEqualTo: 'Resolved')
                        .snapshots()
                        .map((snap) => snap.size),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Recent Activity Title
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Recent Activity List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('activity_log')
                    .orderBy('timestamp', descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No recent activity'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final log = snapshot.data!.docs[index];
                      final data = log.data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(data['action'] ?? 'Activity'),
                          subtitle: Text(
                            data['timestamp'] != null
                                ? _formatTimestamp(data['timestamp'])
                                : 'Unknown time',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    return '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year} '
        '${timestamp.toDate().hour}:${timestamp.toDate().minute}';
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Stream<int> stream;

  const _StatCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<int>(
          stream: stream,
          builder: (context, snapshot) {
            final value = snapshot.data ?? 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, size: 30, color: color),
                    Text(
                      value.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
