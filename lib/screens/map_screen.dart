import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation? initialLocation;
  final bool isSelecting;

  MapScreen({this.initialLocation, this.isSelecting = false});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use a default location if none provided
    final location = widget.initialLocation ??
        PlaceLocation(latitude: 37.422, longitude: -122.084);

    final initialCenter = LatLng(location.latitude, location.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
        actions: widget.isSelecting
            ? [
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: _pickedLocation == null
                      ? null
                      : () {
                          Navigator.of(context).pop(_pickedLocation);
                        },
                ),
              ]
            : [],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: initialCenter,
          initialZoom: 16.0,
          onTap: widget.isSelecting
              ? (tapPosition, point) => _selectLocation(point)
              : null,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.travel_notes',
            maxZoom: 19,
          ),
          MarkerLayer(
            markers: [
              // Show initial location marker
              Marker(
                width: 80.0,
                height: 80.0,
                point: initialCenter,
                child: Container(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40.0,
                  ),
                ),
              ),
              // Show picked location marker if selecting
              if (_pickedLocation != null)
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: _pickedLocation!,
                  child: Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 40.0,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}