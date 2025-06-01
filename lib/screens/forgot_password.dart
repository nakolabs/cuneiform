import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widgets/common/auth_container.dart';
import '../widgets/forgot_password/forgot_password_steps.dart';
import '../utils/validation.dart';

enum ForgotPasswordStep { email, verify, newPassword, success }

class ForgotPasswordScreen extends HookConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = useState(ForgotPasswordStep.email);
    final emailController = useTextEditingController();
    final tokenController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final errorMessage = useState<String?>(null);
    final isObscured = useState(true);
    final isConfirmObscured = useState(true);
    final isLoading = useState(false);

    Future<void> handleSendResetEmail() async {
      final emailError = ValidationUtils.validateEmail(emailController.text);
      if (emailError != null) {
        errorMessage.value = emailError;
        return;
      }

      errorMessage.value = null;
      isLoading.value = true;

      try {
        // TODO: Implement actual forgot password API call
        // await authNotifier.forgotPassword(emailController.text.trim());
        
        await Future.delayed(const Duration(seconds: 2)); // Simulate API call
        currentStep.value = ForgotPasswordStep.verify;
      } catch (e) {
        errorMessage.value = 'Failed to send reset email: ${e.toString()}';
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> handleVerifyToken() async {
      final tokenError = ValidationUtils.validateToken(tokenController.text);
      if (tokenError != null) {
        errorMessage.value = tokenError;
        return;
      }

      errorMessage.value = null;
      isLoading.value = true;

      try {
        // TODO: Implement token verification
        await Future.delayed(const Duration(seconds: 1)); // Simulate API call
        currentStep.value = ForgotPasswordStep.newPassword;
      } catch (e) {
        errorMessage.value = 'Invalid or expired token';
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> handleResetPassword() async {
      final passwordError = ValidationUtils.validatePassword(newPasswordController.text);
      final confirmError = ValidationUtils.validateConfirmPassword(
        confirmPasswordController.text,
        newPasswordController.text,
      );

      if (passwordError != null) {
        errorMessage.value = passwordError;
        return;
      }
      if (confirmError != null) {
        errorMessage.value = confirmError;
        return;
      }

      errorMessage.value = null;
      isLoading.value = true;

      try {
        // TODO: Implement password reset API call
        // await authNotifier.resetPassword(
        //   emailController.text.trim(),
        //   tokenController.text.trim(),
        //   newPasswordController.text,
        // );
        
        await Future.delayed(const Duration(seconds: 2)); // Simulate API call
        currentStep.value = ForgotPasswordStep.success;
      } catch (e) {
        errorMessage.value = 'Failed to reset password: ${e.toString()}';
      } finally {
        isLoading.value = false;
      }
    }

    Widget buildStepContent() {
      switch (currentStep.value) {
        case ForgotPasswordStep.email:
          return EmailStep(
            emailController: emailController,
            errorMessage: errorMessage,
            isLoading: isLoading,
            onSend: handleSendResetEmail,
          );
        case ForgotPasswordStep.verify:
          return VerifyStep(
            tokenController: tokenController,
            errorMessage: errorMessage,
            isLoading: isLoading,
            onVerify: handleVerifyToken,
            email: emailController.text,
          );
        case ForgotPasswordStep.newPassword:
          return NewPasswordStep(
            newPasswordController: newPasswordController,
            confirmPasswordController: confirmPasswordController,
            errorMessage: errorMessage,
            isLoading: isLoading,
            isObscured: isObscured,
            isConfirmObscured: isConfirmObscured,
            onReset: handleResetPassword,
          );
        case ForgotPasswordStep.success:
          return const SuccessStep();
      }
    }

    return AuthContainer(
      hasAppBar: true,
      child: buildStepContent(),
    );
  }
}
