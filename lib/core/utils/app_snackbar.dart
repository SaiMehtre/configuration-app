import 'package:flutter/material.dart';

class AppSnackbar {
  static void success(
    BuildContext context,
    String message,
  ) {
    _showSnackbar(
      context,
      message,
      Colors.greenAccent,
      Icons.check_circle,
    );
  }

  static void error(
    BuildContext context,
    String message,
  ) {
    _showSnackbar(
      context,
      message,
      Colors.redAccent,
      Icons.error,
    );
  }

  static void warning(
    BuildContext context,
    String message,
  ) {
    _showSnackbar(
      context,
      message,
      Colors.orangeAccent,
      Icons.warning,
    );
  }

  static void _showSnackbar(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,

        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        content: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),

            gradient: LinearGradient(
              colors: [
                const Color(0xFF1E293B),
                const Color(0xFF111827),
              ],
            ),

            border: Border.all(
              color: color.withOpacity(0.5),
            ),

            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.25),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),

          child: Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 28,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),

        duration: const Duration(seconds: 2),
      ),
    );
  }
}