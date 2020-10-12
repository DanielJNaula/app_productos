import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:validacion_formularios/src/preferencias/preferencias_usuario.dart';

class UsuarioProvider {
  final String _firebaseToken='AIzaSyC-BhC5iHz91HVvsV0BDDoYe4VW5NxAdus'; 
  final _prefs = new PreferenciasUsuario();



  Future<Map<String, dynamic>> login( String email, String contrasenia ) async{
    final authData={
      'email': email,
      'password': contrasenia,
      'returnSecureToken': true
    };

    final res = await http.post('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodeResp = json.decode(res.body);

    print(decodeResp);

    if (decodeResp.containsKey('idToken')) {
      //Todo: Salvar el token en el storage
      _prefs.token = decodeResp['idToken'];
      return{'ok': true, 'token': decodeResp['idToken']};
    } else {
      return{'ok': false, 'mensaje': decodeResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(String email, String contrasenia) async{
    final authData={
      'email': email,
      'password': contrasenia,
      'returnSecureToken': true
    };

    final res = await http.post('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodeResp = json.decode(res.body);

    print(decodeResp);

    if (decodeResp.containsKey('idToken')) {
      //Todo: Salvar el token en el storage
      _prefs.token = decodeResp['idToken'];
      return{'ok': true, 'token': decodeResp['idToken']};
    } else {
      return{'ok': false, 'mensaje': decodeResp['error']['message']};
    }
  }


}