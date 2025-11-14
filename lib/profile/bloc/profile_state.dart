import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String? avatarPath;
  final bool isLoading;

  const ProfileState({this.avatarPath, this.isLoading = false});

  ProfileState copyWith({
    String? avatarPath,
    bool? isLoading,
  }) {
    return ProfileState(
      avatarPath: avatarPath ?? this.avatarPath,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [avatarPath, isLoading];
}
