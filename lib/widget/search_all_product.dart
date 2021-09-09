import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoppingproject/models/product_men.dart';
import 'package:shoppingproject/utility/my_style.dart';
import 'package:shoppingproject/widget/show_progress.dart';

class SearchAllProduct extends StatefulWidget {
  const SearchAllProduct({Key? key}) : super(key: key);

  @override
  _SearchAllProductState createState() => _SearchAllProductState();
}

class _SearchAllProductState extends State<SearchAllProduct> {
  List<ProductMenModel> productModels = [];
  List<ProductMenModel> searchProductModels = [];

  final debouncer = Debouncer(millisecond: 500);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // readAllProduct();
    delayTime();
  }

  Future<Null> delayTime() async {
    Duration duration = Duration(seconds: 2);
    await Timer(duration, () => readAllProduct());
  }

  Future<Null> readAllProduct() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('product')
          .snapshots()
          .listen((event) {
        for (var item in event.docs) {
          ProductMenModel model = ProductMenModel.fromMap(item.data());
          setState(() {
            productModels.add(model);
          });
        }
      });

      await FirebaseFirestore.instance
          .collection('productMenHat')
          .snapshots()
          .listen((event) {
        for (var item in event.docs) {
          ProductMenModel model = ProductMenModel.fromMap(item.data());
          setState(() {
            productModels.add(model);
          });
        }
      });

      await FirebaseFirestore.instance
          .collection('productMenShoes')
          .snapshots()
          .listen((event) {
        for (var item in event.docs) {
          ProductMenModel model = ProductMenModel.fromMap(item.data());
          setState(() {
            productModels.add(model);
          });
        }
      });

      await FirebaseFirestore.instance
          .collection('productPants')
          .snapshots()
          .listen((event) {
        for (var item in event.docs) {
          ProductMenModel model = ProductMenModel.fromMap(item.data());
          setState(() {
            productModels.add(model);
          });
        }
      });

      await FirebaseFirestore.instance
          .collection('productbag')
          .snapshots()
          .listen((event) {
        for (var item in event.docs) {
          ProductMenModel model = ProductMenModel.fromMap(item.data());
          setState(() {
            productModels.add(model);
          });
        }
      });

      setState(() {
        searchProductModels = productModels;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(color: Colors.black12),
          child: TextFormField(
            onChanged: (value) {
              debouncer.run(() {
                setState(() {
                  searchProductModels = productModels
                      .where((element) => (element.name!
                          .toLowerCase()
                          .contains(value.toLowerCase())))
                      .toList();
                });
              });
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: productModels.length == 0
          ? ShowProgress()
          : GridView.builder(
              itemCount: searchProductModels.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
              ),
              itemBuilder: (context, index) => Card(
                  child: Column(
                children: [
                  Text(
                    searchProductModels[index].name!,
                  ),
                  Container(
                    height: 150,
                    child: CachedNetworkImage(
                      imageUrl: searchProductModels[index].pathImage!,
                      placeholder: (context, url) => MyStyle().showProgress(),
                      errorWidget: (context, url, error) => Image(
                        image: AssetImage('images/pic.png'),
                      ),
                    ),
                  ),
                ],
              )),
            ),
    );
  }
}

class Debouncer {
  final int? millisecond;
  Timer? timer;
  VoidCallback? callBack;

  Debouncer({this.millisecond});

  run(VoidCallback callback) {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: millisecond!), callback);
  }
}
