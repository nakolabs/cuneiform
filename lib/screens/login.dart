import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/auth_provider.dart';
import '../widgets/common/auth_container.dart';
import '../widgets/common/custom_text_field.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/error_message.dart';
import '../utils/validation.dart';
import 'forgot_password.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final errorMessage = useState<String?>(null);
    final isObscured = useState(true);

    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    Future<void> handleLogin() async {
      final emailError = ValidationUtils.validateEmail(emailController.text);
      final passwordError = ValidationUtils.validatePassword(
        passwordController.text,
      );

      if (emailError != null) {
        errorMessage.value = emailError;
        return;
      }
      if (passwordError != null) {
        errorMessage.value = passwordError;
        return;
      }

      errorMessage.value = null;

      try {
        final result = await authNotifier.login(
          emailController.text.trim(),
          passwordController.text,
        );

        if (result == null) {
          errorMessage.value = 'Invalid email or password';
        }
      } catch (e) {
        errorMessage.value = 'Login failed: ${e.toString()}';
      }
    }

    void handleForgotPassword() {
      errorMessage.value = null;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
      );
    }

    return AuthContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // App Logo and Branding
          _buildAppHeader(context),
          const SizedBox(height: 40),

          // Email Field
          CustomTextField(
            controller: emailController,
            labelText: 'Email',
            prefixIcon: LucideIcons.atSign,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),

          // Password Field
          CustomTextField(
            controller: passwordController,
            labelText: 'Password',
            prefixIcon: LucideIcons.lock,
            obscureText: isObscured.value,
            textInputAction: TextInputAction.done,
            onSubmitted: handleLogin,
            suffixIcon: IconButton(
              icon: Icon(
                isObscured.value ? LucideIcons.eye : LucideIcons.eyeOff,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              onPressed: () => isObscured.value = !isObscured.value,
            ),
          ),

          // Error Message
          if (errorMessage.value != null) ...[
            const SizedBox(height: 16),
            ErrorMessage(message: errorMessage.value!),
          ],

          const SizedBox(height: 32),

          // Login Button
          CustomButton(
            text: 'Sign In',
            icon: LucideIcons.logIn,
            onPressed: handleLogin,
            isLoading: authState.isLoading,
          ),

          const SizedBox(height: 20),

          // Forgot Password Link
          TextButton(
            onPressed: handleForgotPassword,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Decorative Elements
          _buildDecorations(context),
        ],
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/icon/icon.png', width: 96, height: 96),
        const SizedBox(height: 8),
        Text(
          'Genesis',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Belajar dan mengajar jadi lebih mudah.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildDecorations(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
