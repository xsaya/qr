import 'package:flutter/material.dart';
import 'package:qr_scan/models/scan_models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({Key? key}) : super(key: key);

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}
class _MapaScreenState extends State<MapaScreen> {
  MapType _currentMapType = MapType.normal;
  late GoogleMapController _control;
  String opcion = 'normal';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)!.settings.arguments as ScanModel;

    final CameraPosition _puntInicial =
        CameraPosition(target: scan.getLatLng(), zoom: 14.4746, tilt: 50);

    Set<Marker> markers = <Marker>{};
    markers.add(
        Marker(markerId: const MarkerId('id1'), position: scan.getLatLng()));

    return Scaffold(
      appBar: AppBar(
        leading: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
          elevation: 20,
        ),
        actions: [
          FloatingActionButton(
            onPressed: () {
              setState(() => _control.animateCamera(
                  CameraUpdate.newCameraPosition(
                      CameraPosition(target: _puntInicial.target, zoom: 17))));
            },
            child: const Icon(
              Icons.add_location_alt_rounded,
              color: Colors.white,
            ),
            elevation: 20,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 700,
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: _currentMapType,
              markers: markers,
              initialCameraPosition: _puntInicial,
              onMapCreated: (GoogleMapController controller) {
                _control = controller;
              },
            ),
          ),
          Container(
            color: Colors.deepPurple,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  child: const Icon(Icons.add_chart_sharp, color: Colors.white),
                  onPressed: () =>
                      setState(() => _currentMapType = MapType.terrain),
                ),
                FloatingActionButton(
                  child: const Icon(
                    Icons.add_a_photo,
                    color: Colors.white,
                  ),
                  onPressed: () =>
                      setState(() => _currentMapType = MapType.normal),
                ),
                FloatingActionButton(
                  child: const Icon(
                    Icons.add_home_work,
                    color: Colors.white,
                  ),
                  onPressed: () =>
                      setState(() => _currentMapType = MapType.satellite),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
