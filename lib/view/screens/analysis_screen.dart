import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'result_screen.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({Key? key}) : super(key: key);

  @override
  State<AnalysisScreen> createState() =>
      _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  File? _image;
  List<String> _results = [];

  final ImagePicker _picker = ImagePicker();

  Future<bool> _checkPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final photosStatus = await Permission.photos.request();

    if (!cameraStatus.isGranted ||
        !photosStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Lütfen kamera ve galeri izinlerini verin",
          ),
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> _selectImage(ImageSource source) async {
    final isGrantedPermission = await _checkPermissions();
    if (!isGrantedPermission) return;

    final picked = await _picker.pickImage(source: source);

    if (picked != null) {
      setState(() {
        print(picked.path);
        _image = File(picked.path);
        _results = [];
      });

      // API simülasyonu
      await Future.delayed(const Duration(seconds: 2));
      final results = [
        'Sivilce',
        'Siyah Nokta'
      ]; // Gerçekte API'den gelecek

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            imageFile: File(picked.path),
            results: results,
          ),
        ),
      );
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Galeriden Seç'),
            onTap: () {
              Navigator.pop(context);
              _selectImage(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Kamerayla Çek'),
            onTap: () {
              Navigator.pop(context);
              _selectImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Cilt Analizi Yap",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Yüzünüzün fotoğrafını yükleyin veya çekin, analiz başlasın.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _showImageOptions,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : null,
                      child: _image == null
                          ? const Icon(Icons.camera_alt,
                              size: 40, color: Colors.grey)
                          : null,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_results.isNotEmpty) ...[
                    const Text(
                      "Tespit Edilen Problemler",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: _results
                          .map((r) => Chip(label: Text(r)))
                          .toList(),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
