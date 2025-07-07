import 'dart:convert';

import 'package:cilt_takip_uygulamasi/models/user_sign_in_model.dart';

import '../models/user_model.dart';

class SignInViewModel {
  Future<UserModel?> signInUser(
      UserSignInModel user) async {
    try {
      final url = Uri.tryParse(
          'http://10.0.2.2:5120/api/User/Login');

      if (url == null) return null;

      // 🔍 Giden veriyi görmek için:
      print("API'ye istek gönderiliyor...");
      print("JSON: ${jsonEncode(user.toJson())}");
      return UserModel.dummyUser;
      // final response = await http.post(
      //   url,
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode(user.toJson()),
      // );

      // // 📥 Gelen cevabı görmek için:
      // print("Status code: ${response.statusCode}");
      // print("Gelen yanıt: ${response.body}");

      // if (response.statusCode == 200) {
      //   final jsonData = jsonDecode(response.body);
      //   return UserModel.fromJson(jsonData);
      // } else {
      //   print('Bir hata oluştu: ${response.body}');
      //   return null;
      // }
    } catch (e) {
      print("Hata: $e");
      return null;
    }
  }
}
