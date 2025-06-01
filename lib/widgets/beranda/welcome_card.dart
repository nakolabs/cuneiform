import 'package:flutter/material.dart';
import '../../providers/user_provider.dart';

class WelcomeCard extends StatelessWidget {
  final UserProfileState userProfileState;

  const WelcomeCard({super.key, required this.userProfileState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withAlpha((0.2 * 255).round()),
        ),
        boxShadow: [
          BoxShadow(
            color:
                theme.brightness == Brightness.dark
                    ? Colors.black.withAlpha((0.0 * 255).toInt())
                    : Colors.black.withAlpha((0.1 * 255).toInt()),
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withAlpha((0.8 * 255).toInt()),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: colorScheme.surface,
              child:
                  userProfileState.profile?.name.isNotEmpty == true
                      ? Text(
                        userProfileState.profile!.name[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      )
                      : Icon(
                        Icons.person_outline,
                        size: 28,
                        color: colorScheme.primary,
                      ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (userProfileState.isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                    ),
                  )
                else if (userProfileState.error != null)
                  Text(
                    'Selamat Datang!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  Text(
                    'Hai, ${userProfileState.profile?.name ?? 'User'}!',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  'Mari mulai belajar hari ini',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
