library flutter_test_behavior;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class UserEvent {
  UserEvent(this.tester, this.key);

  final WidgetTester tester;
  final Key key;
  String _text = '';

  Finder get _finder => find.byKey(key);

  String get text => _text;

  T widget<T extends Widget>() => tester.widget<T>(_finder);

  Future<void> type(String text) async {
    await tap();

    List<int> runes = text.runes.toList();

    for (var i = 0; i < runes.length; i += 1) {
      final char = String.fromCharCode(runes[i]);

      _text += char;

      await tester.enterText(_finder, _text);
    }
  }

  Future<void> erase() async {
    await tap();

    while (_text != '') {
      _text = _text.substring(0, _text.length - 1);

      await tester.enterText(_finder, _text);
    }
  }

  Future<void> tap() async {
    await tester.tap(_finder);
  }
}
