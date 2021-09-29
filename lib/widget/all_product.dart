import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shoppingproject/models/order_sqlite_model.dart';
import 'package:shoppingproject/models/product_men.dart';
import 'package:shoppingproject/models/profile_model.dart';
import 'package:shoppingproject/utility/my_style.dart';
import 'package:shoppingproject/utility/sqlitehelper.dart';
import 'package:shoppingproject/widget/search_all_product.dart';

class AllProduct extends StatefulWidget {
  @override
  _AllProductState createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  List<ProductMenModel> shirtProductMenModels = [];
  List<Widget> shirtWidgets = [];

  List<ProductMenModel> hatProductMenModels = [];
  List<Widget> hatWidgets = [];

  List<ProductMenModel> bagProductMenModels = [];
  List<Widget> bagWidgets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('product')
          .snapshots()
          .listen((event) {
        int indexShirt = 0;
        for (var item in event.docs) {
          ProductMenModel shirtmodel = ProductMenModel.fromMap(item.data());
          Widget shirtwidget =
              buildTemplate(context, shirtmodel, 'Shirt', indexShirt);
          setState(() {
            shirtProductMenModels.add(shirtmodel);
            shirtWidgets.add(shirtwidget);
          });
          indexShirt++;
        }
      });
    });

    await FirebaseFirestore.instance
        .collection('productMenHat')
        .snapshots()
        .listen((event) {
      int indexHat = 0;
      for (var item in event.docs) {
        ProductMenModel hatmodel = ProductMenModel.fromMap(item.data());
        Widget hatWidget = buildTemplate(context, hatmodel, 'Hat', indexHat);
        setState(() {
          hatProductMenModels.add(hatmodel);
          hatWidgets.add(hatWidget);
        });
        indexHat++;
      }
    });

    await FirebaseFirestore.instance
        .collection('productbag')
        .snapshots()
        .listen((event) {
      int indexBag = 0;
      for (var item in event.docs) {
        ProductMenModel bagmodel = ProductMenModel.fromMap(item.data());
        Widget bagwidget = buildTemplate(context, bagmodel, 'Bag', indexBag);
        setState(() {
          bagProductMenModels.add(bagmodel);
          bagWidgets.add(bagwidget);
        });
        indexBag++;
      }
    });
  }

  Future<Null> addProductToSQLite(
    ProductMenModel model,
    int amountInt,
  ) async {
    String? uidshop, nameshop, nameproduct, price, amount, sum;
    uidshop = model.uid;

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('profile')
          .doc(uidshop)
          .snapshots()
          .listen((event) async {
        ProfileModel profileModel = ProfileModel.fromMap(event.data()!);
        if (profileModel.name != null) {
          nameshop = profileModel.name;
        } else {
          nameshop = 'none';
        }

        nameproduct = model.name;
        price = model.detail;
        amount = amountInt.toString();

        int sumInt = amountInt * int.parse(price!.trim());
        sum = sumInt.toString();

        print(
            '### uidshop = $uidshop, nameshop = $nameshop, nameproduct= $nameproduct,\n price = $price, amount = $amount, sum = $sum');
        OrderSQLiteModel orderSQLiteModel = OrderSQLiteModel(
            uidshop: uidshop,
            nameshop: nameshop,
            nameproduct: nameproduct,
            price: price,
            amount: amount,
            sum: sum);

        await SQLiteHelper()
            .insertData(orderSQLiteModel)
            .then(((value) => print('Success Insert SQLite')));
      });
    });
  }
  //ส่วนของการ add สินค้าลงตะกร้า
  Future<Null> addProductToCart(ProductMenModel model) async {
    int amount = 1;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SimpleDialog(
          title: ListTile(
            leading: CachedNetworkImage(
              imageUrl: model.pathImage!,
              placeholder: (context, url) => MyStyle().showProgress(),
              errorWidget: (context, url, error) => Image(
                image: AssetImage('images/pic.png'),
              ),
            ),
            title: MyStyle().titleH1(model.name!),
            subtitle: MyStyle().titleH3('Price = ${model.detail} BHT'),
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: () {
                    setState(() {
                      amount++;
                    });
                  },
                ),
                MyStyle().titleH2('$amount'),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    if (amount > 1) {
                      setState(() {
                        amount--;
                      });
                    } else {
                      setState(() {
                        amount = 1;
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    addProductToSQLite(model, amount);
                  },
                  child: Text('Add to Cart'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  //ส่วนของการ add สินค้าลงตะกร้า

  //ส่วนของ ui โชว์สินค้าต่่างๆ
  Container buildTemplate(BuildContext context, ProductMenModel productMenModel,
      String type, int index) {
    return Container(
      margin: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width * 0.45,
      child: GestureDetector(
        onTap: () {
          print('you click index = $index, type = $type');
          switch (type) {
            case 'Shirt':
              addProductToCart(shirtProductMenModels[index]);
              break;
            case 'Hat':
              addProductToCart(hatProductMenModels[index]);
              break;
            case 'Bag':
              addProductToCart(bagProductMenModels[index]);
              break;
            default:
          }
        },
        child: Card(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4 - 20,
                height: MediaQuery.of(context).size.width * 0.4 - 10,
                child: CachedNetworkImage(
                  imageUrl: productMenModel.pathImage!,
                  placeholder: (context, url) => MyStyle().showProgress(),
                  errorWidget: (context, url, error) => Image(
                    image: AssetImage('images/pic.png'),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color: MyStyle().primaryColor.withOpacity(0.23),
                  )
                ]),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${productMenModel.name}\n'.toUpperCase(),
                            style: Theme.of(context).textTheme.button,
                          ),
                          TextSpan(
                              text: type.toUpperCase(),
                              style: TextStyle(color: MyStyle().lightColor))
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${productMenModel.detail}',
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
        ),
      ),
    );
  }
  //ส่วนของ ui โชว์สินค้าต่่างๆ

  //ส่วน body แสดงสินค้าต่างๆ
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(size, context),
            buildTitleProduct('Shirt', '/shirtmen'),
            buildSingleChildScrollViewShirt(),
            buildTitleProduct('Hat', '/hatmen'),
            buildSingleChildScrollViewHat(),
            buildTitleProduct('Bag', '/bagmen'),
            buildSingleChildScrollViewBag(),
          ],
        ),
      ),
    );
  }
  //ส่วน body แสดงสินค้าต่างๆ

  Padding buildTitleProduct(String title, String myRoute) {
    return Padding(
      padding: const EdgeInsets.only(top: 1, left: 15, right: 15),
      child: Row(
        children: [
          Container(
            height: 24,
            child: Stack(
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 7,
                    color: MyStyle().lightColor.withOpacity(0.2),
                  ),
                )
              ],
            ),
          ),
          Spacer(),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: MyStyle().lightColor,
            onPressed: () => Navigator.pushNamed(context, myRoute),
            child: Text(
              'ProductAll',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  SingleChildScrollView buildSingleChildScrollViewShirt() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: shirtWidgets,
      ),
    );
  }

  SingleChildScrollView buildSingleChildScrollViewHat() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: hatWidgets,
      ),
    );
  }

  SingleChildScrollView buildSingleChildScrollViewBag() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: bagWidgets,
      ),
    );
  }
} //end

