# flutter_local_notifications usa Gson via reflection per serializzare
# i dettagli delle notifiche pianificate.
-keep class com.dexterous.** { *; }
-keep class * extends com.google.gson.TypeAdapter
-keepattributes Signature
-keepattributes *Annotation*
