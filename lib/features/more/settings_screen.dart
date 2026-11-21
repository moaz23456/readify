import 'package:flutter/material.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/features/more/account_settings_screen.dart';
import 'package:readify/features/more/profile_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
            child: Text(
              'Settings',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
          ),
          const Divider(height: 1),
          _SettingsTile(
            title: 'Account',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AccountSettingsScreen(),
              ),
            ),
          ),
          const Divider(height: 1),
          _SettingsTile(
            title: 'Profile',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ProfileSettingsScreen(),
              ),
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
      onTap: onTap,
    );
  }
}