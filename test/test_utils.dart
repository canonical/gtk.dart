// ignore_for_file: non_constant_identifier_names

import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gtk_settings/src/libgtk.dart';
import 'package:mockito/mockito.dart';

Future<void> receiveMethodCall(String method, [dynamic arguments]) async {
  const codec = StandardMethodCodec();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger;

  await messenger.handlePlatformMessage(
    'gtk_settings',
    codec.encodeMethodCall(MethodCall(method, arguments)),
    (_) {},
  );
}

class MockLibGtk extends Mock implements LibGtk {
  @override
  ffi.Pointer<GtkSettings> gtk_settings_get_default() {
    return super.noSuchMethod(
      Invocation.method(#gtk_settings_get_default, []),
      returnValue: ffi.nullptr,
    );
  }

  @override
  void gtk_settings_reset_property(ffi.Pointer? settings, ffi.Pointer? name) {
    return super.noSuchMethod(
      Invocation.method(#gtk_settings_reset_property, [settings, name]),
    );
  }

  @override
  void g_object_get_property(ffi.Pointer? object,
      ffi.Pointer<ffi.Char>? property_name, ffi.Pointer? value) {
    return super.noSuchMethod(Invocation.method(#g_object_get_property, [
      object,
      property_name,
      value,
    ]));
  }

  @override
  void g_object_set_property(ffi.Pointer? object,
      ffi.Pointer<ffi.Char>? property_name, ffi.Pointer? value) {
    return super.noSuchMethod(Invocation.method(#g_object_set_property, [
      object,
      property_name,
      value,
    ]));
  }

  @override
  ffi.Pointer<GValue> g_value_init(ffi.Pointer? value, int? g_type) {
    return super.noSuchMethod(
      Invocation.method(#g_value_init, [value, g_type]),
      returnValue: ffi.nullptr,
    );
  }

  @override
  int g_value_get_boolean(ffi.Pointer? value) {
    return super.noSuchMethod(
      Invocation.method(#g_value_get_boolean, [value]),
      returnValue: 0,
    );
  }

  @override
  void g_value_set_boolean(ffi.Pointer? value, int? v_boolean) {
    return super.noSuchMethod(
      Invocation.method(#g_value_set_boolean, [value, v_boolean]),
    );
  }

  @override
  int g_value_get_int(ffi.Pointer? value) {
    return super.noSuchMethod(
      Invocation.method(#g_value_get_int, [value]),
      returnValue: 0,
    );
  }

  @override
  void g_value_set_int(ffi.Pointer? value, int? v_int) {
    return super.noSuchMethod(
      Invocation.method(#g_value_set_int, [value, v_int]),
    );
  }

  @override
  double g_value_get_double(ffi.Pointer? value) {
    return super.noSuchMethod(
      Invocation.method(#g_value_get_double, [value]),
      returnValue: 0.0,
    );
  }

  @override
  void g_value_set_double(ffi.Pointer? value, double? v_double) {
    return super.noSuchMethod(
      Invocation.method(#g_value_set_double, [value, v_double]),
    );
  }

  @override
  ffi.Pointer<ffi.Char> g_value_get_string(ffi.Pointer? value) {
    return super.noSuchMethod(
      Invocation.method(#g_value_get_string, [value]),
      returnValue: ffi.nullptr,
    );
  }

  @override
  void g_value_set_string(ffi.Pointer? value, ffi.Pointer? v_string) {
    return super.noSuchMethod(
      Invocation.method(#g_value_set_string, [value, v_string]),
    );
  }
}

MockLibGtk mockLibGtk({
  required ffi.Allocator allocator,
  required Map<String, dynamic> properties,
}) {
  final gtk = LibGtk(ffi.DynamicLibrary.open('libgtk-3.so.0'));

  final settings = ffi.Pointer<GtkSettings>.fromAddress(0x1234);

  final mock = MockLibGtk();
  overrideLibGtkForTesting(mock);
  when(mock.gtk_settings_get_default()).thenReturn(settings);

  when(mock.g_object_get_property(settings, any, any)).thenAnswer((i) {
    final key = i.positionalArguments[1] as ffi.Pointer<ffi.Char>;
    final value = properties[key.cast<ffi.Utf8>().toDartString()];
    if (value != null) {
      final ret = i.positionalArguments[2] as ffi.Pointer<GValue>;
      switch (value.runtimeType) {
        case bool:
          gtk.g_value_init(ret, G_TYPE_BOOLEAN);
          gtk.g_value_set_boolean(ret, value as bool ? 1 : 0);
          when(mock.g_value_get_boolean(ret)).thenReturn(value ? 1 : 0);
          break;
        case int:
          gtk.g_value_init(ret, G_TYPE_INT);
          gtk.g_value_set_int(ret, value as int);
          when(mock.g_value_get_int(ret)).thenReturn(value);
          break;
        case double:
          gtk.g_value_init(ret, G_TYPE_DOUBLE);
          gtk.g_value_set_double(ret, value as double);
          when(mock.g_value_get_double(ret)).thenReturn(value);
          break;
        case String:
          final str = (value as String).toNativeUtf8(allocator: allocator);
          gtk.g_value_init(ret, G_TYPE_STRING);
          gtk.g_value_set_string(ret, str.cast());
          when(mock.g_value_get_string(ret)).thenReturn(str.cast());
          break;
        default:
          throw ArgumentError.value(value);
      }
    }
  });

  when(mock.g_object_set_property(settings, any, any)).thenAnswer((i) {
    final key = (i.positionalArguments[1] as ffi.Pointer<ffi.Char>)
        .cast<ffi.Utf8>()
        .toDartString();
    final value = i.positionalArguments[2] as ffi.Pointer<GValue>;
    switch (value.ref.g_type) {
      case G_TYPE_BOOLEAN:
        properties[key] = gtk.g_value_get_boolean(value) != 0;
        break;
      case G_TYPE_INT:
        properties[key] = gtk.g_value_get_int(value);
        break;
      case G_TYPE_DOUBLE:
        properties[key] = gtk.g_value_get_double(value);
        break;
      case G_TYPE_STRING:
        properties[key] =
            gtk.g_value_get_string(value).cast<ffi.Utf8>().toDartString();
        break;
      default:
        throw ArgumentError.value(value.ref.g_type);
    }
  });

  when(mock.gtk_settings_reset_property(settings, any)).thenAnswer((i) {
    final key = (i.positionalArguments[1] as ffi.Pointer<ffi.Char>)
        .cast<ffi.Utf8>()
        .toDartString();
    properties.remove(key);
  });

  when(mock.g_value_init(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<GValue>;
    gtk.g_value_init(value, i.positionalArguments[1] as int);
    return value;
  });
  when(mock.g_value_set_boolean(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<GValue>;
    gtk.g_value_set_boolean(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_int(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<GValue>;
    gtk.g_value_set_int(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_double(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<GValue>;
    gtk.g_value_set_double(value, i.positionalArguments[1]);
  });
  when(mock.g_value_set_string(any, any)).thenAnswer((i) {
    final value = i.positionalArguments[0] as ffi.Pointer<GValue>;
    gtk.g_value_set_string(value, i.positionalArguments[1]);
  });

  return mock;
}
