import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:text_recognizer/screens/scan_menu_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScanMenuScreen(),
    );
  }
}

// packages used:

// google_mlkit_text_recognition: ^0.15.0
// image_picker: ^1.2.1
// image_cropper: ^11.0.0


// for  ios setup, make sure to add the necessary permissions in Info.plist

// <key>NSPhotoLibraryUsageDescription</key>
// <string>This app needs access to your photo library to select images</string>
//
// <key>NSCameraUsageDescription</key>
// <string>This app needs camera access to take photos</string>
//
// <key>NSMicrophoneUsageDescription</key>
// <string>This app needs microphone access to record videos</string>

// for android setup, make sure to add the necessary permissions in AndroidManifest.xml
// <activity
// android:name="com.yalantis.ucrop.UCropActivity"
// android:screenOrientation="portrait"
// android:theme="@style/Theme.AppCompat.Light.NoActionBar"
// tools:ignore="MissingClass" />