import 'dart:convert';
import 'dart:io';
import 'package:mime_type/mime_type.dart';

import 'package:http/http.dart'as http;
import 'package:http_parser/http_parser.dart';
import 'package:validacion_formularios/src/models/producto_model.dart';
import 'package:validacion_formularios/src/preferencias/preferencias_usuario.dart';

class ProductosProvider {
  final String _url = 'https://flutter-varios-fa8b1.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto( ProductoModel producto ) async{

    final url = '$_url/productos.json?auth=${_prefs.token}';

    final resp = await http.post( url, body: productoModelToJson(producto) );

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarProducto( ProductoModel producto ) async{

    final url = '$_url/productos/${ producto.id }.json?auth=${_prefs.token}';

    final resp = await http.put( url, body: productoModelToJson(producto) );

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async{
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodeData = json.decode(resp.body);
    if ( decodeData == null) return[];

    final List<ProductoModel> productos = new List();
    
    decodeData.forEach((id, prod) { 
      final prodTem = ProductoModel.fromJson(prod);
      prodTem.id = id;
      productos.add(prodTem);
    });

    
    return productos;
  }

  Future<int> borrarProducto( ProductoModel producto ) async{

    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';
    final resp = await http.delete(url);
    print( json.decode(resp.body) );

    return 1;
  }

  Future<String> subirImagen( File imagen ) async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dqsrvzxth/image/upload?upload_preset=yl6usuru');
    final mimeType = mime(imagen.path).split('/');

    final imagenUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType( mimeType[0],mimeType[1])
    );

    imagenUploadRequest.files.add(file);

    final streamResponse = await imagenUploadRequest.send();

    final res = await http.Response.fromStream(streamResponse);

    if (res.statusCode != 200 && res.statusCode != 201) {
      print('Algo salio Mal');
      print(res.body);
      return null;
    }

    final respData = json.decode(res.body);
    print(respData);
    return respData['secure_url'];
  }

}