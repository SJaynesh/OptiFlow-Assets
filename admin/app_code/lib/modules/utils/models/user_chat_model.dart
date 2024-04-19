import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';

class UserChatModel {
  String profileImage;
  String fullName;
  String email;
  String department;
  String bio;

  UserChatModel({
    required this.profileImage,
    required this.fullName,
    required this.email,
    required this.department,
    required this.bio,
  });

  factory UserChatModel.fromMap(Map<String, dynamic> data) {
    return UserChatModel(
      profileImage: data['profileImage'],
      fullName: data['fullName'],
      email: data['email'],
      department: data['department'],
      bio: data['bio'],
    );
  }
}