SingleChildScrollView buildSingleChildScrollViewBag(
    Size size, BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        buildBag1(size, context),
        buildBag2(size, context),
        buildBag3(size, context),
        buildBag4(size, context),
      ],
    ),
  );
}

Container buildShirt(Size size, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 15,
      left: 15,
      right: 15,
      top: 15,
    ),
    width: size.width * 0.4,
    child: Column(
      children: [
        Image.asset('images/hoodie1.jpg'),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: MyStyle().primaryColor.withOpacity(0.23),
            )
          ]),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hoodie\n'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                    TextSpan(
                        text: 'Shirt'.toUpperCase(),
                        style: TextStyle(color: MyStyle().lightColor))
                  ],
                ),
              ),
              Spacer(),
              Text(
                '\499 Bath',
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
}

Container buildShirt2(Size size, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 15,
      left: 15,
      right: 15,
      top: 15,
    ),
    width: size.width * 0.4,
    child: Column(
      children: [
        Image.asset('images/hoodie2.jpg'),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: MyStyle().primaryColor.withOpacity(0.23),
            )
          ]),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hoodie\n'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                    TextSpan(
                        text: 'Shirt'.toUpperCase(),
                        style: TextStyle(color: MyStyle().lightColor))
                  ],
                ),
              ),
              Spacer(),
              Text(
                '\99 Bath',
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
}

