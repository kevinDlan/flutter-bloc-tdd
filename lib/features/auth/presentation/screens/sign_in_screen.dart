import 'package:education_app/core/common/extensions/context_extension.dart';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/common/widgets/rounded_button.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/themes/app_font.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:education_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:education_app/features/auth/presentation/widgets/sign_in_form_widget.dart';
import 'package:education_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) {
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedIn) {
            context.userProvider.initUser(state.user);
            Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
          }
        },
        builder: (context, state) {
          return GradientBackground(
            image: MediaRes.authGradientBackground,
            child: SafeArea(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const Text(
                      'Easy to learn, discovery more skill',
                      style: TextStyle(
                        fontFamily: AppFont.aeonik,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sign in to your account',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Baseline(
                          baseline: 100,
                          baselineType: TextBaseline.alphabetic,
                          child: TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              SignUpScreen.routeName,
                            ),
                            child: const Text('Register account'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SignInFormWidget(
                      formKey: formKey,
                      emailController: emailController,
                      passwordController: passwordController,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          ForgotPasswordScreen.routeName,
                        ),
                        child: const Text('Forgot password?'),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (state is AuthLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      RoundedButton(
                        label: 'Sign In',
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          FirebaseAuth.instance.currentUser?.reload();
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  SignInEvent(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
