import 'package:flutter_test/flutter_test.dart';
import 'package:gtk/gtk.dart';

import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('command-line', () async {
    final notifier = GtkApplicationNotifier(['foo']);
    expect(notifier.commandLine, ['foo']);

    final receivedArgs = <List<String>>[];
    notifier.addCommandLineListener(receivedArgs.add);

    await receiveMethodCall('gtk/application', 'command-line', ['foo', 'bar']);
    expect(receivedArgs, [
      ['foo', 'bar']
    ]);
    expect(notifier.commandLine, ['foo', 'bar']);

    await receiveMethodCall('gtk/application', 'command-line', ['baz qux']);
    expect(receivedArgs, [
      ['foo', 'bar'],
      ['baz qux'],
    ]);
    expect(notifier.commandLine, ['baz qux']);

    receivedArgs.clear();
    notifier.removeCommandLineListener(receivedArgs.add);

    await receiveMethodCall('gtk/application', 'command-line', ['none']);
    expect(receivedArgs, isEmpty);
    expect(notifier.commandLine, ['none']);
  });

  test('open', () async {
    final notifier = GtkApplicationNotifier();

    final receivedFiles = <List<String>>[];
    final receivedHints = <String>[];

    void receiveOpen(List<String> files, String hint) {
      receivedFiles.add(files);
      receivedHints.add(hint);
    }

    notifier.addOpenListener(receiveOpen);

    await receiveMethodCall('gtk/application', 'open', {
      'files': ['foo', 'bar'],
      'hint': 'baz'
    });
    expect(receivedFiles, [
      ['foo', 'bar']
    ]);
    expect(receivedHints, ['baz']);

    await receiveMethodCall('gtk/application', 'open', {
      'files': ['baz qux'],
      'hint': 'quux'
    });
    expect(receivedFiles, [
      ['foo', 'bar'],
      ['baz qux'],
    ]);
    expect(receivedHints, ['baz', 'quux']);

    receivedFiles.clear();
    receivedHints.clear();
    notifier.removeOpenListener(receiveOpen);

    await receiveMethodCall('gtk/application', 'open', {
      'files': <String>[],
      'hint': '',
    });
    expect(receivedFiles, isEmpty);
    expect(receivedHints, isEmpty);
  });
}
