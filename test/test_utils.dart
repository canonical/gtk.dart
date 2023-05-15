// ignore_for_file: non_constant_identifier_names

import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtk/src/libgtk.dart';
import 'package:gtk/src/libgtk.g.dart' as ffi;
import 'package:mockito/mockito.dart';

import 'test_utils.mocks.dart';

Future<void> receiveMethodCall(
  String channel,
  String method, [
  dynamic arguments,
]) async {
  const codec = StandardMethodCodec();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  await messenger.handlePlatformMessage(
    channel,
    codec.encodeMethodCall(MethodCall(method, arguments)),
    (_) {},
  );
}

class MockGValue {
  const MockGValue(this.t, this.v);
  final int t;
  final dynamic v;
}

MockLibGtk mockLibGtk({
  required ffi.Allocator allocator,
  required Map<String, MockGValue> properties,
}) {
  final gtk = ffi.LibGtk(ffi.DynamicLibrary.open('libgtk-3.so.0'));

  final settings = ffi.Pointer<ffi.GtkSettings>.fromAddress(0x1234);

  final mock = MockLibGtk();
  overrideLibGtkForTesting(mock);
  when(mock.gtk_settings_get_default()).thenReturn(settings);

  when(mock.g_object_get_property(settings, any, any)).thenAnswer((i) {
    final key = i.positionalArguments[1] as ffi.Pointer<ffi.Char>;
    final value = properties[key.cast<ffi.Utf8>().toDartString()];
    if (value != null) {
      final ret = i.positionalArguments[2] as ffi.Pointer<ffi.GValue>;
      gtk.g_value_init(ret, value.t);
      switch (value.t) {
        case ffi.G_TYPE_BOOLEAN:
          gtk.g_value_set_boolean(ret, value.v as bool ? 1 : 0);
          when(mock.g_value_get_boolean(ret)).thenReturn(value.v ? 1 : 0);
          break;
        case ffi.G_TYPE_CHAR:
          gtk.g_value_set_schar(ret, value.v as int);
          when(mock.g_value_get_schar(ret)).thenReturn(value.v);
          break;
        case ffi.G_TYPE_UCHAR:
          gtk.g_value_set_uchar(ret, value.v as int);
          when(mock.g_value_get_uchar(ret)).thenReturn(value.v);
          break;
        case ffi.G_TYPE_INT:
          gtk.g_value_set_int(ret, value.v as int);
          when(mock.g_value_get_int(ret)).thenReturn(value.v);
          break;
        case ffi.G_TYPE_UINT:
          gtk.g_value_set_uint(ret, value.v as int);
          when(mock.g_value_get_uint(ret)).thenReturn(value.v);
          break;
        case ffi.G_TYPE_LONG:
          gtk.g_value_set_long(ret, value.v as int);
          when(mock.g_value_get_long(ret)).thenReturn(value.v);
          break;
        case ffi.G_TYPE_ULONG:
          gtk.g_value_set_ulong(ret, value.v as int);
          when(mock.g_value_get_ulong(ret)).thenReturn(value.v);
          break;
        case ffi.G_TYPE_INT64:
          gtk.g_value_set_int64(ret, value.v as int);
          when(mock.g_value_get_int64(ret)).thenReturn(value.v);
          break;
        case ffi.G_TYPE_UINT64:
          gtk.g_value_set_uint64(ret, value.v as int);
          when(mock.g_value_get_uint64(ret)).thenReturn(value.v);
          break;
        case ffi.G_TYPE_FLOAT:
          gtk.g_value_set_float(ret, value.v as double);
          when(mock.g_value_get_float(ret)).thenReturn(value.v);
          break;
        case ffi.G_TYPE_DOUBLE:
          gtk.g_value_set_double(ret, value.v as double);
          when(mock.g_value_get_double(ret)).thenReturn(value.v);
          break;
        case ffi.G_TYPE_STRING:
          final str = (value.v as String).toNativeUtf8(allocator: allocator);
          gtk.g_value_set_string(ret, str.cast());
          when(mock.g_value_get_string(ret)).thenReturn(str.cast());
          break;
        default:
          throw ArgumentError('${value.v} (${value.t})');
      }
    }
  });

  when(mock.g_object_set_property(settings, any, any)).thenAnswer((i) {
    final key = (i.positionalArguments[1] as ffi.Pointer<ffi.Char>)
        .cast<ffi.Utf8>()
        .toDartString();
    final value = i.positionalArguments[2] as ffi.Pointer<ffi.GValue>;
    final t = value.ref.g_type;
    dynamic v;
    switch (t) {
      case ffi.G_TYPE_BOOLEAN:
        v = gtk.g_value_get_boolean(value) != 0;
        break;
      case ffi.G_TYPE_CHAR:
        v = gtk.g_value_get_schar(value);
        break;
      case ffi.G_TYPE_UCHAR:
        v = gtk.g_value_get_uchar(value);
        break;
      case ffi.G_TYPE_INT:
        v = gtk.g_value_get_int(value);
        break;
      case ffi.G_TYPE_UINT:
        v = gtk.g_value_get_uint(value);
        break;
      case ffi.G_TYPE_LONG:
        v = gtk.g_value_get_long(value);
        break;
      case ffi.G_TYPE_ULONG:
        v = gtk.g_value_get_ulong(value);
        break;
      case ffi.G_TYPE_INT64:
        v = gtk.g_value_get_int64(value);
        break;
      case ffi.G_TYPE_UINT64:
        v = gtk.g_value_get_uint64(value);
        break;
      case ffi.G_TYPE_FLOAT:
        v = gtk.g_value_get_float(value);
        break;
      case ffi.G_TYPE_DOUBLE:
        v = gtk.g_value_get_double(value);
        break;
      case ffi.G_TYPE_STRING:
        v = gtk.g_value_get_string(value).cast<ffi.Utf8>().toDartString();
        break;
      default:
        throw ArgumentError.value(value.ref.g_type);
    }
    properties[key] = MockGValue(t, v);
  });

  when(mock.gtk_settings_reset_property(settings, any)).thenAnswer((i) {
    final key = (i.positionalArguments[1] as ffi.Pointer<ffi.Char>)
        .cast<ffi.Utf8>()
        .toDartString();
    properties.remove(key);
  });

  when(mock.g_value_init(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<ffi.GValue>;
    gtk.g_value_init(value, i.positionalArguments[1] as int);
    return value;
  });
  when(mock.g_value_set_boolean(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<ffi.GValue>;
    gtk.g_value_set_boolean(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_schar(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<ffi.GValue>;
    gtk.g_value_set_schar(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_uchar(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<ffi.GValue>;
    gtk.g_value_set_uchar(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_int(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<ffi.GValue>;
    gtk.g_value_set_int(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_uint(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<ffi.GValue>;
    gtk.g_value_set_uint(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_long(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<ffi.GValue>;
    gtk.g_value_set_long(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_ulong(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<ffi.GValue>;
    gtk.g_value_set_ulong(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_int64(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<ffi.GValue>;
    gtk.g_value_set_int64(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_uint64(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<ffi.GValue>;
    gtk.g_value_set_uint64(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_float(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<ffi.GValue>;
    gtk.g_value_set_float(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_double(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<ffi.GValue>;
    gtk.g_value_set_double(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_string(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<ffi.GValue>;
    gtk.g_value_set_string(value, i.positionalArguments[1]);
  });

  return mock;
}
