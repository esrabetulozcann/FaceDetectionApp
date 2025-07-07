import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'view/screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions(); // izinleri burada iste
  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  await [
    Permission.camera,
    Permission.photos,
  ].request();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cilt Takip Uygulaması',
      theme: ThemeData(
        fontFamily: 'Roboto',
      ),
      home: const SignInScreen(),
    );
  }
}
