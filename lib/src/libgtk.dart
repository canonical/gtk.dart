import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as ffi;

import 'libgtk.g.dart';
export 'libgtk.g.dart';

LibGtk? _lib;
LibGtk get lib => _lib ??= LibGtk(ffi.DynamicLibrary.open('libgtk-3.so.0'));

extension GValueX on ffi.Pointer<GValue> {
  Object? toDart() {
    switch (ref.g_type) {
      case G_TYPE_BOOLEAN:
        return lib.g_value_get_boolean(this) != 0;
      case G_TYPE_CHAR:
        return lib.g_value_get_char(this);
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
