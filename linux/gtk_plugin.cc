#include "include/gtk/gtk_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

struct _GtkPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(GtkPlugin, gtk_plugin, g_object_get_type())

static void settings_notify_cb(GObject* object, GParamSpec* pspec,
                               gpointer user_data) {
  FlMethodChannel* channel = FL_METHOD_CHANNEL(user_data);
  const gchar* name = g_param_spec_get_name(pspec);
  g_autoptr(FlValue) args = fl_value_new_string(name);
  fl_method_channel_invoke_method(channel, "notify", args, nullptr, nullptr,
                                  nullptr);
}

static void gtk_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(gtk_plugin_parent_class)->dispose(object);
}

static void gtk_plugin_class_init(GtkPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = gtk_plugin_dispose;
}

static void gtk_plugin_init(GtkPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {}

void gtk_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  g_autoptr(GtkPlugin) plugin =
      GTK_PLUGIN(g_object_new(gtk_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  FlBinaryMessenger* messenger = fl_plugin_registrar_get_messenger(registrar);

  g_autoptr(FlMethodChannel) settings_channel =
      fl_method_channel_new(messenger, "gtk/settings", FL_METHOD_CODEC(codec));

  fl_method_channel_set_method_call_handler(
      settings_channel, method_call_cb, g_object_ref(plugin), g_object_unref);

  GtkSettings* settings = gtk_settings_get_default();
  g_signal_connect_object(G_OBJECT(settings), "notify",
                          G_CALLBACK(settings_notify_cb), settings_channel,
                          GConnectFlags(0));
}
