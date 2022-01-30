import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_test/provider/provider.dart';

void main() {
  group('Provider Test', () {
    test('Log Provider Test', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      late List<String> logs;
      container.listen<Log>(
        logProvider,
        (previous, next) {
          logs = next.logs;
        },
        fireImmediately: true,
      );
      expect(logs, isEmpty, reason: 'Logs should be empty');
      container.read(logProvider).addLog('Test Log');
      expect(logs, hasLength(1), reason: 'Logs should have length of 1');
      expect(
        logs.first,
        'Test Log',
        reason: 'Fist logentry should be Test Log',
      );
      container.read(logProvider).clear();
      expect(logs, isEmpty, reason: 'Logs should be empty after clear');
    });
  });

  test('Me Provider Test', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    late String id;
    late String name;
    container.listen<Me>(
      meProvider,
      (previous, next) {
        id = next.ownId;
        name = next.ownName;
      },
      fireImmediately: true,
    );
    expect(id, equals('me'), reason: 'Id should be the startvalue');
    expect(name, equals('me'), reason: 'Name should be the startvalue');
    container.read(meProvider)
      ..ownId = 'testId'
      ..ownName = 'testName';
    expect(id, equals('testId'), reason: 'Id should be testId');
    expect(name, equals('testName'), reason: 'Name should be testName');
  });
}
