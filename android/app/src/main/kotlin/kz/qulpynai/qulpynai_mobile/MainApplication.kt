package kz.qulpynai.qulpynai_mobile

import android.content.pm.PackageManager
import com.yandex.mapkit.MapKitFactory
import io.flutter.app.FlutterApplication

/** Hands the Yandex MapKit key (from local.properties via the manifest) to MapKit. */
class MainApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        MapKitFactory.setLocale("ru_RU")
        // MapKit must get some key before the plugin starts it. Without a real key
        // the app shows its own map placeholder instead of the Yandex map.
        MapKitFactory.setApiKey(mapKitKey(this).ifEmpty { "no-key" })
    }

    companion object {
        fun mapKitKey(app: android.content.Context): String {
            val info = app.packageManager.getApplicationInfo(app.packageName, PackageManager.GET_META_DATA)
            return info.metaData?.getString("kz.qulpynai.YANDEX_MAPKIT_API_KEY").orEmpty().trim()
        }
    }
}
