import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/auth_text_field.dart';
import 'providers/auth_provider.dart';

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
  bool _keepLoggedIn = true;

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
    final start = index * 0.1;
    final end = start + 0.5;

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          start.clamp(0.0, 1.0),
          end.clamp(0.0, 1.0),
          curve: Curves.easeOut,
        ),
      ),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Interval(
                  start.clamp(0.0, 1.0),
                  end.clamp(0.0, 1.0),
                  curve: Curves.easeOut,
                ),
              ),
            ),
        child: child,
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(authProvider.notifier)
          .signInWithEmail(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await ref.read(authProvider.notifier).signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Google Sign-In failed: $e')));
      }
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
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send'),
          ),
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });

    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: theme.surface,
      body: Stack(
        children: [
          // Background Blurs
          Positioned(
            top: -100,
            right: -100,
            child: _BlurCircle(
              color: theme.primary.withValues(alpha: isDark ? 0.15 : 0.1),
              size: 400,
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: _BlurCircle(
              color: isDark
                  ? const Color(0xFF6366F1).withValues(alpha: 0.15)
                  : const Color(0xFF818CF8).withValues(alpha: 0.1),
              size: 350,
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: theme.spacingXL,
                  vertical: theme.spacingLG,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      _animateWidget(
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/logo.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.contain,
                          ),
                        ),
                        0,
                      ),
                      const SizedBox(height: 3),

                      // Welcome Text
                      _animateWidget(
                        Text(
                          'Taskmaster',
                          style: GoogleFonts.goldman(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.0,
                            color: theme.textPrimary,
                          ),
                        ),
                        1,
                      ),
                      SizedBox(height: theme.spacingMD),

                      // Form Container
                      _animateWidget(
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.surface.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color:
                                  theme.labelSmall.color?.withValues(
                                    alpha: 0.1,
                                  ) ??
                                  Colors.grey.withValues(alpha: 0.1),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back',
                                style: GoogleFonts.audiowide(
                                  fontSize: 28,
                                  color: theme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Please enter your details to continue',
                                style: theme.bodyMedium.copyWith(
                                  color: theme.bodyMedium.color?.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Divider(
                                color: theme.labelSmall.color?.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Email Field
                              AuthTextField(
                                label: 'Email Address',
                                hint: 'your@email.com',
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.email,
                                prefixIcon: Icon(
                                  Icons.alternate_email_rounded,
                                  size: 20,
                                  color: theme.primary,
                                ),
                              ),
                              SizedBox(height: theme.spacingLG),

                              // Password Field
                              AuthTextField(
                                label: 'Password',
                                hint: '••••••••',
                                controller: _passwordController,
                                obscureText: true,
                                validator: Validators.password,
                                prefixIcon: Icon(
                                  Icons.lock_person_outlined,
                                  size: 20,
                                  color: theme.primary,
                                ),
                              ),

                              // Options Row
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Checkbox(
                                            value: _keepLoggedIn,
                                            onChanged: (v) => setState(
                                              () => _keepLoggedIn = v ?? false,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            activeColor: theme.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Remember me',
                                          style: theme.labelSmall.copyWith(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: _resetPassword,
                                      child: Text(
                                        'Forgot Password?',
                                        style: theme.labelSmall.copyWith(
                                          color: theme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: theme.spacingXL),

                              // Login Button
                              GestureDetector(
                                onTap: isLoading ? null : _login,
                                child: Container(
                                  height: 56,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: theme.primaryGradient,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.primary.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          'Sign In',
                                          style: theme.titleMedium.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        2,
                      ),
                      SizedBox(height: theme.spacingXL),

                      // Divider
                      _animateWidget(
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: theme.labelSmall.color?.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'or continue with',
                                style: theme.labelSmall.copyWith(
                                  color: theme.labelSmall.color?.withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: theme.labelSmall.color?.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        7,
                      ),
                      SizedBox(height: theme.spacingXL),

                      // Google Login
                      _animateWidget(
                        OutlinedButton(
                          onPressed: isLoading ? null : _signInWithGoogle,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: BorderSide(
                              color:
                                  theme.labelSmall.color?.withValues(
                                    alpha: 0.1,
                                  ) ??
                                  Colors.grey,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.g_mobiledata, size: 32),
                              const SizedBox(width: 8),
                              const Text('Google Account'),
                            ],
                          ),
                        ),
                        8,
                      ),
                      SizedBox(height: theme.spacingXL),

                      // Footer
                      _animateWidget(
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: theme.labelSmall.copyWith(
                                color: theme.labelSmall.color?.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.go('/signup'),
                              child: Text(
                                'Create Free Account',
                                style: theme.labelSmall.copyWith(
                                  color: theme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        9,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  final Color color;
  final double size;

  const _BlurCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}
