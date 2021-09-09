import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shoppingproject/models/profile_model.dart';
import 'package:shoppingproject/utility/dialog.dart';
import 'package:shoppingproject/utility/my_style.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  ProfileModel? profileModel;
  String? displayName, uid, address, phone;

  Position? userLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readProfile();
    findPosition().then((value) {
      setState(() {
        userLocation = value;
        print(
            'lat = ${userLocation!.latitude}, lag = ${userLocation!.longitude}');
      });
    });
  }

  Future<Position?> findPosition() async {
    var position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      position = null;
    }
    return position;
  }

  Future<Null> readProfile() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        uid = event!.uid;
        setState(() {
          displayName = event.displayName;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => uploadValueToFirebase(),
        child: Icon(Icons.cloud_upload),
      ),
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: displayName == null
          ? MyStyle().showProgress()
          : Center(
              child: Column(
                children: [
                  MyStyle().titleH1(displayName!),
                  buildAddress(),
                  buildPhone(),
                  buildMap(),
                ],
              ),
            ),
    );
  }

  Future<Null> uploadValueToFirebase() async {
    if ((address?.isEmpty ?? true) || (phone?.isEmpty ?? true)) {
      normalDialog(context, 'Have Space ?', 'Pleae fill Every Blank');
    } else {
      ProfileModel model = ProfileModel(
        name: displayName,
        address: address,
        phone: phone,
        lat: userLocation!.latitude,
        lng: userLocation!.longitude,
      );

      Map<String, dynamic> map = model.toMap();

      await Firebase.initializeApp().then((value) async {
        await FirebaseFirestore.instance
            .collection('profile')
            .doc(uid)
            .set(map)
            .then(
              (value) => Navigator.pop(context));
      });
    }
  }

  Set<Marker> setMarket() {
    return <Marker>[
      Marker(
          markerId: MarkerId('idUser'),
          position: LatLng(userLocation!.latitude, userLocation!.longitude),
          infoWindow: InfoWindow(
              title: 'You Here ?',
              snippet:
                  'lat = ${userLocation!.latitude}, lng = ${userLocation!.longitude}')),
    ].toSet();
  }

  Expanded buildMap() => Expanded(
        child: Container(
          child: userLocation == null
              ? MyStyle().showProgress()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target:
                          LatLng(userLocation!.latitude, userLocation!.longitude),
                      zoom: 16,
                    ),
                    onMapCreated: (controller) {},
                    markers: setMarket(),
                  ),
                ),
        ),
      );

  Container buildAddress() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        onChanged: (value) => address = value.trim(),
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: 'Address :'),
      ),
    );
  }

  Container buildPhone() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        keyboardType: TextInputType.phone,
        onChanged: (value) => phone = value.trim(),
        decoration:
            InputDecoration(border: OutlineInputBorder(), labelText: 'Phone :'),
      ),
    );
  }
}
