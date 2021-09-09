import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoppingproject/models/product_men.dart';
import 'package:shoppingproject/utility/my_style.dart';

class PantsMen extends StatefulWidget {
  @override
  _PantsMenState createState() => _PantsMenState();
}

class _PantsMenState extends State<PantsMen> {
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      print('initailize Success');
      await FirebaseFirestore.instance
          .collection('productPants')
          .orderBy('name')
          .snapshots()
          .listen((event) {
        print('snapshot = ${event.docs}');
        for (var snapshot in event.docs) {
          Map<String, dynamic> map = snapshot.data();
          print('map = $map');
          ProductMenModel model = ProductMenModel.fromMap(map);
          print('name = ${model.name}');
          setState(() {
            widgets.add(createWidget(model));
          });
        }
      });
    });
  }

  Widget createWidget(ProductMenModel model) =>
      Column(
        children: [
          Container(
            width: 160, child: Image.network(model.pathImage!),
            
          ),
          Text(model.name!),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hat'),backgroundColor: MyStyle().primaryColor),
      body: widgets.length == 0
          ? Center(child: CircularProgressIndicator())
          : GridView.extent(
              maxCrossAxisExtent: 250,
              children: widgets,
            ),
    );
  }
}
