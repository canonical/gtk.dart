import 'package:flutter_test/flutter_test.dart';
import 'package:gtk_settings/gtk_settings.dart';

import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('notify', () async {
    final settings = GtkSettings();

    var wasNotified = 0;
    settings.addListener(() => ++wasNotified);

    settings
        .notifyValue('foo')
        .listen(expectAsync1((value) => expect(value, null), count: 1));

    await receiveMethodCall('notify', 'foo');
    expect(wasNotified, 1);
  });
}
