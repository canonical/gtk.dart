import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as ffi;
import 'package:meta/meta.dart';

import 'libgtk.g.dart';

LibGtk? _lib;
LibGtk get lib => _lib ??= LibGtk(ffi.DynamicLibrary.open('libgtk-3.so.0'));

@visibleForTesting
void overrideLibGtkForTesting(LibGtk lib) => _lib = lib;

extension GValueX on ffi.Pointer<GValue> {
  Object? toDartObject() {
    switch (ref.g_type) {
      case G_TYPE_BOOLEAN:
        return lib.g_value_get_boolean(this) != 0;
      case G_TYPE_CHAR:
        return lib.g_value_get_schar(this);
      case G_TYPE_UCHAR:
        return lib.g_value_get_uchar(this);
      case G_TYPE_INT:
        return lib.g_value_get_int(this);
      case G_TYPE_UINT:
        return lib.g_value_get_uint(this);
      case G_TYPE_LONG:
        return lib.g_value_get_long(this);
      case G_TYPE_ULONG:
        return lib.g_value_get_ulong(this);
      case G_TYPE_INT64:
        return lib.g_value_get_int64(this);
      case G_TYPE_UINT64:
        return lib.g_value_get_uint64(this);
      case G_TYPE_FLOAT:
        return lib.g_value_get_float(this);
      case G_TYPE_DOUBLE:
        return lib.g_value_get_double(this);
      case G_TYPE_STRING:
        return lib.g_value_get_string(this).cast<ffi.Utf8>().toDartString();
    }
    return null;
  }
}

extension ObjectX on Object {
  ffi.Pointer<GValue> toNativeGValue({required ffi.Allocator allocator}) {
    switch (runtimeType) {
      case bool:
        final gvalue = allocator<GValue>();
        lib.g_value_init(gvalue, G_TYPE_BOOLEAN);
        lib.g_value_set_boolean(gvalue, this as bool ? 1 : 0);
        return gvalue;
      case int:
        final gvalue = allocator<GValue>();
        lib.g_value_init(gvalue, G_TYPE_INT64);
        lib.g_value_set_int64(gvalue, this as int);
        return gvalue;
      case double:
        final gvalue = allocator<GValue>();
        lib.g_value_init(gvalue, G_TYPE_DOUBLE);
        lib.g_value_set_double(gvalue, this as double);
        return gvalue;
      case String:
        final gvalue = allocator<GValue>();
        lib.g_value_init(gvalue, G_TYPE_STRING);
        lib.g_value_set_string(
            gvalue, (this as String).toNativeUtf8(allocator: allocator).cast());
        return gvalue;
      default:
        throw UnsupportedError('Unsupported type: $runtimeType');
    }
  }
}
