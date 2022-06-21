List<CategoriaModel> categoriasFromJson(dynamic str) =>
    List<CategoriaModel>.from((str).map((x) => CategoriaModel.fromJson(x)));

class CategoriaModel {
  late int? idCategoria;
  late String? categoria;

  CategoriaModel({this.idCategoria, this.categoria});

  CategoriaModel.fromJson(Map<String, dynamic> json) {
    idCategoria = json["idCategoria"];
    categoria = json["categoria"];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data["idCategoria"] = idCategoria;
    _data["categoria"] = categoria;
    return _data;
  }
}
