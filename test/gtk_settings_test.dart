import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter_test/flutter_test.dart';
import 'package:gtk_settings/gtk_settings.dart';

import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('get/set/reset', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'boolean': true,
        'integer': 123,
        'double': 123.456,
        'string': 'foo',
      });

      final settings = GtkSettings();

      expect(settings.getValue('boolean'), true);
      settings.setBoolValue('boolean', false);
      expect(settings.getValue('boolean'), false);
      settings.resetValue('boolean');
      expect(settings.getValue('boolean'), isNull);

      expect(settings.getValue('integer'), 123);
      settings.setIntValue('integer', 456);
      expect(settings.getValue('integer'), 456);
      settings.resetValue('integer');
      expect(settings.getValue('integer'), isNull);

      expect(settings.getValue('double'), 123.456);
      settings.setDoubleValue('double', 789.012);
      expect(settings.getValue('double'), 789.012);
      settings.resetValue('double');
      expect(settings.getValue('double'), isNull);

      expect(settings.getValue('string'), 'foo');
      settings.setStringValue('string', 'bar');
      expect(settings.getValue('string'), 'bar');
      settings.resetValue('string');
      expect(settings.getValue('string'), isNull);
    });
  });

  test('notify', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'boolean': true,
        'integer': 123,
        'double': 123.456,
        'string': 'foo',
      });

      final settings = GtkSettings();

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyValue('boolean')
          .listen(expectAsync1((value) => expect(value, true), count: 1));
      await receiveMethodCall('notify', 'boolean');
      expect(wasNotified, ++expectedNotified);

      settings
          .notifyValue('integer')
          .listen(expectAsync1((value) => expect(value, 123), count: 1));
      await receiveMethodCall('notify', 'integer');
      expect(wasNotified, ++expectedNotified);

      settings
          .notifyValue('double')
          .listen(expectAsync1((value) => expect(value, 123.456), count: 1));
      await receiveMethodCall('notify', 'double');
      expect(wasNotified, ++expectedNotified);

      settings
          .notifyValue('string')
          .listen(expectAsync1((value) => expect(value, 'foo'), count: 1));
      await receiveMethodCall('notify', 'string');
      expect(wasNotified, ++expectedNotified);

      await receiveMethodCall('notify', 'other');
      expect(wasNotified, ++expectedNotified);
    });
  });
}
