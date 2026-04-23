import 'gtk_icon_stub.dart' if (dart.library.ffi) 'gtk_icon_real.dart';

/// Looks up icons according to the GTK theme.
abstract class GtkIcon {
  /// Creates a [GtkIcon] that reads the active theme from GTK settings.
  ///
  /// A [themeName] can optionally be provided to override the default theme
  /// obtained from GTK.
  factory GtkIcon({String? themeName}) = GtkIconImpl;

  /// Returns the path to the best matching icon file for [name] at the given
  /// [size] and [scale], or `null` if no icon could be found.
  String? findIcon(String name, {int size = 48, int scale = 1});

  /// The name of the icon theme used for lookups.
  String get themeName;
}
