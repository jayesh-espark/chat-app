import 'dart:async';
import 'package:chating_app/app/screens/home_screen/view/home_view/profile_screen/profile_view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view/home_view/current_chat_list/current_chats_view/current_chat_list_view.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<Widget> pages = [CurrentChatsView(), ProfileView()];
  int currentIndex = 0;

  HomeBloc() : super(HomeInitial()) {
    on<OnPageChangedEvent>(_handlePageChange);
  }

  FutureOr<void> _handlePageChange(
    OnPageChangedEvent event,
    Emitter<HomeState> emit,
  ) {
    currentIndex = event.pageIndex;
    emit(OnPageChangedState());
  }
}
