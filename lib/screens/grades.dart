import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GradesScreen extends HookConsumerWidget {
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grades',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Overall GPA',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '3.75',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  const Text('out of 4.0'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Course Grades',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _mockGrades.length,
              itemBuilder: (context, index) {
                final grade = _mockGrades[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      grade['course'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(grade['assignment'] as String),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          grade['grade'] as String,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getGradeColor(grade['grade'] as String),
                          ),
                        ),
                        Text(
                          '${grade['score'] as int}%',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
      case 'A+':
        return Colors.green;
      case 'B':
      case 'B+':
        return Colors.blue;
      case 'C':
      case 'C+':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}

final _mockGrades = [
  {
    'course': 'Flutter Development',
    'assignment': 'Calculator App',
    'grade': 'A',
    'score': 95,
  },
  {
    'course': 'Data Structures',
    'assignment': 'Binary Tree Implementation',
    'grade': 'B+',
    'score': 88,
  },
  {
    'course': 'Web Development',
    'assignment': 'Portfolio Website',
    'grade': 'A+',
    'score': 98,
  },
  {
    'course': 'Flutter Development',
    'assignment': 'UI Design Assignment',
    'grade': 'A',
    'score': 92,
  },
];
