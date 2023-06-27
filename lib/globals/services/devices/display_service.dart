// ignore_for_file: camel_case_types, constant_identifier_names

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:win32/win32.dart';

/// A display monitor.
class Display {
  final String name;
  final String rawName;
  final int _deviceIndex;
  final int _stateFlags;

  Display._(this.rawName, this._deviceIndex, this._stateFlags) : name = rawName.replaceAll(RegExp(r'[^a-zA-Z\d]'), '');

  /// Returns the primary [Display].
  static Display get primary => findAll().firstWhere((display) => display.isPrimary);

  /// Finds a [Display] by its [name] (e.g. `DISPLAY2`).
  static Display? findByName(String name) => findAll().where((display) => display.name == name).firstOrNull;

  /// Returns all [Display]s on the system.
  static Iterable<Display> findAll() sync* {
    final pDevice = calloc<DISPLAY_DEVICE>();
    final device = pDevice.ref..cb = sizeOf<DISPLAY_DEVICE>();

    var deviceIndex = 0;

    while (EnumDisplayDevices(nullptr, deviceIndex, pDevice, 0) != FALSE) {
      yield Display._(device.DeviceName, deviceIndex, device.StateFlags);
      deviceIndex++;
    }

    free(pDevice);
  }

  /// Returns `true` if the [Display] is connected.
  bool get isConnected => (_stateFlags & DISPLAY_DEVICE_ACTIVE) == DISPLAY_DEVICE_ACTIVE;

  /// Returns `true` if the [Display] is the primary display.
  bool get isPrimary => (_stateFlags & DISPLAY_DEVICE_PRIMARY_DEVICE) == DISPLAY_DEVICE_PRIMARY_DEVICE;

  /// Sets the [Display] as the primary display.
  void setAsPrimary() {
    assert(isConnected);

    if (isPrimary) {
      if (kDebugMode) print('This display is already set as the primary display.');
      return;
    }

    using((arena) {
      final pDevice = arena<DISPLAY_DEVICE>();
      final device = pDevice.ref..cb = sizeOf<DISPLAY_DEVICE>();

      var result = EnumDisplayDevices(nullptr, _deviceIndex, pDevice, 0);
      if (result == FALSE) {
        if (kDebugMode) print('Failed to get display devices.');
        return;
      }

      final pDeviceName = device.DeviceName.toNativeUtf16(allocator: arena);
      final pMode = arena<DEVMODE>();
      final mode = pMode.ref;

      result = EnumDisplaySettings(pDeviceName, ENUM_CURRENT_SETTINGS, pMode);
      if (result == FALSE) {
        if (kDebugMode) print('Failed to get current display settings.');
        return;
      }

      final offsetX = mode.dmPosition.x;
      final offsetY = mode.dmPosition.y;
      mode.dmPosition.x = 0;
      mode.dmPosition.y = 0;

      result =
          ChangeDisplaySettingsEx(pDeviceName, pMode, 0, CDS_SET_PRIMARY | CDS_UPDATEREGISTRY | CDS_NORESET, nullptr);
      if (result != DISP_CHANGE_SUCCESSFUL) {
        if (kDebugMode) print('Failed to change display settings.');
        return;
      }

      var deviceIndex = 0;

      // Update remaining displays
      while (EnumDisplayDevices(nullptr, deviceIndex, pDevice, 0) != FALSE) {
        final device = pDevice.ref;

        if (_isAttachedToDesktop(device.StateFlags) && deviceIndex != _deviceIndex) {
          final pDeviceName = device.DeviceName.toNativeUtf16(allocator: arena);
          final pMode = arena<DEVMODE>();
          final mode = pMode.ref;

          result = EnumDisplaySettings(pDeviceName, ENUM_CURRENT_SETTINGS, pMode);
          if (result == FALSE) {
            if (kDebugMode) print('Failed to get current display settings.');
            return;
          }

          mode.dmPosition.x -= offsetX;
          mode.dmPosition.y -= offsetY;

          result = ChangeDisplaySettingsEx(pDeviceName, pMode, 0, CDS_UPDATEREGISTRY | CDS_NORESET, nullptr);
          if (result != DISP_CHANGE_SUCCESSFUL) {
            if (kDebugMode) print('Failed to change display settings.');
            return;
          }
        }

        deviceIndex++;
      }

      // Apply settings
      result = ChangeDisplaySettingsEx(nullptr, nullptr, 0, 0, nullptr);
      if (result != DISP_CHANGE_SUCCESSFUL) {
        if (kDebugMode) print('Failed to change display settings.');
        return;
      }
    });
  }

  bool _isAttachedToDesktop(int stateFlags) =>
      (stateFlags & DisplayDeviceStateFlags_AttachedToDesktop) == DisplayDeviceStateFlags_AttachedToDesktop;

