import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shoppingproject/models/profile_model.dart';
import 'package:shoppingproject/utility/my_style.dart';

class ShowProfileUser extends StatefulWidget {
  @override
  _ShowProfileUserState createState() => _ShowProfileUserState();
}

class _ShowProfileUserState extends State<ShowProfileUser> {
  ProfileModel? profileModel;
  bool statusLoad = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readProfile();
  }

  Future<Null> readProfile() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event!.uid;
        print('uid ==>> $uid');
        await FirebaseFirestore.instance
            .collection('profile')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {
            statusLoad = false;
            profileModel = ProfileModel.fromMap(event.data()!);
          });
        });
      });
    });
  }

  //ส่วนแสดงข้อมูล หน้า profile
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: profileModel == null
          ? buildFloatingActionButton(context)
          : SizedBox(),
      body: statusLoad
          ? MyStyle().showProgress()
          : profileModel == null
              ? Center(child: MyStyle().titleH1('Please Updata Your Profie'))
              : Center(
                  child: Column(
                    children: [
                      MyStyle().titleH1(profileModel!.name!),
                      MyStyle().titleH2(profileModel!.address!),
                      MyStyle().titleH2(profileModel!.phone!),
                      buildMap(),
                    ],
                  ),
                ),
    );
  }
  //ส่วนแสดงข้อมูล หน้า profile

  //ปักหมุดที้อยู่บนแผนที่
  Set<Marker> setMarker() {
    return [
      Marker(
          markerId: MarkerId('id'),
          position: LatLng(profileModel!.lat!, profileModel!.lng!),
          infoWindow: InfoWindow(
              title: 'You are Here ?',
              snippet:
                  'lat = ${profileModel!.lat} lng = ${profileModel!.lng}')),
    ].toSet();
  }
  //ปักหมุดที้อยู่บนแผนที่

  //แสดง google map
  Expanded buildMap() => Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(profileModel!.lat!, profileModel!.lng!),
              zoom: 16,
            ),
            onMapCreated: (controller) {},
            markers: setMarker(),
          ),
        ),
      );

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, '/editProfile'),
      child: Icon(Icons.edit),
    );
  }
}
//แสดง google map
