import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/auth_text_field.dart';
import '../presentation/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _animateWidget(Widget child, int index) {
    final start = index * 0.08;
    final end = start + 0.4;
    
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.easeOut),
      ),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0), curve: Curves.easeOut),
        )),
        child: child,
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref.read(authProvider.notifier).signInWithEmail(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email first')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Text('Send password reset email to $email?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Send')),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(authProvider.notifier).resetPassword(email);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password reset email sent')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;
    
    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        },
      );
    });

    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              Theme.of(context).brightness == Brightness.dark
                  ? 'assets/splash_bg_dark.png'
                  : 'assets/splash_bg_light.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(theme.spacingLG),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _animateWidget(
                    Center(
                      child: Image.asset(
                        'assets/logo.png',
                        height: 80,
                        width: 80,
                      ),
                    ),
                    0,
                  ),
                  SizedBox(height: theme.spacingLG),
                  _animateWidget(
                    Text(
                      'Welcome Back',
                      style: theme.displayLarge.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    1,
                  ),
                  _animateWidget(
                    Text(
                      'Sign in to manage your life',
                      style: theme.titleMedium.copyWith(
                        color: theme.titleMedium.color?.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    2,
                  ),
                  SizedBox(height: theme.spacingXL),
                  _animateWidget(
                    AuthTextField(
                      label: 'Email',
                      hint: 'name@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                      prefixIcon: Icon(Icons.email_outlined, size: 20, color: theme.primary),
                    ),
                    3,
                  ),
                  SizedBox(height: theme.spacingMD),
                  _animateWidget(
                    AuthTextField(
                      label: 'Password',
                      hint: '••••••••',
                      controller: _passwordController,
                      obscureText: true,
                      validator: Validators.password,
                      prefixIcon: Icon(Icons.lock_outline_rounded, size: 20, color: theme.primary),
                    ),
                    4,
                  ),
                  _animateWidget(
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _resetPassword,
                        child: Text(
                          'Forgot Password?',
                          style: theme.labelSmall.copyWith(color: theme.primary),
                        ),
                      ),
                    ),
                    5,
                  ),
                  SizedBox(height: theme.spacingLG),
                  _animateWidget(
                    ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        foregroundColor: theme.surface,
                        padding: EdgeInsets.all(theme.spacingMD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(theme.radiusMD),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Sign In'),
                    ),
                    6,
                  ),
                  SizedBox(height: theme.spacingMD),
                  _animateWidget(
                    OutlinedButton.icon(
                      onPressed: isLoading ? null : () => ref.read(authProvider.notifier).signInWithGoogle(),
                      icon: const Icon(Icons.g_mobiledata, size: 32),
                      label: const Text('Continue with Google'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(theme.spacingMD),
                        side: BorderSide(color: theme.labelSmall.color?.withValues(alpha: 0.1) ?? Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(theme.radiusMD),
                        ),
                      ),
                    ),
                    7,
                  ),
                  SizedBox(height: theme.spacingXL),
                  _animateWidget(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: theme.labelSmall.copyWith(
                            color: theme.labelSmall.color?.withValues(alpha: 0.6),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/signup'),
                          child: Text(
                            'Sign Up',
                            style: theme.labelSmall.copyWith(
                              color: theme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    8,
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }
}
