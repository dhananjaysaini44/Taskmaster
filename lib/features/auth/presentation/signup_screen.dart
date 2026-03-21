import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/auth_text_field.dart';
import '../presentation/auth_provider.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Widget _animateWidget(Widget child, int index) {
    final start = index * 0.08;
    final end = start + 0.4;

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
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
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

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      await ref
          .read(authProvider.notifier)
          .signUpWithEmail(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            _nameController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).appTheme;

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
      backgroundColor: theme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(theme.spacingLG),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _animateWidget(
                    Icon(
                      Icons.person_add_rounded,
                      size: 64,
                      color: theme.primary,
                    ),
                    0,
                  ),
                  SizedBox(height: theme.spacingLG),
                  _animateWidget(
                    Text(
                      'Create Account',
                      style: theme.displayLarge.copyWith(fontSize: 32),
                      textAlign: TextAlign.center,
                    ),
                    1,
                  ),
                  _animateWidget(
                    Text(
                      'Start managing your life today',
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
                      label: 'Full Name',
                      hint: 'John Doe',
                      controller: _nameController,
                      validator: Validators.name,
                      prefixIcon: Icon(
                        Icons.person_outline,
                        size: 20,
                        color: theme.primary,
                      ),
                    ),
                    3,
                  ),
                  SizedBox(height: theme.spacingMD),
                  _animateWidget(
                    AuthTextField(
                      label: 'Email',
                      hint: 'name@example.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: theme.primary,
                      ),
                    ),
                    4,
                  ),
                  SizedBox(height: theme.spacingMD),
                  _animateWidget(
                    AuthTextField(
                      label: 'Password',
                      hint: '••••••••',
                      controller: _passwordController,
                      obscureText: true,
                      validator: Validators.password,
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                        color: theme.primary,
                      ),
                    ),
                    5,
                  ),
                  SizedBox(height: theme.spacingMD),
                  _animateWidget(
                    AuthTextField(
                      label: 'Confirm Password',
                      hint: '••••••••',
                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: (val) => Validators.confirmPassword(
                        _passwordController.text,
                        val,
                      ),
                      prefixIcon: Icon(
                        Icons.lock_clock_outlined,
                        size: 20,
                        color: theme.primary,
                      ),
                    ),
                    6,
                  ),
                  SizedBox(height: theme.spacingLG),
                  _animateWidget(
                    ElevatedButton(
                      onPressed: isLoading ? null : _signUp,
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
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Create Account'),
                    ),
                    7,
                  ),
                  SizedBox(height: theme.spacingMD),
                  _animateWidget(
                    OutlinedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => ref
                                .read(authProvider.notifier)
                                .signInWithGoogle(),
                      icon: const Icon(Icons.g_mobiledata, size: 32),
                      label: const Text('Continue with Google'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(theme.spacingMD),
                        side: BorderSide(
                          color:
                              theme.labelSmall.color?.withValues(alpha: 0.1) ??
                              Colors.grey,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(theme.radiusMD),
                        ),
                      ),
                    ),
                    8,
                  ),
                  SizedBox(height: theme.spacingXL),
                  _animateWidget(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: theme.labelSmall.copyWith(
                            color: theme.labelSmall.color?.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: Text(
                            'Sign In',
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
    );
  }
}
