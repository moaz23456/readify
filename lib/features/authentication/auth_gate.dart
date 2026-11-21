import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/main.dart';
import '../main_layout/main_layout_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("error: ${snapshot.error}"),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const CustomAuthScreen();
        }

        return  MainLayoutScreen();
      },
    );
  }
}

class CustomAuthScreen extends StatefulWidget {
  const CustomAuthScreen({super.key});

  @override
  State<CustomAuthScreen> createState() => _CustomAuthScreenState();
}

class _CustomAuthScreenState extends State<CustomAuthScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isSignIn = true;
  bool rememberMe = false;
  bool obscurePassword = true;
  bool isLoading = false;

  Future<void> authenticate() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      if (isSignIn) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('Signed in successfully!'),
          ),
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Something went wrong'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Please enter your email first'),
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      scaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent successfully!'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Something went wrong'),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 170,
                      height: 170,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    isSignIn
                        ? "welcome back! please sign in to continue"
                        : "welcome! please sign up to continue",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 30),

                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
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

                  TextFormField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  if (isSignIn)
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                          fillColor:
                          WidgetStateProperty.resolveWith<Color>(
                                (states) {
                              if (states.contains(WidgetState.selected)) {
                                return AppColors.primary;
                              }
                              return Colors.white;
                            },
                          ),
                          checkColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),

                        const Expanded(
                          child: Text(
                            'Remember Me',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),

                        TextButton(
                          onPressed: resetPassword,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: isLoading ? null : authenticate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text(
                      isSignIn ? 'Sign In' : 'Sign Up',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSignIn = !isSignIn;
                      });
                    },
                    child: Text(
                      isSignIn
                          ? "Don't have an account? Sign Up"
                          : "Already have an account? Sign In",
                      style: TextStyle(
                        color: AppColors.primary,
                      ),
                    ),
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