List<CalificacionModel> calificacionFromJson(dynamic str) =>
    List<CalificacionModel>.from(
        (str).map((x) => CalificacionModel.fromJson(x)));

// double estrellasFromJson(Map<dynamic, dynamic> json) {
//   var promedio = double.parse(json["estrellasPromedio"]);
//   return promedio;
// }

class CalificacionModel {
  late int? idUsuarioCalificado;
  late int? idUsuarioCalificador;
  late dynamic? estrellas;
  late String? comentario;

  CalificacionModel(this.idUsuarioCalificado, this.idUsuarioCalificador,
      this.estrellas, this.comentario);

  CalificacionModel.fromJson(Map<String, dynamic> json) {
    idUsuarioCalificado = json["idUsuarioCalificado"];
    idUsuarioCalificador = json["idUsuarioCalificador"];
    estrellas = json["estrellas"];
    comentario = json["comentario"];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data["idUsuarioCalificado"] = idUsuarioCalificado;
    _data["idUsuarioCalificador"] = idUsuarioCalificador;
    _data["estrellas"] = estrellas;
    _data["comentario"] = comentario;
    return _data;
  }
}
