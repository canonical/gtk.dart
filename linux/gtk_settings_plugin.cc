#include "include/gtk_settings/gtk_settings_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>

struct _GtkSettingsPlugin {
  GObject parent_instance;
  FlBinaryMessenger* messenger;
};

G_DEFINE_TYPE(GtkSettingsPlugin, gtk_settings_plugin, g_object_get_type())

static FlValue* to_fl_value(GValue* value) {
  if (value == nullptr) {
    return fl_value_new_null();
  }
  switch (G_VALUE_TYPE(value)) {
    case G_TYPE_BOOLEAN:
      return fl_value_new_bool(g_value_get_boolean(value));
    case G_TYPE_CHAR:
      return fl_value_new_int(g_value_get_schar(value));
    case G_TYPE_UCHAR:
      return fl_value_new_int(g_value_get_uchar(value));
    case G_TYPE_INT:
      return fl_value_new_int(g_value_get_int(value));
    case G_TYPE_UINT:
      return fl_value_new_int(g_value_get_uint(value));
    case G_TYPE_LONG:
      return fl_value_new_int(g_value_get_long(value));
    case G_TYPE_ULONG:
      return fl_value_new_int(g_value_get_ulong(value));
    case G_TYPE_INT64:
      return fl_value_new_int(g_value_get_int64(value));
    case G_TYPE_UINT64:
      return fl_value_new_int(g_value_get_uint64(value));
    case G_TYPE_FLOAT:
      return fl_value_new_float(g_value_get_float(value));
    case G_TYPE_DOUBLE:
      return fl_value_new_float(g_value_get_double(value));
    case G_TYPE_STRING:
      return fl_value_new_string(g_value_get_string(value));
    default:
      return nullptr;
  }
  return nullptr;
}

static GValue* to_g_value(GType type, FlValue* value) {
  GValue* result = g_new0(GValue, 1);
  g_value_init(result, type);
  switch (type) {
    case G_TYPE_BOOLEAN:
      g_value_set_boolean(result, fl_value_get_bool(value));
      break;
    case G_TYPE_CHAR:
      g_value_set_schar(result, fl_value_get_int(value));
      break;
    case G_TYPE_UCHAR:
      g_value_set_uchar(result, fl_value_get_int(value));
      break;
    case G_TYPE_INT:
      g_value_set_int(result, fl_value_get_int(value));
      break;
    case G_TYPE_UINT:
      g_value_set_uint(result, fl_value_get_int(value));
      break;
    case G_TYPE_LONG:
      g_value_set_long(result, fl_value_get_int(value));
      break;
    case G_TYPE_ULONG:
      g_value_set_ulong(result, fl_value_get_int(value));
      break;
    case G_TYPE_INT64:
      g_value_set_int64(result, fl_value_get_int(value));
      break;
    case G_TYPE_UINT64:
      g_value_set_uint64(result, fl_value_get_int(value));
      break;
    case G_TYPE_FLOAT:
      g_value_set_float(result, fl_value_get_float(value));
      break;
    case G_TYPE_DOUBLE:
      g_value_set_double(result, fl_value_get_float(value));
      break;
    case G_TYPE_STRING:
      g_value_set_string(result, fl_value_get_string(value));
      break;
    default:
      g_free(result);
      return nullptr;
  }
  return result;
}

static FlMethodResponse* get_value(FlValue* args) {
  GtkSettings* settings = gtk_settings_get_default();
  const gchar* key = fl_value_get_string(args);
  GValue value = G_VALUE_INIT;
  g_object_get_property(G_OBJECT(settings), key, &value);
  g_autoptr(FlValue) result = to_fl_value(&value);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse* set_value(FlValue* key, FlValue* type,
                                   FlValue* value) {
  g_autofree GValue* g_value = to_g_value(fl_value_get_int(type), value);
  GtkSettings* settings = gtk_settings_get_default();
  g_object_set_property(G_OBJECT(settings), fl_value_get_string(key), g_value);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

static FlMethodResponse* reset_value(FlValue* key) {
  GtkSettings* settings = gtk_settings_get_default();
  gtk_settings_reset_property(settings, fl_value_get_string(key));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

static void notify_cb(GObject* object, GParamSpec* pspec, gpointer user_data) {
  const gchar* name = g_param_spec_get_name(pspec);
  GValue value = G_VALUE_INIT;
  g_object_get_property(object, name, &value);

  g_autoptr(FlValue) event = to_fl_value(&value);
  FlEventChannel* channel = FL_EVENT_CHANNEL(user_data);
  fl_event_channel_send(channel, event, nullptr, nullptr);
}

static FlMethodResponse* listen_value(FlBinaryMessenger* messenger,
                                      FlValue* key) {
  static gint id = 0;
  g_autofree gchar* name = g_strdup_printf("gtk_settings/%d", ++id);

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  FlEventChannel* channel =
      fl_event_channel_new(messenger, name, FL_METHOD_CODEC(codec));
  fl_event_channel_set_stream_handlers(channel, nullptr, nullptr, nullptr,
                                       nullptr);

  GtkSettings* settings = gtk_settings_get_default();
  g_autofree gchar* signal =
      g_strdup_printf("notify::%s", fl_value_get_string(key));
  gint handler = g_signal_connect(G_OBJECT(settings), signal,
                                  G_CALLBACK(notify_cb), channel);

  g_autoptr(FlValue) result = fl_value_new_list();
  fl_value_append_take(result, fl_value_new_string(name));
  fl_value_append_take(result, fl_value_new_int(handler));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static FlMethodResponse* cancel_value(FlValue* handler) {
  g_signal_handler_disconnect(gtk_settings_get_default(),
                              fl_value_get_int(handler));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(nullptr));
}

static void gtk_settings_plugin_handle_method_call(GtkSettingsPlugin* self,
                                                   FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);
  FlValue* args = fl_method_call_get_args(method_call);

  if (strcmp(method, "getValue") == 0) {
    response = get_value(args);
  } else if (strcmp(method, "setValue") == 0) {
    FlValue* key = fl_value_get_list_value(args, 0);
    FlValue* type = fl_value_get_list_value(args, 1);
    FlValue* value = fl_value_get_list_value(args, 2);
    response = set_value(key, type, value);
  } else if (strcmp(method, "resetValue") == 0) {
    response = reset_value(args);
  } else if (strcmp(method, "listenValue") == 0) {
    response = listen_value(self->messenger, args);
  } else if (strcmp(method, "cancelValue") == 0) {
    response = cancel_value(args);
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void gtk_settings_plugin_dispose(GObject* object) {
  GtkSettingsPlugin* self = GTK_SETTINGS_PLUGIN(object);
  g_clear_object(&self->messenger);

  G_OBJECT_CLASS(gtk_settings_plugin_parent_class)->dispose(object);
}

static void gtk_settings_plugin_class_init(GtkSettingsPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = gtk_settings_plugin_dispose;
}

static void gtk_settings_plugin_init(GtkSettingsPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  GtkSettingsPlugin* plugin = GTK_SETTINGS_PLUGIN(user_data);
  gtk_settings_plugin_handle_method_call(plugin, method_call);
}

void gtk_settings_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  g_autoptr(GtkSettingsPlugin) plugin = GTK_SETTINGS_PLUGIN(
      g_object_new(gtk_settings_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  plugin->messenger = FL_BINARY_MESSENGER(
      g_object_ref(fl_plugin_registrar_get_messenger(registrar)));

  g_autoptr(FlMethodChannel) channel = fl_method_channel_new(
      plugin->messenger, "gtk_settings", FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      channel, method_call_cb, g_object_ref(plugin), g_object_unref);
}
