import 'package:flutter/material.dart';
import 'section_header.dart';
import 'activity_item.dart';

class ActivitiesSection extends StatelessWidget {
  const ActivitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Aktivitas Terbaru',
          actionText: 'Lihat Semua',
          onActionPressed: () {
            // TODO: Navigate to all activities
          },
        ),
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // Activity List
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withAlpha(
                      (0.2 * 255).round(),
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isDark
                              ? Colors.black.withOpacity(0.0)
                              : Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ActivityItem(
                      title: 'Tugas Matematika dikumpulkan',
                      time: '2 jam yang lalu',
                      icon: Icons.check_circle_outline,
                      color: colorScheme.primary,
                    ),
                    Divider(
                      height: 1,
                      color: colorScheme.outline.withOpacity(0.3),
                      indent: 60,
                    ),
                    ActivityItem(
                      title: 'Kelas Fisika dimulai',
                      time: '4 jam yang lalu',
                      icon: Icons.play_circle_outline,
                      color: colorScheme.secondary,
                    ),
                    Divider(
                      height: 1,
                      color: colorScheme.outline.withOpacity(0.3),
                      indent: 60,
                    ),
                    ActivityItem(
                      title: 'Ujian Kimia minggu depan',
                      time: '1 hari yang lalu',
                      icon: Icons.warning_amber_outlined,
                      color: colorScheme.error,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
