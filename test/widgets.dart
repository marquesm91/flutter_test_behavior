import 'package:flutter/material.dart';

import 'fake_events.dart';

class FormKeys {
  static const input = const Key('input');
  static const button = const Key('button');
}

class ButtonWidget extends StatelessWidget {
  ButtonWidget(this.events);

  final FakeEvents events;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: FormKeys.button,
      onPressed: events.onPress,
      child: Text('Click me'),
    );
  }
}

class InputWidget extends StatelessWidget {
  InputWidget(this.events);

  final FakeEvents events;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: FormKeys.input,
      onChanged: events.onChanged,
      onTap: events.onPress,
      decoration: InputDecoration(hintText: 'Enter text'),
    );
  }
}
