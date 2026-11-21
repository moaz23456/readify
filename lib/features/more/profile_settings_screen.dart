import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readify/core/services/profile_photo.dart';
import 'package:readify/core/theme/app_color.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late String _displayName;
  String _gender = '';
  String _birthday = '';
  String _country = '';

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';
    final name = user?.displayName ?? '';
    _displayName = name.isNotEmpty
        ? name
        : (email.contains('@') ? email.split('@').first : 'Reader');
  }

  Future<String?> _askText(String title, String initial) {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _editName() async {
    final value = await _askText('Display Name', _displayName);
    if (value == null || value.isEmpty) return;
    try {
      await FirebaseAuth.instance.currentUser?.updateDisplayName(value);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save the name')),
      );
      return;
    }
    if (!mounted) return;
    setState(() => _displayName = value);
  }

  Future<void> _editCountry() async {
    final value = await _askText('Country', _country);
    if (value == null) return;
    setState(() => _country = value);
  }

  Future<void> _editGender() async {
    final value = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Gender'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'Male'),
            child: const Text('Male', style: TextStyle(fontSize: 17)),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, 'Female'),
            child: const Text('Female', style: TextStyle(fontSize: 17)),
          ),
        ],
      ),
    );
    if (value == null) return;
    setState(() => _gender = value);
  }

  Future<void> _editBirthday() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    final d = picked.day.toString().padLeft(2, '0');
    final m = picked.month.toString().padLeft(2, '0');
    setState(() => _birthday = '$d/$m/${picked.year}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'settings',
                  style: TextStyle(fontSize: 14, color: AppColors.primary),
                ),
                Text(
                  'Profile',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 20),
          Center(
            child: ValueListenableBuilder<File?>(
              valueListenable: ProfilePhoto.instance.photo,
              builder: (_, file, __) {
                return CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.chip,
                  backgroundImage: file != null ? FileImage(file) : null,
                  child: file == null
                      ? const Icon(
                    Icons.person,
                    size: 55,
                    color: AppColors.primary,
                  )
                      : null,
                );
              },
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => ProfilePhoto.instance.pickFromGallery(),
              child: const Text(
                'Change photo',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const Divider(height: 1),
          _Row(label: 'Display Name', value: _displayName, onEdit: _editName),
          const Divider(height: 1),
          _Row(label: 'Gender', value: _gender, onEdit: _editGender),
          const Divider(height: 1),
          _Row(label: 'Birthday', value: _birthday, onEdit: _editBirthday),
          const Divider(height: 1),
          _Row(label: 'Country', value: _country, onEdit: _editCountry),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onEdit;

  const _Row({
    required this.label,
    required this.value,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? 'Not set' : value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onEdit, child: const Text('Edit')),
        ],
      ),
    );
  }
}