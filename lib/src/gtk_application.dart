import 'package:flutter/widgets.dart';

import 'gtk_application_notifier.dart';

/// A widget that can be used to listen to remote GTK application command-line
/// arguments and file open requests from within the widget tree.
///
/// ```dart
/// import 'package:flutter/material.dart';
/// import 'package:gtk_application/gtk_application.dart';
///
/// void main() {
///   runApp(
///     MaterialApp(
///       home: GtkApplication(
///         onCommandLine: (args) => print('command-line: $args'),
///         onOpen: (files, hint) => print('open ($hint): $files'),
///         child: // ...
///       ),
///     ),
///   );
/// }
/// ```
///
/// See also:
///  * [GtkApplicationNotifier]
///  * [GApplication::command-line](https://docs.gtk.org/gio/signal.Application.command-line.html)
///  * [GApplication::open](https://docs.gtk.org/gio/signal.Application.open.html)
class GtkApplication extends StatefulWidget {
  /// Creates a new [GtkApplication] with and optional [onCommandLine] and/or
  /// [onOpen] callback.
  const GtkApplication({
    super.key,
    this.child,
    this.onCommandLine,
    this.onOpen,
    this.notifier,
  });

  /// An optional child widget below this widget in the tree.
  final Widget? child;

  /// An optional listener that will be notified when the application receives
  /// remote command-line arguments.
  final GtkCommandLineListener? onCommandLine;

  /// An optional listener that will be notified when the application receives
  /// remote file open requests.
  final GtkOpenListener? onOpen;

  /// An optional notifier that will be used to listen to remote command-line
  /// arguments and file open requests. If not specified, a new notifier will be
  /// created.
  final GtkApplicationNotifier? notifier;

  @override
  State<GtkApplication> createState() => _GtkApplicationState();
}

class _GtkApplicationState extends State<GtkApplication> {
  late GtkApplicationNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _initNotifier();
  }

  @override
  void didUpdateWidget(covariant GtkApplication oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notifier != widget.notifier) {
      _cleanupNotifier();
      _initNotifier();
    }
  }

  @override
  void dispose() {
    _cleanupNotifier();
    super.dispose();
  }

  void _initNotifier() {
    _notifier = widget.notifier ?? GtkApplicationNotifier();
    _notifier.addCommandLineListener(_onCommandLine);
    _notifier.addOpenListener(_onOpen);
  }

  void _cleanupNotifier() {
    _notifier.removeCommandLineListener(_onCommandLine);
    _notifier.removeOpenListener(_onOpen);
    if (widget.notifier == null) {
      _notifier.dispose();
    }
  }

  void _onCommandLine(List<String> args) {
    widget.onCommandLine?.call(args);
  }

  void _onOpen(List<String> files, String hint) {
    widget.onOpen?.call(files, hint);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox.shrink();
  }
}
