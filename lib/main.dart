import 'package:flutter/material.dart';
import 'package:validacion_formularios/src/bloc/provider.dart';
import 'package:validacion_formularios/src/pages/home_page.dart';
import 'package:validacion_formularios/src/pages/login_page.dart';
import 'package:validacion_formularios/src/pages/producto_page.dart';
import 'package:validacion_formularios/src/pages/registro_page.dart';
import 'package:validacion_formularios/src/preferencias/preferencias_usuario.dart';
 
void main() async{
  WidgetsFlutterBinding.ensureInitialized(); 
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Provider(child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        'login'     : ( BuildContext context ) => LoginPage(),
        'registro'  : ( BuildContext context ) => RegistroPage(),
        'home'      : ( BuildContext context ) => HomePage(),
        'producto'  : ( BuildContext context ) => ProductoPage()
      },
      theme: ThemeData(
        primaryColor: Colors.deepPurple
      ),
    ));
  }
}