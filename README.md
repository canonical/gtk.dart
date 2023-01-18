# GTK+ utilities for Flutter Linux applications

[![license: MPL](https://img.shields.io/badge/license-MPL-magenta.svg)](https://opensource.org/licenses/MPL-2.0)
[![CI](https://github.com/ubuntu-flutter-community/gtk.dart/actions/workflows/ci.yaml/badge.svg)](https://github.com/ubuntu-flutter-community/gtk.dart/actions/workflows/ci.yaml)
[![codecov](https://codecov.io/gh/ubuntu-flutter-community/gtk.dart/branch/main/graph/badge.svg?token=c9t1uqCGob)](https://codecov.io/gh/ubuntu-flutter-community/gtk.dart)

## GtkSettings

[GtkSettings](https://docs.gtk.org/gtk3/class.Settings.html) provide a mechanism
to share global settings between applications on Linux.

![screenshot](https://raw.githubusercontent.com/ubuntu-flutter-community/gtk.dart/main/example/screenshot.png)

## GtkApplication

GtkApplication allows the primary Flutter [GTK application](https://developer.gnome.org/documentation/tutorials/application.html)
instance to listen to remote application instances' command-line arguments and
file open requests.

| **NOTE:** `linux/my_application.cc` must be modified for this package to be able to function. See "Getting Started" below for details. |
| --- |

[gtk-application.webm](https://user-images.githubusercontent.com/140617/194487627-093236b4-ee1a-4b05-82e7-72024b997cd1.webm)

### Getting Started

Apply the following changes to `linux/my_application.cc`:

<details><summary><code>my_application_activate()</code>: activate an existing window if present</summary>

```diff
diff --git a/example/linux/my_application.cc b/example/linux/my_application.cc
index 5cd43c6..94e7215 100644
--- a/linux/my_application.cc
+++ b/linux/my_application.cc
@@ -20,6 +20,12 @@ static void my_application_activate(GApplication* application) {
   GtkWindow* window =
       GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));
 
+  GList* windows = gtk_application_get_windows(GTK_APPLICATION(application));
+  if (windows) {
+    gtk_window_present(GTK_WINDOW(windows->data));
+    return;
+  }
+
   // Use a header bar when running in GNOME as this is the common style used
   // by applications and is the setup most users will be using (e.g. Ubuntu
   // desktop).
```
</details>

<details><summary><code>my_application_local_command_line()</code>: return <code>FALSE</code> to allow the package to handle the command line</summary>

```diff
--- a/linux/my_application.cc
+++ b/linux/my_application.cc
@@ -81,7 +81,7 @@ static gboolean my_application_local_command_line(GApplication* application,
   g_application_activate(application);
   *exit_status = 0;
 
-  return TRUE;
+  return FALSE;
 }
 
 // Implements GObject::dispose.

```
</details>


<details><summary><code>my_application_new()</code>: replace <code>G_APPLICATION_NON_UNIQUE</code> with <code>G_APPLICATION_HANDLES_COMMAND_LINE</code> and <code>G_APPLICATION_HANDLES_OPEN</code> flags</summary>

```diff
--- a/linux/my_application.cc
+++ b/linux/my_application.cc
@@ -101,7 +101,8 @@ static void my_application_class_init(MyApplicationClass* klass) {
 static void my_application_init(MyApplication* self) {}
 
 MyApplication* my_application_new() {
-  return MY_APPLICATION(g_object_new(my_application_get_type(),
-                                     "application-id", APPLICATION_ID, "flags",
-                                     G_APPLICATION_NON_UNIQUE, nullptr));
+  return MY_APPLICATION(g_object_new(
+      my_application_get_type(), "application-id", APPLICATION_ID, "flags",
+      G_APPLICATION_HANDLES_COMMAND_LINE | G_APPLICATION_HANDLES_OPEN,
+      nullptr));
 }
```
</details>

### Examples

The `GtkApplication` widget allows listening to remote application instances'
command-line arguments and file open requests from within the widget tree.

```dart
import 'package:flutter/material.dart';
import 'package:gtk_application/gtk_application.dart';

void main() {
  runApp(
    MaterialApp(
      home: GtkApplication(
        onCommandLine: (args) => print('command-line: $args'),
        onOpen: (files, hint) => print('open ($hint): $files'),
        child: // ...
      ),
    ),
  );
}
```

The `GtkApplicationNotifier` object allows listening to remote application
instances' command-line arguments and file open requests outside the widget
tree.

```dart
import 'package:flutter/widgets.dart';
import 'package:gtk_application/gtk_application.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final notifier = GtkApplicationNotifier();
  notifier.addCommandLineListener((args) {
    print('command-line: $args');
  });
  notifier.addOpenListener((files, hint) {
    print('open ($hint): $files');
  });

  // ...
  // notifier.dispose();
}
```
