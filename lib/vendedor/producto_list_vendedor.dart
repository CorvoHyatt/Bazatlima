import 'package:flutter/material.dart';
import 'package:bazatlima/Models/producto_model.dart';
import 'package:bazatlima/vendedor/producto_item_vendedor.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

import '../api_service.dart';

class ProductListVendedor extends StatefulWidget {
  const ProductListVendedor({Key? key}) : super(key: key);

  @override
  State<ProductListVendedor> createState() => _ProductListVendedorState();
}

class _ProductListVendedorState extends State<ProductListVendedor> {
  List<ProductoModel> productos = List<ProductoModel>.empty(growable: true);
  int _currentIndex = 0;
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductoItemVendedor(
                    model: products[index],
                    onDelete: (ProductoModel model) {
                      setState(() {});
                      APIService.deleteProducto(model.idProducto)
                          .then((response) {
                        return FormHelper.showSimpleAlertDialog(
                            context, "Alerta", "Producto eliminado", "Ok", () {
                          Navigator.of(context).pop();
                        });
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
      body: loadProducts(),
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

  Widget loadProducts() {
    return FutureBuilder(
      future: APIService.getProductos(),
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
