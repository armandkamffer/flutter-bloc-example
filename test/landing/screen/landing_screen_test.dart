import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_demo/landing/bloc/landing_bloc.dart';
import 'package:flutter_bloc_demo/landing/models/landing_item.dart';
import 'package:flutter_bloc_demo/landing/screen/landing_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLandingBloc extends MockBloc<LandingEvent, LandingState>
    implements LandingBloc {}

void main() {
  group("Landing screen state output tests", () {
    late LandingBloc mockedLandingBloc;
    late Widget testWidget;

    setUp(() {
      mockedLandingBloc = MockLandingBloc();
      testWidget = MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
          home: LandingWidget(landingBloc: mockedLandingBloc),
        ),
      );
    });

    testWidgets("LandingWidget LandingLoading state displays",
        (WidgetTester tester) async {
      whenListen<LandingState>(
        mockedLandingBloc,
        Stream.fromIterable([LandingLoading()]),
        initialState: LandingLoading(),
      );

      await tester.pumpWidget(testWidget);
      await tester.pump(Duration.zero);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("LandingWidget LandingLoaded state displays",
        (WidgetTester tester) async {
      whenListen<LandingState>(
        mockedLandingBloc,
        Stream.fromIterable([
          LandingLoaded(
            items: const [
              LandingItem(title: "Item 19"),
            ],
          ),
        ]),
        initialState: LandingLoading(),
      );

      await tester.pumpWidget(testWidget);
      await tester.pump(Duration.zero);

      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text("1 - Item 19"), findsOneWidget);

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets("LandingWidget LandingError state displays",
        (WidgetTester tester) async {
      whenListen<LandingState>(
        mockedLandingBloc,
        Stream.fromIterable([LandingError(errorMessage: "EXCEPTION ERROR")]),
        initialState: LandingLoading(),
      );

      await tester.pumpWidget(testWidget);
      await tester.pump(Duration.zero);

      expect(find.text("EXCEPTION ERROR"), findsOneWidget);
      expect(find.text("Try again"), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });

  group("Landing screen interaction tests", () {
    late LandingBloc mockedLandingBloc;
    late Widget testWidget;

    setUp(() {
      mockedLandingBloc = MockLandingBloc();
      testWidget = MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
          home: LandingWidget(landingBloc: mockedLandingBloc),
        ),
      );
    });

    testWidgets("LandingWidget LandingLoading state displays",
        (WidgetTester tester) async {
      whenListen<LandingState>(
        mockedLandingBloc,
        Stream.fromIterable([
          LandingLoaded(
            items: const [
              LandingItem(title: "Test item"),
            ],
          ),
        ]),
        initialState: LandingLoading(),
      );

      await tester.pumpWidget(testWidget);
      await tester.pump(Duration.zero);
      await tester.tap(find.byIcon(Icons.delete));

      verify(
        () => mockedLandingBloc.add(
          LandingRemoveItem(
            item: const LandingItem(title: "Test item"),
          ),
        ),
      ).called(1);
    });
  });
}
