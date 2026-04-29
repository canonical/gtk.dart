import 'gtk_icon.dart';

/// Stub implementation of [GtkIcon] for non-Linux platforms.
class GtkIconImpl implements GtkIcon {
  GtkIconImpl({String? themeName}) : _themeOverride = themeName;

  final String? _themeOverride;

  @override
  String get themeName => _themeOverride ?? 'hicolor';

  @override
  String? findIcon(String name, {int size = 48, int scale = 1}) => null;
}
