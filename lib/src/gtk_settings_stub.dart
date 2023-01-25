import 'package:flutter/foundation.dart';

import 'gtk_settings.dart';

class GtkSettingsImpl with ChangeNotifier implements GtkSettings {
  @override
  Object? getValue(String key) => null;

  @override
  Stream<Object?> notifyValue(String key) => Stream.empty();

  @override
  void setValue(String key, Object value) {}

  @override
  void resetValue(String key) {}
}
