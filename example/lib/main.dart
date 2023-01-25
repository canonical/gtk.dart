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
      child: const ExampleApp(),
    ),
  );
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      builder: (context, yaru, builder) => MaterialApp(
        theme: yaru.theme,
        darkTheme: yaru.darkTheme,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('gtk.dart'),
          ),
          body: const ExamplePage(),
        ),
      ),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GtkApplication(
      onCommandLine: (args) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('command-line'),
            content: Text(args.toString()),
            actions: [
              OutlinedButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      onOpen: (files, hint) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('open $hint'),
            content: Column(
              children: files.map((f) => Text(f)).toList(),
            ),
            actions: [
              OutlinedButton(
                onPressed: Navigator.of(context).pop,
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      child: ListView.builder(
        itemCount: properties.length,
        itemBuilder: (context, index) => SettingsTile(properties[index]),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile(this.property, {super.key});

  final String property;

  @override
  Widget build(BuildContext context) {
    final value = context.select((GtkSettings s) => s.getProperty(property));
    return ListTile(
      title: Text(value.toString()),
      subtitle: Text(property),
    );
  }
}
