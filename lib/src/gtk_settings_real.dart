import 'dart:async';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gtk_settings.dart';
import 'libgtk.dart';
import 'libgtk.g.dart' as ffi;

class GtkSettingsImpl with ChangeNotifier implements GtkSettings {
  GtkSettingsImpl() {
    methodChannel.setMethodCallHandler(_handleMethodCall);
    _finalizer.attach(this, _controller, detach: this);
  }

  @visibleForTesting
  static const methodChannel = MethodChannel('gtk/settings');

  final _controller = StreamController<String>.broadcast();
  static final Finalizer<StreamController<String>> _finalizer =
      Finalizer((controller) => controller.close());

  @override
  Object? getProperty(String name) {
    return ffi.using((arena) {
      final value = arena<ffi.GValue>();
      lib.g_object_get_property(
        lib.gtk_settings_get_default().cast(),
        name.toNativeUtf8(allocator: arena).cast(),
        value,
      );
      return value.toDartObject();
    });
  }

  @override
  Stream<Object?> notifyProperty(String name) {
    return _controller.stream
        .where((event) => event == name)
        .map((event) => getProperty(name));
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
  void setProperty(String name, Object value) {
    ffi.using((arena) {
      lib.g_object_set_property(
        lib.gtk_settings_get_default().cast(),
        name.toNativeUtf8(allocator: arena).cast(),
        value.toNativeGValue(allocator: arena),
      );
    });
  }

  @override
  void resetProperty(String name) {
    ffi.using((arena) {
      lib.gtk_settings_reset_property(
        lib.gtk_settings_get_default().cast(),
        name.toNativeUtf8(allocator: arena).cast(),
      );
    });
  }
}
