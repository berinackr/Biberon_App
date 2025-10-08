import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error, warning }

class Toast {
  static void showToast(BuildContext context, String message, ToastType type) {
    final fToast = FToast()..init(context);

    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: type == ToastType.success
            ? Colors.green
            : type == ToastType.error
                ? Colors.red
                : Colors.orange,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ToastType.success == type
                ? Icons.check
                : ToastType.error == type
                    ? Icons.error
                    : Icons.warning,
          ),
          const SizedBox(
            width: 12,
          ),
          Flexible(child: Text(message)),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
