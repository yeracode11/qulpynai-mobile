package kz.qulpynai.qulpynai_mobile

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val hasKey = MainApplication.mapKitKey(applicationContext).isNotEmpty()
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "kz.qulpynai/maps").setMethodCallHandler { call, result ->
            if (call.method == "hasKey") result.success(hasKey) else result.notImplemented()
        }
    }
}
