import 'dart:async';

class Validaciones {

  final validacionEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink){
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      RegExp regExp = new RegExp(pattern);
      if (regExp.hasMatch(email)) {
        sink.add( email );
        
      } else {
        sink.addError('Email no es correcto');
      }

    }
  );

  final validacionContrasenia = StreamTransformer<String, String>.fromHandlers(
    handleData: (contrasenia, sink){
      if (contrasenia.length >= 6) {
        sink.add( contrasenia );
      } else {
        sink.addError('Mas de 6 caracteres por favor');
      }
    }
  );
}