import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class SignUpViewModel {
  Future<String?> registerUser(UserModel user) async {
    try {
      final url = Uri.parse('http://10.0.2.2:5120/api/User/Add');

      // 🔍 Giden veriyi görmek için:
      print("API'ye istek gönderiliyor...");
      print("JSON: ${jsonEncode(user.toJson())}");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      // 📥 Gelen cevabı görmek için:
      print("Status code: ${response.statusCode}");
      print("Gelen yanıt: ${response.body}");

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Bir hata oluştu: ${response.body}');
        return null;
      }
    } catch (e) {
      print("Hata: $e");
      return null;
    }
  }
}
