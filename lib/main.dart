import 'package:cuneiform/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'providers/auth_provider.dart';
import 'providers/beranda_provider.dart';
import 'services/auth_service.dart';
import 'screens/login.dart';
import 'screens/beranda.dart';
import 'screens/assignments.dart';
import 'screens/class.dart';
import 'screens/schedule.dart';
import 'screens/profile.dart';
import 'screens/settings.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await AuthService.initialize();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final themeState = ref.watch(themeProvider);

    // Remove the problematic useEffect for now, or replace with correct method
    // useEffect(() {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     ref.read(authProvider.notifier).checkAuthStatus();
    //   });
    //   return null;
    // }, []);

    return MaterialApp(
      title: 'Cuneiform',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.themeMode.themeMode,
      home: _buildHomeWidget(authState),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _buildHomeWidget(AuthState authState) {
    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return authState.isLoggedIn
        ? const AuthenticatedApp()
        : const LoginScreen();
  }
}

class AuthenticatedApp extends HookConsumerWidget {
  const AuthenticatedApp({super.key});

  static const _navigationItems = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(LucideIcons.home),
      selectedIcon: Icon(LucideIcons.home),
      label: 'Beranda',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.clipboardList),
      selectedIcon: Icon(LucideIcons.clipboardList),
      label: 'Tugas',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.school),
      selectedIcon: Icon(LucideIcons.school),
      label: 'Kelas',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.calendar),
      selectedIcon: Icon(LucideIcons.calendar),
      label: 'Jadwal',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.user),
      selectedIcon: Icon(LucideIcons.user),
      label: 'Profil',
    ),
  ];

  static const _pages = [
    BerandaScreen(),
    AssignmentsScreen(),
    KelasScreen(),
    JadwalScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState(0);
    final prevIndex = useState(0);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine if current page is Beranda (index 0)
    final isBerandaScreen = selectedIndex.value == 0;
    // Watch scroll state for Beranda screen
    final isBerandaScrolled = ref.watch(berandaScrollProvider);

    // App bar should be orange only on Beranda and when not scrolled
    final shouldUseOrangeAppBar = isBerandaScreen && !isBerandaScrolled;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor:
            shouldUseOrangeAppBar
                ? const Color(0xFFEA580C)
                : colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor:
            shouldUseOrangeAppBar ? Colors.white : colorScheme.onSurface,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icon/icon.png', // Your app icon path
              height: 40,
              width: 40,
              // color:
              //     shouldUseOrangeAppBar
              //         ? Colors.white
              //         : colorScheme.primary,
            ),
            const SizedBox(width: 5),
            Text(
              'Genesis',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                color:
                    shouldUseOrangeAppBar
                        ? Colors.white
                        : colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),

        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton.outlined(
              icon: Badge(
                smallSize: 6,
                backgroundColor:
                    shouldUseOrangeAppBar ? Colors.white : colorScheme.primary,
                child: Icon(
                  LucideIcons.bell,
                  size: 20,
                  color:
                      shouldUseOrangeAppBar
                          ? Colors.white
                          : colorScheme.onSurface,
                ),
              ),
              onPressed: () {
                // TODO: Navigate to notifications
              },
              style: IconButton.styleFrom(
                backgroundColor:
                    shouldUseOrangeAppBar
                        ? Colors.white.withOpacity(0.2)
                        : colorScheme.surface.withOpacity(0.5),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              tooltip: 'Notifikasi',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton.outlined(
              icon: Icon(
                LucideIcons.settings,
                size: 20,
                color:
                    shouldUseOrangeAppBar
                        ? Colors.white
                        : colorScheme.onSurface,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => Scaffold(
                          appBar: AppBar(
                            title: const Text('Pengaturan'),
                            backgroundColor: colorScheme.surface,
                            foregroundColor: colorScheme.onSurface,
                            elevation: 0,
                          ),
                          body: const SettingsScreenContent(),
                        ),
                  ),
                );
              },
              style: IconButton.styleFrom(
                backgroundColor:
                    shouldUseOrangeAppBar
                        ? Colors.white.withOpacity(0.2)
                        : colorScheme.surface.withOpacity(0.5),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              tooltip: 'Pengaturan',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surface.withAlpha((0.1 * 255).round()),
            ],
          ),
        ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 100), // cepat
          switchInCurve: Curves.easeOut, // halus tapi responsif
          transitionBuilder:
              (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
          child: Container(
            key: ValueKey(selectedIndex.value),
            child: _pages[selectedIndex.value],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(color: colorScheme.outline, width: 0.2),
          ),
        ),
        child: NavigationBar(
          backgroundColor: colorScheme.surface,
          selectedIndex: selectedIndex.value,
          onDestinationSelected: (index) {
            prevIndex.value = selectedIndex.value;
            selectedIndex.value = index;
          },
          destinations: _navigationItems,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3.0,
          height: 72,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          animationDuration: const Duration(milliseconds: 400),
          // overlayColor: WidgetStateProperty.resolveWith<Color?>((
          //   Set<WidgetState> states,
          // ) {
          //   if (states.contains(WidgetState.pressed)) {
          //     return AppTheme.primaryOrange; // efek tekan
          //   }
          //   return null;
          // }),
        ),
      ),
    );
  }
}
