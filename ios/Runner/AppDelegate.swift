import UIKit
import Flutter
import Firebase
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 1) Provide your iOS‐restricted Google Maps API key here:
    GMSServices.provideAPIKey("AIzaSyA6dM7IW6g4MAmw4I3R_Awg2VqZLzuVTWc")

    // 2) Then register all Flutter plugins as usual:
    GeneratedPluginRegistrant.register(with: self)

    // 3) Continue with any other setup (e.g., Firebase)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}