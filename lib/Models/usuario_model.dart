List<UsuarioModel> usuariosFromJson(dynamic str) =>
    List<UsuarioModel>.from((str).map((x) => UsuarioModel.fromJson(x)));

UsuarioModel usuarioFromJson(dynamic str) => UsuarioModel.fromJson(str);

class UsuarioModel {
  late int? idUsuario;
  late String? nombreUsuario;
  late String? correo;
  late String? password;
  late int? rol;
  late String? imagen;
  late String? telefono;

  UsuarioModel(
      {this.idUsuario,
      this.nombreUsuario,
      this.correo,
      this.password,
      this.rol,
      this.imagen,
      this.telefono});

  UsuarioModel.fromJson(Map<String, dynamic> json) {
    idUsuario = json["idUsuario"];
    nombreUsuario = json["nombreUsuario"];
    correo = json["correo"];
    password = json["password"];
    rol = json["rol"];
    imagen = json["imagen"];
    telefono = json["telefono"];
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data["idUsuario"] = idUsuario;
    _data["nombreUsuario"] = nombreUsuario;
    _data["correo"] = correo;
    _data["password"] = password;
    _data["rol"] = rol;
    _data["imagen"] = imagen;
    _data["telefono"] = telefono;
    return _data;
  }
}
