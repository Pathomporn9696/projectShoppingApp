import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shoppingproject/utility/my_style.dart';
import 'package:shoppingproject/widget/add_list_product.dart';
import 'package:shoppingproject/widget/all_product.dart';
import 'package:shoppingproject/widget/show_men_list.dart';
import 'package:shoppingproject/widget/show_profile_user.dart';
import 'package:shoppingproject/widget/show_women_list.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String? name, email;
  Widget currenWidget = AllProduct();

  @override
  void initState() {
    super.initState();
    findNameAnEmail();
  }

  Future<Null> findToken(String uid) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      await firebaseMessaging.getToken().then((value) async {
        print('### uid ที่ login อยู่ ==>> $uid');
        print('### token ==> $value');

        // Map<String, dynamic> data = Map();
        Map<String, dynamic> data = {};
        data['token'] = value;

        await FirebaseFirestore.instance
            .collection('profile')
            .doc(uid)
            .update(data)
            .then((value) => print('Update Token Success'));
      });
    });
  }

  Future<Null> findNameAnEmail() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        String uid = event!.uid;
        findToken(uid);
        setState(() {
          name = event.displayName;
          email = event.email;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //ส่วนของ appbar ด้านบน ประกอบไปด้วย icon ต่างๆ
      appBar: AppBar(
        backgroundColor: MyStyle().primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/showCart'),
          ),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () => Navigator.pushNamed(context, '/showOrderCustomer'),
          ),
        ],
      ),
      //ส่วนของ appbar ด้านบน ประกอบไปด้วย icon ต่างๆ

      drawer: buildDrawer(),
      body: currenWidget,
    );
  }
  //ส่วนของ drawer
  Drawer buildDrawer() {
    return Drawer(
      child: Stack(
        children: [
          Column(
            children: [
              buildUserAccountsDrawerHeader(),
              buildListTileAllProduct(),
              buildListTileShowMenList(),
              buildListTileShowWomenList(),
              buildListTileShowProfile(),
              buildListTileAddProduct(),
            ],
          ),
          buildSignOut(),
        ],
      ),
    );
  }
  //ส่วนของ drawer

  ListTile buildListTileAllProduct() {
    return ListTile(
      leading: Icon(
        Icons.home,
        color: MyStyle().lightColor,
        size: 36.0,
      ),
      title: Text('Home'),
      subtitle: Text('Show All Product in my Stock'),
      onTap: () {
        setState(() {
          currenWidget = AllProduct();
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildListTileShowMenList() {
    return ListTile(
      leading: Icon(
        Icons.face,
        color: Colors.blue,
        size: 36.0,
      ),
      title: Text('Product For Men'),
      subtitle: Text('Show All Product in my Stock'),
      onTap: () {
        setState(() {
          currenWidget = ShowMenList();
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildListTileShowWomenList() {
    return ListTile(
      leading: Icon(
        Icons.face,
        color: Colors.pink,
        size: 36.0,
      ),
      title: Text('Product For Women'),
      subtitle: Text('Show All Product in my Stock'),
      onTap: () {
        setState(() {
          currenWidget = ShowWomenList();
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildListTileShowProfile() {
    return ListTile(
      leading: Icon(
        Icons.account_circle,
        size: 36.0,
      ),
      title: Text('Profile User'),
      subtitle: Text('edit Profile'),
      onTap: () {
        setState(() {
          currenWidget = ShowProfileUser();
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildListTileAddProduct() {
    return ListTile(
      leading: Icon(
        Icons.queue,
        size: 36.0,
        color: Colors.greenAccent,
      ),
      title: Text('Add Product'),
      subtitle: Text('product'),
      onTap: () {
        setState(() {
          currenWidget = AddListProduct();
        });
        Navigator.pop(context);
      },
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/wall.jpg'), fit: BoxFit.cover),
      ),
      accountName: MyStyle().titleH2White(name == null ? 'Name' : name!),
      accountEmail: MyStyle().titleH2White(email == null ? 'Email' : email!),
      currentAccountPicture: Image.asset('images/logo.png'),
    );
  }

  Column buildSignOut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            await Firebase.initializeApp().then((value) async {
              await FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/authen', (route) => false));
            });
          },
          tileColor: MyStyle().darkColor,
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.white,
            size: 36.0,
          ),
          title: MyStyle().titleH2White('Sign Out'),
          subtitle: MyStyle().titleH3White('Sign Out & Go to Login'),
        ),
      ],
    );
  }
}
