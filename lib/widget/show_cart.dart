import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoppingproject/models/order_firebase_model.dart';
import 'package:shoppingproject/models/order_sqlite_model.dart';
import 'package:shoppingproject/utility/my_style.dart';
import 'package:shoppingproject/utility/sqlitehelper.dart';

class ShowCart extends StatefulWidget {
  ShowCart({Key? key}) : super(key: key);

  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<OrderSQLiteModel> orderSQLiteModels = [];

  bool statusLoad = true;
  int? total;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCart();
  }

  Future<Null> readCart() async {
    total = 0;
    orderSQLiteModels.clear();
    await SQLiteHelper().readData().then((value) {
      for (var item in value) {
        setState(() {
          total = total! + int.parse(item.sum!);
        });
      }

      setState(() {
        orderSQLiteModels = value;
        statusLoad = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => orderProduct(),
        child: Icon(
          Icons.monetization_on,
          size: 48,
        ),
      ),
      appBar: AppBar(
        title: Text('Show Cart'),
      ),
      body: statusLoad
          ? MyStyle().showProgress()
          : orderSQLiteModels.length == 0
              ? Center(child: MyStyle().titleH1('Cart Empty'))
              : Column(
                  children: [
                    buildTitle(),
                    buildListView(),
                    Divider(),
                    buildTotal(),
                  ],
                ),
    );
  }

  Future<Null> orderProduct() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uidBuyer = event!.uid;
        String? nameBuyer = event.displayName;
        DateTime dateTime = DateTime.now();
        Timestamp timestamp = Timestamp.fromDate(dateTime);
        print('datatime =$dateTime, timestamp ==> $timestamp');

        for (var item in orderSQLiteModels) {
          OrderFirebaseModel orderFirebaseModel = OrderFirebaseModel(
            amount: item.amount,
            timestamp: timestamp,
            namebuyer: nameBuyer,
            nameproduct: item.nameproduct,
            price: item.price,
            status: 'Order',
            sum: item.sum,
            uidbuyer: uidBuyer,
          );

          Map<String, dynamic> data = orderFirebaseModel.toMap();

          await FirebaseFirestore.instance
              .collection('profile')
              .doc(item.uidshop)
              .collection('orderproduct')
              .doc()
              .set(data)
              .then((value) {
            print('Add data Success');
            SQLiteHelper().deleteDataWhereId(item.id);
          });
        }

        // process Sent Noti
        

        readCart();
      });
    });
  }

  Row buildTotal() {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyStyle().titleH2('Total :'),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: MyStyle().titleH2(total == null ? '?' : '$total'),
        ),
      ],
    );
  }

  Widget buildTitle() {
    return Container(
      decoration: BoxDecoration(color: MyStyle().lightColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text('Product'),
            ),
            Expanded(
              flex: 2,
              child: Text('Shop'),
            ),
            Expanded(
              flex: 1,
              child: Text('Price'),
            ),
            Expanded(
              flex: 1,
              child: Text('Amt'),
            ),
            Expanded(
              flex: 1,
              child: Text('sum'),
            ),
          ],
        ),
      ),
    );
  }
  //หน้า ตะกร้า สินค้า
  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: orderSQLiteModels.length,
      itemBuilder: (context, index) => Dismissible(
        key: Key(orderSQLiteModels[index].uidshop!),
        onDismissed: (direction) async {
          print('dismiss at id ==>> ${orderSQLiteModels[index].id}');
          await SQLiteHelper()
              .deleteDataWhereId(orderSQLiteModels[index].id)
              .then(((value) => readCart()));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(orderSQLiteModels[index].nameproduct!),
              ),
              Expanded(
                flex: 2,
                child: Text(orderSQLiteModels[index].nameshop!),
              ),
              Expanded(
                flex: 1,
                child: Text(orderSQLiteModels[index].price!),
              ),
              Expanded(
                flex: 1,
                child: Text(orderSQLiteModels[index].amount!),
              ),
              Expanded(
                flex: 1,
                child: Text(orderSQLiteModels[index].sum!),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//หน้า ตะกร้า สินค้า
