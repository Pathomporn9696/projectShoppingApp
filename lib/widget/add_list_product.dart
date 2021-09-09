import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoppingproject/utility/my_style.dart';
import 'package:shoppingproject/widget/myhome.dart';

class AddListProduct extends StatefulWidget {
  @override
  _AddListProductState createState() => _AddListProductState();
}

class _AddListProductState extends State<AddListProduct> {
  File? file;
  String? name, detail, urlPicture;

  Widget uploadButtom() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton.icon(
            color: MyStyle().primaryColor,
            onPressed: () {
              print('you click upload');

              if (file == null) {
                showAlert(
                    'Non Choose Picture', 'Please Clicl Camera or Gallery');
              } else if (name == null ||
                  name!.isEmpty ||
                  detail == null ||
                  detail!.isEmpty) {
                showAlert('Havp Space', 'Please Fill Every Blank');
              } else {
                uploadPictureToStorage();
              }
            },
            icon: Icon(
              Icons.cloud_upload,
              color: Colors.white,
            ),
            label: Text(
              'Upload Data To Firebse',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> uploadPictureToStorage() async {
    Random random = Random();
    int i = random.nextInt(100000);

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference reference =
        firebaseStorage.ref().child('productmen/product$i.jpg');
    UploadTask uploadTask = reference.putFile(file!);

    urlPicture =
        await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
    print('urlPicture = $urlPicture');
    insertValueToFireStore();
  }

  Future<void> insertValueToFireStore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Map<String, dynamic> map = Map();
    map['name'] = name;
    map['detail'] = detail;
    map['pathImage'] = urlPicture;

    await firestore
        .collection('product')
        .doc()
        .set(map)
        .then((value) {
          print('Insert Success');
          MaterialPageRoute route = MaterialPageRoute(
            builder:(value) => MyHome(), 
          );
          Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
        });
  }

  Future<void> showAlert(String title, String message) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  }

  Widget nameForm() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: TextField(
          onChanged: (String string) {
            name = string.trim();
          },
          decoration: InputDecoration(
            helperText: 'กรุณากรอก ชื่อ ของสินค้า',
            labelText: 'Name Product',
            icon: Icon(Icons.text_format),
          ),
        ));
  }

  Widget detailForm() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.6,
        child: TextField(
          onChanged: (String string) {
            detail = string.trim();
          },
          decoration: InputDecoration(
            helperText: 'กรุณากรอก ราคา ของสินค้า',
            labelText: 'Price of product',
            icon: Icon(Icons.monetization_on),
          ),
        ));
  }

  Widget cameraButton() {
    return IconButton(
        icon: Icon(
          Icons.add_a_photo,
          size: 36.0,
          color: MyStyle().darkColor,
        ),
        onPressed: () {
          chooseImage(ImageSource.camera);
        });
  }

  Future<void> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker().getImage(
        source: imageSource,
        maxWidth: 100.0,
        maxHeight: 100.0,
      );

      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

  Widget galleryButton() {
    return IconButton(
        icon: Icon(
          Icons.add_photo_alternate,
          size: 36.0,
          color: MyStyle().lightColor,
        ),
        onPressed: () {
          chooseImage(ImageSource.gallery);
        });
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget showImage() {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: file == null ? Image.asset('images/pic.png') : Image.file(file!),
    );
  }

  Widget showContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          showImage(),
          showButton(),
          nameForm(),
          detailForm(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          showContent(),
          uploadButtom(),
        ],
      ),
    );
  }
}
