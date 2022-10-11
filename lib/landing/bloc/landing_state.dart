part of 'landing_bloc.dart';

@immutable
abstract class LandingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LandingLoading extends LandingState {}

class LandingLoaded extends LandingState {
  final List<LandingItem> items;
  final String? message;

  LandingLoaded({this.items = const [], this.message});

  @override
  List<Object?> get props => [items, message];
}

class LandingError extends LandingState {
  final String errorMessage;

  LandingError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
