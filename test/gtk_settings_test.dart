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
      settings.setBoolValue('boolean', false);
      expect(settings.getValue('boolean'), false);

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyValue('boolean')
          .listen(expectAsync1((value) => expect(value, false), count: 1));
      await receiveMethodCall('notify', 'boolean');
      expect(wasNotified, ++expectedNotified);

      settings.resetValue('boolean');
      expect(settings.getValue('boolean'), isNull);
    });
  });

  test('char/uchar', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'char': MockGValue(G_TYPE_CHAR, -12),
        'uchar': MockGValue(G_TYPE_UCHAR, 34),
      });

      final settings = GtkSettings();

      expect(settings.getValue('char'), -12);
      settings.setCharValue('char', -34);
      expect(settings.getValue('char'), -34);

      expect(settings.getValue('uchar'), 34);
      settings.setUCharValue('uchar', 56);
      expect(settings.getValue('uchar'), 56);

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyValue('char')
          .listen(expectAsync1((value) => expect(value, -34), count: 1));
      await receiveMethodCall('notify', 'char');
      expect(wasNotified, ++expectedNotified);

      settings
          .notifyValue('uchar')
          .listen(expectAsync1((value) => expect(value, 56), count: 1));
      await receiveMethodCall('notify', 'uchar');
      expect(wasNotified, ++expectedNotified);

      settings.resetValue('char');
      expect(settings.getValue('char'), isNull);

      settings.resetValue('uchar');
      expect(settings.getValue('uchar'), isNull);
    });
  });

  test('int/uint', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'int': MockGValue(G_TYPE_INT, -123),
        'uint': MockGValue(G_TYPE_UINT, 456),
      });

      final settings = GtkSettings();

      expect(settings.getValue('int'), -123);
      settings.setIntValue('int', -456);
      expect(settings.getValue('int'), -456);

      expect(settings.getValue('uint'), 456);
      settings.setUIntValue('uint', 789);
      expect(settings.getValue('uint'), 789);

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyValue('int')
          .listen(expectAsync1((value) => expect(value, -456), count: 1));
      await receiveMethodCall('notify', 'int');
      expect(wasNotified, ++expectedNotified);

      settings
          .notifyValue('uint')
          .listen(expectAsync1((value) => expect(value, 789), count: 1));
      await receiveMethodCall('notify', 'uint');
      expect(wasNotified, ++expectedNotified);

      settings.resetValue('int');
      expect(settings.getValue('int'), isNull);

      settings.resetValue('uint');
      expect(settings.getValue('uint'), isNull);
    });
  });

  test('long/ulong', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'long': MockGValue(G_TYPE_LONG, -123456789),
        'ulong': MockGValue(G_TYPE_ULONG, 123456789),
      });

      final settings = GtkSettings();

      expect(settings.getValue('long'), -123456789);
      settings.setLongValue('long', -987654321);
      expect(settings.getValue('long'), -987654321);

      expect(settings.getValue('ulong'), 123456789);
      settings.setULongValue('ulong', 987654321);
      expect(settings.getValue('ulong'), 987654321);

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyValue('long')
          .listen(expectAsync1((value) => expect(value, -987654321), count: 1));
      await receiveMethodCall('notify', 'long');
      expect(wasNotified, ++expectedNotified);

      settings
          .notifyValue('ulong')
          .listen(expectAsync1((value) => expect(value, 987654321), count: 1));
      await receiveMethodCall('notify', 'ulong');
      expect(wasNotified, ++expectedNotified);

      settings.resetValue('long');
      expect(settings.getValue('long'), isNull);

      settings.resetValue('ulong');
      expect(settings.getValue('ulong'), isNull);
    });
  });

  test('int64/uint64', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'int64': MockGValue(G_TYPE_INT64, -123456789),
        'uint64': MockGValue(G_TYPE_UINT64, 123456789),
      });

      final settings = GtkSettings();

      expect(settings.getValue('int64'), -123456789);
      settings.setInt64Value('int64', -987654321);
      expect(settings.getValue('int64'), -987654321);

      expect(settings.getValue('uint64'), 123456789);
      settings.setUInt64Value('uint64', 987654321);
      expect(settings.getValue('uint64'), 987654321);

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyValue('int64')
          .listen(expectAsync1((value) => expect(value, -987654321), count: 1));
      await receiveMethodCall('notify', 'int64');
      expect(wasNotified, ++expectedNotified);

      settings
          .notifyValue('uint64')
          .listen(expectAsync1((value) => expect(value, 987654321), count: 1));
      await receiveMethodCall('notify', 'uint64');
      expect(wasNotified, ++expectedNotified);

      settings.resetValue('int64');
      expect(settings.getValue('int64'), isNull);

      settings.resetValue('uint64');
      expect(settings.getValue('uint64'), isNull);
    });
  });

  test('float/double', () async {
    ffi.using((arena) async {
      // ignore: unused_local_variable
      final gtk = mockLibGtk(allocator: arena, properties: {
        'float': MockGValue(G_TYPE_FLOAT, 123.456),
        'double': MockGValue(G_TYPE_DOUBLE, 123456.789),
      });

      final settings = GtkSettings();

      expect(settings.getValue('float'), 123.456);
      settings.setFloatValue('float', 789.012);
      expect(settings.getValue('float'), closeTo(789.012, 0.0001));

      expect(settings.getValue('double'), 123456.789);
      settings.setDoubleValue('double', 789012.345);
      expect(settings.getValue('double'), 789012.345);

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings.notifyValue('float').listen(expectAsync1(
          (value) => expect(value, closeTo(789.012, 0.0001)),
          count: 1));
      await receiveMethodCall('notify', 'float');
      expect(wasNotified, ++expectedNotified);

      settings
          .notifyValue('double')
          .listen(expectAsync1((value) => expect(value, 789012.345), count: 1));
      await receiveMethodCall('notify', 'double');
      expect(wasNotified, ++expectedNotified);

      settings.resetValue('float');
      expect(settings.getValue('float'), isNull);

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
      settings.setStringValue('string', 'bar');
      expect(settings.getValue('string'), 'bar');

      var wasNotified = 0;
      var expectedNotified = 0;
      settings.addListener(() => ++wasNotified);

      settings
          .notifyValue('string')
          .listen(expectAsync1((value) => expect(value, 'bar'), count: 1));
      await receiveMethodCall('notify', 'string');
      expect(wasNotified, ++expectedNotified);

      settings.resetValue('string');
      expect(settings.getValue('string'), isNull);

      await receiveMethodCall('notify', 'other');
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

      await receiveMethodCall('notify', 'other');
      expect(wasNotified, ++expectedNotified);
    });
  });
}
