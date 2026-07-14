import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../features/auth/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load remembered credentials
      final notifier = ref.read(authControllerProvider.notifier);
      _rememberMe = notifier.getRememberMe();
      if (_rememberMe) {
        _emailController.text = notifier.getRememberedEmail();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authControllerProvider.notifier).login(
      _emailController.text,
      _passwordController.text,
      _rememberMe,
    );

    if (success && mounted) {
      context.go('/dashboard');
    }
  }

  void _quickFill(String email, String password) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppConstants.backgroundDark : AppConstants.backgroundLight,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(
                  color: isDark ? AppConstants.borderDark : AppConstants.borderLight,
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Branding Logo
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.fingerprint_rounded,
                            color: AppConstants.primaryColor,
                            size: 48,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Heading Text
                      const Center(
                        child: Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Sign in to Smart HR System',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppConstants.textSecondaryDark : AppConstants.textSecondaryLight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email input
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'name@company.com',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter email';
                          }
                          final emailReg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailReg.hasMatch(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password input
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Remember Me Toggles
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: AppConstants.primaryColor,
                              onChanged: (val) {
                                setState(() {
                                  _rememberMe = val ?? false;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Remember me',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Error message if any
                      if (authState.errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppConstants.dangerColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: AppConstants.dangerColor),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  authState.errorMessage!,
                                  style: const TextStyle(color: AppConstants.dangerColor, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Login Button
                      ElevatedButton(
                        onPressed: authState.isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 52),
                        ),
                        child: authState.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Sign In', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 32),

                      // Quick Mock Logins
                      const Divider(),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          'QUICK EVALUATION LOGIN CODES',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: isDark ? AppConstants.textSecondaryDark : AppConstants.textSecondaryLight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildQuickFillChip(
                            label: 'Admin',
                            color: AppConstants.primaryColor,
                            onTap: () => _quickFill('admin@company.com', 'Password123'),
                          ),
                          _buildQuickFillChip(
                            label: 'HR',
                            color: AppConstants.warningColor,
                            onTap: () => _quickFill('hr@company.com', 'Password123'),
                          ),
                          _buildQuickFillChip(
                            label: 'Employee',
                            color: AppConstants.accentColor,
                            onTap: () => _quickFill('employee@company.com', 'Password123'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickFillChip({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
