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

      expect(settings.getProperty('boolean'), true);
      settings.setProperty('boolean', false);
      expect(settings.getProperty('boolean'), false);

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyProperty('boolean')
          .listen(expectAsync1((value) => expect(value, false), count: 1));
      await receiveMethodCall('gtk/settings', 'notify', 'boolean');
      expect(wasNotified, ++expectedNotified);

      settings.resetProperty('boolean');
      expect(settings.getProperty('boolean'), isNull);
    });
  });

  test('int', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'int': MockGValue(G_TYPE_INT64, -123456789),
      });

      final settings = GtkSettings();

      expect(settings.getProperty('int'), -123456789);
      settings.setProperty('int', -987654321);
      expect(settings.getProperty('int'), -987654321);

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyProperty('int')
          .listen(expectAsync1((value) => expect(value, -987654321), count: 1));
      await receiveMethodCall('gtk/settings', 'notify', 'int');
      expect(wasNotified, ++expectedNotified);

      settings.resetProperty('int');
      expect(settings.getProperty('int'), isNull);
    });
  });

  test('double', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'double': MockGValue(G_TYPE_DOUBLE, 123456.789),
      });

      final settings = GtkSettings();

      expect(settings.getProperty('double'), 123456.789);
      settings.setProperty('double', 789012.345);
      expect(settings.getProperty('double'), 789012.345);

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyProperty('double')
          .listen(expectAsync1((value) => expect(value, 789012.345), count: 1));
      await receiveMethodCall('gtk/settings', 'notify', 'double');
      expect(wasNotified, ++expectedNotified);

      settings.resetProperty('double');
      expect(settings.getProperty('double'), isNull);
    });
  });

  test('string', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'string': MockGValue(G_TYPE_STRING, 'foo'),
      });

      final settings = GtkSettings();

      expect(settings.getProperty('string'), 'foo');
      settings.setProperty('string', 'bar');
      expect(settings.getProperty('string'), 'bar');

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyProperty('string')
          .listen(expectAsync1((value) => expect(value, 'bar'), count: 1));
      await receiveMethodCall('gtk/settings', 'notify', 'string');
      expect(wasNotified, ++expectedNotified);

      settings.resetProperty('string');
      expect(settings.getProperty('string'), isNull);

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
