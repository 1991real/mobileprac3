import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/profile_bloc.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc()..add(LoadProfileAvatar()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Профиль")),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            final bloc = context.read<ProfileBloc>();

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => bloc.add(PickNewAvatar()),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      child: CircleAvatar(
                        key: ValueKey(state.avatarPath ?? 'default'),
                        radius: 70,
                        backgroundColor: Colors.grey[300],
                        child: ClipOval(
                          child: state.avatarPath != null
                              ? Image.file(
                                  File(state.avatarPath!),
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/default_avatar.png",
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (state.avatarPath != null)
                    ElevatedButton(
                      onPressed: () => bloc.add(DeleteAvatar()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Удалить фото"),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    "Александр",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    state.avatarPath == null
                        ? "Используется стандартный аватар"
                        : "Аватар установлен",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  if (state.isLoading) const CircularProgressIndicator(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
