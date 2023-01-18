import 'package:flutter/material.dart';
import 'package:gtk/gtk.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';

const properties = [
  kGtkAlternativeButtonOrder,
  kGtkAlternativeSortArrows,
  kGtkApplicationPreferDarkTheme,
  kGtkCursorAspectRatio,
  kGtkCursorBlink,
  kGtkCursorBlinkTime,
  kGtkCursorBlinkTimeout,
  kGtkCursorThemeName,
  kGtkCursorThemeSize,
  kGtkDecorationLayout,
  kGtkDialogsUseHeader,
  kGtkDndDragThreshold,
  kGtkDoubleClickDistance,
  kGtkDoubleClickTime,
  kGtkEnableAccels,
  kGtkEnableAnimations,
  kGtkEnableEventSounds,
  kGtkEnableInputFeedbackSounds,
  kGtkEnablePrimaryPaste,
  kGtkEntryPasswordHintTimeout,
  kGtkEntrySelectOnFocus,
  kGtkErrorBell,
  kGtkFontName,
  kGtkFontconfigTimestamp,
  kGtkIconThemeName,
  kGtkImModule,
  kGtkKeyThemeName,
  kGtkKeynavUseCaret,
  kGtkLabelSelectOnFocus,
  kGtkLongPressTime,
  kGtkModules,
  kGtkOverlayScrolling,
  kGtkPrimaryButtonWarpsSlider,
  kGtkPrintBackends,
  kGtkPrintPreviewCommand,
  kGtkRecentFilesEnabled,
  kGtkRecentFilesMaxAge,
  kGtkShellShowsAppMenu,
  kGtkShellShowsDesktop,
  kGtkShellShowsMenubar,
  kGtkSoundThemeName,
  kGtkSplitCursor,
  kGtkThemeName,
  kGtkTitlebarDoubleClick,
  kGtkTitlebarMiddleClick,
  kGtkTitlebarRightClick,
  kGtkXftAntialias,
  kGtkXftDpi,
  kGtkXftHinting,
  kGtkXftHintstyle,
  kGtkXftRgba,
];

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => GtkSettings(),
      child: const GtkSettingsApp(),
    ),
  );
}

class GtkSettingsApp extends StatelessWidget {
  const GtkSettingsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      builder: (context, yaru, builder) => MaterialApp(
        theme: yaru.theme,
        darkTheme: yaru.darkTheme,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('GtkSettings'),
          ),
          body: ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) => GtkSettingsTile(properties[index]),
          ),
        ),
      ),
    );
  }
}

class GtkSettingsTile extends StatelessWidget {
  const GtkSettingsTile(this.property, {super.key});

  final String property;

  @override
  Widget build(BuildContext context) {
    final value = context.select((GtkSettings s) => s.getValue(property));
    return ListTile(
      title: Text(value.toString()),
      subtitle: Text(property),
    );
  }
}
