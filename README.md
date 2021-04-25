# flutter_test_behavior

Interact with Flutter Widgets the same way the user does.

## Simple example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_behavior/flutter_test_behavior.dart';
import 'package:mocktail/mocktail.dart';

class FakeEvents {
  void onPress() {}
  void onChanged(String? text) {}
}

class MockFakeEvents extends Mock implements FakeEvents {}

// ...
testWidgets('Should perform a tap on Button', (tester) async {
  final FakeEvents events = MockFakeEvents();

  // Create an UserEvent to simulate user interactions with Widgets
  final button = UserEvent(tester, Key('button'));

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Container(
          child: TextButton(
            key: Key('button'),
            onPressed: events.onPress,
            child: Text('Click me'),
          ),
        ),
      ),
    ),
  );

  await button.tap();

  await tester.pump();

  verify(() => events.onPress()).called(1);
});
```

## API

The API is very straightforward. It will bring the same behavior as a user would interact with any screen. Every action called from `UserEvent` instance is asynchronous.

### `UserEvent(WidgetTester, Key)`

Every instance should have a `WidgetTester` and `Key`. It will be responsible to retrieve the correct Widget by `Key` from Widget tree and make some actions using the `WidgetTester`. Every Widget where users could interact with should have its own `UserEvent` instance.

```dart
final button = UserEvent(tester, Key('button'));
```

### `tap()`

Trigger a `tap` event from `WidgetTester` using the `UserEvent` instance and its Widget `Key`.

```dart
final button = UserEvent(tester, Key('button'));

await button.tap();
```

### `type(String text)`

Trigger an `enterText` event from `WidgetTester` using the `UserEvent` instance and its Widget `Key`. To simulate a user interaction correctly, every character from `text` will trigger an `enterText` event and starts with a `tap` event if was not focused.

```dart
final input = UserEvent(tester, Key('input'));

// tap() will trigger once because input is not focused
// type() will trigger 5 times because hello has 5 characteres
await input.type('hello');
```

### `erase()`

Trigger an `enterText` event from `WidgetTester` using the `UserEvent` instance and its Widget `Key`. To simulate a user interaction correctly, every character it is typed before will trigger an `enterText` event until empty string and starts with a `tap` event if was not focused.

```dart
final input = UserEvent(tester, Key('input'));

// tap() will trigger tap event once because input is not focused
// type() will trigger enterText event for 'h'
// type() will trigger enterText event for 'he'
// type() will trigger enterText event for 'hel'
// type() will trigger enterText event for 'hell'
// type() will trigger enterText event for 'hello'
await input.type('hello');

// tap() won't trigger because input is already focused
// type() will trigger enterText event for 'hell'
// type() will trigger enterText event for 'hel'
// type() will trigger enterText event for 'he'
// type() will trigger enterText event for 'h'
// type() will trigger enterText event for ''
await input.erase();
```

### `widget<T extends Widget>()`

Get the most recent instance from a Widget using the `UserEvent` instance and its Widget `Key`. Useful to assert some widget property.

```dart
final input = UserEvent(tester, Key('input'));

// widgetInput could access a TextField interface
// to assert some property
TextField widgetInput = input.widget<TextField>();
```
