import 'package:flutter/material.dart';
 feature/feed-and-search
import 'features/feed/presentation/pages/feed_page.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FeedPage(),
  ));
}

import 'post/screens/create_post_screen.dart'; // import หน้าฟอร์มโพสต์

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lost and Found',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // เปลี่ยนหน้าแรก (home) ให้เปิดไปที่หน้าสร้างโพสต์
      home: const CreatePostScreen(),
    );
  }
}
 main
