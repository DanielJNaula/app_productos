// To parse this JSON data, do
//
//     final productoModel = productoModelFromJson(jsonString);

import 'dart:convert';

ProductoModel productoModelFromJson(String str) => ProductoModel.fromJson(json.decode(str));

String productoModelToJson(ProductoModel data) => json.encode(data.toJson());

class ProductoModel {
    ProductoModel({
        this.id,
        this.titulo = '',
        this.valor  = 0.0,
        this.estado = true,
        this.fotoUrl,
    });

    String id;
    String titulo;
    double valor;
    bool estado;
    String fotoUrl;

    factory ProductoModel.fromJson(Map<String, dynamic> json) => ProductoModel(
        id      : json["id"],
        titulo  : json["titulo"],
        valor   : json["valor"],
        estado  : json["estado"],
        fotoUrl : json["fotoUrl"],
    );

    Map<String, dynamic> toJson() => {
        //"id"      : id,
        "titulo"  : titulo,
        "valor"   : valor,
        "estado"  : estado,
        "fotoUrl" : fotoUrl,
    };
}