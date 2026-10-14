import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/theme.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/check_email_availability_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final CheckEmailAvailabilityUseCase _checkEmailAvailabilityUseCase;
  late final SignUpUseCase _signUpUseCase;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    final authRepository =
        AuthRepositoryImpl(AuthRemoteDataSourceImpl(ApiClient()));
    _checkEmailAvailabilityUseCase =
        CheckEmailAvailabilityUseCase(authRepository);
    _signUpUseCase = SignUpUseCase(authRepository);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.person_add, size: 80, color: AppTheme.primary),
                const SizedBox(height: 32),
                Text(
                  'Create Account',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign up to get started',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  controller: nameController,
                  hintText: 'Full Name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email Address',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                      return 'Password must contain only letters and numbers';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                PrimaryButton(
                  text: 'Sign Up',
                  isLoading: _isLoading,
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _isLoading = true;
                      });

                      final email = emailController.text.trim();
                      final isRegisteredResult =
                          await _checkEmailAvailabilityUseCase(email);

                      bool isAlreadyRegistered = false;
                      isRegisteredResult.fold(
                        (failure) {},
                        (registered) => isAlreadyRegistered = registered,
                      );

                      if (isAlreadyRegistered) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'This account is already in use. Please enter another account.',
                            ),
                            backgroundColor: AppTheme.error,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      }

                      final signUpResult = await _signUpUseCase(
                        name: nameController.text.trim(),
                        email: email,
                        password: passwordController.text.trim(),
                      );

                      if (!context.mounted) return;

                      signUpResult.fold(
                        (failure) {
                          String errorMessage = failure.failureMessage;
                          if (errorMessage.toLowerCase().contains('email') &&
                              (errorMessage.toLowerCase().contains('unique') ||
                                  errorMessage.toLowerCase().contains('already') ||
                                  errorMessage.toLowerCase().contains('exist'))) {
                            errorMessage =
                                'This account is already in use. Please enter another account.';
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(errorMessage),
                              backgroundColor: AppTheme.error,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        (user) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Account created successfully! Please login.'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                      );

                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                            ) =>
                                const LoginScreen(),
                            transitionsBuilder: (
                              context,
                              animation,
                              secondaryAnimation,
                              child,
                            ) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
