import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'scan_menu_image_preview_screen.dart';
import '../provider/scan_menu_view_model.dart';

class ScanMenuScreen extends ConsumerWidget {
  const ScanMenuScreen({super.key});

  /// Helper function to handle image selection and navigation
  Future<void> _handleImageSelection(BuildContext context, WidgetRef ref, ImageSource source) async {
    final File? file = await ref.read(scanMenuProvider.notifier).pickImage(source);

    if (file != null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ScanMenuImagePreviewScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            ref.read(scanMenuProvider.notifier).resetState();
            Navigator.pop(context);
          },
        ),
        title: const Text("Scan Menu", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text("• Align the menu within the frame", style: TextStyle(color: Colors.grey, fontSize: 14)),

          Expanded(
            child: Center(
              child: SizedBox(
                width: 280, height: 380,
                child: CustomPaint(painter: FramePainter()),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                _buildActionButton(
                  label: "Upload Photo",
                  icon: Icons.file_upload_outlined,
                  color: const Color(0xFFEF444C),
                  textColor: Colors.white,
                  onPressed: () => _handleImageSelection(context, ref, ImageSource.gallery),
                ),
                const SizedBox(height: 15),
                _buildActionButton(
                  label: "Take Photo",
                  icon: Icons.camera_alt_outlined,
                  color: const Color(0xFFFFF1F2),
                  textColor: const Color(0xFFEF444C),
                  onPressed: () => _handleImageSelection(context, ref, ImageSource.camera),
                ),
                const SizedBox(height: 20),
                const Text("• JPG, PNG or PDF. Max 10MB", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable button builder for the UI
  Widget _buildActionButton({required String label, required IconData icon, required Color color, required Color textColor, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: textColor),
        label: Text(label, style: TextStyle(color: textColor, fontSize: 18)),
      ),
    );
  }
}

/// Custom painter to draw the pink scanner corners
class FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFB2BC)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double corner = 40;
    canvas.drawPath(Path()..moveTo(0, corner)..lineTo(0, 0)..lineTo(corner, 0), paint);
    canvas.drawPath(Path()..moveTo(size.width - corner, 0)..lineTo(size.width, 0)..lineTo(size.width, corner), paint);
    canvas.drawPath(Path()..moveTo(0, size.height - corner)..lineTo(0, size.height)..lineTo(corner, size.height), paint);
    canvas.drawPath(Path()..moveTo(size.width - corner, size.height)..lineTo(size.width, size.height)..lineTo(size.width, size.height - corner), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}