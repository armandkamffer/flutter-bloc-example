import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc_demo/landing/bloc/landing_bloc.dart';
import 'package:flutter_bloc_demo/landing/models/landing_item.dart';
import 'package:flutter_bloc_demo/landing/repository/landing_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../utils/test_data_generator.dart';

import 'landing_bloc_test.mocks.dart';

@GenerateMocks([LandingRepository])
void main() {
  group("Bloc Events Tests", () {
    late LandingBloc landingBloc;
    late MockLandingRepository mockedRepository;

    setUp(() {
      mockedRepository = MockLandingRepository();
      landingBloc = LandingBloc(repository: mockedRepository);
    });

    tearDown(() {
      landingBloc.close();
    });

    blocTest(
      "emits [LandingLoading, LandingLoaded] when succesful",
      setUp: () {
        when(mockedRepository.loadItems())
            .thenAnswer((_) async => TestDataGenerator.mockedItems);
      },
      build: () => landingBloc,
      act: (bloc) => bloc.add(LandingLoadItems()),
      expect: () => [
        LandingLoading(),
        LandingLoaded(items: TestDataGenerator.mockedItems),
      ],
      verify: (bloc) => verify(mockedRepository.loadItems()).called(1),
    );

    blocTest(
      "emits [LandingLoading, LandingError] when failure",
      setUp: () {
        when(mockedRepository.loadItems())
            .thenThrow(Exception("Test exception"));
      },
      build: () => landingBloc,
      act: (bloc) => bloc.add(LandingLoadItems()),
      expect: () => [
        LandingLoading(),
        LandingError(errorMessage: "Exception: Test exception"),
      ],
      verify: (bloc) => verify(mockedRepository.loadItems()).called(1),
    );

    blocTest(
      "emits [LandingLoaded] when item added",
      build: () => landingBloc,
      act: (bloc) =>
          bloc.add(LandingAddItem(item: const LandingItem(title: "Test"))),
      expect: () => [
        LandingLoaded(
          items: const [
            LandingItem(title: "Test"),
          ],
          message: "Item added",
        ),
      ],
    );

    blocTest(
      "emits [LandingLoaded] when item removed",
      build: () => landingBloc,
      act: (bloc) => bloc
        ..add(LandingAddItem(item: const LandingItem(title: "Test")))
        ..add(LandingRemoveItem(item: const LandingItem(title: "Test"))),
      skip: 1,
      expect: () => [
        LandingLoaded(
          items: const [],
          message: "Item removed",
        ),
      ],
    );
  });
}
