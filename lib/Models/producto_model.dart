List<ProductoModel> productosFromJson(dynamic str) =>
    List<ProductoModel>.from((str).map((x) => ProductoModel.fromJson(x)));

ProductoModel productoFromJson(dynamic str) => ProductoModel.fromJson(str);

class ProductoModel {
  late int? idProducto;
  late String? nombreProducto;
  late String? imagen;
  late String? descripcion;
  late num? precio;
  late int? idCategoria;
  late int? estadoProducto;
  late int? idUsuario;

  ProductoModel(
      {this.idProducto,
      this.nombreProducto,
      this.imagen,
      this.descripcion,
      this.precio,
      this.idCategoria,
      this.estadoProducto,
      this.idUsuario});

  ProductoModel.fromJson(Map<String, dynamic> json) {
    idProducto = json["idProducto"];
    nombreProducto = json["nombreProducto"];
    imagen = json["imagen"];
    descripcion = json["descripcion"];
    precio = json["precio"];
    idCategoria = json["idCategoria"];
    estadoProducto = json["estadoProducto"];
    idUsuario = json["idUsuario"];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data["idProducto"] = idProducto;
    _data["nombreProducto"] = nombreProducto;
    _data["imagen"] = imagen;
    _data["descripcion"] = descripcion;
    _data["precio"] = precio;
    _data["idCategoria"] = idCategoria;
    _data["estadoProducto"] = estadoProducto;
    _data["idUsuario"] = idUsuario;
    return _data;
  }
}
