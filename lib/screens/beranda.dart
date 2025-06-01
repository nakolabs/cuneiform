import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../providers/user_provider.dart';
import '../providers/beranda_provider.dart';
import '../widgets/beranda/welcome_card.dart';
import '../widgets/beranda/quick_menu.dart';
import '../widgets/beranda/alerts_section.dart';
import '../widgets/beranda/activities_section.dart';

class BerandaScreen extends HookConsumerWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileState = ref.watch(userProfileProvider);
    final userProfileNotifier = ref.read(userProfileProvider.notifier);
    final scrollController = useScrollController();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        userProfileNotifier.loadUserProfile();
      });

      void scrollListener() {
        final isScrolled = scrollController.offset > 80;
        ref.read(berandaScrollProvider.notifier).state = isScrolled;
      }

      scrollController.addListener(scrollListener);
      return () => scrollController.removeListener(scrollListener);
    }, []);

    return RefreshIndicator(
      onRefresh: () async {
        await userProfileNotifier.loadUserProfile();
      },

      child: Stack(
        children: [
          // Main scrollable content
          _buildGradientBackground(context),
          SingleChildScrollView(
            controller: scrollController,
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 100), // Space for the header
                    _buildMainContent(context),
                  ],
                ),
                _buildWelcomeSection(userProfileState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
         gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFEA580C), // Orange-600 at top
                Theme.of(context).colorScheme.surface, // Surface color at bottom
              ],
              stops: const [0.0, 0.5], // Gradient stops at middle
            ),
      ),
    );
  }

  Widget _buildWelcomeSection(UserProfileState userProfileState) {
    return Container(
      margin: const EdgeInsets.only(top: 38, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: WelcomeCard(userProfileState: userProfileState),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 60),

          // Quick Actions Menu
          _QuickMenuSection(),

          SizedBox(height: 32),

          // Important Alerts/Notifications
          AlertsSection(),

          SizedBox(height: 32),

          // Recent Activities
          ActivitiesSection(),

          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _QuickMenuSection extends StatelessWidget {
  const _QuickMenuSection();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [SizedBox(height: 16), QuickMenu()],
      ),
    );
  }
}
