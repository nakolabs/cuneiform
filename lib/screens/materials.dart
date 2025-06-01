import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MaterialsScreen extends HookConsumerWidget {
  const MaterialsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Learning Materials',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _mockMaterials.length,
              itemBuilder: (context, index) {
                final material = _mockMaterials[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      material['icon'] as IconData,
                      color: material['color'] as Color,
                      size: 32,
                    ),
                    title: Text(
                      material['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(material['course'] as String),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(material['duration'] as String, style: TextStyle(color: Colors.grey[600])),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        // TODO: Download material
                      },
                    ),
                    onTap: () {
                      // TODO: Open material
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

final _mockMaterials = [
  {
    'title': 'Introduction to Flutter Widgets',
    'course': 'Flutter Development',
    'duration': '45 min',
    'icon': Icons.video_library,
    'color': Colors.red,
  },
  {
    'title': 'Arrays and Lists Explained',
    'course': 'Data Structures',
    'duration': '30 min',
    'icon': Icons.picture_as_pdf,
    'color': Colors.blue,
  },
  {
    'title': 'HTML & CSS Basics',
    'course': 'Web Development',
    'duration': '60 min',
    'icon': Icons.video_library,
    'color': Colors.red,
  },
  {
    'title': 'JavaScript Functions',
    'course': 'Web Development',
    'duration': '25 min',
    'icon': Icons.article,
    'color': Colors.green,
  },
];
