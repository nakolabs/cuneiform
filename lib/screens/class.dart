import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class KelasScreen extends HookConsumerWidget {
  const KelasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          
          // Classes List
          ...List.generate(_mockClasses.length, (index) {
            final kelas = _mockClasses[index];
            final isActive = kelas['status'] == 'Aktif';
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: _buildClassCard(context, kelas, isActive),
            );
          }),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, Map<String, dynamic> kelas, bool isActive) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final classColor = kelas['color'] as Color;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive 
              ? classColor.withOpacity(0.2)
              : colorScheme.outlineVariant.withOpacity(0.3),
          width: isActive ? 1.5 : 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to class detail
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and status
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: classColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    kelas['icon'] as IconData,
                    color: classColor,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kelas['name'] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        kelas['teacher'] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Status indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive 
                        ? Colors.green.withOpacity(0.1)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: isActive 
                        ? Border.all(color: Colors.green.withOpacity(0.2))
                        : null,
                  ),
                  child: Text(
                    kelas['status'] as String,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isActive ? Colors.green.shade700 : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Details row
            Row(
              children: [
                _buildDetailItem(
                  context,
                  icon: LucideIcons.mapPin,
                  text: kelas['room'] as String,
                ),
                
                const SizedBox(width: 20),
                
                _buildDetailItem(
                  context,
                  icon: LucideIcons.users,
                  text: '${kelas['students']} siswa',
                ),
                
                const Spacer(),
                
                _buildDetailItem(
                  context,
                  icon: LucideIcons.clock,
                  text: kelas['time'] as String,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            icon,
            size: 12,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

final _mockClasses = [
  {
    'name': 'Matematika Lanjut',
    'teacher': 'Pak Budi',
    'room': 'Ruang 101',
    'students': 25,
    'time': '08:00',
    'status': 'Aktif',
    'color': Colors.blue,
    'icon': LucideIcons.calculator,
  },
  {
    'name': 'Fisika Dasar',
    'teacher': 'Bu Sari',
    'room': 'Lab Fisika',
    'students': 20,
    'time': '10:00',
    'status': 'Aktif',
    'color': Colors.green,
    'icon': LucideIcons.atom,
  },
  {
    'name': 'Kimia Organik',
    'teacher': 'Pak Joko',
    'room': 'Lab Kimia',
    'students': 18,
    'time': '13:00',
    'status': 'Selesai',
    'color': Colors.purple,
    'icon': LucideIcons.flaskConical,
  },
  {
    'name': 'Bahasa Inggris',
    'teacher': 'Miss Anna',
    'room': 'Ruang 205',
    'students': 30,
    'time': '15:00',
    'status': 'Aktif',
    'color': Colors.orange,
    'icon': LucideIcons.languages,
  },
];
