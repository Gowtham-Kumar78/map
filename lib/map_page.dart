import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng markerPosition =  LatLng(35.201049999999995,-91.8318334); // Initial marker position
  String placeName = 'Heber Springs, Arkansas';

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setMarkerFromPlaceName();
  }

  Future<void> _setMarkerFromPlaceName() async {
    try {
      // Get the location from the place name
      List<Location> locations = await locationFromAddress(placeName);
      if (locations.isNotEmpty) {
        Location firstResult = locations.first;
        setState(() {
          markerPosition = LatLng(firstResult.latitude, firstResult.longitude);
        });
        print(
            'Location found: Latitude: ${firstResult.latitude}, Longitude: ${firstResult.longitude}');
      }
    } catch (e) {
      print('Error finding location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location not found: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map View"),
        backgroundColor: Colors.blue,
      ),
      body: FlutterMap(
          options: MapOptions(
            initialCenter: markerPosition,
            initialZoom: 9,

            // onTap: (tapPosition, latLng) {
            //   // Update marker position when the map is tapped
            //   setState(() {
            //     markerPosition = latLng;
            //   });

            //   // Print latitude and longitude to the console
            //   print("Tapped Location: Latitude: ${latLng.latitude}, Longitude: ${latLng.longitude}");
            // },
          ),
          children:  [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.maps',

            ),

            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: markerPosition,
                  child: const Icon(Icons.location_on,color: Colors.red,),
                ),
              ],
            ),
          ],

      ),
    );
  }


}
