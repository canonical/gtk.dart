import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:gtk_settings/gtk_settings.dart';
import 'package:yaru/yaru.dart';

const settings = GtkSettings();

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

void main() => runApp(const GtkSettingsApp());

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
    return StreamBuilder(
      key: Key(property),
      stream: StreamGroup.merge([
        settings.getValue(property).asStream(),
        settings.notifyValue(property),
      ]),
      builder: (context, snapshot) {
        return ListTile(
          title: Text(snapshot.data.toString()),
          subtitle: Text(property),
        );
      },
    );
  }
}
