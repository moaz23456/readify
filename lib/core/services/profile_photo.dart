import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhoto {
  ProfilePhoto._();
  static final ProfilePhoto instance = ProfilePhoto._();

  final ValueNotifier<File?> photo = ValueNotifier<File?>(null);

  final ImagePicker _picker = ImagePicker();

  /// يفتح المعرض ويحفظ الصورة المختارة.
  /// TODO(API): لما الباك إند يجهز نرفعها على POST /api/v1/Users/me/profile-image
  Future<void> pickFromGallery() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 85,
    );
    if (picked == null) return;
    photo.value = File(picked.path);
  }
}