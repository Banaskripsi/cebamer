import 'package:cebamer/tema/teks_tema.dart';
import 'package:cebamer/tema/warna.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Notifikasi{

  Notifikasi();

  void notif({required String text, String subTitle = '', IconData icon = Icons.info, Color warna = Colors.black}) {
    final BuildContext? currentContext = Get.context;

    if (currentContext != null) {
      try {
        DelightToastBar(
          autoDismiss: true,
          position: DelightSnackbarPosition.top,
          builder: (context) {
            return ToastCard(
              leading: Icon(icon, color: warna),
              title: Text(
                text,
                style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: warna),
              ),
              subtitle: Text(
                subTitle,
                style: BanaTemaTeks.temaCerah.bodyMedium!.copyWith(color: primer3)
              ),
            );
          },
        ).show(currentContext);
      } catch (e) {
        Get.snackbar(
          "Error Notifikasi",
          text,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade300,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Info (Context Null)",
        text,
        snackPosition: SnackPosition.TOP,
      );
    }
  }
}

class DialogGlobal {
  DialogGlobal();

  Future<void> tampilkan({
    required String title,
    required String message,
    String confirmText = 'OK',
    String? cancelText,
    IconData icon = Icons.info_outline,
    Color iconColor = Colors.blue,
    bool barrierDismissible = true,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    final context = Get.context;

    if (context == null) {
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: BanaTemaTeks.temaCerah.displayLarge!.copyWith(color: primer3),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: BanaTemaTeks.temaCerah.bodyMedium!.copyWith(color: primer3),
        ),
        actions: [
          if (cancelText != null)
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: salahInd
              ),
              onPressed: () {
                Get.back();
                if (onCancel != null) onCancel();
              },
              child: Text(
                cancelText,
                style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: warnaCerah3)
              ),
            ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: primer1
              ),
            onPressed: () {
              Get.back();
              if (onConfirm != null) onConfirm();
              
            },
            child: Text(
              confirmText,
              style: BanaTemaTeks.temaCerah.bodyLarge!.copyWith(color: warnaCerah3)
            ),
          ),
        ],
      ),
    );
  }
}