Container buildShirt3(Size size, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 15,
      left: 15,
      right: 15,
      top: 15,
    ),
    width: size.width * 0.4,
    child: Column(
      children: [
        Image.asset('images/hoodie3.jpg'),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: MyStyle().primaryColor.withOpacity(0.23),
            )
          ]),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hoodie\n'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                    TextSpan(
                        text: 'Shirt'.toUpperCase(),
                        style: TextStyle(color: MyStyle().lightColor))
                  ],
                ),
              ),
              Spacer(),
              Text(
                '\400 Bath',
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
}

Container buildShirt4(Size size, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 15,
      left: 15,
      right: 15,
      top: 15,
    ),
    width: size.width * 0.4,
    child: Column(
      children: [
        Image.asset('images/hoodie4.jpg'),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: MyStyle().primaryColor.withOpacity(0.23),
            )
          ]),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hoodie\n'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                    TextSpan(
                        text: 'Shirt'.toUpperCase(),
                        style: TextStyle(color: MyStyle().lightColor))
                  ],
                ),
              ),
              Spacer(),
              Text(
                '\150 Bath',
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
}

Container buildHat1(Size size, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 15,
      left: 15,
      right: 15,
      top: 15,
    ),
    width: size.width * 0.4,
    child: Column(
      children: [
        Image.asset('images/hat2.png'),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: MyStyle().primaryColor.withOpacity(0.23),
            )
          ]),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Adidas\n'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                    TextSpan(
                        text: 'HAT'.toUpperCase(),
                        style: TextStyle(color: MyStyle().lightColor))
                  ],
                ),
              ),
              Spacer(),
              Text(
                '\199 Bath',
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
}

Container buildHat2(Size size, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 15,
      left: 15,
      right: 15,
      top: 15,
    ),
    width: size.width * 0.4,
    child: Column(
      children: [
        Image.asset('images/hat3.png'),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: MyStyle().primaryColor.withOpacity(0.23),
            )
          ]),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Jordan\n'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                    TextSpan(
                        text: 'HAT'.toUpperCase(),
                        style: TextStyle(color: MyStyle().lightColor))
                  ],
                ),
              ),
              Spacer(),
              Text(
                '\299 Bath',
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
}

Container buildHat3(Size size, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 15,
      left: 15,
      right: 15,
      top: 15,
    ),
    width: size.width * 0.4,
    child: Column(
      children: [
        Image.asset('images/hat4.png'),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: MyStyle().primaryColor.withOpacity(0.23),
            )
          ]),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Nike\n'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                    TextSpan(
                        text: 'HAT'.toUpperCase(),
                        style: TextStyle(color: MyStyle().lightColor))
                  ],
                ),
              ),
              Spacer(),
              Text(
                '\199 Bath',
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
}

Container buildHat4(Size size, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 15,
      left: 15,
      right: 15,
      top: 15,
    ),
    width: size.width * 0.4,
    child: Column(
      children: [
        Image.asset('images/hat5.png'),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: MyStyle().primaryColor.withOpacity(0.23),
            )
          ]),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Hat\n'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                    TextSpan(
                        text: 'HAT'.toUpperCase(),
                        style: TextStyle(color: MyStyle().lightColor))
                  ],
                ),
              ),
              Spacer(),
              Text(
                '\199 Bath',
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
}

Container buildBag1(Size size, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 15,
      left: 15,
      right: 15,
      top: 15,
    ),
    width: size.width * 0.4,
    child: Column(
      children: [
        Image.asset('images/b1.png'),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: MyStyle().primaryColor.withOpacity(0.23),
            )
          ]),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Supream\n'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                    TextSpan(
                        text: 'BAG'.toUpperCase(),
                        style: TextStyle(color: MyStyle().lightColor))
                  ],
                ),
              ),
              Spacer(),
              Text(
                '\199 Bath',
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
}

