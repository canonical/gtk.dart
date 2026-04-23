import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as ffi;

import 'gtk_icon.dart';
import 'libgtk.dart';
import 'libgtk.g.dart' as ffi;

/// Real implementation of [GtkIcon] that delegates to GTK.
class GtkIconImpl implements GtkIcon {
  GtkIconImpl({String? themeName}) : _themeOverride = themeName;

  final String? _themeOverride;

  @override
  String get themeName {
    if (_themeOverride != null) return _themeOverride!;
    return ffi.using((arena) {
      final value = arena<ffi.GValue>();
      lib.g_object_get_property(
        lib.gtk_settings_get_default().cast(),
        'gtk-icon-theme-name'.toNativeUtf8(allocator: arena).cast(),
        value,
      );
      final obj = value.toDartObject();
      return (obj is String && obj.isNotEmpty) ? obj : 'hicolor';
    });
  }

  @override
  String? findIcon(String name, {int size = 48, int scale = 1}) {
    return ffi.using((arena) {
      final theme = _themeOverride != null
          ? _createTheme(_themeOverride!, arena)
          : lib.gtk_icon_theme_get_default();

      final iconName = name.toNativeUtf8(allocator: arena).cast<ffi.Char>();
      final gtkIconInfo = lib.gtk_icon_theme_lookup_icon_for_scale(
        theme,
        iconName,
        size,
        scale,
        ffi.GtkIconLookupFlags.GTK_ICON_LOOKUP_FORCE_SIZE,
      );

      String? result;
      if (gtkIconInfo.address != 0) {
        final filenamePtr = lib.gtk_icon_info_get_filename(gtkIconInfo);
        if (filenamePtr.address != 0) {
          result = filenamePtr.cast<ffi.Utf8>().toDartString();
        }
        lib.gtk_icon_info_free(gtkIconInfo);
      }

      // free our custom theme if we had to create one
      if (_themeOverride != null) {
        lib.g_object_unref(theme.cast());
      }

      return result;
    });
  }

  /// Creates a temporary [ffi.GtkIconTheme] pinned to [name].
  ffi.Pointer<ffi.GtkIconTheme> _createTheme(
    String name,
    ffi.Arena arena,
  ) {
    final theme = lib.gtk_icon_theme_new();
    final nameNative = name.toNativeUtf8(allocator: arena).cast<ffi.Char>();
    lib.gtk_icon_theme_set_custom_theme(theme, nameNative);
    return theme;
  }
}
