// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:bazatlima/Models/calificacion_model.dart';
import 'package:bazatlima/Models/categoria_model.dart';
import 'package:bazatlima/Models/producto_model.dart';
import 'package:http/http.dart' as http;
import 'Models/usuario_model.dart';
import 'config.dart';

class APIService {
  static var client = http.Client();

  // ---------------- PRODUCTOS ----------------
  static Future<List<ProductoModel>?> getProductos() async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiURL, Config.productoURL);

    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return productosFromJson(data["data"]);
    } else {
      return null;
    }
  }

  static Future<ProductoModel?> getProducto(int idProducto) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var productoURL = "${Config.productoURL}/$idProducto";
    var url = Uri.http(Config.apiURL, productoURL);
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return productoFromJson(data["data"]);
    } else {
      return null;
    }
  }

  static Future<bool> saveProducto(
    ProductoModel model,
    bool isEditMode,
    bool isFileSelected,
  ) async {
    var productoURL = Config.productoURL;
    if (isEditMode) {
      productoURL = "$productoURL/update/${model.idProducto}";
    } else {
      productoURL = "$productoURL/create";
    }

    var url = Uri.http(Config.apiURL, productoURL);

    var requestMethod = isEditMode ? "PUT" : "POST";
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    if (requestMethod == "POST") {
      var data = jsonEncode({
        'nombreProducto': model.nombreProducto,
        'precio': model.precio,
        'descripcion': model.descripcion,
        'idCategoria': model.idCategoria,
        'idUsuario': 2,
        'imagen': model.imagen ?? ""
      });
      var response =
          await client.post(url, headers: requestHeaders, body: data);
      if (response.statusCode == 200) {
        return true;
      }
    }
    return false;
  }

  static Future<bool> deleteProducto(productId) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    // ignore: prefer_interpolation_to_compose_strings
    var url =
        Uri.http(Config.apiURL, "${Config.productoURL}/delete/$productId");

    var response = await client.delete(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // ---------------- Categorias ----------------
  static Future<List<CategoriaModel>?> getCategorias() async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var categoriasURL = "${Config.categoriasURL}/";
    var url = Uri.http(Config.apiURL, categoriasURL);
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return categoriasFromJson(data["data"]);
    } else {
      return null;
    }
  }

  // ---------------- Calificacion ----------------
  static Future<List<CalificacionModel>?> getCalificacion(idUsuario) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var calificacionURL = "${Config.calificacionURL}/$idUsuario";
    var url = Uri.http(Config.apiURL, calificacionURL);
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return calificacionFromJson(data["data"]);
    } else {
      return null;
    }
  }

  static Future<int?> getEstrellas(idUsuario) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var calificacionURL = "${Config.calificacionURL}/average/$idUsuario";
    var url = Uri.http(Config.apiURL, calificacionURL);
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return estrellasFromJson(data["data"]);
    } else {
      return null;
    }
  }

  static Future<bool> saveCalificacion(
    CalificacionModel model,
    bool isEditMode,
  ) async {
    var calificacionURL = "${Config.calificacionURL}/create";
    var url = Uri.http(Config.apiURL, calificacionURL);

    var requestMethod = "POST";

    var request = http.MultipartRequest(requestMethod, url);

    request.fields["idUsuarioCalificado"] =
        model.idUsuarioCalificado!.toString();
    request.fields["idUsuarioCalificador"] =
        model.idUsuarioCalificador!.toString();
    request.fields["estrellas"] = model.estrellas!.toString();
    request.fields["comentario"] = model.comentario!;

    var response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  // ---------------- Usuario ----------------
  static Future<dynamic> exist(correo, password) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var usuarioURL = "${Config.usuariosURL}/exists";
    var url = Uri.http(Config.apiURL, usuarioURL);
    var data = jsonEncode({
      'correo': correo,
      'password': password,
    });
    var response = await client.post(url, headers: requestHeaders, body: data);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data["data"]);
      return usuarioFromJson(data["data"]);
    } else {
      return -1;
    }
  }

  static Future<UsuarioModel?> getUsuario(int? idUsuario) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var usuarioURL = "${Config.usuariosURL}/$idUsuario";
    var url = Uri.http(Config.apiURL, usuarioURL);
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return usuarioFromJson(data);
    } else {
      return null;
    }
  }

  // ---------------- Carrito ---------------- POR LO PRONTO

  static Future<List<CalificacionModel>?> getCarrito(
      idProducto, idUsuario) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var calificacionURL = "${Config.calificacionURL}/$idProducto/$idUsuario";
    var url = Uri.http(Config.apiURL, calificacionURL);
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return calificacionFromJson(data["data"]);
    } else {
      return null;
    }
  }
}
