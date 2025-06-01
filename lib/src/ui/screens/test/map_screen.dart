import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../models/profile/profile_model.dart';
import '../../theme/app_colors.dart';

class MapScreen extends StatefulWidget {
  final List<Profile> profiles;

  const MapScreen(this.profiles, {super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  int _markerIdCounter = 0;

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(46.2276, 2.2137),
    zoom: 5.5,
  );

  String? _darkNoPoiMapStyle;

  @override
  void initState() {
    super.initState();
    _loadDarkNoPoiMapStyle();
  }

  Future<void> _loadDarkNoPoiMapStyle() async {
    try {
      final String styleJson =
      await rootBundle.loadString('assets/map_styles/dark_map_no_poi.json');
      if (!mounted) return;
      setState(() {
        _darkNoPoiMapStyle = styleJson;
      });
    } catch (e) {
      debugPrint('Could not load map style: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_darkNoPoiMapStyle != null) {
      _mapController.setMapStyle(_darkNoPoiMapStyle);
    }
    _addProfileMarkers();
  }

  Future<void> _addProfileMarkers() async {
    for (final profile in widget.profiles) {
      final LatLng position = LatLng(profile.latitude, profile.longitude);

      BitmapDescriptor descriptor;
      if ((profile.photoUrl ?? '').isNotEmpty) {
        try {
          descriptor = await getMarkerBitmap(
            avatarAssetPath: null,
            avatarUrl: profile.photoUrl,
            pinColor: Colors.redAccent,
            markerSize: 120,
          );
        } catch (e) {
          debugPrint('Failed to load avatar for ${profile.firstName}: $e');
          descriptor = BitmapDescriptor.defaultMarker;
        }
      } else {
        descriptor = BitmapDescriptor.defaultMarker;
      }

      final String markerIdVal = 'marker_${_markerIdCounter++}';
      final Marker marker = Marker(
        markerId: MarkerId(markerIdVal),
        position: position,
        icon: descriptor,
        infoWindow: InfoWindow(
          title: '${profile.firstName} ${profile.lastName}',
          snippet: profile.city.isNotEmpty
              ? '${profile.city}, ${profile.country}'
              : profile.country,
        ),
        anchor: const Offset(0.5, 1.0),
      );

      if (!mounted) return;
      setState(() {
        _markers.add(marker);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: _onMapCreated,
        markers: _markers,
        zoomControlsEnabled: false,
        compassEnabled: false,
        myLocationButtonEnabled: true,
        mapToolbarEnabled: false,
      ),
    );
  }
}

///
/// Helper to produce a “pin” BitmapDescriptor with a circular avatar inside.
///
Future<BitmapDescriptor> getMarkerBitmap({
  String? avatarAssetPath,
  String? avatarUrl,
  required Color pinColor,
  required int markerSize,
}) async {
  assert(
  (avatarAssetPath != null) || (avatarUrl != null),
  'Provide either an asset path or a URL for the avatar.',
  );

  final ui.Image avatarImage = avatarAssetPath != null
      ? await _loadImageFromAsset(avatarAssetPath, targetSize: markerSize)
      : await _loadImageFromNetwork(avatarUrl!, targetSize: markerSize);

  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(
    pictureRecorder,
    Rect.fromLTWH(0, 0, markerSize.toDouble(), markerSize.toDouble()),
  );

  final double canvasSize = markerSize.toDouble();
  final double circleRadius = canvasSize * 0.40;
  final Offset circleCenter = Offset(
    canvasSize / 2,
    canvasSize / 2 - (circleRadius * 0.1),
  );

  // Draw pin head
  final Paint circlePaint = Paint()..color = pinColor;
  canvas.drawCircle(circleCenter, circleRadius, circlePaint);

  // Draw pin tip
  final Path trianglePath = Path();
  final double tipHeight = canvasSize * 0.20;
  final double halfBase = circleRadius * 0.5;
  final double triangleTopY = circleCenter.dy + (circleRadius * 0.6);
  trianglePath.moveTo(circleCenter.dx - halfBase, triangleTopY);
  trianglePath.lineTo(circleCenter.dx + halfBase, triangleTopY);
  trianglePath.lineTo(circleCenter.dx, triangleTopY + tipHeight);
  trianglePath.close();
  canvas.drawPath(trianglePath, circlePaint);

  // Draw white border
  final Paint borderPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = canvasSize * 0.04;
  canvas.drawCircle(circleCenter, circleRadius, borderPaint);

  // Draw avatar inside clipped circle
  final double avatarDiameter = circleRadius * 1.6;
  final Rect avatarRect = Rect.fromCenter(
    center: circleCenter,
    width: avatarDiameter,
    height: avatarDiameter,
  );
  canvas.save();
  canvas.clipPath(Path()..addOval(avatarRect));
  final Paint avatarPaint = Paint();
  canvas.drawImageRect(
    avatarImage,
    Rect.fromLTWH(
      0,
      0,
      avatarImage.width.toDouble(),
      avatarImage.height.toDouble(),
    ),
    avatarRect,
    avatarPaint,
  );
  canvas.restore();

  final ui.Picture picture = pictureRecorder.endRecording();
  final ui.Image finalImage = await picture.toImage(markerSize, markerSize);
  final ByteData? byteData = await finalImage.toByteData(
    format: ui.ImageByteFormat.png,
  );
  final Uint8List pngBytes = byteData!.buffer.asUint8List();
  return BitmapDescriptor.fromBytes(pngBytes);
}

Future<ui.Image> _loadImageFromAsset(
    String assetPath, {
      required int targetSize,
    }) async {
  final ByteData data = await rootBundle.load(assetPath);
  final Uint8List bytes = data.buffer.asUint8List();
  final ui.Codec codec = await ui.instantiateImageCodec(
    bytes,
    targetWidth: targetSize,
    targetHeight: targetSize,
  );
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image;
}

Future<ui.Image> _loadImageFromNetwork(
    String url, {
      required int targetSize,
    }) async {
  final http.Response response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    throw Exception('Failed to load network image: $url');
  }
  // Fix: use response.bodyBytes (not response	bodyBytes)
  final Uint8List bytes = response.bodyBytes;
  final ui.Codec codec = await ui.instantiateImageCodec(
    bytes,
    targetWidth: targetSize,
    targetHeight: targetSize,
  );
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image;
}
