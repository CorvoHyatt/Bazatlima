import 'package:bazatlima/vendedor/producto_item_carrito.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'Models/producto_model.dart';
import 'api_service.dart';

class Carrito extends StatefulWidget {
  const Carrito({Key? key}) : super(key: key);

  @override
  State<Carrito> createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {
  int? idUsuario;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          title: const Text("Carrito", style: TextStyle(color: Colors.amber)),
        ),
        body: loadId(idUsuario),
      ),
    );
  }

  Widget loadId(idUsuario) {
    return FutureBuilder(
      future: Future<int>.delayed(Duration.zero, (() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int id = prefs.getInt("idUsuario") ?? 0;
        return id;
      })),
      builder: (BuildContext context, AsyncSnapshot<int?> idusuario) {
        if (idusuario.hasData) {
          print("idUsuario: ${idusuario.data}");
          idUsuario = idusuario.data;
          return loadProducts(idUsuario);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget loadProducts(idUsuario) {
    print("load: $idUsuario");
    return FutureBuilder(
      future: APIService.getProductosByCarrito(idUsuario),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<ProductoModel>?> model,
      ) {
        if (model.hasData) {
          return productListCarrito(model.data);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget productListCarrito(List<ProductoModel>? productos) {
    List<ProductoModel> products = productos!.reversed.toList();

    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              products.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 180.0),
                      child: Center(
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.90,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 12.0, left: 10, right: 10),
                            child: Text(
                              "Parece que aún no tienes productos :( \n\n\nAgrega tú primer producto ofertado a tu carrito :)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductoItemCarrito(
                          model: products[index],
                          onDelete: (ProductoModel model) {
                            setState(() {});
                            APIService.deleteProductoFromCarrito(
                                    model.idProducto)
                                .then((response) {
                              if (response) {
                                return FormHelper.showSimpleAlertDialog(context,
                                    "Exito!", "Producto eliminado", "Ok", () {
                                  Navigator.popUntil(
                                      context, ModalRoute.withName('/carrito'));
                                });
                              } else {
                                return FormHelper.showSimpleAlertDialog(
                                    context,
                                    "Error!",
                                    "Algo inesperado ocurrio",
                                    "Ok", () {
                                  Navigator.popUntil(
                                      context, ModalRoute.withName('/carrito'));
                                });
                              }
                            });
                          },
                        );
                      },
                    )
            ],
          )
        ],
      ),
    ));
  }
}
