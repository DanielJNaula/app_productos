

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:validacion_formularios/src/models/producto_model.dart';
import 'package:validacion_formularios/src/provider/productos_provider.dart';
import 'package:validacion_formularios/src/utils/utils.dart' as utils;


class ProductoPage extends StatefulWidget {

  
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  PickedFile photo;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductoModel producto = new ProductoModel();
  final productoProvider = new ProductosProvider();

  bool _guardando = false;


  @override
  Widget build(BuildContext context) {

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;

    if ( prodData != null ) {
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual), 
            onPressed: _seleccionarFoto
          ),
          IconButton(
            icon: Icon(Icons.camera_alt), 
            onPressed: _tomarFoto
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearEstado(),
                _crearBoton(),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _crearNombre(){
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value)=> producto.titulo = value,
      validator: (value){
        return value.length < 3 ?  'Ingrese el nombre del producto' :  null;
      },
    );
  }

  Widget _crearPrecio(){
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value)=> producto.valor = double.parse(value),
      validator: (value){
        return utils.isNumero(value) ? null : 'Solo números';
      },
    );
  }

  Widget _crearEstado(){
    return SwitchListTile(
      value: producto.estado,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple, 
      onChanged: (value)=>setState(() {
          producto.estado = value;
        })
      
    );
  }

  Widget _crearBoton(){
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null:_submit
      
    );
  }

  void _submit() async{
    
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    setState(() { _guardando = true;});

    if (photo !=null) {
      producto.fotoUrl =  await productoProvider.subirImagen(File(photo.path));
      print('=======================');
      print('=======================');
      print('=======================');
      print('=======================');
      print('=======================');
      print('=======================');
      print(producto.fotoUrl);
    }

    if ( producto.id == null ) {
      productoProvider.crearProducto(producto);
      mostrarSnackBar('Registro guardado');  
      Navigator.pushNamed(context, 'home').then((value) { setState(() { });});
    } else {
      productoProvider.editarProducto(producto);
      mostrarSnackBar('Registro Editado');
      Navigator.pop(context);
    }

    setState(() { _guardando = false;});

    
  }

  void mostrarSnackBar(String mensaje){

    final snackbar = SnackBar(
      content: Text( mensaje ),
      duration: Duration( milliseconds: 3500 ),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto(){
    if (producto.fotoUrl != null ) {
      return FadeInImage(
        placeholder: AssetImage('assets/jar-loading.gif'), 
        image: NetworkImage( producto.fotoUrl ),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }else{
      if( photo != null ){
        return Image.file(
          File(photo.path),
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset('assets/no-image.png');
    }
  }

  _seleccionarFoto(){
    _processImage( ImageSource.gallery );
  }

  

  _tomarFoto(){
    _processImage( ImageSource.camera );
  }

  _processImage( ImageSource type ) async {
    final _picker = ImagePicker();
 
    final pickedFile = await _picker.getImage(
      source: type,
    );
 
    // Para manejar el error al cancelar la seleccion de una foto
    try {
      photo = PickedFile(pickedFile.path);
    } catch (e) {
      print('$e');
    }
 
    // Si el usuario cancelo o no selecciona una foto
    if (photo != null) {
      // limpieza
      producto.fotoUrl = null;
    }
    
 
    setState(() {});
  }
}