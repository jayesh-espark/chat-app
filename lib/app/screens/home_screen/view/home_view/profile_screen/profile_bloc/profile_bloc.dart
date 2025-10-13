import 'dart:async';
import 'dart:developer';

import 'package:chating_app/app/core/storage/local_storage.dart';
import 'package:chating_app/app/model/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  String avatar = "";
  String userName = "";
  UserModel? userModel;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadUserProfileEvent>(_handleLoadUserProfile);
    on<LogoutUserEvent>(_hadleLogoutUser);
  }

  FutureOr<void> _handleLoadUserProfile(
    LoadUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    userModel = await LocalStorageApp().getUser();
    log("userModel => ${userModel?.toJson()}");
    avatar = userModel?.avatarUrl ?? "";
    userName = '${userModel?.firstName ?? ""} ${userModel?.lastName ?? ""}';
    emit(LoadUserProfileState());
  }

  FutureOr<void> _hadleLogoutUser(
    LogoutUserEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(LogoutUserState());
  }
}
