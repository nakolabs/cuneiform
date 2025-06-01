import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AssignmentsScreen extends HookConsumerWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _mockAssignments.length,
            separatorBuilder:
                (context, index) => Column(
                  children: [
                    // const SizedBox(height: 8),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colorScheme.outline.withAlpha((0.1 * 255).toInt()),
                    ),
                    // const SizedBox(height: 8),
                  ],
                ),
            itemBuilder: (context, index) {
              final assignment = _mockAssignments[index];
              return _buildAssignmentCard(context, assignment);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(
    BuildContext context,
    Map<String, dynamic> assignment,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final status = assignment['status'] as String;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title only
          Text(
            assignment['title'] as String,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            assignment['course'] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          // Footer: Due date and Action
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      LucideIcons.clock,
                      size: 14,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      assignment['dueDate'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionButton(
                context,
                status,
                assignment['statusColor'] as Color,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String status,
    Color statusColor,
  ) {
    final theme = Theme.of(context);

    String text;
    Color backgroundColor;
    Color textColor;
    VoidCallback? onPressed;

    switch (status) {
      case 'Pending':
        text = 'Mulai';
        onPressed = () {
          // TODO: Start assignment
        };
        break;
      case 'In Progress':
        text = 'Lanjut';
        onPressed = () {
          // TODO: Continue assignment
        };
        break;
      case 'Submitted':
        text = 'Lihat';

        onPressed = () {
          // TODO: View submission
        };
        break;
      default:
        return const SizedBox.shrink();
    }

    backgroundColor = statusColor.withAlpha((0.1 * 255).toInt());
    textColor = statusColor;

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }
}

final _mockAssignments = [
  {
    'title': 'Membuat Aplikasi Kalkulator Sederhana',
    'course': 'Pengembangan Flutter',
    'dueDate': '15 Desember 2023',
    'status': 'In Progress',
    'statusColor': Colors.orange,
  },
  {
    'title': 'Implementasi Binary Search Tree',
    'course': 'Struktur Data',
    'dueDate': '20 Desember 2023',
    'status': 'Pending',
    'statusColor': Colors.blue,
  },
  {
    'title': 'Membuat Website Portfolio',
    'course': 'Pengembangan Web',
    'dueDate': '10 Desember 2023',
    'status': 'Submitted',
    'statusColor': Colors.green,
  },
  {
    'title': 'Analisis Algoritma Sorting',
    'course': 'Algoritma dan Pemrograman',
    'dueDate': '25 Desember 2023',
    'status': 'Pending',
    'statusColor': Colors.blue,
  },
];
