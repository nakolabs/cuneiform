import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/theme_provider.dart';

class SettingsScreenContent extends HookConsumerWidget {
  const SettingsScreenContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final themeState = ref.watch(themeProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),

          // Account Section
          _buildSectionHeader(context, 'Account'),
          _buildMenuGroup(context, [
            _buildMenuItem(
              context,
              icon: LucideIcons.user,
              title: 'Profile',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: LucideIcons.lock,
              title: 'Security',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: LucideIcons.mail,
              title: 'Email',
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 32),

          // Preferences Section
          _buildSectionHeader(context, 'Preferences'),
          _buildMenuGroup(context, [
            _buildMenuItem(
              context,
              icon: LucideIcons.palette,
              title: 'Theme',
              trailing: _buildDropdownChip(
                context,
                value: themeState.themeMode.displayName,
                items: AppThemeMode.values.map((mode) => mode.displayName).toList(),
                onChanged: (value) {
                  if (value != null) {
                    final selectedMode = AppThemeMode.values.firstWhere(
                      (mode) => mode.displayName == value,
                    );
                    ref.read(themeProvider.notifier).setTheme(selectedMode);
                  }
                },
              ),
              onTap: null,
            ),
            _buildMenuItem(
              context,
              icon: LucideIcons.globe,
              title: 'Language',
              trailing: _buildDropdownChip(
                context,
                value: 'English',
                items: ['English', 'Indonesia'],
                onChanged: (value) {},
              ),
              onTap: null,
            ),
            _buildSwitchMenuItem(
              context,
              icon: LucideIcons.bell,
              title: 'Notifications',
              value: true,
              onChanged: (value) {},
            ),
          ]),

          const SizedBox(height: 32),

          // Support Section
          _buildSectionHeader(context, 'Support'),
          _buildMenuGroup(context, [
            _buildMenuItem(
              context,
              icon: LucideIcons.helpCircle,
              title: 'Help Center',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: LucideIcons.messageCircle,
              title: 'Contact',
              onTap: () {},
            ),
            _buildMenuItem(
              context,
              icon: LucideIcons.star,
              title: 'Rate App',
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 32),

          // About Section
          _buildSectionHeader(context, 'About'),
          _buildMenuGroup(context, [
            _buildMenuItem(
              context,
              icon: LucideIcons.info,
              title: 'Version',
              trailing: Text(
                '1.0.0',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: null,
            ),
            _buildMenuItem(
              context,
              icon: LucideIcons.code,
              title: 'Licenses',
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _buildMenuGroup(BuildContext context, List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final child = entry.value;
          final isLast = index == children.length - 1;
          
          return Column(
            children: [
              child,
              if (!isLast) _buildDivider(context),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing,
              ] else if (onTap != null) ...[
                const SizedBox(width: 12),
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return _buildMenuItem(
      context,
      icon: icon,
      title: title,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: colorScheme.primary,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onTap: () => onChanged(!value),
    );
  }

  Widget _buildDropdownChip(
    BuildContext context, {
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          icon: Icon(
            LucideIcons.chevronDown,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 56),
      height: 1,
      color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
    );
  }
}
