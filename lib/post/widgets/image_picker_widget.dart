import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  // เปลี่ยน callback ให้ส่งเป็น Uint8List (Image Bytes) แทน File
  final Function(Uint8List?, String?) onImageSelected;

  const ImagePickerWidget({super.key, required this.onImageSelected});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        // อ่านข้อมูลรูปภาพเป็น Bytes เพื่อให้รองรับทั้ง Web และ Windows/Mobile
        final Uint8List bytes = await pickedFile.readAsBytes();
        
        setState(() {
          _imageBytes = bytes;
        });
        
        // ส่งทั้ง Bytes และ Path (หรือ Name) กลับไป
        widget.onImageSelected(_imageBytes, pickedFile.name);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showPickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('เลือกจากคลังภาพ'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('ถ่ายภาพ / เปิดกล้อง'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPickerBottomSheet,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[400]!),
        ),
        // ใช้ Image.memory แทน Image.file เพื่อให้แสดงผลบนคอมพิวเตอร์ได้แน่นอน
        child: _imageBytes != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  _imageBytes!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text('ไม่สามารถโหลดรูปภาพได้'),
                    );
                  },
                ),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('เพิ่มรูปภาพของหาย/ที่พบ', style: TextStyle(color: Colors.grey)),
                ],
              ),
      ),
    );
  }
}