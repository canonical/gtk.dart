import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The signature of a callback that receives remote command-line arguments.
///
/// See also:
///  * [GApplication::command-line](https://docs.gtk.org/gio/signal.Application.command-line.html)
typedef GtkCommandLineListener = void Function(List<String> args);

/// The signature of a callback that receives remote file open requests.
///
/// See also:
///  * [GApplication::open](https://docs.gtk.org/gio/signal.Application.open.html)
typedef GtkOpenListener = void Function(List<String> files, String hint);

/// An object that can be used to listen to remote GTK application command-line
/// arguments and file open requests outside the widget tree.
///
/// ```dart
/// import 'package:flutter/widgets.dart';
/// import 'package:gtk_application/gtk_application.dart';
///
/// void main(List<String> args) {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   final notifier = GtkApplicationNotifier(args);
///   notifier.addCommandLineListener((args) {
///     print('command-line: $args');
///   });
///   notifier.addOpenListener((files, hint) {
///     print('open ($hint): $files');
///   });
///
///   // ...
///   // notifier.dispose();
/// }
/// ```
///
/// See also:
///  * [GtkApplication]
///  * [GApplication::command-line](https://docs.gtk.org/gio/signal.Application.command-line.html)
///  * [GApplication::open](https://docs.gtk.org/gio/signal.Application.open.html)
class GtkApplicationNotifier {
  /// Creates a new [GtkApplicationNotifier]. Optionally, the initial value of
  /// [commandLine] can be provided.
  GtkApplicationNotifier([this._commandLine]) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  List<String>? _commandLine;
  final _channel = const MethodChannel('gtk/application');
  final _commandLineListeners = <GtkCommandLineListener>[];
  final _openListeners = <GtkOpenListener>[];

  /// Returns the most recent command-line arguments.
  ///
  /// This is either the most recently received remote command-line arguments,
  /// the initial value provided via the constructor, or `null` if none of those
  /// are available.
  List<String>? get commandLine => _commandLine;

  /// Adds a [listener] that will be notified when the application receives
  /// remote command-line arguments.
  void addCommandLineListener(GtkCommandLineListener listener) {
    _commandLineListeners.add(listener);
  }

  /// Removes a previously registered remote command-line argument [listener].
  void removeCommandLineListener(GtkCommandLineListener listener) {
    _commandLineListeners.remove(listener);
  }

  /// Adds a [listener] that will be notified when the application receives
  /// remote file open requests.
  void addOpenListener(GtkOpenListener listener) {
    _openListeners.add(listener);
  }

  /// Removes a previously registered remote file open request [listener].
  void removeOpenListener(GtkOpenListener listener) {
    _openListeners.remove(listener);
  }

  /// Discards any resources used by the object. After this is called, the
  /// listeners will no longer be notified.
  void dispose() {
    _channel.setMethodCallHandler(null);
    _commandLineListeners.clear();
    _openListeners.clear();
  }

  /// Notify all the remote command-line argument listeners.
  @protected
  @visibleForTesting
  void notifyCommandLine(List<String> args) {
    _commandLine = args;
    final listeners = List.of(_commandLineListeners);
    for (final listener in listeners) {
      listener(args);
    }
  }

  /// Notify all the remote file open request listeners.
  @protected
  @visibleForTesting
  void notifyOpen({required List<String> files, required String hint}) {
    final listeners = List.of(_openListeners);
    for (final listener in listeners) {
      listener(files, hint);
    }
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'command-line':
        final args = call.arguments as List;
        notifyCommandLine(args.cast<String>());
        break;
      case 'open':
        final args = call.arguments as Map;
        notifyOpen(
          files: (args['files'] as List).cast<String>(),
          hint: args['hint'].toString(),
        );
        break;
      default:
        throw UnsupportedError(call.method);
    }
  }
}
