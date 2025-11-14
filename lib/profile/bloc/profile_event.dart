import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadProfileAvatar extends ProfileEvent {}

class PickNewAvatar extends ProfileEvent {}

class DeleteAvatar extends ProfileEvent {}
