import 'package:equatable/equatable.dart';

class LandingItem extends Equatable {
  final String title;

  const LandingItem({required this.title});

  @override
  List<Object?> get props => [title];
}
