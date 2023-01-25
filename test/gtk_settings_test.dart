import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter_test/flutter_test.dart';
import 'package:gtk/gtk.dart';
import 'package:gtk/src/libgtk.g.dart' hide GtkSettings;

import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('boolean', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'boolean': MockGValue(G_TYPE_BOOLEAN, true),
      });

      final settings = GtkSettings();

      expect(settings.getValue('boolean'), true);
      settings.setValue('boolean', false);
      expect(settings.getValue('boolean'), false);

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyValue('boolean')
          .listen(expectAsync1((value) => expect(value, false), count: 1));
      await receiveMethodCall('gtk/settings', 'notify', 'boolean');
      expect(wasNotified, ++expectedNotified);

      settings.resetValue('boolean');
      expect(settings.getValue('boolean'), isNull);
    });
  });

  test('int', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'int': MockGValue(G_TYPE_INT64, -123456789),
      });

      final settings = GtkSettings();

      expect(settings.getValue('int'), -123456789);
      settings.setValue('int', -987654321);
      expect(settings.getValue('int'), -987654321);

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyValue('int')
          .listen(expectAsync1((value) => expect(value, -987654321), count: 1));
      await receiveMethodCall('gtk/settings', 'notify', 'int');
      expect(wasNotified, ++expectedNotified);

      settings.resetValue('int');
      expect(settings.getValue('int'), isNull);
    });
  });

  test('double', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'double': MockGValue(G_TYPE_DOUBLE, 123456.789),
      });

      final settings = GtkSettings();

      expect(settings.getValue('double'), 123456.789);
      settings.setValue('double', 789012.345);
      expect(settings.getValue('double'), 789012.345);

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyValue('double')
          .listen(expectAsync1((value) => expect(value, 789012.345), count: 1));
      await receiveMethodCall('gtk/settings', 'notify', 'double');
      expect(wasNotified, ++expectedNotified);

      settings.resetValue('double');
      expect(settings.getValue('double'), isNull);
    });
  });

  test('string', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'string': MockGValue(G_TYPE_STRING, 'foo'),
      });

      final settings = GtkSettings();

      expect(settings.getValue('string'), 'foo');
      settings.setValue('string', 'bar');
      expect(settings.getValue('string'), 'bar');

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyValue('string')
          .listen(expectAsync1((value) => expect(value, 'bar'), count: 1));
      await receiveMethodCall('gtk/settings', 'notify', 'string');
      expect(wasNotified, ++expectedNotified);

      settings.resetValue('string');
      expect(settings.getValue('string'), isNull);

      await receiveMethodCall('gtk/settings', 'notify', 'other');
      expect(wasNotified, ++expectedNotified);
    });
  });

  test('other', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {});

      final settings = GtkSettings();

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      await receiveMethodCall('gtk/settings', 'notify', 'other');
      expect(wasNotified, ++expectedNotified);
    });
  });
}
