part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class OnPageChangedEvent extends HomeEvent {
  final int pageIndex;
  OnPageChangedEvent({required this.pageIndex});
}
