## 2.1.0

- Migrate to Flutter 3.10 and Dart 3.0

## 2.0.0

- GSettings: adjust naming to closer follow GTK
- GSettings: replace setXxxValue() with setValue()

## 2.0.0-beta.1

- Made `GtkSettings` mockable.

## 2.0.0-beta.0

- Re-purpose this package to be a collection of non-visual GTK+ utilities for
  Flutter applications.
- Add `GtkApplication` handling remote command-line arguments and file open
  requests.
- Add `GtkSettings` for accessing desktop and application settings.

## 1.0.0-rc.9

- Change adwaitaLight and adwaitaDark type to getters instead of Function

## 1.0.0-rc.8

- Fix canvasColor not working

## 1.0.0-rc.7

- Add documentation for colors in libadwaita_theme
- Add adwaitaLight and adwaitaDark for LibAdwaita Theme

## 1.0.0-rc.6

- `GnomeTheme` is now deprecated, use `Theme.of(context).[color]` to get whatever color you want.

## 1.0.0-rc.5

- Get native window button placement by using gsetting schema

## 1.0.0-rc.4

- Made width nullable and fix defaults for `GtkContainer`
- Update Screenshot

## 1.0.0-rc.3

- Fix ViewSwitcher color
- Add `GtkContainer` custom widget
- Add new example app
- Fix gtk sidebar item bg color

## 1.0.0-rc.2

- Fix error when no leading icon was provided for the sidebar
- Rename `gtk_colors.dart` to `gtk_theme.dart` and moved it to the widgets directory
- Fix imports in the files

## 1.0.0-rc.1

- Remove gnomeTheme parameter requirement for gtk_sidebar
- Add details about paramters of `GnomeTheme.of(context)`

## 1.0.0-rc.0

- Use color schemes from libadwaita

## 0.9.8+1

- Remove dead code

## 0.9.8

- Add riverpod example
- Fix selected and unselected color for gtk sidebar
- Fix initial color parsing

## 0.9.5

- Fix instructions on how to use window decoration
- Update README and screenshot

## 0.9.0

- Update gsettings to latest version
- Fix native theme picker by @MalcolmMielle
- Made Window Decorations a seperate package to keep this package lightweight

## 0.8.5

- Use NavigationToolbar instead of Stack to center widget.

## 0.8.0

- Update example
- Add expanded and height property to GtkViewSwitcher

## 0.7.0+1

- Fix Padding of Icons with Gtk header button
- Update `titlebarSpace` and `padding` for `GtkHeaderBar`

## 0.7.0

- Add GtkViewSwitcher from `flutter_gtk` package
- Fix Double tap on header buttons doesn't work.
- Change default padding for header

## 0.6.0

- Remove `adwaita_icons` from dependency of example
- Revamp code for `GtkSidebar`.

## 0.5.5

- Remove `adwaita_icons` from dependency
- Add default values for onClose, onMinimize and onMaximize for GtkHeaderBar.bitsdojo and .nativeshell.
- Add titlebarSpace property to adjust the space b/w titlebar and trailing items.

## 0.5.0+1

- Rename beignDrag to performDrag for nativeshell Gtk Header.

## 0.5.0

- Add onDoubleTap and onHeaderDrag method for GtkHeaderBar
- Add padding and height parameter to GtkHeaderBar
- Add GtkHeaderBar.bitsdojo and GtkHeaderBar.nativeshell to integerate well with these plugins

## 0.4.0+1

- Update Screenshot

## 0.4.0

- Add auto detect gtk theme using GtkColorType.system by @MalcolmMielle
- Update Window Decorations plugin
- Add isActive parameter to Gtk popup button

## 0.2.3

- Change children to body for GtkPopupMenu
- Update Documentation and comments
- Update get Gtk color logic
- Update example by adding bitsdojo_window
- Update Screenshot

## 0.2.0+2

- Fix typo in README
- Add Screenshot in README

## 0.2.0+1

- Update github homepage

## 0.2.0

- Remove `bitsdojo_window` dependency

## 0.1.0+1

- Fix Readme

## 0.1.0

- initial release.
