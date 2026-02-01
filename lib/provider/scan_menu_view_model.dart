import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// State class to hold the image file and loading status
class ScanMenuState {
  final File? imageFile;
  final bool isLoading;

  ScanMenuState({this.imageFile, this.isLoading = false});

  ScanMenuState copyWith({File? imageFile, bool? isLoading}) {
    return ScanMenuState(
      imageFile: imageFile ?? this.imageFile,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Provider definition
final scanMenuProvider = StateNotifierProvider<ScanMenuViewModel, ScanMenuState>((ref) {
  return ScanMenuViewModel();
});

class ScanMenuViewModel extends StateNotifier<ScanMenuState> {
  ScanMenuViewModel() : super(ScanMenuState());

  final ImagePicker _picker = ImagePicker();

  /// Resets the state to clear the image and stop loading indicators
  void resetState() {
    state = ScanMenuState();
  }

  /// Opens the Gallery or Camera to select an image
  Future<File?> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      // Verify if the provider is still active before updating state
      if (!mounted) return null;

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        state = state.copyWith(imageFile: file);
        return file;
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
    return null;
  }

  /// Opens the cropping UI to let the user adjust the image area
  Future<void> cropImage() async {
    if (state.imageFile == null || !mounted) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: state.imageFile!.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          statusBarColor: Colors.white,
          activeControlsWidgetColor: const Color(0xFFEF444C),
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    if (croppedFile != null && mounted) {
      state = state.copyWith(imageFile: File(croppedFile.path));
    }
  }

  /// Extracts text from the image using ML Kit and simulates a database upload
  Future<bool> submitMenuData() async {
    if (state.imageFile == null || !mounted) return false;

    state = state.copyWith(isLoading: true);

    try {
      final inputImage = InputImage.fromFile(state.imageFile!);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

      final RecognizedText result = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();

      // Simulated Database Upload Logic
      debugPrint("---------------------------------------------");
      debugPrint("🚀 UPLOADING DATA TO DATABASE...");
      debugPrint("📂 Image Path: ${state.imageFile!.path}");
      debugPrint("📝 Extracted Text: ${result.text}");
      debugPrint("---------------------------------------------");

      await Future.delayed(const Duration(seconds: 2));
      debugPrint("✅ DATABASE UPLOAD SUCCESSFUL");

      return true;
    } catch (e) {
      debugPrint("❌ Submission Error: $e");
      return false;
    } finally {
      if (mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }
}