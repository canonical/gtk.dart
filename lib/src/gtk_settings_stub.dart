import 'package:flutter/foundation.dart';

import 'gtk_settings.dart';

class GtkSettingsImpl with ChangeNotifier implements GtkSettings {
  @override
  Object? getProperty(String name) => null;

  @override
  Stream<Object?> notifyProperty(String name) => Stream.empty();

  @override
  void setProperty(String name, Object value) {}

  @override
  void resetProperty(String name) {}
}
