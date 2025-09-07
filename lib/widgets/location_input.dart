import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function(double, double)? onSelectPlace;

  LocationInput({this.onSelectPlace});

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;
  double? _currentLatitude;
  double? _currentLongitude;

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      
      // For now, we'll create a simple preview or use a placeholder
      // You can implement a proper static map service later
      setState(() {
        _currentLatitude = locData.latitude;
        _currentLongitude = locData.longitude;
        _previewImageUrl = 'location_selected'; // Placeholder
      });
      
      if (widget.onSelectPlace != null && _currentLatitude != null && _currentLongitude != null) {
        widget.onSelectPlace!(_currentLatitude!, _currentLongitude!);
      }
    } catch (error) {
      print('Error getting location: $error');
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    
    if (selectedLocation == null) {
      return;
    }
    
    setState(() {
      _currentLatitude = selectedLocation.latitude;
      _currentLongitude = selectedLocation.longitude;
      _previewImageUrl = 'location_selected'; // Placeholder
    });
    
    if (widget.onSelectPlace != null) {
      widget.onSelectPlace!(selectedLocation.latitude, selectedLocation.longitude);
    }
  }

  Widget _buildLocationPreview() {
    if (_previewImageUrl == null) {
      return Text('No Location Chosen', textAlign: TextAlign.center);
    }
    
    // For now, show location coordinates
    // You can implement a proper map preview later
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on, color: Colors.red, size: 40),
        SizedBox(height: 8),
        Text(
          'Location Selected',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        if (_currentLatitude != null && _currentLongitude != null)
          Text(
            'Lat: ${_currentLatitude!.toStringAsFixed(4)}\nLng: ${_currentLongitude!.toStringAsFixed(4)}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _buildLocationPreview(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Current Location'),
              onPressed: _getCurrentUserLocation,
            ),
            TextButton.icon(
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}