  /// Returns `true` if the [Display] supports the given [resolution].
  bool supportsResolution(Resolution resolution) {
    assert(isConnected);
    return supportedResolutions.contains(resolution);
  }

  /// Gets the [Display]'s current resolution.
  Resolution get resolution {
    assert(isConnected);

    final pDisplayName = rawName.toNativeUtf16();
    final pMode = calloc<DEVMODE>();
    final mode = pMode.ref..dmSize = sizeOf<DEVMODE>();

    try {
      final result = EnumDisplaySettings(pDisplayName, ENUM_CURRENT_SETTINGS, pMode);
      if (result == FALSE) {
        throw Exception('Failed to get current display settings.');
      }

      return (width: mode.dmPelsWidth, height: mode.dmPelsHeight);
    } finally {
      free(pMode);
      free(pDisplayName);
    }
  }

  /// Sets the [Display]'s resolution to the given [resolution].
  set resolution(Resolution resolution) {
    assert(isConnected);

    if (!supportsResolution(resolution)) {
      if (kDebugMode) print('Display does not support resolution ${resolution.prettify}.');
      return;
    }

    final (:width, :height) = resolution;

    using((arena) {
      final pDisplayName = rawName.toNativeUtf16(allocator: arena);
      final pMode = arena<DEVMODE>();
      final mode = pMode.ref..dmSize = sizeOf<DEVMODE>();

      var result = EnumDisplaySettings(pDisplayName, ENUM_CURRENT_SETTINGS, pMode);
      if (result == FALSE) {
        if (kDebugMode) print('Failed to get current display settings.');
        return;
      }

      if (mode.dmPelsHeight == height && mode.dmPelsWidth == width) {
        if (kDebugMode) print('Display resolution is already set to ${resolution.prettify()}.');
        return;
      }

      pMode.ref
        ..dmPelsWidth = width
        ..dmPelsHeight = height
        ..dmFields = DM_PELSWIDTH | DM_PELSHEIGHT;

      result = ChangeDisplaySettingsEx(pDisplayName, pMode, 0, CDS_RESET | CDS_UPDATEREGISTRY, nullptr);

      if (result != DISP_CHANGE_SUCCESSFUL) {
        if (kDebugMode) print('Failed to change display settings.');
        return;
      }
    });
  }

  /// Returns all supported resolutions of the [Display].
  Iterable<Resolution> get supportedResolutions sync* {
    assert(isConnected);

    final pDisplayName = rawName.toNativeUtf16();
    final pMode = calloc<DEVMODE>();
    final mode = pMode.ref..dmSize = sizeOf<DEVMODE>();

    var modeIndex = 0; // 0 = The first mode
    var previousResolution = (width: -1, height: -1);

    while (EnumDisplaySettings(pDisplayName, modeIndex, pMode) != FALSE) {
      final resolution = (width: mode.dmPelsWidth, height: mode.dmPelsHeight);
      if (previousResolution != resolution) {
        previousResolution = resolution;
        yield resolution;
      }
      modeIndex++;
    }

    free(pMode);
    free(pDisplayName);
  }

  @override
  String toString() => 'Display(name: $name, isConnected: $isConnected, isPrimary: $isPrimary)';
}

typedef Resolution = ({int width, int height});

extension on Resolution {
  /// Returns a prettified version of the [Resolution] (e.g. `1920 x 1080`).
  String prettify() {
    final (:width, :height) = this;
    return '$width x $height';
  }
}

// Add these constants into the win32 package

const CDS_FULLSCREEN = 4;
const CDS_GLOBAL = 8;
const CDS_NORESET = 0x10000000;
const CDS_RESET = 0x40000000;
const CDS_SET_PRIMARY = 0x10;
const CDS_TEST = 2;
const CDS_UPDATEREGISTRY = 1;
const CDS_VIDEOPARAMETERS = 0x20;
const CDS_ENABLE_UNSAFE_MODES = 0x100;
const CDS_DISABLE_UNSAFE_MODES = 0x200;
const CDS_RESET_EX = 0x20000000;

const DisplayDeviceStateFlags_AttachedToDesktop = 0x1;

const DISP_CHANGE_SUCCESSFUL = 0;
const DISP_CHANGE_RESTART = 1;
const DISP_CHANGE_FAILED = -1;
const DISP_CHANGE_BADMODE = -2;
const DISP_CHANGE_NOTUPDATED = -3;
const DISP_CHANGE_BADFLAGS = -4;
const DISP_CHANGE_BADPARAM = -5;
const DISP_CHANGE_BADDUALVIEW = -6;

const DM_PELSWIDTH = 0x00080000;
const DM_PELSHEIGHT = 0x00100000;

const ENUM_CURRENT_SETTINGS = -1;
