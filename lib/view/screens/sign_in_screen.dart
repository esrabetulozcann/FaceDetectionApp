import 'package:cilt_takip_uygulamasi/models/user_sign_in_model.dart';
import 'package:cilt_takip_uygulamasi/viewmodel/sign_in_viewmodel.dart';
import 'package:flutter/material.dart';

import 'analysis_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _signInViewModel = SignInViewModel();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSignInTap() async {
    final isValid =
        _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    final signInModel = UserSignInModel(
      email: _emailController.text,
      password: _passwordController.text,
    );

    final result =
        await _signInViewModel.signInUser(signInModel);

    if (result == null) {
      // Başarısız giriş
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Giriş Başarısız"),
          content: const Text("Email veya şifre hatalı."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tamam"),
            ),
          ],
        ),
      );
      return;
    }

    // Başarılı giriş
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pop(); // dialog'u kapat
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          content: const Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Giriş başarılı..."),
            ],
          ),
        );
      },
    );

    // Analiz ekranına yönlendir
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (_) => const AnalysisScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C7D7E),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Hoş Geldiniz',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email boş bırakılamaz';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifre boş bırakılamaz';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Şifre',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onSignInTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor:
                          const Color(0xFF4C7D7E),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Giriş Yap',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hesabınız yok mu?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const SignUpScreen()),
                        );
                      },
                      child: const Text('Kayıt Ol'),
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
