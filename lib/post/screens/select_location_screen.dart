import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap; // เพิ่ม Import นี้

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  // พิกัดเริ่มต้น (กรุงเทพฯ)
  LatLng _pickedLocation = const LatLng(13.7563, 100.5018);

  // ฟังก์ชั่นช่วยแปลงพิกัดส่งกลับไปหน้า CreatePostScreen
  void _confirmAndPop() {
    final selectedGmapLocation = gmap.LatLng(
      _pickedLocation.latitude,
      _pickedLocation.longitude,
    );
    Navigator.of(context).pop(selectedGmapLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ปักหมุดสถานที่ของหาย/พบเจอ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _confirmAndPop, // ใช้ฟังก์ชั่นส่งค่ากลับ
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _pickedLocation,
              initialZoom: 15.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _pickedLocation = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _pickedLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.check_circle),
              label: Text(
                'ยืนยันตำแหน่งนี้ (${_pickedLocation.latitude.toStringAsFixed(4)}, ${_pickedLocation.longitude.toStringAsFixed(4)})',
                style: const TextStyle(fontSize: 16),
              ),
              onPressed: _confirmAndPop, // ใช้ฟังก์ชั่นส่งค่ากลับ
            ),
          ),
        ],
      ),
    );
  }
}