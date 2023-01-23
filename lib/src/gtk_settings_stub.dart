import 'package:flutter/foundation.dart';

import 'gtk_settings.dart';

class GtkSettingsImpl with ChangeNotifier implements GtkSettings {
  @override
  Object? getValue(String key) => null;

  @override
  Stream<Object?> notifyValue(String key) => Stream.empty();

  @override
  void setBoolValue(String key, bool value) {}

  @override
  void setCharValue(String key, int value) {}

  @override
  void setUCharValue(String key, int value) {}

  @override
  void setIntValue(String key, int value) {}

  @override
  void setUIntValue(String key, int value) {}

  @override
  void setLongValue(String key, int value) {}

  @override
  void setULongValue(String key, int value) {}

  @override
  void setInt64Value(String key, int value) {}

  @override
  void setUInt64Value(String key, int value) {}

  @override
  void setFloatValue(String key, double value) {}

  @override
  void setDoubleValue(String key, double value) {}

  @override
  void setStringValue(String key, String value) {}

  @override
  void resetValue(String key) {}
}
