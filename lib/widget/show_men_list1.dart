import 'package:flutter/material.dart';


class ShowMenList extends StatefulWidget {
  @override
  _ShowMenListState createState() => _ShowMenListState();
}

class _ShowMenListState extends State<ShowMenList> {
  double? screen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Center(
          child: Column(
          children: [
            Text('สินค้าทั้งหมด'),
            Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      buildShirt(context),
                      buildHat(context),
                    ],
                  ),

                  Row(
                    children: [
                      buildPants(context),                     
                      buildShoes(context),
                    ],
                  ),
                ],
              ),
            )
          ],
      ),
        ),
      ],)
    );
  }

  Column buildShoes(BuildContext context) {
    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          width: 175,
                          child: Image.asset('images/shoes1.jpg')),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/shoesmen'),
                          child: Text('Shoes', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    );
  }

  Column buildPants(BuildContext context) {
    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          width: 175,
                          child: Image.asset('images/pants1.jpg')),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/pantsmen'),
                          child: Text('Pants', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    );
  }

  Column buildHat(BuildContext context) {
    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          width: 175,
                          child: Image.asset('images/hat1.jpg')),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/hatmen'),
                          child: Text('Hat', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    );
  }

  Column buildShirt(BuildContext context) {
    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          width: 175,
                          child: Image.asset('images/hoodie1.jpg')),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/shirtmen'),
                          child: Text('Shirt', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    );
  }
}