Container buildBag2(Size size, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 15,
      left: 15,
      right: 15,
      top: 15,
    ),
    width: size.width * 0.4,
    child: Column(
      children: [
        Image.asset('images/b2.png'),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: MyStyle().primaryColor.withOpacity(0.23),
            )
          ]),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Nike\n'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                    TextSpan(
                        text: 'BAG'.toUpperCase(),
                        style: TextStyle(color: MyStyle().lightColor))
                  ],
                ),
              ),
              Spacer(),
              Text(
                '\999 Bath',
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
}

Container buildBag3(Size size, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 15,
      left: 15,
      right: 15,
      top: 15,
    ),
    width: size.width * 0.4,
    child: Column(
      children: [
        Image.asset('images/b3.png'),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: MyStyle().primaryColor.withOpacity(0.23),
            )
          ]),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Dakine\n'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                    TextSpan(
                        text: 'BAG'.toUpperCase(),
                        style: TextStyle(color: MyStyle().lightColor))
                  ],
                ),
              ),
              Spacer(),
              Text(
                '\500 Bath',
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
}

Container buildBag4(Size size, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(
      bottom: 15,
      left: 15,
      right: 15,
      top: 15,
    ),
    width: size.width * 0.4,
    child: Column(
      children: [
        Image.asset('images/b4.png'),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 50,
              color: MyStyle().primaryColor.withOpacity(0.23),
            )
          ]),
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Nike\n'.toUpperCase(),
                      style: Theme.of(context).textTheme.button,
                    ),
                    TextSpan(
                        text: 'BAG'.toUpperCase(),
                        style: TextStyle(color: MyStyle().lightColor))
                  ],
                ),
              ),
              Spacer(),
              Text(
                '\1299 Bath',
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
}

Padding buildTitleProductAllShirt(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 1, left: 15, right: 15),
    child: Row(
      children: [
        buildTitleProductShirt(),
        Spacer(),
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: MyStyle().lightColor,
          onPressed: () => Navigator.pushNamed(context, '/shirtmen'),
          child: Text(
            'ProductAll',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    ),
  );
}

Padding buildTitleProductAllBag(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 1, left: 15, right: 15),
    child: Row(
      children: [
        buildTitleProductBag(),
        Spacer(),
        FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: MyStyle().lightColor,
          onPressed: () => Navigator.pushNamed(context, '/bagmen'),
          child: Text(
            'ProductAll',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    ),
  );
}

Container buildTitleProductShirt() {
  return Container(
    height: 24,
    child: Stack(
      children: [
        Text(
          'ProductShirt',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 7,
            color: MyStyle().lightColor.withOpacity(0.2),
          ),
        )
      ],
    ),
  );
}

Container buildTitleProductHat() {
  return Container(
    height: 24,
    child: Stack(
      children: [
        Text(
          'ProductHat',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 7,
            color: MyStyle().lightColor.withOpacity(0.2),
          ),
        )
      ],
    ),
  );
}

Container buildTitleProductBag() {
  return Container(
    height: 24,
    child: Stack(
      children: [
        Text(
          'ProductBag',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 7,
            color: MyStyle().lightColor.withOpacity(0.2),
          ),
        )
      ],
    ),
  );
}

Container buildHeader(Size size, BuildContext context) {
  return Container(
    margin: EdgeInsets.only(bottom: 20),
    height: size.height * 0.2,
    child: Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 20,
            bottom: 15,
            right: 15,
            top: 15,
          ),
          height: size.height * 0.2 - 27,
          decoration: BoxDecoration(
              color: MyStyle().primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              )),
          child: Row(
            children: [
              Text(
                'Welcome To Shopping',
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // ส่วนของ Search bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 50,
                  color: MyStyle().primaryColor.withOpacity(0.23),
                ),
              ],
            ),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SearchAllProduct(),
                        ),
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.redAccent,
                      ),
                    ),
                    Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        // ส่วนของ Search bar
      ],
    ),
  );
}
