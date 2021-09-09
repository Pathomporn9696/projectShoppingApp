import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoppingproject/models/product_men.dart';
import 'package:shoppingproject/utility/my_style.dart';

class ShirtMenList extends StatefulWidget {
  @override
  _ShirtMenListState createState() => _ShirtMenListState();
}

class _ShirtMenListState extends State<ShirtMenList> {
  late double screen;
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
          .collection('product')
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
      Container(
          margin: EdgeInsets.only(
            bottom: 15,left: 15,right: 15,top: 15,
          ),
          width: screen *0.4,
          child: Column(
            children: [
              Container(
                width: screen*0.29,
                child: Image.network(model.pathImage!)
              ),
              Container(padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0,10),
                    blurRadius: 50,
                    color: MyStyle().primaryColor.withOpacity(0.23), 
                  )
                ]
              ),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: model.name!.toUpperCase(),
                          style: Theme.of(context).textTheme.button,
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    model.detail!,
                    style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: MyStyle().darkColor),
                  )
                ],
              ),
              )
            ],

          ),
        );

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(backgroundColor: MyStyle().primaryColor),
      body: widgets.length == 0
          ? Center(child: CircularProgressIndicator())
          : GridView.extent(
              maxCrossAxisExtent: 300,
              children: widgets,
            ),
    );
  }
}
