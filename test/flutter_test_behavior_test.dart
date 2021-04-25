import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_behavior/flutter_test_behavior.dart';
import 'package:mocktail/mocktail.dart';

import 'fake_events.dart';
import 'widgets.dart';

void main() {
  late FakeEvents inputEvents;
  late FakeEvents buttonEvents;

  late MaterialApp pageWidget;

  setUp(() {
    inputEvents = MockFakeEvents();
    buttonEvents = MockFakeEvents();

    pageWidget = MaterialApp(
      home: Scaffold(
        body: Container(
          child: Column(
            children: [
              InputWidget(inputEvents),
              ButtonWidget(buttonEvents),
            ],
          ),
        ),
      ),
    );
  });

  testWidgets('Should perform a tap on ButtonWidget', (tester) async {
    final button = UserEvents(tester, FormKeys.button);

    await tester.pumpWidget(pageWidget);

    await button.tap();
    await tester.pump();

    verify(() => buttonEvents.onPress()).called(1);
  });

  testWidgets('Should perform a tap and enter text on InputWidget',
      (tester) async {
    final input = UserEvents(tester, FormKeys.input);
    String typedText = 'hi';

    await tester.pumpWidget(pageWidget);

    await input.type(typedText);
    await tester.pump();

    // type() will simulate a tap on widget and
    // will trigger onChanged event the exact typed string length
    verify(() => inputEvents.onPress()).called(1);
    verify(() => inputEvents.onChanged('h')).called(1);
    verify(() => inputEvents.onChanged('hi')).called(1);
  });

  testWidgets('Should perform a tap and erase text on InputWidget',
      (tester) async {
    final input = UserEvents(tester, FormKeys.input);
    String typedText = 'hi';

    await tester.pumpWidget(pageWidget);

    await input.type(typedText);
    await input.erase();

    await tester.pump();

    verify(() => inputEvents.onPress()).called(1);
    verify(() => inputEvents.onChanged('h')).called(2);
    verify(() => inputEvents.onChanged('hi')).called(1);
    verify(() => inputEvents.onChanged('')).called(1);
  });
}
