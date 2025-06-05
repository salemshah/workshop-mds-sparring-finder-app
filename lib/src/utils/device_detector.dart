// lib/utils/device_detector.dart

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

/// Enum to represent the four possible runtime targets.
enum DeviceType {
  iosRealDevice,
  iosSimulator,
  androidRealDevice,
  androidEmulator,
  unknown,
}

/// A utility that inspects Platform + DeviceInfoPlugin to figure out
/// if we’re running on:
///   • iOS real device
///   • iOS simulator
///   • Android real device
///   • Android emulator
///
/// If it can’t determine, it returns [DeviceType.unknown].
class DeviceDetector {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Returns a [DeviceType] describing the current runtime.
  ///
  /// On iOS: checks `IosDeviceInfo.isPhysicalDevice`.
  /// On Android: checks `AndroidDeviceInfo.isPhysicalDevice`.
  /// Otherwise: returns `DeviceType.unknown`.
  static Future<DeviceType> getDeviceType() async {
    try {
      if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        // `isPhysicalDevice == true` → real device; false → simulator
        return (iosInfo.isPhysicalDevice ?? false)
            ? DeviceType.iosRealDevice
            : DeviceType.iosSimulator;
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        // `isPhysicalDevice == true` → real device; false → emulator
        return (androidInfo.isPhysicalDevice ?? false)
            ? DeviceType.androidRealDevice
            : DeviceType.androidEmulator;
      }
    } catch (_) {
      // If plugin fails or throws, fall through to unknown
    }
    return DeviceType.unknown;
  }
}
