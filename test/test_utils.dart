import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> receiveMethodCall(String method, [dynamic arguments]) async {
  const codec = StandardMethodCodec();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance!.defaultBinaryMessenger;

  await messenger.handlePlatformMessage(
    'gtk_settings',
    codec.encodeMethodCall(MethodCall(method, arguments)),
    (_) {},
  );
}
