import 'package:flutter/foundation.dart';

import 'gtk_settings_stub.dart' if (dart.library.ffi) 'gtk_settings_real.dart';

abstract class GtkSettings implements ChangeNotifier {
  factory GtkSettings() = GtkSettingsImpl;
  Object? getValue(String key);
  Stream<Object?> notifyValue(String key);
  void setValue(String key, Object value);
  void resetValue(String key);
}
