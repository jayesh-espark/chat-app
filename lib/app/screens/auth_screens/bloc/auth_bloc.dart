import 'dart:async';

import 'package:chating_app/app/model/base_response.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utills/app_images.dart';
import '../../../network_calls/services/auth_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  String avatar = AppImages.avatar3d1;
  DateTime? selectedDate;
  String selectedCategory = '3D';
  final Map<String, List<String>> avatarCategories = {
    '3D': [
      AppImages.avatar3d1,
      AppImages.avatar3d2,
      AppImages.avatar3d3,
      AppImages.avatar3d4,
      AppImages.avatar3d5,
    ],
    'Bluey': [
      AppImages.avatarBluey1,
      AppImages.avatarBluey2,
      AppImages.avatarBluey3,
      AppImages.avatarBluey4,
      AppImages.avatarBluey5,
      AppImages.avatarBluey6,
      AppImages.avatarBluey7,
      AppImages.avatarBluey8,
      AppImages.avatarBluey9,
      AppImages.avatarBluey10,
    ],
    'Memo': [
      AppImages.avatarMemo1,
      AppImages.avatarMemo2,
      AppImages.avatarMemo3,
      AppImages.avatarMemo4,
      AppImages.avatarMemo5,
      AppImages.avatarMemo6,
      AppImages.avatarMemo7,
      AppImages.avatarMemo8,
      AppImages.avatarMemo9,
      AppImages.avatarMemo10,
      AppImages.avatarMemo11,
      AppImages.avatarMemo12,
      AppImages.avatarMemo13,
      AppImages.avatarMemo14,
      AppImages.avatarMemo15,
      AppImages.avatarMemo16,
      AppImages.avatarMemo17,
      AppImages.avatarMemo18,
      AppImages.avatarMemo19,
      AppImages.avatarMemo20,
      AppImages.avatarMemo21,
      AppImages.avatarMemo22,
      AppImages.avatarMemo23,
      AppImages.avatarMemo24,
      AppImages.avatarMemo25,
      AppImages.avatarMemo26,
      AppImages.avatarMemo27,
      AppImages.avatarMemo28,
      AppImages.avatarMemo29,
      AppImages.avatarMemo30,
      AppImages.avatarMemo31,
      AppImages.avatarMemo32,
      AppImages.avatarMemo33,
      AppImages.avatarMemo34,
      AppImages.avatarMemo35,
    ],
    'Notion': [
      AppImages.avatarNotion1,
      AppImages.avatarNotion2,
      AppImages.avatarNotion3,
      AppImages.avatarNotion4,
      AppImages.avatarNotion5,
      AppImages.avatarNotion6,
      AppImages.avatarNotion7,
      AppImages.avatarNotion8,
      AppImages.avatarNotion9,
      AppImages.avatarNotion10,
      AppImages.avatarNotion11,
      AppImages.avatarNotion12,
      AppImages.avatarNotion13,
      AppImages.avatarNotion14,
      AppImages.avatarNotion15,
    ],
    'Teams': [
      AppImages.avatarTeams1,
      AppImages.avatarTeams2,
      AppImages.avatarTeams3,
      AppImages.avatarTeams4,
      AppImages.avatarTeams5,
      AppImages.avatarTeams6,
      AppImages.avatarTeams7,
      AppImages.avatarTeams8,
      AppImages.avatarTeams9,
    ],
    'Toon': [
      AppImages.avatarToon1,
      AppImages.avatarToon2,
      AppImages.avatarToon3,
      AppImages.avatarToon4,
      AppImages.avatarToon5,
      AppImages.avatarToon6,
      AppImages.avatarToon7,
      AppImages.avatarToon8,
      AppImages.avatarToon9,
      AppImages.avatarToon10,
    ],
    'Upstream': [
      AppImages.avatarUpstream1,
      AppImages.avatarUpstream2,
      AppImages.avatarUpstream3,
      AppImages.avatarUpstream10,
      AppImages.avatarUpstream11,
      AppImages.avatarUpstream12,
      AppImages.avatarUpstream13,
      AppImages.avatarUpstream14,
      AppImages.avatarUpstream15,
      AppImages.avatarUpstream16,
      AppImages.avatarUpstream17,
      AppImages.avatarUpstream18,
      AppImages.avatarUpstream19,
      AppImages.avatarUpstream20,
      AppImages.avatarUpstream21,
      AppImages.avatarUpstream22,
    ],
  };

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_handleLoginRequested);
    on<BirthDateSelectionEvent>(_handleBirthSelectionDate);
    on<BirthDateSelectedEvent>(_handleBirthSelectedDate);
    on<AvatarSelectionEvent>(_handleAvatarSelectionEvent);
    on<AvatarSelectedEvent>(_handleAvatarSelectedEvent);
    on<SignupRequested>(_handleSignUp);
    on<ChangeAvatarCategoryEvent>(_onChangeAvatarCategoryEvent);
  }

  Future<void> _handleLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(LoginErrorOccurredState(message: "Please fill all the fields"));
      return;
    }
    if (!event.email.contains(RegExp(r'\S+@\S+\.\S+'))) {
      emit(LoginErrorOccurredState(message: "Please enter a valid email"));
      return;
    }
    emit(LoadingState());
    BaseResponseModel responseModel = await AuthServices().login(
      event.email,
      event.password,
    );
    if (responseModel.success) {
      emit(LoginSuccessState(message: responseModel.message));
    } else {
      emit(LoginErrorOccurredState(message: responseModel.message));
    }
  }

  FutureOr<void> _handleBirthSelectionDate(
    BirthDateSelectionEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthAction(true));
  }

  FutureOr<void> _handleBirthSelectedDate(
    BirthDateSelectedEvent event,
    Emitter<AuthState> emit,
  ) {
    selectedDate = event.dateTime;
    emit(BirthDateSelectState(birthDate: event.dateTime));
  }

  FutureOr<void> _handleAvatarSelectionEvent(
    AvatarSelectionEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthAction(false));
  }

  FutureOr<void> _handleAvatarSelectedEvent(
    AvatarSelectedEvent event,
    Emitter<AuthState> emit,
  ) {
    avatar = event.avatar;
    emit(ImageSelectionState(avatar: avatar));
  }

  Future<void> _handleSignUp(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (event.firstName.isEmpty ||
        event.email.isEmpty ||
        event.password.isEmpty ||
        selectedDate == null) {
      emit(SignUpErrorOccurredState(message: "Please fill all the fields"));
      return;
    }
    if (!event.email.contains(RegExp(r'\S+@\S+\.\S+'))) {
      emit(SignUpErrorOccurredState(message: "Please enter a valid email"));
      return;
    }
    if (event.password.length < 6) {
      emit(
        SignUpErrorOccurredState(
          message: "Password must be at least 6 characters long",
        ),
      );
      return;
    }
    emit(LoadingState());
    BaseResponseModel responseModel = await AuthServices().signUp(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
      dateOfBirth: event.dateOfBirth,
      avatar: avatar,
    );
    if (responseModel.success) {
      emit(SignUpSuccessState(message: responseModel.message));
    } else {
      emit(SignUpErrorOccurredState(message: responseModel.message));
    }
  }

  FutureOr<void> _onChangeAvatarCategoryEvent(
    ChangeAvatarCategoryEvent event,
    Emitter<AuthState> emit,
  ) {
    selectedCategory = event.avatarCat;
    emit(ChangeAvatarCategoryState(avatarCat: selectedCategory));
  }
}
