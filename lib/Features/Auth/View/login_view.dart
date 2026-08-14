import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:security_app/Features/MainPage/View/main_home_page.dart';

import '../../../Core/Colors/app_colors.dart';
import '../../../Core/UIConstants/aivio_border_radius.dart';
import '../../../Core/UIConstants/aivio_font_sizes.dart';
import '../../../Core/UIConstants/aivio_icon_sizes.dart';
import '../../../Core/UIConstants/aivio_spacing.dart';
import '../BLoC/auth_bloc.dart';
import '../BLoC/auth_event.dart';
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colors.scaffoldBackground,
        body: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.allLg,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: AppSpacing.allMd,
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    borderRadius: AppRadius.xlRadius,
                  ),
                  child: Icon(
                    Icons.shield_outlined,
                    size: AppIconSizes.xl,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  "بوابة الأمن",
                  style: TextStyle(
                    fontSize: AppFontSizes.headingLarge,
                    fontWeight: FontWeight.bold,
                    color: colors.textMain,
                  ),
                ),
                const Text(
                  "بوابة موظفي الأمن لعام 2026",
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: Colors.grey,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: AppRadius.xlRadius,
                    border: Border(
                      top: BorderSide(color: colors.primary, width: 5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: AppSpacing.allLg,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("رقم الموظف", colors),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _usernameController,
                          style: TextStyle(color: colors.textMain),
                          decoration: _inputDecoration(
                            colors,
                            "أدخل رقمك الوظيفي...",
                            Icons.person_outline,
                          ),
                          validator: (value) =>
                          value!.isEmpty ? "يرجى إدخال الرقم" : null,
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        _buildLabel("كلمة المرور", colors),
                        const SizedBox(height: AppSpacing.xs),

                        BlocBuilder<AuthBloc, AuthState>(
                          buildWhen: (previous, current) =>
                          current is AuthInitial,
                          builder: (context, state) {
                            bool isObscured = true;
                            if (state is AuthInitial) {
                              isObscured = state.isPasswordVisible;
                            }

                            return TextFormField(
                              controller: _passwordController,
                              obscureText: isObscured,
                              style: TextStyle(color: colors.textMain),
                              decoration: _inputDecoration(
                                colors,
                                "••••••••",
                                Icons.lock_outline,
                                suffixWidget: IconButton(
                                  icon: Icon(
                                    isObscured
                                        ? Icons.visibility_off_outlined
                                        : Icons.remove_red_eye_outlined,
                                    color: colors.textSecondary,
                                    size: AppIconSizes.md,
                                  ),
                                  onPressed: () {
                                    context.read<AuthBloc>().add(
                                      TogglePasswordVisibility(),
                                    );
                                  },
                                ),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? "يرجى إدخال كلمة المرور"
                                  : null,
                            );
                          },
                        ),

                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          "هل نسيت كلمة المرور؟",
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: AppFontSizes.bodySmall,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is AuthSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "مرحباً بك: ${state.user.name}",
                                  ),
                                ),
                              );
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
                                  foregroundColor: isDark
                                      ? Colors.black
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.mdRadius,
                                  ),
                                  elevation: 0,
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
                                    color: colors.scaffoldBackground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  "نظام إدارة أمن المجمع السكني",
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: AppFontSizes.caption,
                  ),
                ),
                Text(
                  "${DateTime.now().year} © All Rights Reserved AIVIO LTD",
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: AppFontSizes.caption,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, AppColors colors) {
    return Text(
      text,
      style: TextStyle(
        color: colors.textMain,
        fontSize: AppFontSizes.bodyMedium,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _inputDecoration(
      AppColors colors,
      String hint,
      IconData icon, {
        Widget? suffixWidget,
      }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: colors.textSecondary.withOpacity(0.5),
        fontSize: AppFontSizes.bodyMedium,
      ),
      prefixIcon: Icon(icon, color: colors.textSecondary, size: AppIconSizes.md),
      suffixIcon: suffixWidget,
      filled: true,
      fillColor: colors.inputFill,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
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