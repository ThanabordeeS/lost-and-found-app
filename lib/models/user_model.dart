class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
  });

  // แปลงจาก Map (เช่น ดึงมาจาก Database/Firebase) มาเป็น Object
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profileImage: map['profileImage'],
    );
  }

  // แปลงจาก Object เป็น Map เพื่อบันทึกลง Database
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
    };
  }
}