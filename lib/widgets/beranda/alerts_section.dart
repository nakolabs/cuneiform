import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'alert_card.dart';
import 'section_header.dart';

class AlertsSection extends StatelessWidget {
  const AlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Perlu Perhatian',
          actionText: 'Lihat Semua',
          onActionPressed: () {
            // TODO: Navigate to all alerts
          },
        ),
        const SizedBox(height: 16),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark 
                      ? Colors.black.withOpacity(0.0)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                AlertCard(
                  icon: LucideIcons.alertCircle,
                  title: 'Tugas Belum Selesai',
                  description: '3 tugas menunggu dikerjakan',
                  color: colorScheme.error,
                  isUrgent: true,
                  onTap: () {
                    // TODO: Navigate to pending tasks
                  },
                ),
                Divider(
                  height: 1,
                  color: colorScheme.outline.withOpacity(0.3),
                  indent: 60,
                ),
                AlertCard(
                  icon: LucideIcons.calendar,
                  title: 'Ujian Mendekati',
                  description: 'Ujian Matematika dalam 5 hari',
                  color: const Color(0xFFF59E0B),
                  onTap: () {
                    // TODO: Navigate to upcoming exams
                  },
                ),
                Divider(
                  height: 1,
                  color: colorScheme.outline.withOpacity(0.3),
                  indent: 60,
                ),
                AlertCard(
                  icon: LucideIcons.clock,
                  title: 'Deadline Hari Ini',
                  description: 'Tugas Fisika harus dikumpulkan',
                  color: colorScheme.primary,
                  onTap: () {
                    // TODO: Navigate to today's deadlines
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
