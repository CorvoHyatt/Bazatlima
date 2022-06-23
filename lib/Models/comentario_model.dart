List<ComentarioModel> carritoFromJson(dynamic str) =>
    List<ComentarioModel>.from((str).map((x) => ComentarioModel.fromJson(x)));

class ComentarioModel {
  late String? nombreUsuario;
  late String? comentario;

  ComentarioModel({this.nombreUsuario, this.comentario});

  ComentarioModel.fromJson(Map<String, dynamic> json) {
    nombreUsuario = json["nombreUsuario"];
    comentario = json["comentario"];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data["nombreUsuario"] = nombreUsuario;
    _data["comentario"] = comentario;
    return _data;
  }
}
