import 'dart:math';

class LocationHelper {
  static String generateLocationPreviewImage({
    double? latitude,
    double? longitude,
  }) {
    // Using a completely free static map service
    // This service provides static maps without requiring an API key
    return 'https://staticmap.openstreetmap.de/staticmap.php'
        '?center=$latitude,$longitude'
        '&zoom=15'
        '&size=600x300'
        '&maptype=mapnik'
        '&markers=$latitude,$longitude,lightblue';
    
    // Alternative free services you can try:
    
    // 1. Using MapQuest (requires free API key)
    /*
    return 'https://www.mapquestapi.com/staticmap/v5/map'
        '?key=YOUR_FREE_MAPQUEST_KEY'
        '&center=$latitude,$longitude'
        '&zoom=15'
        '&size=600,300'
        '&type=map'
        '&imagetype=png'
        '&pois=mcenter,,$latitude,$longitude,0,0|';
    */
    
    // 2. Using Mapbox (requires free API key)
    /*
    return 'https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/'
        'pin-s-a+ff0000($longitude,$latitude)/'
        '$longitude,$latitude,15/600x300'
        '?access_token=YOUR_MAPBOX_TOKEN';
    */
  }
  
  // Alternative method using OpenStreetMap tiles directly (no API key needed)
  static String generateSimpleLocationPreview({
    double? latitude,
    double? longitude,
  }) {
    // This creates a URL that shows the location using OpenStreetMap
    // You'll need to implement a custom widget to display this
    final zoom = 15;
    final tileX = ((longitude! + 180.0) / 360.0 * (1 << zoom)).floor();
    final tileY = ((1.0 - log(tan(pi / 4 + latitude! * pi / 180 / 2)) / pi) / 2.0 * (1 << zoom)).floor();
    
    return 'https://tile.openstreetmap.org/$zoom/$tileX/$tileY.png';
  }
}