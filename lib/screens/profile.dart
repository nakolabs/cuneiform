import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';
import 'settings.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileState = ref.watch(userProfileProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 32), // Status bar spacing
          // Profile Header - Compact Horizontal Layout
          Row(
            children: [
              // Profile Picture
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child:
                    userProfileState.profile?.name.isNotEmpty == true
                        ? Center(
                          child: Text(
                            userProfileState.profile!.name[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        )
                        : Icon(
                          LucideIcons.user,
                          size: 24,
                          color: colorScheme.onPrimary,
                        ),
              ),
              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (userProfileState.isLoading)
                      const CircularProgressIndicator()
                    else if (userProfileState.error != null)
                      Text(
                        'Failed to load profile',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      )
                    else ...[
                      Text(
                        userProfileState.profile?.name ?? 'User',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userProfileState.profile?.email ?? 'user@example.com',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Profile Options
          Card(
            elevation: 0,
            color: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  icon: LucideIcons.user,
                  title: 'Edit Profile',
                  onTap: () {
                    // TODO: Navigate to edit profile
                  },
                ),
                _buildDivider(context),
                _buildMenuItem(
                  context,
                  icon: LucideIcons.bookOpen,
                  title: 'My Courses',
                  onTap: () {
                    // TODO: Navigate to my courses
                  },
                ),
                _buildDivider(context),
                _buildMenuItem(
                  context,
                  icon: LucideIcons.award,
                  title: 'Achievements',
                  onTap: () {
                    // TODO: Navigate to achievements
                  },
                ),
                _buildDivider(context),
                _buildMenuItem(
                  context,
                  icon: LucideIcons.clock,
                  title: 'Learning History',
                  onTap: () {
                    // TODO: Navigate to learning history
                  },
                ),
                _buildDivider(context),
                _buildMenuItem(
                  context,
                  icon: LucideIcons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreenContent(),
                      ),
                    );
                  },
                ),
                _buildDivider(context),
                _buildMenuItem(
                  context,
                  icon: LucideIcons.logOut,
                  title: 'Sign Out',
                  onTap: () {
                    _showLogoutDialog(context, ref);
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? colorScheme.error : colorScheme.onSurfaceVariant,
        size: 20,
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: isDestructive ? colorScheme.error : null,
        ),
      ),
      trailing: Icon(
        LucideIcons.chevronRight,
        color: colorScheme.outline,
        size: 16,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Sign Out',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(authProvider.notifier).logout();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
                child: const Text('Sign Out'),
              ),
            ],
          ),
    );
  }
}
