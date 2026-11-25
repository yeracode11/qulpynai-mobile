import Flutter
import UIKit
import YandexMapsMobile

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// Yandex MapKit key from Info.plist (filled from ios/Flutter/Secrets.xcconfig, not in git).
  private var mapKitKey: String {
    let key = Bundle.main.object(forInfoDictionaryKey: "YandexMapKitApiKey") as? String ?? ""
    return key.hasPrefix("$(") ? "" : key.trimmingCharacters(in: .whitespaces)
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // MapKit must get some key before the plugin starts it. Without a real key the
    // app shows its own map placeholder instead of the Yandex map.
    YMKMapKit.setLocale("ru_RU")
    YMKMapKit.setApiKey(mapKitKey.isEmpty ? "no-key" : mapKitKey)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let hasKey = !mapKitKey.isEmpty
    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "QulpynaiMaps") else { return }
    let channel = FlutterMethodChannel(name: "kz.qulpynai/maps", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { call, result in
      call.method == "hasKey" ? result(hasKey) : result(FlutterMethodNotImplemented)
    }
  }
}
