import 'package:flutter/foundation.dart';

import 'gtk_settings_stub.dart' if (dart.library.ffi) 'gtk_settings_real.dart';

abstract class GtkSettings implements ChangeNotifier {
  factory GtkSettings() = GtkSettingsImpl;
  Object? getProperty(String name);
  Stream<Object?> notifyProperty(String name);
  void setProperty(String name, Object value);
  void resetProperty(String name);
}
