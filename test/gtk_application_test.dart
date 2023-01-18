import 'package:flutter_test/flutter_test.dart';
import 'package:gtk/gtk.dart';

import 'test_utils.dart';

void main() {
  testWidgets('command-line', (tester) async {
    final receivedArgs = <List<String>>[];
    final notifier = GtkApplicationNotifier();

    await tester.pumpWidget(GtkApplication(
      notifier: notifier,
      onCommandLine: receivedArgs.add,
    ));

    notifier.notifyCommandLine(['foo', 'bar']);
    expect(receivedArgs, [
      ['foo', 'bar']
    ]);

    await tester.pumpWidget(const GtkApplication());

    receivedArgs.clear();

    await receiveMethodCall('gtk/application', 'command-line', ['none']);
    expect(receivedArgs, isEmpty);
  });

  testWidgets('open', (tester) async {
    final receivedFiles = <List<String>>[];
    final receivedHints = <String>[];
    final notifier = GtkApplicationNotifier();

    void receiveOpen(List<String> files, String hint) {
      receivedFiles.add(files);
      receivedHints.add(hint);
    }

    await tester.pumpWidget(GtkApplication(
      notifier: notifier,
      onOpen: receiveOpen,
    ));

    notifier.notifyOpen(files: ['foo', 'bar'], hint: 'baz');
    expect(receivedFiles, [
      ['foo', 'bar']
    ]);
    expect(receivedHints, ['baz']);

    await tester.pumpWidget(const GtkApplication());

    receivedFiles.clear();
    receivedHints.clear();

    await receiveMethodCall('gtk/application', 'open', {
      'files': <String>[],
      'hint': '',
    });
    expect(receivedFiles, isEmpty);
    expect(receivedHints, isEmpty);
  });

  testWidgets('rebuild', (tester) async {
    var onCommandLine1 = 0;
    var onOpen1 = 0;
    final notifier1 = GtkApplicationNotifier();
    await tester.pumpWidget(
      GtkApplication(
        notifier: notifier1,
        onCommandLine: (_) => onCommandLine1++,
        onOpen: (_, __) => onOpen1++,
      ),
    );
    notifier1.notifyCommandLine(['foo']);
    expect(onCommandLine1, 1);
    notifier1.notifyOpen(files: ['foo'], hint: 'bar');
    expect(onOpen1, 1);

    var onCommandLine2 = 0;
    var onOpen2 = 0;
    final notifier2 = GtkApplicationNotifier();
    await tester.pumpWidget(
      GtkApplication(
        notifier: notifier2,
        onCommandLine: (_) => onCommandLine2++,
        onOpen: (_, __) => onOpen2++,
      ),
    );
    notifier2.notifyCommandLine(['foo']);
    expect(onCommandLine2, 1);
    notifier2.notifyOpen(files: ['foo'], hint: 'bar');
    expect(onOpen2, 1);

    notifier1.notifyCommandLine(['foo']);
    expect(onCommandLine1, 1);
    notifier1.notifyOpen(files: ['foo'], hint: 'bar');
    expect(onOpen1, 1);
  });
}
