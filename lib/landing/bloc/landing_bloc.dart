import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_demo/landing/models/landing_item.dart';
import 'package:flutter_bloc_demo/landing/repository/landing_repository.dart';
import 'package:meta/meta.dart';

part 'landing_event.dart';
part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  late LandingRepository _repository;
  List<LandingItem> _landingItems = [];

  LandingBloc({LandingRepository? repository}) : super(LandingLoading()) {
    _repository = repository ?? LandingRepository();

    on<LandingLoadItems>(_onLoadItems);
    on<LandingAddItem>(_onAddItem);
    on<LandingRemoveItem>(_onRemoveItem);
  }

  _onLoadItems(LandingLoadItems event, Emitter<LandingState> emit) async {
    emit(LandingLoading());

    try {
      _landingItems = await _repository.loadItems();
      emit(LandingLoaded(items: List.from(_landingItems)));
    } catch (exception) {
      emit(LandingError(errorMessage: "$exception"));
    }
  }

  _onAddItem(LandingAddItem event, Emitter<LandingState> emit) {
    _landingItems.add(event.item);
    emit(
      LandingLoaded(
        items: List.from(_landingItems),
        message: "Item added",
      ),
    );
  }

  _onRemoveItem(LandingRemoveItem event, Emitter<LandingState> emit) {
    _landingItems.remove(event.item);
    emit(
      LandingLoaded(
        items: List.from(_landingItems),
        message: "Item removed",
      ),
    );
  }
}
