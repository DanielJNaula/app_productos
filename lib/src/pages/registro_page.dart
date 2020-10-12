import 'package:flutter/material.dart';
import 'package:validacion_formularios/src/bloc/provider.dart';
import 'package:validacion_formularios/src/provider/usuario_provider.dart';
import 'package:validacion_formularios/src/utils/utils.dart';

class RegistroPage extends StatelessWidget {
  //const RegistroPage({Key key}) : super(key: key);
  final usuarioProvider = new UsuarioProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _crearFondo( context ),
          _loginForm( context )
        ],
      ),
    );
  }

  Widget _loginForm(BuildContext context){
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(child: Container(height: size.height * 0.28)),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular( 5.0 ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: [
                Text('Crear Cuenta', style: TextStyle(fontSize: 20.0)),
                SizedBox( height: 60.0 ),
                _crearEmail(bloc),
                SizedBox( height: 30.0 ),
                _crearContrasenia(bloc),
                SizedBox( height: 30.0 ),
                _crearBoton(bloc)

              ],
            ),
          ),
          FlatButton(
            child: Text('¿Ya tienes cuenta? Login'),
            onPressed: ()=>Navigator.pushReplacementNamed(context, 'login')
          ),
          SizedBox(height: 100.0)
        ],
      ),
    );
  } 

  Widget _crearBoton(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.formValidacionStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Registrar'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _registroNuevoUsuario(bloc, context) : null
        );
      },
    );
    
  }

  _registroNuevoUsuario(LoginBloc bloc, BuildContext context) async{
    
    Map info =  await usuarioProvider.nuevoUsuario(bloc.email, bloc.contrasenia);

    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      mostrarAlerta(context, info['mensaje']);
    }
  }

  Widget _crearEmail(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.emailStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electrónico',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.cambioEmail,
          ),
        );
      },
    );    
  } 

  Widget _crearContrasenia(LoginBloc bloc){
    
    return StreamBuilder(
      stream: bloc.contrasenialStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: bloc.cambioContrasenia,
          ),
        );
      },
    );
  } 

  Widget _crearFondo( BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoMorado =  Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ]
        )
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );
    return Stack(
      children: [
        fondoMorado,
        Positioned(top: size.height * 0.1, left: 30.0,child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0,child: circulo),
        Positioned(bottom: 120.0, right: -10.0,child: circulo),
        Positioned(bottom: -50.0, left: -20.0,child: circulo),

        Container(
          padding: EdgeInsets.only(top: size.height * 0.1),
          child: Column(
            children: [
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0 ),
              SizedBox( height: 10.0, width: double.infinity),
              Text('Daniel Naula',style: TextStyle(color: Colors.white, fontSize: 25.0))
            ],
          ),
        )
      ],
    );
  }
}