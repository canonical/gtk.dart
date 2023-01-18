import 'dart:async';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gtk_settings_mixin.dart';
import 'libgtk.dart';

class GtkSettings extends ChangeNotifier with GtkSettingsMixin {
  GtkSettings() {
    methodChannel.setMethodCallHandler(_handleMethodCall);
    _finalizer.attach(this, _controller, detach: this);
  }

  @visibleForTesting
  static const methodChannel = MethodChannel('gtk_settings');

  final _controller = StreamController<String>.broadcast();
  static final Finalizer<StreamController<String>> _finalizer =
      Finalizer((controller) => controller.close());

  @override
  Object? getValue(String key) {
    final settings = lib.gtk_settings_get_default();
    return ffi.using((arena) {
      final gvalue = arena<GValue>();
      lib.g_object_get_property(
        settings.cast(),
        key.toNativeUtf8(allocator: arena).cast(),
        gvalue,
      );
      return gvalue.toDart();
    });
  }

  @override
  Stream<Object?> notifyValue(String key) {
    return _controller.stream
        .where((event) => event == key)
        .map((event) => getValue(key));
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'notify':
        _controller.add(call.arguments);
        break;
      default:
        throw MissingPluginException('$call');
    }
    notifyListeners();
  }

  @override
  void setBoolValue(String key, bool value) {
    ffi.using((arena) {
      final gvalue = arena<GValue>();
      lib.g_value_init(gvalue, G_TYPE_BOOLEAN);
      lib.g_value_set_boolean(gvalue, value ? 1 : 0);
      _setValue(key.toNativeUtf8(allocator: arena), gvalue);
    });
  }

  @override
  void setCharValue(String key, int value) {
    ffi.using((arena) {
      final gvalue = arena<GValue>();
      lib.g_value_init(gvalue, G_TYPE_CHAR);
      lib.g_value_set_char(gvalue, value);
      _setValue(key.toNativeUtf8(allocator: arena), gvalue);
    });
  }

  @override
  void setUCharValue(String key, int value) {
    ffi.using((arena) {
      final gvalue = arena<GValue>();
      lib.g_value_init(gvalue, G_TYPE_UCHAR);
      lib.g_value_set_uchar(gvalue, value);
      _setValue(key.toNativeUtf8(allocator: arena), gvalue);
    });
  }

  @override
  void setIntValue(String key, int value) {
    ffi.using((arena) {
      final gvalue = arena<GValue>();
      lib.g_value_init(gvalue, G_TYPE_INT);
      lib.g_value_set_int(gvalue, value);
      _setValue(key.toNativeUtf8(allocator: arena), gvalue);
    });
  }

  @override
  void setUIntValue(String key, int value) {
    ffi.using((arena) {
      final gvalue = arena<GValue>();
      lib.g_value_init(gvalue, G_TYPE_UINT);
      lib.g_value_set_uint(gvalue, value);
      _setValue(key.toNativeUtf8(allocator: arena), gvalue);
    });
  }

  @override
  void setLongValue(String key, int value) {
    ffi.using((arena) {
      final gvalue = arena<GValue>();
      lib.g_value_init(gvalue, G_TYPE_LONG);
      lib.g_value_set_long(gvalue, value);
      _setValue(key.toNativeUtf8(allocator: arena), gvalue);
    });
  }

  @override
  void setULongValue(String key, int value) {
    ffi.using((arena) {
      final gvalue = arena<GValue>();
      lib.g_value_init(gvalue, G_TYPE_ULONG);
      lib.g_value_set_ulong(gvalue, value);
      _setValue(key.toNativeUtf8(allocator: arena), gvalue);
    });
  }

  @override
  void setInt64Value(String key, int value) {
    ffi.using((arena) {
      final gvalue = arena<GValue>();
      lib.g_value_init(gvalue, G_TYPE_INT64);
      lib.g_value_set_int64(gvalue, value);
      _setValue(key.toNativeUtf8(allocator: arena), gvalue);
    });
  }

  @override
  void setUInt64Value(String key, int value) {
    ffi.using((arena) {
      final gvalue = arena<GValue>();
      lib.g_value_init(gvalue, G_TYPE_UINT64);
      lib.g_value_set_uint64(gvalue, value);
      _setValue(key.toNativeUtf8(allocator: arena), gvalue);
    });
  }

  @override
  void setFloatValue(String key, double value) {
    ffi.using((arena) {
      final gvalue = arena<GValue>();
      lib.g_value_init(gvalue, G_TYPE_FLOAT);
      lib.g_value_set_float(gvalue, value);
      _setValue(key.toNativeUtf8(allocator: arena), gvalue);
    });
  }

  @override
  void setDoubleValue(String key, double value) {
    ffi.using((arena) {
      final gvalue = arena<GValue>();
      lib.g_value_init(gvalue, G_TYPE_DOUBLE);
      lib.g_value_set_double(gvalue, value);
      _setValue(key.toNativeUtf8(allocator: arena), gvalue);
    });
  }

  @override
  void setStringValue(String key, String value) {
    ffi.using((arena) {
      final gvalue = arena<GValue>();
      lib.g_value_init(gvalue, G_TYPE_STRING);
      final string = value.toNativeUtf8(allocator: arena);
      lib.g_value_set_string(gvalue, string.cast());
      _setValue(key.toNativeUtf8(allocator: arena), gvalue);
    });
  }

  void _setValue(ffi.Pointer<ffi.Utf8> key, ffi.Pointer<GValue> gvalue) {
    final settings = lib.gtk_settings_get_default();
    lib.g_object_set_property(settings.cast(), key.cast(), gvalue);
  }

  @override
  void resetValue(String key) {
    ffi.using((arena) {
      final settings = lib.gtk_settings_get_default();
      lib.gtk_settings_reset_property(
        settings.cast(),
        key.toNativeUtf8(allocator: arena).cast(),
      );
    });
  }
}
