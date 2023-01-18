#ifndef FLUTTER_PLUGIN_GTK_PLUGIN_H_
#define FLUTTER_PLUGIN_GTK_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

G_DECLARE_FINAL_TYPE(GtkPlugin, gtk_plugin, GTK, PLUGIN, GObject)

FLUTTER_PLUGIN_EXPORT GType gtk_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void gtk_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_GTK_PLUGIN_H_
