import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class QuickMenu extends StatefulWidget {
  const QuickMenu({super.key});

  @override
  State<QuickMenu> createState() => _QuickMenuState();
}

class _QuickMenuState extends State<QuickMenu>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  List<Map<String, dynamic>> _getAllMenuItems() {
    return [
      {
        'icon': LucideIcons.settings,
        'label': 'Pengaturan',
        'color': const Color(0xFF6B7280),
        'onTap': () {
          // TODO: Navigate to settings
        },
      },
      {
        'icon': LucideIcons.bell,
        'label': 'Notifikasi',
        'color': const Color(0xFFEF4444),
        'onTap': () {
          // TODO: Navigate to notifications
        },
      },
      {
        'icon': LucideIcons.bookOpen,
        'label': 'Materi',
        'color': const Color(0xFF8B5CF6),
        'onTap': () {
          // TODO: Navigate to materials
        },
      },
      {
        'icon': LucideIcons.brain,
        'label': 'Quiz',
        'color': const Color(0xFF10B981),
        'onTap': () {
          // TODO: Navigate to quiz
        },
      },
      {
        'icon': LucideIcons.helpCircle,
        'label': 'Bantuan',
        'color': const Color(0xFF3B82F6),
        'onTap': () {
          // TODO: Navigate to help
        },
      },
      {
        'icon': LucideIcons.info,
        'label': 'Tentang',
        'color': const Color(0xFFF59E0B),
        'onTap': () {
          // TODO: Navigate to about
        },
      },
      {
        'icon': LucideIcons.calendar,
        'label': 'Jadwal',
        'color': const Color(0xFF06B6D4),
        'onTap': () {
          // TODO: Navigate to schedule
        },
      },
      {
        'icon': LucideIcons.users,
        'label': 'Komunitas',
        'color': const Color(0xFFEC4899),
        'onTap': () {
          // TODO: Navigate to community
        },
      },
    ];
  }

  Widget _buildMenuItem(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: item['onTap'] as VoidCallback,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? theme.colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withAlpha((0.2 * 255).round()),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isDark
                      ? Colors.black.withOpacity(0.0)
                      : Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (item['color'] as Color).withOpacity(isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item['icon'] as IconData,
                size: 20,
                color: item['color'] as Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item['label'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark ? theme.colorScheme.onSurface : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final allMenuItems = _getAllMenuItems();
    final mainMenuItems = allMenuItems.take(4).toList();
    final additionalMenuItems = allMenuItems.skip(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row with expand/collapse button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Menu Cepat',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (additionalMenuItems.isNotEmpty)
              TextButton(
                onPressed: _toggleExpanded,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded ? 'Tutup' : 'Lihat Semua',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        _isExpanded
                            ? LucideIcons.chevronUp
                            : LucideIcons.chevronRight,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        // Main menu grid (4 items only)
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 0.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children:
              mainMenuItems
                  .map((item) => _buildMenuItem(context, item))
                  .toList(),
        ),
        // Expandable additional menu items
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _animation.value,
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 20,
            ), // Add bottom padding for shadow
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children:
                  additionalMenuItems
                      .map((item) => _buildMenuItem(context, item))
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
