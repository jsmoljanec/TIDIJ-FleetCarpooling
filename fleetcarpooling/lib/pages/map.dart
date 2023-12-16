import 'package:fleetcarpooling/Modularity/models/vehicle.dart';
import 'package:fleetcarpooling/VehicleManagamentService/vehicle_managament_service.dart';
import 'package:fleetcarpooling/handlers/udp_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fleetcarpooling/ui_elements/vehicle_controller.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {  
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(46.303117, 16.324079);
  late String actionMessage = 'Waiting for action...';
  
  Set<Marker> markers = {};
  bool showController = false;
  late MarkerId selectedMarkerId;

  
  static const port = 50001;
  late UDPManager udpManager;
  late BitmapDescriptor icon;

  @override
  void initState(){
    String deviceIpAddress = const String.fromEnvironment('DEVICE_IP_ADDRESS');
    if(deviceIpAddress.isNotEmpty){
      udpManager = UDPManager(deviceIpAddress, port);
    }else{
      udpManager = UDPManager("10.0.2.2", port);
    }
    udpManager.connectUDP();
    updateMapWithVehicleMarkers();
    selectedMarkerId = const MarkerId('');
    getIcons();
    super.initState();
  }

  getIcons() async {
    var icon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(),"assets/icons/vehicle_icon90.png");
    setState(() {
      this.icon = icon;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: GoogleMap(
                onMapCreated: onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 12.0,
                ),
                onTap: (_) {
                  setState(() {
                    showController = false;
                    selectedMarkerId = const MarkerId('');
                  });
                },
                markers: markers,
              ),
            ),
            if (showController)
              VehicleController(
                onCommand: (command) {
                  udpManager.sendCommand(command, selectedMarkerId);
                  setActionMessage(command);
                }
              ),
          ],
        ),
      ),
    );
  } 


  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void setActionMessage(String command) {
    setState(() {
      if (command.startsWith("set-destination")) {
        actionMessage = 'Destination set.';
      } else if (command.startsWith("start")) {
        actionMessage = 'Vehicle $selectedMarkerId started ride.';
      } else if (command.startsWith("stop")) {
        actionMessage = 'Vehicle $selectedMarkerId stopped ride.';
      }
    });
  }

  Marker createVehicleMarker(Vehicle vehicle) {
  return Marker(
    icon: icon,
    markerId: MarkerId(vehicle.vin),
    position: LatLng(vehicle.latitude, vehicle.longitude),
    infoWindow: InfoWindow(title: "${vehicle.brand} ${vehicle.model}"),
    onTap: () {
      setState(() {
        if (selectedMarkerId.value == vehicle.vin) {
          showController = false;
          selectedMarkerId = const MarkerId('');
        } else {
          showController = true;
          selectedMarkerId = MarkerId(vehicle.vin);
        }
      });
    },
  );
}

  void updateMapWithVehicleMarkers() {
    getVehicles().listen((vehicles) {
      final newMarkers = vehicles
        .where((vehicle) => vehicle.active == true)
        .map(createVehicleMarker)
        .toSet();

      if (newMarkers.isNotEmpty) {
        setState(() {
          markers = newMarkers;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
