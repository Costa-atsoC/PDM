import 'dart:io' as io;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ubi/common/Drawer.dart';
import 'package:ubi/firebase_auth_implementation/models/post_model.dart';
import 'package:ubi/firebase_auth_implementation/models/user_model.dart';
import 'package:path/path.dart' as path;

import '../common/Management.dart';
import '../common/Utils.dart';
import '../common/appTheme.dart';
import '../database_help.dart';
import '../firestore/post_firestore.dart';
import '../firestore/user_firestore.dart';

class firebaseStorage {
  //-----------------------------------------------------------
  //Update profile picture
    FirebaseStorage storage = FirebaseStorage.instance;

  // Select and image from the gallery or take a picture with the camera
  // Then upload to Firebase Storage
    Future<void> upload(String inputSource, String uid) async {
      final picker = ImagePicker();
      XFile? pickedImage;
      try {
        pickedImage = await picker.pickImage(
            source: inputSource == 'camera'
                ? ImageSource.camera
                : ImageSource.gallery,
            maxWidth: 1920);
        final String fileName = path.basename(pickedImage!.path);
        io.File imageFile = io.File(pickedImage.path);
        try {
          // Uploading the selected image with some custom meta data
          await storage.ref(fileName).putFile(
              imageFile,
              SettableMetadata(customMetadata: {
                'uploaded_by': uid
              }));
          // Refresh the UI
          //setState(() {});
        } on FirebaseException catch (error) {
          if (kDebugMode) {
            print(error);
          }
        }
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
    }

  // Retrieve the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
    Future<List<Map<String, dynamic>>> loadImages(String uid) async {
      List<Map<String, dynamic>> files = [];

      final ListResult result = await storage.ref().list();
      final List<Reference> allFiles = result.items;

      await Future.forEach<Reference>(allFiles, (file) async {
        final String fileUrl = await file.getDownloadURL();
        final FullMetadata fileMeta = await file.getMetadata();
        if(fileMeta.customMetadata?['uploaded_by'] == uid) {
        files.add({
          "url": fileUrl,
          "path": file.fullPath,
          "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
          "description":
              fileMeta.customMetadata?['description'] ?? 'No description'
        });
      }
    });

      return files;
    }

  // Delete the selected image
    Future<void> delete(String ref) async {
      await storage.ref(ref).delete();

      // Rebuild the UI
      //setState(() {});
    }

  //end of update profile picture
  //-----------------------------------------------------------
}