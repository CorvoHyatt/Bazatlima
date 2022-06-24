import 'package:flutter/material.dart';
import 'package:bazatlima/Models/producto_model.dart';
import 'package:bazatlima/vendedor/producto_item_vendedor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../api_service.dart';

class ProductListVendedor extends StatefulWidget {
  const ProductListVendedor({Key? key}) : super(key: key);

  @override
  State<ProductListVendedor> createState() => _ProductListVendedorState();
}

class _ProductListVendedorState extends State<ProductListVendedor> {
  List<ProductoModel> productos = List<ProductoModel>.empty(growable: true);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? idUsuario;
  @override
  void initState() {
    super.initState();
  }

  Widget productListVendedor(List<ProductoModel>? productos) {
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
                              "Parece que aún no tienes productos :( \n\n\nAgrega tú primer producto en el botón con signo + :)",
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
                      itemBuilder: (BuildContext ctx, index) {
                        return ProductoItemVendedor(
                          model: products[index],
                          onDelete: (ProductoModel model) {
                            setState(() {});
                            APIService.deleteProducto(model.idProducto)
                                .then((response) {
                              if (response) {
                                return FormHelper.showSimpleAlertDialog(
                                    ctx, "Exito!", "Producto eliminado", "Ok",
                                    () {
                                  Navigator.popUntil(ctx,
                                      ModalRoute.withName('/list-vendedor'));
                                });
                              } else {
                                return FormHelper.showSimpleAlertDialog(
                                    ctx,
                                    "Error!",
                                    "Algo inesperado ocurrio",
                                    "Ok", () {
                                  Navigator.popUntil(ctx,
                                      ModalRoute.withName('/list-vendedor'));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
            child: Text(
          "Mis Productos Ofertados",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.amber,
          ),
        )),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: const [
              (Color.fromARGB(255, 0, 0, 0)),
              (Color.fromARGB(255, 57, 62, 63))
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: loadId(idUsuario),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, "/add-product");
          },
          tooltip: "Agregar Producto",
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          child: const Icon(
            Icons.add,
            color: Colors.amber,
          )),
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
      future: APIService.getProductosById(idUsuario),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<ProductoModel>?> model,
      ) {
        if (model.hasData) {
          return productListVendedor(model.data);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
