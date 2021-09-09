import 'package:flutter/material.dart';

Future<Null> normalDialog(BuildContext context, String? title, String? message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        leading: Image.asset('images/logo.png'),
        title: Text(title!,style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),),
        subtitle: Text(message!),
      ),
      children: [TextButton(onPressed: ()=> Navigator.pop(context), child: Text('OK'))],
    ),
  );
}
