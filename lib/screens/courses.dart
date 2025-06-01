import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CoursesScreen extends HookConsumerWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Courses',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _mockCourses.length,
              itemBuilder: (context, index) {
                final course = _mockCourses[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: course['color'] as Color?,
                      child: Icon(course['icon'] as IconData, color: Colors.white),
                    ),
                    title: Text(
                      course['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course['instructor'] as String),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: course['progress'] as double,
                          backgroundColor: Colors.grey[300],
                        ),
                        const SizedBox(height: 4),
                        Text('${((course['progress'] as double?) ?? 0.0 * 100).toInt()}% Complete'),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Navigate to course detail
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

final _mockCourses = [
  {
    'title': 'Flutter Development',
    'instructor': 'Dr. John Smith',
    'progress': 0.7,
    'color': Colors.blue,
    'icon': Icons.phone_android,
  },
  {
    'title': 'Data Structures',
    'instructor': 'Prof. Jane Doe',
    'progress': 0.4,
    'color': Colors.green,
    'icon': Icons.account_tree,
  },
  {
    'title': 'Web Development',
    'instructor': 'Mr. Bob Wilson',
    'progress': 0.9,
    'color': Colors.orange,
    'icon': Icons.web,
  },
];
