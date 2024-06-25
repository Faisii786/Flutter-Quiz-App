import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowSnackBar {
  snackBarTop(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 2),
      colorText: Colors.white,
    );
  }
}
