import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/widgets/custom_alert_dialog.dart';
import 'package:image/image.dart' as img;

String formatDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  DateFormat formatter = DateFormat('MMM d, y');
  return formatter.format(dateTime);
}

Future<File> cropImage(XFile image) async {
  File croppedImage;
  final croppedFile = await ImageCropper().cropImage(
    sourcePath: image.path,
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: primaryColor,
          initAspectRatio: CropAspectRatioPreset.square,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          lockAspectRatio: true),
      IOSUiSettings(
        title: 'Crop Image',
        minimumAspectRatio: 1.0,
        aspectRatioPresets: [CropAspectRatioPreset.square],
      ),
    ],
  );

  croppedImage = await resizeImage(File(croppedFile!.path));

  return croppedImage;
}

Future<File> resizeImage(File file) async {
  // Load the image
  final img.Image? image = img.decodeImage(await file.readAsBytes());

  if (image == null) {
    throw Exception("Failed to decode image");
  }

  // Resize the image to 150x150 pixels
  final img.Image resized = img.copyResize(image, width: 300, height: 300);

  // Save the resized image to a temporary file
  final resizedFile = File('${file.parent.path}/resized_${file.uri.pathSegments.last}');
  await resizedFile.writeAsBytes(img.encodeJpg(resized));

  return resizedFile;
}

DateTime parseDate(String date) {
  return DateTime.parse(date);
}

String formatSubDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

String generateDate(DateTime date) {
  return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date.toUtc());
}

String getGreeting() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour >= 5 && hour < 12) {
    return 'Good Morning';
  } else if (hour >= 12 && hour < 17) {
    return 'Good Afternoon';
  } else if (hour >= 17 && hour < 21) {
    return 'Good Evening';
  } else {
    return 'Good Night';
  }
}

void showErrorDialog(String title, String message, context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomAlertDialog(
        title: title,
        message: message,
        onConfirm: () {
          Navigator.of(context).pop();
        },
      );
    },
  );
}

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> writeToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> readToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  Future<String?> readUsername() async {
    return await _storage.read(key: 'username');
  }

  Future<void> writeUserType({String? userType = "Seeker"}) async {
    await _storage.write(key: 'user_type', value: userType);
  }

  Future<String?> readUserType() async {
    return await _storage.read(key: 'user_type');
  }

  Future<String?> readUserId() async {
    return await _storage.read(key: 'user_id');
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
