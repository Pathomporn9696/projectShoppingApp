import 'package:flutter/material.dart';

class MyStyle {

  Color darkColor = Color(0xffc30000);
  Color primaryColor = Color(0xffff2626);
  Color lightColor = Color(0xffff6751);

  Widget showProgress() => Center(child: CircularProgressIndicator());
  
  Widget showLogo()=>Image.asset('images/logo.png');

  Widget titleH1(String string) =>Text(
    string, 
    style: TextStyle(
      fontSize: 30, 
      fontWeight: FontWeight.bold,
      color: lightColor,
    ),
  );

  Widget titleH2(String string) =>Text(
    string, 
    style: TextStyle(
      fontSize: 20, 
      fontWeight: FontWeight.w500,
      color: lightColor,
    ),
  );

  Widget titleH2White(String string) =>Text(
    string, 
    style: TextStyle(
      fontSize: 20, 
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  );

  Widget titleH3(String string) =>Text(
    string, 
    style: TextStyle(
      fontSize: 16, 
      //fontWeight: FontWeight.bold,
      color: lightColor,
    ),
  );

  Widget titleH3White(String string) =>Text(
    string, 
    style: TextStyle(
      fontSize: 16, 
      //fontWeight: FontWeight.bold,
      color: Colors.white54,
    ),
  );

  MyStyle();
}