import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef UdpMessageHandler = void Function(String message);

class UDPManager {
  late RawDatagramSocket _clientSocket;
  late InternetAddress destinationIPAddress;
  late int port;
  late UdpMessageHandler udpMessageHandler;

  UDPManager(String destinationIP, givenPort, {required this.udpMessageHandler}) {
    destinationIPAddress = InternetAddress(destinationIP);
    port = givenPort;
  }

  Future<void> connectUDP() async {
    _clientSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    _clientSocket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram dg = _clientSocket.receive()!;
        String message = String.fromCharCodes(dg.data);
        handleUdpMessage(message);
      }
    });
  }
  void sendCommand(String command, MarkerId selectedMarkerId) {
    _clientSocket.send("$command ${selectedMarkerId.value}".codeUnits, destinationIPAddress,port);
  }

  void handleUdpMessage(String message) {
    (message.toLowerCase()).contains("is currently at") ? parseAndHandleLocationMessage(message) : "";
    udpMessageHandler(message);
  }

  void parseAndHandleLocationMessage(String message) {
    RegExp regExp = RegExp(r"'latitude': (\d+\.\d+), 'longitude': (\d+\.\d+)");
    var match = regExp.firstMatch(message);
    if (match != null) {
      var latitude = double.parse(match.group(1)!);
      var longitude = double.parse(match.group(2)!);
      print('$latitude, $longitude');
    }
  }

  void dispose() {
    _clientSocket.close();
  }
}