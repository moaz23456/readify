import 'package:flutter/material.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/features/more/coming_soon_screen.dart';
import 'package:readify/features/more/favorite_screen.dart';
import 'package:readify/features/more/help_screen.dart';
import 'package:readify/features/more/profile_screen.dart';
import 'package:readify/features/more/recommendations_screen.dart';

void showMoreSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (sheetContext) {
      void open(Widget screen) {
        Navigator.pop(sheetContext);
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      }

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _MoreItem(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    onTap: () => open(const ProfileScreen()),
                  ),
                  _MoreItem(
                    icon: Icons.thumb_up_alt_outlined,
                    label: 'Top picks\nfor you',
                    onTap: () => open(const RecommendationsScreen()),
                  ),
                  _MoreItem(
                    icon: Icons.favorite_border,
                    label: 'Favorite',
                    onTap: () => open(const FavoriteScreen()),
                  ),
                ],
              ),
              Row(
                children: [
                  _MoreItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () =>
                        open(const ComingSoonScreen(title: 'Settings')),
                  ),
                  _MoreItem(
                    icon: Icons.photo_camera_outlined,
                    label: 'Scan books',
                    onTap: () =>
                        open(const ComingSoonScreen(title: 'Scan books')),
                  ),
                  _MoreItem(
                    icon: Icons.help_outline,
                    label: 'Help',
                    onTap: () => open(const HelpScreen()),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _MoreItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MoreItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: const BoxDecoration(
                  color: AppColors.chip,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: AppColors.primary),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}