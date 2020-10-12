import 'package:flutter/material.dart';
import 'package:validacion_formularios/src/bloc/provider.dart';
import 'package:validacion_formularios/src/models/producto_model.dart';
import 'package:validacion_formularios/src/provider/productos_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('home'),
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: ()=>Navigator.pushNamed(context, 'producto')
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
      future: productosProvider.cargarProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, i) => _crearItem( context ,snapshot.data[i] )
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearItem(BuildContext context ,ProductoModel producto){
    
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red
      ),
      onDismissed: ( direccion ){
        //borrar producto
        productosProvider.borrarProducto(producto);
      },
      child: Card(
        child: Column(
          children: [
            (producto.fotoUrl == null)
            ? Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(
              placeholder: AssetImage('assets/jar-loading.gif'), 
              image: NetworkImage(producto.fotoUrl),
              width: double.infinity,
              height: 300.0,
              fit: BoxFit.cover,

            ),

            ListTile(
              title: Text('${ producto.titulo } - ${ producto.valor }'),
                subtitle: Text( producto.id ),
                onTap: ()=> Navigator.pushNamed(context, 'producto', arguments: producto).then((value) { setState(() { }); }),
                //onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto ).then((value) { setState(() { }); }),
              )
          ],
        ),
      )
    );
  }
}