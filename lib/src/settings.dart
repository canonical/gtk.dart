import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gtype.dart';

class GtkSettings {
  const GtkSettings();

  @visibleForTesting
  static const methodChannel = MethodChannel('gtk_settings');

  Future<Object?> getValue(String key) {
    return methodChannel.invokeMethod<Object?>('getValue', key);
  }

  Future<bool?> getBoolValue(String key) {
    return getValue(key).then((value) => value as bool?);
  }

  Future<int?> getCharValue(String key) {
    return getValue(key).then((value) => value as int?);
  }

  Future<int?> getUCharValue(String key) {
    return getValue(key).then((value) => value as int?);
  }

  Future<int?> getIntValue(String key) {
    return getValue(key).then((value) => value as int?);
  }

  Future<int?> getUIntValue(String key) {
    return getValue(key).then((value) => value as int?);
  }

  Future<int?> getLongValue(String key) {
    return getValue(key).then((value) => value as int?);
  }

  Future<int?> getULongValue(String key) {
    return getValue(key).then((value) => value as int?);
  }

  Future<int?> getInt64Value(String key) {
    return getValue(key).then((value) => value as int?);
  }

  Future<int?> getUInt64Value(String key) {
    return getValue(key).then((value) => value as int?);
  }

  Future<double?> getFloatValue(String key) {
    return getValue(key).then((value) => value as double?);
  }

  Future<double?> getDoubleValue(String key) {
    return getValue(key).then((value) => value as double?);
  }

  Future<String?> getStringValue(String key) {
    return getValue(key).then((value) => value as String?);
  }

  Future<void> setBoolValue(String key, bool value) {
    return _setValue(key, GType.BOOLEAN, value);
  }

  Future<void> setCharValue(String key, int value) {
    return _setValue(key, GType.CHAR, value);
  }

  Future<void> setUCharValue(String key, int value) {
    return _setValue(key, GType.UCHAR, value);
  }

  Future<void> setIntValue(String key, int value) {
    return _setValue(key, GType.INT, value);
  }

  Future<void> setUIntValue(String key, int value) {
    return _setValue(key, GType.UINT, value);
  }

  Future<void> setLongValue(String key, int value) {
    return _setValue(key, GType.LONG, value);
  }

  Future<void> setULongValue(String key, int value) {
    return _setValue(key, GType.ULONG, value);
  }

  Future<void> setInt64Value(String key, int value) {
    return _setValue(key, GType.INT64, value);
  }

  Future<void> setUInt64Value(String key, int value) {
    return _setValue(key, GType.UINT64, value);
  }

  Future<void> setFloatValue(String key, double value) {
    return _setValue(key, GType.FLOAT, value);
  }

  Future<void> setDoubleValue(String key, double value) {
    return _setValue(key, GType.DOUBLE, value);
  }

  Future<void> setStringValue(String key, String value) {
    return _setValue(key, GType.STRING, value);
  }

  Future<void> _setValue(String key, GType type, Object? value) {
    return methodChannel.invokeMethod('setValue', [key, type.value, value]);
  }

  Future<void> resetValue(String key) {
    return methodChannel.invokeMethod('resetValue', key);
  }

  Stream<Object?> notifyValue(String key) async* {
    final args = await methodChannel.invokeMethod('listenValue', key);
    final eventChannel = EventChannel('${args[0]}');
    try {
      yield* eventChannel.receiveBroadcastStream();
    } finally {
      await methodChannel.invokeMethod('cancelValue', args[1]);
    }
  }
}
