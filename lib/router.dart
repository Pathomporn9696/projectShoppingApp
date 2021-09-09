import 'package:flutter/material.dart';
import 'package:shoppingproject/widget/add_list_product.dart';
import 'package:shoppingproject/widget/authen.dart';
import 'package:shoppingproject/widget/bag_men_list.dart';
import 'package:shoppingproject/widget/edit_profile.dart';
import 'package:shoppingproject/widget/hat_men_list.dart';
import 'package:shoppingproject/widget/myhome.dart';
import 'package:shoppingproject/widget/pants_men_list.dart';
import 'package:shoppingproject/widget/register.dart';
import 'package:shoppingproject/widget/shirt_men_list.dart';
import 'package:shoppingproject/widget/shoes_men_list.dart';
import 'package:shoppingproject/widget/show_cart.dart';
import 'package:shoppingproject/widget/show_men_list.dart';
import 'package:shoppingproject/widget/show_order_customer.dart';


final Map<String, WidgetBuilder> routes ={
  '/authen':(BuildContext context)=> Authen(),
  '/register':(BuildContext context)=>Register(),
  '/myHome': (BuildContext context)=> MyHome(),
  '/showMen':(BuildContext context)=>ShowMenList(),
  '/shirtmen':(BuildContext context)=> ShirtMenList(),
  '/hatmen':(BuildContext context)=> HatMenList(),
  '/pantsmen':(BuildContext context)=>PantsMen(),
  '/shoesmen':(BuildContext context)=>ShoesMenList(),
  '/bagmen':(BuildContext context)=> BagMenProduct(),
  '/addProduct':(BuildContext context)=>AddListProduct(),
  '/editProfile':(BuildContext context)=>EditProfile(),
  '/showCart':(BuildContext context)=>ShowCart(),
  '/showOrderCustomer':(BuildContext context)=>ShowOderCustomer(),
  
};