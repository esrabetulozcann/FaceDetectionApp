import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../viewmodel/sign_up_viewmodel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedGender = "Kadın";

  final viewModel = SignUpViewModel();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Burada kayıt işlemini yapacağız
    print("Ad: ${_nameController.text}");
    print("Soyad: ${_surnameController.text}");
    print("Email: ${_emailController.text}");
    print("Telefon: ${_phoneController.text}");
    print("Şifre: ${_passwordController.text}");
    print("Cinsiyet: $_selectedGender");

    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        name: _nameController.text,
        surname: _surnameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        passwordHash: _passwordController.text,
        gender: _selectedGender,
      );

      final result = await viewModel.registerUser(user);

      if(!mounted) return;
      if(result == null){
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Sonuç"),
            content: Text('Bir hata oluştu'),
            actions: [
              TextButton(
                child: Text("Tamam"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );

        return;
      }

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Sonuç"),
          content: Text(result),
          actions: [
            TextButton(
              child: Text("Tamam"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      if(!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C7D7E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C7D7E),
        elevation: 0,
        title: const Text(
          'Kayıt Ol',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(_nameController, 'Ad'),
                const SizedBox(height: 12),
                _buildTextField(_surnameController, 'Soyad'),
                const SizedBox(height: 12),
                _buildTextField(_emailController, 'Email'),
                const SizedBox(height: 12),
                _buildTextField(_phoneController, 'Telefon'),
                const SizedBox(height: 12),
                _buildTextField(_passwordController, 'Şifre', isPassword: true),
                const SizedBox(height: 12),
                _buildGenderDropdown(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4C7D7E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Kayıt Ol'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool isPassword = false}) {
    return TextFormField(
      validator: (value){
        if(value == null) return "$hintText boş bırakılamaz";
        if(value.isEmpty) return "$hintText boş bırakılamaz";
        return null;
      },
      controller: controller,
      obscureText: isPassword,
      keyboardType: hintText == "Telefon" ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        value: _selectedGender,
        hint: const Text("Cinsiyet Seçin"),
        isExpanded: true,
        underline: const SizedBox(),
        items: [
          DropdownMenuItem(value: 'Erkek', child: Text('Erkek')),
          DropdownMenuItem(value: 'Kadın', child: Text('Kadın')),
        ],
        onChanged: (value) {
          if(value == null) return;
          setState(() {
            _selectedGender = value;
          });
        },
      ),
    );
  }
}
