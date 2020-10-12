import 'dart:async';

import 'package:validacion_formularios/src/bloc/validaciones_login.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validaciones {
  final _emailController = BehaviorSubject<String>();
  final _contraseniaController = BehaviorSubject<String>();

  //Recuperar los datos del Stream

  Stream<String> get emailStream => _emailController.stream.transform( validacionEmail );
  Stream<String> get contrasenialStream => _contraseniaController.stream.transform( validacionContrasenia );

  Stream<bool> get formValidacionStream =>
  Rx.combineLatest2(emailStream, contrasenialStream, (e, p) => true);

  //Insertar valores al stream
  Function(String) get cambioEmail => _emailController.sink.add;
  Function(String) get cambioContrasenia => _contraseniaController.sink.add;

  //Obtener el ultimo valor ingresado a los streams
  String get email => _emailController.value;
  String get contrasenia => _contraseniaController.value;

  
  
  dispose(){
    _emailController?.close();
    _contraseniaController?.close();
  }


}