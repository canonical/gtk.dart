#include "include/gtk_settings/gtk_settings_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

struct _GtkSettingsPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(GtkSettingsPlugin, gtk_settings_plugin, g_object_get_type())

static void notify_cb(GObject* object, GParamSpec* pspec, gpointer user_data) {
  FlMethodChannel* channel = FL_METHOD_CHANNEL(user_data);
  const gchar* name = g_param_spec_get_name(pspec);
  g_autoptr(FlValue) args = fl_value_new_string(name);
  fl_method_channel_invoke_method(channel, "notify", args, nullptr, nullptr,
                                  nullptr);
}

static void gtk_settings_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(gtk_settings_plugin_parent_class)->dispose(object);
}

static void gtk_settings_plugin_class_init(GtkSettingsPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = gtk_settings_plugin_dispose;
}

static void gtk_settings_plugin_init(GtkSettingsPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {}

void gtk_settings_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  g_autoptr(GtkSettingsPlugin) plugin = GTK_SETTINGS_PLUGIN(
      g_object_new(gtk_settings_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  FlBinaryMessenger* messenger = fl_plugin_registrar_get_messenger(registrar);

  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(messenger, "gtk_settings", FL_METHOD_CODEC(codec));

  fl_method_channel_set_method_call_handler(
      channel, method_call_cb, g_object_ref(plugin), g_object_unref);

  GtkSettings* settings = gtk_settings_get_default();
  g_signal_connect_object(G_OBJECT(settings), "notify", G_CALLBACK(notify_cb),
                          channel, GConnectFlags(0));
}
