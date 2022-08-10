import 'dart:async';

import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:geolocator/geolocator.dart';
import 'package:vector_math/vector_math.dart';
import 'dart:math' show sin, cos, sqrt, atan2;


import '../services/network_status_service.dart';
import '../widget/network_aware_widget.dart';

class Greetings extends StatefulWidget {
  const Greetings({Key? key}) : super(key: key);

  @override
  State<Greetings> createState() => _GreetingsState();
}

class _GreetingsState extends State<Greetings> {
  var message = '';

  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  ConnectivityResult result = ConnectivityResult.none;

  bool isclicked =false;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  String distance = "";
  late StreamSubscription<Position> positionStream;

  checkGps() async {
    setState((){
      isclicked=true;
    });
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if(servicestatus){
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        }else if(permission == LocationPermission.deniedForever){
          print("'Location permissions are permanently denied");
        }else{
          haspermission = true;
        }
      }else{
        haspermission = true;
      }

      if(haspermission){
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    }else{
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }
  getLocation() async {
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();
    double earthRadius = 6371000;

    var userLat=position.latitude;
    var userLong =position.longitude;

    var givenLat = 37.0902;
    var givenlong = -95.7129;
    print(long+" , "+lat);
    var dlong = givenlong - userLong;
    var dlat = givenLat - userLat;
  print(dlong.toString()+" "+dlat.toString());
    var dLat = radians(givenlong - userLong);
    var dLng = radians(givenLat - userLat);
    var a = sin(dLat/2) * sin(dLat/2) + cos(radians(userLat))
        * cos(radians(givenLat)) * sin(dLng/2) * sin(dLng/2);
    var c = 2 * atan2(sqrt(a), sqrt(1-a));
    var d = earthRadius * c;
    print(d/1000);
    distance = (d/1000).toString();


    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings).listen((Position position) {
      print(position.longitude);
      print(position.latitude);


      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
      });
    });
  }
  @override
  void initState() {
    super.initState();
    internetSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
    });
  }

  @override
  void dispose() {
    internetSubscription.cancel();
    super.dispose();
  }

  void getCurrentLocation() async {
    // var position = await Geolocator.getCurrentPosition()
    var position = await GeolocatorPlatform.instance.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    var timeNow = int.parse(DateFormat('kk').format(now));
    clearData()async{
      await APICacheManager().deleteCache("KEY");
    }
    if (timeNow <= 12) {
      message = 'Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      message = 'Afernoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      message = 'Evening';
    } else {
      message = 'Night';
    }
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Good " + message,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontFamily: "Satisfy",
                  fontWeight: FontWeight.w600,
                  fontSize: 35,
                  letterSpacing: 0.27,
                  //color: DesignCourseAppTheme.darkerText,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Network Status : ",
                      style: TextStyle(fontSize: 15)),
                  hasInternet
                      ? Row(
                          children: const [
                            Icon(
                              Icons.circle,
                              color: Color(0xff00FF00),
                              size: 15,
                            ),
                            Text(" Online")
                          ],
                        )
                      : Row(
                          children: const [
                            Icon(
                              Icons.circle,
                              color: Color(0xffFF0000),
                              size: 15,
                            ),
                            Text(" Offline")
                          ],
                        )
                ],
              ),
              SizedBox(height: 50,),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(Icons.my_location,size: 50,),
              ),
              GestureDetector(
                onTap: (){
                  isclicked = true;
                  checkGps();
                },
                child: Container(
                  height: 40,
                  width: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xff2196F3),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Text("Get Location",style: TextStyle(color: Color(0xffFFFFFF)),),
                ),
              ),
              isclicked?
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                    children: [

                      Text(servicestatus? "GPS is Enabled": "GPS is disabled."),
                      Text(haspermission? "GPS has permission": "GPS permission is disabled."),

                      Text("Current Longitude: $long", style:TextStyle(fontSize: 20)),
                      Text("Current Latitude: $lat", style: TextStyle(fontSize: 20),),
                      Text("The distance between users location and lat-long 37.0902°N, 95.7129 W is $distance Kilometers"),
                    ]
                ),
              ):SizedBox(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.clear),
        label: Text("Clear Data"),
        backgroundColor: Color(0xff2196F3),
        foregroundColor: Color(0xffFFFFFF),
        onPressed: (){
          clearData();
        },
      ),
    );
  }
}
