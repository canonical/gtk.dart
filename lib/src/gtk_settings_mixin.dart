import 'package:flutter/foundation.dart';

mixin GtkSettingsMixin on ChangeNotifier {
  Object? getValue(String key);
  Stream<Object?> notifyValue(String key);
  void setBoolValue(String key, bool value);
  void setCharValue(String key, int value);
  void setUCharValue(String key, int value);
  void setIntValue(String key, int value);
  void setUIntValue(String key, int value);
  void setLongValue(String key, int value);
  void setULongValue(String key, int value);
  void setInt64Value(String key, int value);
  void setUInt64Value(String key, int value);
  void setFloatValue(String key, double value);
  void setDoubleValue(String key, double value);
  void setStringValue(String key, String value);
  void resetValue(String key);
}
