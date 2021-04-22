import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/src/constants/assets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapPage extends StatefulWidget {
  @override
  State<GoogleMapPage> createState() => GoogleMapPageState();
}

class GoogleMapPageState extends State<GoogleMapPage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initMap = CameraPosition(
    target: LatLng(13.6972552, 100.5131413),
    zoom: 14.4746,
  );

  final dummyData = List<LatLng>();
  final _marker = Set<Marker>();
  bool _permissionGranted;
  StreamSubscription<LocationData> _locationSubscription;

  static final CameraPosition _codeMobile = CameraPosition(
      target: LatLng(13.6972552, 100.5131413), zoom:13);

  @override
  void initState() {
    dummyData.add(LatLng(13.6972552,100.5131413));
    dummyData.add(LatLng(13.7029927,100.543399));
    dummyData.add(LatLng(13.6990459,100.5382859));
    _requestLocationPermission();
    super.initState();
  }
  void _requestLocationPermission() async {
    try {
      _permissionGranted =
          await Location().requestPermission() == PermissionStatus.granted;
      setState(() {});
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        return print('Permission denied');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Google Maps")),
      body: Stack(
        children: [
          GoogleMap(
            markers: _marker,
            mapType: MapType.normal,
            initialCameraPosition: _initMap,
            trafficEnabled: true,
            myLocationEnabled: _permissionGranted,
            myLocationButtonEnabled: _permissionGranted,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
              left: 0,
              child: Row(
                children: [
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                      onPressed: _pinMarker,
                      icon: Icon(Icons.pin_drop),
                      label: Text("Pin Biker")),
                  SizedBox(width: 8),
                  _buildTrackingButton()
                ],
              )),
        ],
      ),
    );
  }

  Future<void> _pinMarker() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_codeMobile));

    for (var latLng in dummyData) {
      await _addMarker(latLng, title: "xx", snippet: "yy", isShowInfo: true);
    }

    setState(() {

    });
    // dummyData.forEach((element) {
    //   final marker = Marker(
    //     markerId: MarkerId(element.toString()),
    //     position: element,
    //   );
    //   _marker.add(marker);
    //   setState(() {
    //
    //   });
    // });
  }
  Future<Uint8List> getBytesFromAsset(String path, double height) async {
    final byteData = await rootBundle.load(path);
    final codec = await instantiateImageCodec(
      byteData.buffer.asUint8List(),
      targetHeight: height.toInt(),
    );
    final frameInfo = await codec.getNextFrame();
    final image = await frameInfo.image.toByteData(format: ImageByteFormat.png);
    return image.buffer.asUint8List();
  }

  Future<void> _addMarker(
      LatLng position, {
        String title = 'none',
        String snippet = 'none',
        String pinAsset = Asset.pinBikerImage,
        bool isShowInfo = false,
      }) async {
    final byteData = await getBytesFromAsset(
      pinAsset,
      MediaQuery.of(context).size.height * 0.2,
    );

    final bitmapDescriptor = BitmapDescriptor.fromBytes(byteData);

    final marker = Marker(
      // important. unique id
      markerId: MarkerId(position.toString()),
      position: position,
      infoWindow: isShowInfo
          ? InfoWindow(
        title: title,
        snippet: snippet,
        onTap: () {
          // _launchMaps(
          //   position.latitude,
          //   position.longitude,
          // );
        },
      )
          : null,
      icon: bitmapDescriptor,
      onTap: () {
        print('lat: ${position.latitude}, lng: ${position.longitude}');
      },
    );
    _marker.add(marker);
  }
  ElevatedButton _buildTrackingButton() {
    final isTracking = _locationSubscription != null;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: isTracking ? Colors.red : Colors.purpleAccent,
      ),
      onPressed: () {
        _trackingLocation();
      },
      label: Text(isTracking ? 'Stop tracking' : 'Start tracking'),
      icon: Icon(Icons.alt_route),
    );
  }

  void _trackingLocation() async {
    if (_locationSubscription != null) {
      setState(() {
        _locationSubscription.cancel();
        _locationSubscription = null;
        _marker?.clear();
      });
      return;
    }

    final locationService = Location();
    await locationService.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 1000,
      distanceFilter: 100,
    ); // meters.

    try {
      final serviceEnabled = await locationService.serviceEnabled();
      if (!serviceEnabled) {
        bool serviceStatusResult = await locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          _trackingLocation();
        } else {
          print('Service denied');
        }
        return;
      }

      final granted =
          await locationService.requestPermission() == PermissionStatus.granted;

      if (!granted) {
        print('Permission denied');
        return;
      }

      _locationSubscription = locationService.onLocationChanged.listen(
            (LocationData result) async {
          _marker?.clear();
          final latLng = LatLng(result.latitude, result.longitude);
          await _addMarker(
            latLng,
            pinAsset: Asset.pinMarkerImage,
          );
          setState(() {
            _animateCamera(latLng);
          });
        },
      );
    } on PlatformException catch (e) {
      print('trackingLocation error: ${e.message}');
      if (e.code == 'PERMISSION_DENIED') {
        return print('Permission denied');
      }
      if (e.code == 'SERVICE_STATUS_ERROR') {
        return print('Service error');
      }
    }
  }

  Future<void> _animateCamera(LatLng position) async {
    _controller.future.then((controller) {
      controller.animateCamera(CameraUpdate.newLatLngZoom(position, 16));
    });
  }
}