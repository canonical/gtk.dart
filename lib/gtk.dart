library gtk;

export 'src/constants.dart';
export 'src/gtk_settings_stub.dart'
    if (dart.library.ffi) 'src/gtk_settings_real.dart';
