import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  
  late GoogleMapController _controller;
  final LatLng _eth = const LatLng(9.03, 38.74);

  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _eth, // San Francisco coordinates
          zoom: 12,
        ),

        onMapCreated: (controller){
          _controller = controller;
        },
      ),
    );
  }
}