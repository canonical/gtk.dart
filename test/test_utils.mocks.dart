// ignore_for_file: non_constant_identifier_names

import 'dart:ffi' as ffi;

import 'package:gtk/src/libgtk.g.dart';
import 'package:mockito/mockito.dart';

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
  int g_value_get_schar(ffi.Pointer? value) {
    return super.noSuchMethod(
      Invocation.method(#g_value_get_schar, [value]),
      returnValue: 0,
    );
  }

  @override
  void g_value_set_schar(ffi.Pointer? value, int? v_char) {
    return super.noSuchMethod(
      Invocation.method(#g_value_set_schar, [value, v_char]),
    );
  }

  @override
  int g_value_get_uchar(ffi.Pointer? value) {
    return super.noSuchMethod(
      Invocation.method(#g_value_get_uchar, [value]),
      returnValue: 0,
    );
  }

  @override
  void g_value_set_uchar(ffi.Pointer? value, int? v_uchar) {
    return super.noSuchMethod(
      Invocation.method(#g_value_set_uchar, [value, v_uchar]),
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
  int g_value_get_uint(ffi.Pointer? value) {
    return super.noSuchMethod(
      Invocation.method(#g_value_get_uint, [value]),
      returnValue: 0,
    );
  }

  @override
  void g_value_set_uint(ffi.Pointer? value, int? v_uint) {
    return super.noSuchMethod(
      Invocation.method(#g_value_set_uint, [value, v_uint]),
    );
  }

  @override
  int g_value_get_long(ffi.Pointer? value) {
    return super.noSuchMethod(
      Invocation.method(#g_value_get_long, [value]),
      returnValue: 0,
    );
  }

  @override
  void g_value_set_long(ffi.Pointer? value, int? v_long) {
    return super.noSuchMethod(
      Invocation.method(#g_value_set_long, [value, v_long]),
    );
  }

  @override
  int g_value_get_ulong(ffi.Pointer? value) {
    return super.noSuchMethod(
      Invocation.method(#g_value_get_ulong, [value]),
      returnValue: 0,
    );
  }

  @override
  void g_value_set_ulong(ffi.Pointer? value, int? v_ulong) {
    return super.noSuchMethod(
      Invocation.method(#g_value_set_ulong, [value, v_ulong]),
    );
  }

  @override
  int g_value_get_int64(ffi.Pointer? value) {
    return super.noSuchMethod(
      Invocation.method(#g_value_get_int64, [value]),
      returnValue: 0,
    );
  }

  @override
  void g_value_set_int64(ffi.Pointer? value, int? v_int64) {
    return super.noSuchMethod(
      Invocation.method(#g_value_set_int64, [value, v_int64]),
    );
  }

  @override
  int g_value_get_uint64(ffi.Pointer? value) {
    return super.noSuchMethod(
      Invocation.method(#g_value_get_uint64, [value]),
      returnValue: 0,
    );
  }

  @override
  void g_value_set_uint64(ffi.Pointer? value, int? v_uint64) {
    return super.noSuchMethod(
      Invocation.method(#g_value_set_uint64, [value, v_uint64]),
    );
  }

  @override
  double g_value_get_float(ffi.Pointer? value) {
    return super.noSuchMethod(
      Invocation.method(#g_value_get_float, [value]),
      returnValue: 0.0,
    );
  }

  @override
  void g_value_set_float(ffi.Pointer? value, double? v_float) {
    return super.noSuchMethod(
      Invocation.method(#g_value_set_float, [value, v_float]),
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
