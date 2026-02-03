import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  DateTime? _dob;

  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final String? email = FirebaseAuth.instance.currentUser!.email;
  final String? photoUrl = FirebaseAuth.instance.currentUser!.photoURL;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _nameController.text = data['name'] ?? '';
      _emailController.text = email ?? '';

      if (data['dob'] != null) {
        _dob = (data['dob'] as Timestamp).toDate();
        _dobController.text = _formatDate(_dob!);
      }
      setState(() {});
    }
  }

  Future<void> _saveProfile() async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': _nameController.text,
      'dob': _dob != null ? Timestamp.fromDate(_dob!) : null,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu thông tin')),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage:
              photoUrl != null ? NetworkImage(photoUrl!) : null,
              child:
              photoUrl == null ? const Icon(Icons.person, size: 50) : null,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dob ?? DateTime(2000),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    _dob = picked;
                    _dobController.text = _formatDate(picked);
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: _dobController,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
