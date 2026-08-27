import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';

import '../../ForgetPassword/View/forget_password_view.dart';
import '../../MainPage/View/main_home_page.dart';
import '../BLoC/auth_event.dart';
import '../BLoC/auth_bloc.dart';
import '../BLoC/auth_state.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController(
    text: "Security",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "123",
  );

  final bool isDark = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: colors.scaffoldBackground,
          body: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.allLg,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: AppRadius.xlRadius,
                            boxShadow: [
                              BoxShadow(
                                color: colors.primary.withOpacity(0.25),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.business_outlined,
                            size: AppIconSizes.xl,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          right: -5,
                          bottom: -5,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: colors.scaffoldBackground,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: colors.primary,
                              child: Icon(
                                Icons.shield_outlined,
                                size: AppIconSizes.sm,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      "بوابة الأمن",
                      style: TextStyle(
                        fontSize: AppFontSizes.headingLarge,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "بوابة موظفي الأمن لعام 2026",
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    _buildLabel("البريد الإلكتروني أو الرقم الوظيفي", colors),
                    const SizedBox(height: AppSpacing.xs),
                    TextFormField(
                      controller: _usernameController,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: colors.textMain),
                      decoration: _inputDecoration(
                        colors,
                        "أدخل بريدك الإلكتروني...",
                        Icons.email_outlined,
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "الحقل مطلوب" : null,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildLabel("كلمة المرور", colors),
                    const SizedBox(height: AppSpacing.xs),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        bool isObscured = true;

                        if (state is AuthInitial) {
                          isObscured = state.isPasswordVisible;
                        }

                        return TextFormField(
                          controller: _passwordController,
                          obscureText: isObscured,
                          textAlign: TextAlign.right,
                          style: TextStyle(color: colors.textMain),
                          decoration: _inputDecoration(
                            colors,
                            "••••••••",
                            Icons.lock_outline,
                            prefixWidget: IconButton(
                              icon: Icon(
                                isObscured
                                    ? Icons.visibility_off_outlined
                                    : Icons.remove_red_eye_outlined,
                                color: colors.textSecondary,
                                size: AppIconSizes.md,
                              ),
                              onPressed: () => context.read<AuthBloc>().add(
                                TogglePasswordVisibility(),
                              ),
                            ),
                          ),
                          validator: (value) =>
                          value!.isEmpty ? "الحقل مطلوب" : null,
                        );
                      },
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordView(),
                            ),
                          );
                        },
                        child: Text(
                          "نسيت كلمة المرور؟",
                          style: TextStyle(
                            color: colors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.bodySmall,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainHomePage(user: state.user),
                            ),
                          );
                        } else if (state is AuthFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.errorMessage),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: colors.primary,
                            ),
                          );
                        }

                        return SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.mdRadius,
                              ),
                              elevation: 8,
                              shadowColor: colors.primary.withOpacity(0.4),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(
                                  LoginSubmitted(
                                    username: _usernameController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "تسجيل الدخول",
                              style: TextStyle(
                                fontSize: AppFontSizes.bodyLarge,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // التذييل والنصوص الحقوقية
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "نظام إدارة أمن المجمع السكني",
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: AppFontSizes.caption,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${DateTime.now().year} © All Rights Reserved AIVIO LTD",
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: AppFontSizes.caption,
                          ),
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
    );
  }

  Widget _buildLabel(String text, AppColors colors) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        style: TextStyle(
          color: colors.primary,
          fontSize: AppFontSizes.bodyMedium,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      AppColors colors,
      String hint,
      IconData icon, {
        Widget? prefixWidget,
      }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: colors.textSecondary.withOpacity(0.5),
        fontSize: AppFontSizes.bodyMedium,
      ),
      suffixIcon: Icon(icon, color: colors.textSecondary, size: AppIconSizes.md),
      prefixIcon: prefixWidget,
      filled: true,
      fillColor: colors.inputFill,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
      border: OutlineInputBorder(
        borderRadius: AppRadius.mdRadius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.mdRadius,
        borderSide: BorderSide(color: colors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.mdRadius,
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
    );
  }
}