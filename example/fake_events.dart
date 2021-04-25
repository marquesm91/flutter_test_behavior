import 'package:mocktail/mocktail.dart';

class FakeEvents {
  void onPress() {}
  void onChanged(String? text) {}
}

class MockFakeEvents extends Mock implements FakeEvents {}
