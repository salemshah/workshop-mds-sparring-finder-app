import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place_plus/google_place_plus.dart';
import 'package:sparring_finder/generated/assets.dart';

import '../../theme/app_colors.dart';

class AddressPickerScreen extends StatefulWidget {
  const AddressPickerScreen({super.key});

  @override
  State<AddressPickerScreen> createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen> {
  static const String _kGoogleApiKey =
      "AIzaSyA6dM7IW6g4MAmw4I3R_Awg2VqZLzuVTWc";

  String? _darkNoPoiMapStyle;
  late final GooglePlace _googlePlace;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<AutocompletePrediction> _predictions = [];
  bool _isLoadingSuggestions = false;
  String? _selectedAddress;
  LatLng? _selectedLatLng;
  String? _city;
  String? _country;

  GoogleMapController? _mapController;
  Marker? _selectedPlaceMarker;

  Timer? _debounce;
  late final BitmapDescriptor _cachedMarkerIcon;

  static const CameraPosition _kInitialCameraPosition = CameraPosition(
    target: LatLng(46.2276, 2.2137),
    zoom: 5.5,
  );

  @override
  void initState() {
    super.initState();
    _loadDarkNoPoiMapStyle();
    _googlePlace = GooglePlace(_kGoogleApiKey);
    _cachedMarkerIcon =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    _searchController.addListener(_onSearchTextChanged);
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _loadDarkNoPoiMapStyle() async {
    try {
      final String styleJson =
          await rootBundle.loadString(Assets.mapStylesDarkMapNoPoi);
      if (mounted) {
        setState(() {
          _darkNoPoiMapStyle = styleJson;
        });
      }
    } catch (e) {
      debugPrint('Error loading map style: $e');
    }
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_isLoadingSuggestions) {
          setState(() {
            _predictions = [];
          });
        }
      });
    }
  }

  void _onSearchTextChanged() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      if (query.length >= 2) {
        _fetchAutocompleteSuggestions(query);
      } else {
        if (mounted) {
          setState(() {
            _predictions = [];
            _isLoadingSuggestions = false;
          });
        }
      }
    });
  }

  Future<void> _fetchAutocompleteSuggestions(String input) async {
    if (mounted) {
      setState(() {
        _isLoadingSuggestions = true;
      });
    }
    try {
      final result = await _googlePlace.autocomplete.get(
        input,
        language: "en",
        components: [Component("country", "fr")],
      );
      if (!mounted) return;
      if (result != null && result.predictions != null) {
        setState(() {
          _predictions = result.predictions!;
        });
      } else {
        setState(() {
          _predictions = [];
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _predictions = [];
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingSuggestions = false;
        });
      }
    }
  }

  Future<void> _onPredictionTap(AutocompletePrediction p) async {
    if (p.placeId == null) return;
    final details = await _googlePlace.details.get(p.placeId!);
    if (details?.result == null) return;
    final place = details!.result!;

    if (place.geometry?.location == null) return;
    final lat = place.geometry!.location!.lat!;
    final lng = place.geometry!.location!.lng!;

    // Extract city & country from addressComponents
    _city = null;
    _country = null;
    for (final comp in place.addressComponents ?? []) {
      final types = comp.types ?? [];
      if (types.contains("locality")) {
        _city = comp.longName;
      }
      if (types.contains("country")) {
        _country = comp.longName;
      }
    }
    // fallback if "locality" is missing:
    if (_city == null) {
      for (final comp in place.addressComponents ?? []) {
        final types = comp.types ?? [];
        if (types.contains("administrative_area_level_1")) {
          _city = comp.longName;
          break;
        }
      }
    }

    final fullAddress = place.formattedAddress;

    setState(() {
      _selectedLatLng = LatLng(lat, lng);
      _selectedAddress = fullAddress;
      _searchController.text = fullAddress ?? "";
    });
    _focusNode.unfocus();
  }

  void _onConfirmPressed() {
    if (_selectedLatLng == null || _selectedAddress == null) {
      return;
    }
    // Return a map with address, lat, lng, city, country
    Navigator.of(context).pop(<String, dynamic>{
      "latitude": _selectedLatLng!.latitude,
      "longitude": _selectedLatLng!.longitude,
      "address": _selectedAddress!,
      "city": _city,
      "country": _country,
    });
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    if (_darkNoPoiMapStyle != null) {
      await _mapController?.setMapStyle(_darkNoPoiMapStyle);
    }
  }

  Widget _buildSuggestionsDropdown(BuildContext context) {
    final text = _searchController.text.trim();
    if (!_focusNode.hasFocus || text.length < 2) return const SizedBox.shrink();
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.fromBorderSide(BorderSide(color: Colors.white24)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height *
            (_predictions.isEmpty ? 0.1 : 0.4),
      ),
      child: _isLoadingSuggestions
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          : (_predictions.isEmpty
              ? Center(
                  child: Text(
                    "No results",
                    style: TextStyle(color: AppColors.text),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _predictions.length,
                  itemBuilder: (context, index) {
                    final p = _predictions[index];
                    return ListTile(
                      dense: true,
                      title: Text(
                        p.structuredFormatting?.mainText ?? "",
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        p.structuredFormatting?.secondaryText ?? "",
                        style: const TextStyle(color: Colors.white54),
                      ),
                      onTap: () => _onPredictionTap(p),
                    );
                  },
                )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // ─── 1) Full‐screen GoogleMap behind everything ───
            GoogleMap(
              initialCameraPosition: _kInitialCameraPosition,
              onMapCreated: _onMapCreated,
              markers: _selectedPlaceMarker != null
                  ? <Marker>{_selectedPlaceMarker!}
                  : <Marker>{},
              zoomControlsEnabled: false,
              compassEnabled: false,
              myLocationButtonEnabled: false,
              mapToolbarEnabled: false,
            ),

            // ─── 3) Search bar + suggestions dropdown ───
            Positioned(
              top: MediaQuery.of(context).padding.top + 25,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.transparent,
                elevation: 8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: AppColors.inputFill,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30)),
                              border: Border.fromBorderSide(
                                BorderSide(color: AppColors.primary, width: 2),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              focusNode: _focusNode,
                              controller: _searchController,
                              style: const TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your address",
                                hintStyle: TextStyle(color: Colors.white54),
                                icon: Icon(Icons.search, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                          child: IconButton(
                            color: AppColors.primary,
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildSuggestionsDropdown(context),
                  ],
                ),
              ),
            ),

            // ─── 4) Bottom “Confirm Your Address” card (only if an address is chosen) ───
            if (_selectedLatLng != null && _selectedAddress != null)
              Positioned(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).padding.bottom + 25,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border.fromBorderSide(
                      BorderSide(color: AppColors.border, width: 2),
                    ),
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Confirm Your Address",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedAddress!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // ─── Row with Cancel + Confirm ───
                      Row(
                        children: [
                          // Cancel just pops and returns nothing
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Colors.redAccent,
                                  width: 2,
                                ),
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Confirm returns the chosen data
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _onConfirmPressed,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                minimumSize: const Size(double.infinity, 48),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text(
                                "Confirm",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
