part of 'landing_bloc.dart';

@immutable
abstract class LandingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LandingLoadItems extends LandingEvent {}

class LandingRemoveItem extends LandingEvent {
  final LandingItem item;

  LandingRemoveItem({required this.item});

  @override
  List<Object?> get props => [item];
}

class LandingAddItem extends LandingEvent {
  final LandingItem item;

  LandingAddItem({required this.item});

  @override
  List<Object?> get props => [item];
}
