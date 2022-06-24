// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:bazatlima/Models/calificacion_model.dart';
import 'package:bazatlima/Models/carrito_model.dart';
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
      print(data["data"]);
      return productosFromJson(data["data"]);
    } else {
      return null;
    }
  }

  static Future<List<ProductoModel>?> getProductosBySearch(
      String busqueda) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var urL = "${Config.productoURL}/getProductosByBusqueda";
    var url = Uri.http(Config.apiURL, urL);
    var data = jsonEncode({
      'producto': busqueda,
    });
    var response = await client.post(url, headers: requestHeaders, body: data);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data["data"]);
      return productosFromJson(data["data"]);
    } else {
      return null;
    }
  }

  static Future<List<ProductoModel>?> getProductosById(int? idUsuario) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var urL = "${Config.productoURL}/getProductosByUsuario/$idUsuario";
    var url = Uri.http(Config.apiURL, urL);

    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data["data"]);
      return productosFromJson(data["data"]);
    } else {
      return null;
    }
  }

  static Future<List<ProductoModel>?> getProductosByCarrito(
      int? idUsuario) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var urL = "${Config.carritoURL}/$idUsuario";
    print(urL);
    var url = Uri.http(Config.apiURL, urL);

    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data["data"]);
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
    int? idUsuario,
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
    var data;
    if (requestMethod == "POST") {
      data = jsonEncode({
        'nombreProducto': model.nombreProducto,
        'precio': model.precio,
        'descripcion': model.descripcion,
        'idCategoria': model.idCategoria,
        'idUsuario': idUsuario,
        'imagen':
            "https://www.salonsale.com.mx/admin/productos/default.jpg" // Aquí va model.imagen
      });
      var response =
          await client.post(url, headers: requestHeaders, body: data);
      if (response.statusCode == 200) {
        return true;
      }
    }

    if (requestMethod == "PUT") {
      data = jsonEncode({
        'nombreProducto': model.nombreProducto,
        'precio': model.precio,
        'descripcion': model.descripcion,
        'idCategoria': model.idCategoria,
        'idUsuario': idUsuario,
        'imagen': model.imagen
        //Aquí va model.imagen
      });
      var response = await client.put(url, headers: requestHeaders, body: data);
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
      print(data["data"]);
      return calificacionFromJson(data["data"]);
    } else {
      return null;
    }
  }

  static Future<double?> getEstrellas(idUsuario) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var calificacionURL = "${Config.calificacionURL}/average/$idUsuario";
    var url = Uri.http(Config.apiURL, calificacionURL);
    var response = await client.get(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return (double.parse((data["data"]["estrellasPromedio"].toString())));
    } else {
      return null;
    }
  }

  static Future<bool> saveCalificacion(CalificacionModel model) async {
    var calificacionURL = "${Config.calificacionURL}/create";
    var url = Uri.http(Config.apiURL, calificacionURL);
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var data;

    data = jsonEncode({
      'comentario': model.comentario,
      'estrellas': model.estrellas,
      'idUsuarioCalificado': model.idUsuarioCalificado,
      'idUsuarioCalificador': model.idUsuarioCalificador,
    });
    var response = await client.post(url, headers: requestHeaders, body: data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // ---------------- Usuario ----------------

  static Future<int> agregarUsuario(UsuarioModel? usuario) async {
    var usuarioURL = Config.usuariosURL;
    usuarioURL = "$usuarioURL/create";
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiURL, usuarioURL);
    var data = jsonEncode({
      'nombreUsuario': usuario?.nombreUsuario,
      'telefono': usuario?.telefono,
      'correo': usuario?.correo,
      'password': usuario?.password,
      'rol': 0,
      'imagen':
          "https://icons.veryicon.com/png/o/avatar/user-2/skull-line-1.png"
    });
    var response = await client.post(url, headers: requestHeaders, body: data);
    if (response.statusCode == 200) {
      var resp = jsonDecode(response.body);
      return resp;
    }
    return -1;
  }

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

  static Future<bool> updateUsuario(UsuarioModel usuario) async {
    var usuarioURL = Config.usuariosURL;
    usuarioURL = "$usuarioURL/update/${usuario.idUsuario}";
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiURL, usuarioURL);
    var data = jsonEncode({
      'nombreUsuario': usuario.nombreUsuario,
      'telefono': usuario.telefono,
      'correo': usuario.correo,
      'password': usuario.password,
      'rol': usuario.rol,
      'imagen': usuario.imagen
    });
    var response = await client.put(url, headers: requestHeaders, body: data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
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

  static Future<bool> addProductoToCarrito(idProducto, idUsuario) async {
    var calificacionURL = "${Config.carritoURL}/create";
    var url = Uri.http(Config.apiURL, calificacionURL);
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    var data = jsonEncode({
      'idProducto': idProducto,
      'idUsuario': idUsuario,
    });
    var response = await client.post(url, headers: requestHeaders, body: data);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  static Future<bool> deleteProductoFromCarrito(productId) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    // ignore: prefer_interpolation_to_compose_strings
    var url = Uri.http(Config.apiURL, "${Config.carritoURL}/delete/$productId");

    var response = await client.delete(url, headers: requestHeaders);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
