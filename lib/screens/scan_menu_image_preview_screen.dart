import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/scan_menu_view_model.dart';
import 'scan_menu_screen.dart';

class ScanMenuImagePreviewScreen extends ConsumerWidget {
  const ScanMenuImagePreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanState = ref.watch(scanMenuProvider);
    final viewModel = ref.read(scanMenuProvider.notifier);

    if (scanState.imageFile == null) return const SizedBox();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          // Disable back button during loading to prevent state issues
          onPressed: scanState.isLoading ? null : () => Navigator.pop(context),
        ),
        title: const Text("Preview Menu", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          /// Main Preview Area
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(scanState.imageFile!, width: 300, height: 400, fit: BoxFit.cover),
                  ),
                  SizedBox(width: 320, height: 420, child: CustomPaint(painter: FramePainter())),
                ],
              ),
            ),
          ),

          /// Bottom row containing Crop and Submit buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              children: [
                // Crop Button (Disabled during loading)
                Expanded(
                  child: _buildFooterButton(
                    label: "Crop",
                    icon: Icons.crop,
                    isPrimary: false,
                    onPressed: scanState.isLoading ? null : () => viewModel.cropImage(),
                  ),
                ),
                const SizedBox(width: 15),

                // Submit Button with internal loader
                Expanded(
                  child: _buildFooterButton(
                    label: "Submit",
                    icon: Icons.check_circle_outline,
                    isPrimary: true,
                    isLoading: scanState.isLoading, // Pass loading state here
                    onPressed: scanState.isLoading ? null : () async {
                      final success = await viewModel.submitMenuData();
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Menu processed successfully!")),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Refactored Helper Button to show CircularProgressIndicator when isLoading is true
  Widget _buildFooterButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    bool isLoading = false, // Default is false
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFFEF444C) : const Color(0xFFFFF1F2),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2.5,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isPrimary ? Colors.white : const Color(0xFFEF444C)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : const Color(0xFFEF444C),
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}