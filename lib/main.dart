import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String? nickname;

  UserProfile({required this.name, this.nickname});
}

void main() => runApp(const MaterialApp(home: NicknameDemo()));

class NicknameDemo extends StatelessWidget {
  const NicknameDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final user1 = UserProfile(name: "Hiền Trang", nickname: "crush");
    final user2 = UserProfile(name: "Trình Văn Đận");

    return Scaffold(
      appBar: AppBar(title: const Text("User & Nickname Demo")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("DANH SÁCH NGƯỜI DÙNG:", style: TextStyle(fontWeight: FontWeight.bold)),
            const Divider(),


            _buildUserTile(user1),

            const SizedBox(height: 20),


            _buildUserTile(user2),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTile(UserProfile user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Họ tên: ${user.name}", style: const TextStyle(fontSize: 18)),


        Text(
          "Biệt danh: ${user.nickname ?? "Chưa đặt biệt danh"}",
          style: TextStyle(
              fontSize: 16,
              color: user.nickname == null ? Colors.grey : Colors.blue
          ),
        ),
      ],
    );
  }
}