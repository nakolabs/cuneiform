import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../common/custom_text_field.dart';
import '../common/custom_button.dart';
import '../common/error_message.dart';

class EmailStep extends HookWidget {
  final TextEditingController emailController;
  final ValueNotifier<String?> errorMessage;
  final ValueNotifier<bool> isLoading;
  final VoidCallback onSend;

  const EmailStep({
    super.key,
    required this.emailController,
    required this.errorMessage,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/icon/icon.png', width: 96, height: 96),
        const SizedBox(height: 24),
        Text(
          'Forgot Password?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your email, we\'ll send you a verification code to reset your password.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 32),
        CustomTextField(
          controller: emailController,
          labelText: 'Email',
          prefixIcon: LucideIcons.atSign,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: onSend,
        ),
        if (errorMessage.value != null) ...[
          const SizedBox(height: 16),
          ErrorMessage(message: errorMessage.value!),
        ],
        const SizedBox(height: 24),
        CustomButton(
          text: 'Send verification code',
          icon: LucideIcons.mail,
          onPressed: onSend,
          isLoading: isLoading.value,
        ),
      ],
    );
  }
}

class VerifyStep extends HookWidget {
  final TextEditingController tokenController;
  final ValueNotifier<String?> errorMessage;
  final ValueNotifier<bool> isLoading;
  final VoidCallback onVerify;
  final String email;

  const VerifyStep({
    super.key,
    required this.tokenController,
    required this.errorMessage,
    required this.isLoading,
    required this.onVerify,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/icon/icon.png', width: 96, height: 96),
        const SizedBox(height: 24),
        Text(
          'Check Your Email',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We\'ve sent a verification code to\n$email',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 32),
        CustomTextField(
          controller: tokenController,
          labelText: 'Verification Code',
          prefixIcon: LucideIcons.keyRound,
          textInputAction: TextInputAction.done,
          onSubmitted: onVerify,
        ),
        if (errorMessage.value != null) ...[
          const SizedBox(height: 16),
          ErrorMessage(message: errorMessage.value!),
        ],
        const SizedBox(height: 24),
        CustomButton(
          text: 'Verify Code',
          icon: LucideIcons.shieldCheck,
          onPressed: onVerify,
          isLoading: isLoading.value,
        ),
      ],
    );
  }
}

class NewPasswordStep extends HookWidget {
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;
  final ValueNotifier<String?> errorMessage;
  final ValueNotifier<bool> isLoading;
  final ValueNotifier<bool> isObscured;
  final ValueNotifier<bool> isConfirmObscured;
  final VoidCallback onReset;

  const NewPasswordStep({
    super.key,
    required this.newPasswordController,
    required this.confirmPasswordController,
    required this.errorMessage,
    required this.isLoading,
    required this.isObscured,
    required this.isConfirmObscured,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/icon/icon.png', width: 96, height: 96),
        const SizedBox(height: 24),
        Text(
          'Reset Password',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your new password below',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 32),
        CustomTextField(
          controller: newPasswordController,
          labelText: 'New Password',
          prefixIcon: LucideIcons.lock,
          obscureText: isObscured.value,
          textInputAction: TextInputAction.next,
          suffixIcon: IconButton(
            icon: Icon(
              isObscured.value
                  ? LucideIcons.eye
                  : LucideIcons.eyeOff,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            onPressed: () => isObscured.value = !isObscured.value,
          ),
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: confirmPasswordController,
          labelText: 'Confirm Password',
          prefixIcon: LucideIcons.lock,
          obscureText: isConfirmObscured.value,
          textInputAction: TextInputAction.done,
          onSubmitted: onReset,
          suffixIcon: IconButton(
            icon: Icon(
              isConfirmObscured.value
                 ? LucideIcons.eye
                  : LucideIcons.eyeOff,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            onPressed: () => isConfirmObscured.value = !isConfirmObscured.value,
          ),
        ),
        if (errorMessage.value != null) ...[
          const SizedBox(height: 16),
          ErrorMessage(message: errorMessage.value!),
        ],
        const SizedBox(height: 24),
        CustomButton(
          text: 'Reset Password',
          onPressed: onReset,
          isLoading: isLoading.value,
          icon: LucideIcons.checkCircle,
        ),
      ],
    );
  }
}

class SuccessStep extends StatelessWidget {
  const SuccessStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          LucideIcons.checkCircle,
          size: 64,
          color: Colors.green,
        ),
        const SizedBox(height: 24),
        Text(
          'Password Reset Successful!',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your password has been successfully reset. You can now sign in with your new password.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Back to Login',
          icon: LucideIcons.arrowLeft,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
