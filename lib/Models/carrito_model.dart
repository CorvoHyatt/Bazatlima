List<CarritoModel> carritoFromJson(dynamic str) =>
    List<CarritoModel>.from((str).map((x) => CarritoModel.fromJson(x)));

class CarritoModel {
  late int? idUsuario;
  late int? idProducto;

  CarritoModel({this.idUsuario, this.idProducto});

  CarritoModel.fromJson(Map<String, dynamic> json) {
    idUsuario = json["idProducto"];
    idProducto = json["idProducto"];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data["idUsuario"] = idUsuario;
    _data["idProducto"] = idProducto;
    return _data;
  }
}
