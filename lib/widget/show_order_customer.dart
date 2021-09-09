import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoppingproject/models/order_firebase_model.dart';
import 'package:shoppingproject/utility/my_style.dart';

class ShowOderCustomer extends StatefulWidget {
  ShowOderCustomer({Key? key}) : super(key: key);

  @override
  _ShowOderCustomerState createState() => _ShowOderCustomerState();
}

class _ShowOderCustomerState extends State<ShowOderCustomer> {
  bool statusLoad = true;
  List<OrderFirebaseModel> orderFirebaseModels = [];
  String? uidLogin;
  List<String> docs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readOrder();
  }

  Future<Null> readOrder() async {
    orderFirebaseModels.clear();
    docs.clear();
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        uidLogin = event!.uid;
        await FirebaseFirestore.instance
            .collection('profile')
            .doc(event.uid)
            .collection('orderproduct')
            .snapshots()
            .listen((event) {
          setState(() {
            statusLoad = false;
          });
          for (var item in event.docs) {
            OrderFirebaseModel orderFirebaseModel =
                OrderFirebaseModel.fromMap(item.data());
            docs.add(item.id);
            setState(() {
              orderFirebaseModels.add(orderFirebaseModel);
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Order Customer'),
      ),
      body: statusLoad
          ? MyStyle().showProgress()
          : orderFirebaseModels.length == 0
              ? Center(child: MyStyle().titleH1('No Order'))
              : buildListView(),
    );
  }

  Future<Null> updataOrder(OrderFirebaseModel model, int index) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('profile')
          .doc(uidLogin)
          .collection('orderproduct')
          .doc(docs[index])
          .update({'status': 'Finish'}).then((value) => readOrder());
    });
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: orderFirebaseModels.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          updataOrder(orderFirebaseModels[index], index);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(orderFirebaseModels[index].nameproduct!),
                ),
                Expanded(
                  flex: 2,
                  child: Text(orderFirebaseModels[index].namebuyer!),
                ),
                Expanded(
                  flex: 1,
                  child: Text(orderFirebaseModels[index].price!),
                ),
                Expanded(
                  flex: 1,
                  child: Text(orderFirebaseModels[index].amount!),
                ),
                Expanded(
                  flex: 1,
                  child: Text(orderFirebaseModels[index].sum!),
                ),
                Expanded(
                  flex: 1,
                  child: buildStatus(orderFirebaseModels[index].status),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStatus(String? string) {
    Color? color;
    switch (string) {
      case 'Order':
        color = Colors.red;
        break;
      case 'Finish':
        color = Colors.green;
        break;
      default:
    }
    return Container(
      decoration: BoxDecoration(color: color),
      child: Text(string!),
    );
  }
}
