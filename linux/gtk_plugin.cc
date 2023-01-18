#include "include/gtk/gtk_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

struct _GtkPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(GtkPlugin, gtk_plugin, g_object_get_type())

static void method_response_cb(GObject* object, GAsyncResult* result,
                               gpointer user_data) {
  FlMethodChannel* channel = FL_METHOD_CHANNEL(user_data);
  g_autoptr(GError) error = nullptr;
  g_autoptr(FlMethodResponse) response =
      fl_method_channel_invoke_method_finish(channel, result, &error);
  if (response == nullptr) {
    g_warning("gtk.dart: failed to call method: %s", error->message);
  }
}

static gint app_command_line_cb(GApplication* application,
                                GApplicationCommandLine* command_line,
                                gpointer user_data) {
  FlMethodChannel* channel = FL_METHOD_CHANNEL(user_data);
  gchar** arguments =
      g_application_command_line_get_arguments(command_line, nullptr);
  g_autoptr(FlValue) value = fl_value_new_list_from_strv(arguments + 1);
  g_strfreev(arguments);
  fl_method_channel_invoke_method(channel, "command-line", value, nullptr,
                                  method_response_cb, channel);
  return 0;
}

static void app_open_cb(GApplication* application, GFile** files, gint n_files,
                        gchar* hint, gpointer user_data) {
  FlMethodChannel* method_channel = FL_METHOD_CHANNEL(user_data);
  g_autoptr(FlValue) value = fl_value_new_map();
  FlValue* list = fl_value_new_list();
  for (int i = 0; i < n_files; ++i) {
    fl_value_append_take(list, fl_value_new_string(g_file_get_uri(files[i])));
  }
  fl_value_set_string_take(value, "files", list);
  fl_value_set_string_take(value, "hint", fl_value_new_string(hint));
  fl_method_channel_invoke_method(method_channel, "open", value, nullptr,
                                  method_response_cb, method_channel);
}

static void settings_notify_cb(GObject* object, GParamSpec* pspec,
                               gpointer user_data) {
  FlMethodChannel* channel = FL_METHOD_CHANNEL(user_data);
  const gchar* name = g_param_spec_get_name(pspec);
  g_autoptr(FlValue) args = fl_value_new_string(name);
  fl_method_channel_invoke_method(channel, "notify", args, nullptr,
                                  method_response_cb, channel);
}

static void gtk_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(gtk_plugin_parent_class)->dispose(object);
}

static void gtk_plugin_class_init(GtkPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = gtk_plugin_dispose;
}

static void gtk_plugin_init(GtkPlugin* self) {}

void gtk_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  g_autoptr(FlMethodCodec) codec =
      FL_METHOD_CODEC(fl_standard_method_codec_new());
  FlBinaryMessenger* messenger = fl_plugin_registrar_get_messenger(registrar);

  GApplication* app = g_application_get_default();
  g_autoptr(FlMethodChannel) app_channel =
      fl_method_channel_new(messenger, "gtk/application", codec);
  g_signal_connect_data(G_OBJECT(app), "command-line",
                        G_CALLBACK(app_command_line_cb),
                        g_object_ref(app_channel),
                        GClosureNotify(g_object_unref), GConnectFlags(0));
  g_signal_connect_data(G_OBJECT(app), "open", G_CALLBACK(app_open_cb),
                        g_object_ref(app_channel),
                        GClosureNotify(g_object_unref), GConnectFlags(0));

  GtkSettings* settings = gtk_settings_get_default();
  g_autoptr(FlMethodChannel) settings_channel =
      fl_method_channel_new(messenger, "gtk/settings", codec);
  g_signal_connect_data(G_OBJECT(settings), "notify",
                        G_CALLBACK(settings_notify_cb),
                        g_object_ref(settings_channel),
                        GClosureNotify(g_object_unref), GConnectFlags(0));
}
