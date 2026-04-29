import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter_test/flutter_test.dart';
import 'package:gtk/src/gtk_icon_real.dart';
import 'package:gtk/src/libgtk.dart';
import 'package:gtk/src/libgtk.g.dart' as gtk;
import 'package:mockito/mockito.dart';

import 'test_utils.dart';
import 'test_utils.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('themeName', () {
    test('returns override without touching GTK settings', () {
      ffi.using((arena) {
        final mock = MockLibGtk();
        overrideLibGtkForTesting(mock);

        final icon = GtkIconImpl(themeName: 'Adwaita');
        expect(icon.themeName, 'Adwaita');
        verifyNever(mock.gtk_settings_get_default());
      });
    });

    test('returns default from GTK settings when no override', () {
      ffi.using((arena) {
        mockLibGtk(
          allocator: arena,
          properties: {
            'gtk-icon-theme-name': MockGValue(gtk.G_TYPE_STRING, 'Yaru')
          },
          iconName: '',
          themeName: 'Yaru',
        );
        final icon = GtkIconImpl();
        expect(icon.themeName, 'Yaru');
      });
    });
  });

  group('findIcon valid', () {
    test('returns default theme icon', () {
      ffi.using((arena) {
        mockLibGtk(
          allocator: arena,
          properties: {
            'gtk-icon-theme-name': MockGValue(gtk.G_TYPE_STRING, 'Yaru')
          },
          iconName: 'folder',
          themeName: 'TestTheme',
          iconFile: '/usr/share/icons/TestTheme/48x48/places/folder.png',
        );
        final icon = GtkIconImpl();
        expect(
          icon.findIcon('folder', size: 48),
          '/usr/share/icons/TestTheme/48x48/places/folder.png',
        );
      });
    });

    test('returns overridden theme icon', () {
      ffi.using((arena) {
        mockLibGtk(
          allocator: arena,
          properties: {
            'gtk-icon-theme-name': MockGValue(gtk.G_TYPE_STRING, 'Yaru')
          },
          iconName: 'folder',
          themeName: 'TestTheme',
          iconFile: '/usr/share/icons/MyTheme/48x48/places/folder.png',
        );
        final icon = GtkIconImpl(themeName: 'MyTheme');
        expect(
          icon.findIcon('folder', size: 48),
          '/usr/share/icons/MyTheme/48x48/places/folder.png',
        );
      });
    });

    test('passes size and scale to lookup call', () {
      ffi.using((arena) {
        mockLibGtk(
          allocator: arena,
          properties: {
            'gtk-icon-theme-name': MockGValue(gtk.G_TYPE_STRING, 'Yaru')
          },
          iconName: 'folder',
          themeName: 'TestTheme',
          iconFile: '/usr/share/icons/T/96x96@2/folder.png',
        );
        final icon = GtkIconImpl();
        expect(
          icon.findIcon('folder', size: 48, scale: 2),
          '/usr/share/icons/T/96x96@2/folder.png',
        );
      });
    });
  });

  group('findIcon invalid', () {
    test('returns null when icon doesn\'t exist', () {
      ffi.using((arena) {
        mockLibGtk(
          allocator: arena,
          properties: {
            'gtk-icon-theme-name': MockGValue(gtk.G_TYPE_STRING, 'Yaru')
          },
          iconName: 'folder',
          themeName: 'TestTheme',
          iconFile: '/usr/share/icons/TestTheme/48x48/places/folder.png',
        );
        expect(GtkIconImpl().findIcon('nonexistent', size: 48), isNull);
      });
    });
  });
}
