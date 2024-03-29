import 'package:flutter/material.dart';

bool isNumero( String s){
  if (s.isEmpty) return false;
  
  final n = num.tryParse(s);

  return ( n == null ) ? false : true;

}

void mostrarAlerta( BuildContext context, String mensaje){
  showDialog(
    context: context,
    builder: ( context ){
        return AlertDialog(
          title: Text('Infomración incorrecta'),
          content: Text(mensaje),
          actions: [
            FlatButton(
              child: Text('OK'),
              onPressed: ()=> Navigator.of(context).pop(),
            )
          ],
        );
    }
  );
}