import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ImagePicker _picker = ImagePicker();
  final String _key = "saved_avatar";

  ProfileBloc() : super(const ProfileState()) {
    on<LoadProfileAvatar>(_onLoad);
    on<PickNewAvatar>(_onPick);
    on<DeleteAvatar>(_onDelete);
  }

  Future<void> _onLoad(
      LoadProfileAvatar event, Emitter<ProfileState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPath = prefs.getString(_key);

    emit(state.copyWith(avatarPath: savedPath));
  }

 Future<void> _onPick(
    PickNewAvatar event, Emitter<ProfileState> emit) async {
  emit(state.copyWith(isLoading: true));

  final picked = await _picker.pickImage(source: ImageSource.gallery);
  if (picked == null) {
    emit(state.copyWith(isLoading: false));
    return;
  }

  final directory = await getApplicationDocumentsDirectory();
  final File newImage = File(picked.path);

  // 🔥 UNIQUE FILE NAME FIX
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final File localImage =
      await newImage.copy("${directory.path}/avatar_$timestamp.png");

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_key, localImage.path);

  emit(state.copyWith(
    avatarPath: localImage.path,
    isLoading: false,
  ));
}


Future<void> _onDelete(
  DeleteAvatar event,
  Emitter<ProfileState> emit,
) async {
  final prefs = await SharedPreferences.getInstance();

  final savedPath = prefs.getString(_key);


  await prefs.remove(_key);


  if (savedPath != null) {
    final file = File(savedPath);
    if (await file.exists()) {
      await file.delete();
      await FileImage(file).evict(); 
    }
  }


  emit(state.copyWith(avatarPath: null,isLoading: false));
}


}
