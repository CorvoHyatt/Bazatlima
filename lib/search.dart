import 'package:bazatlima/comprador/producto_idem.dart';
import 'package:flutter/material.dart';

import 'Models/producto_model.dart';
import 'api_service.dart';

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Widget loadProducts() {
    return FutureBuilder(
      future: APIService.getProductosBySearch(query),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<ProductoModel>?> model,
      ) {
        if (model.hasData) {
          return productList(model.data);
        }
        return const Center(
          child: Text(
            "No se encontraron coincidencias :(",
            style: TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }

  Widget productList(productos) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: productos.length,
            itemBuilder: (context, index) {
              return TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/view-product",
                      arguments: {'model': productos[index]});
                },
                child: ProductoItem(
                  model: productos[index],
                  onDelete: (ProductoModel model) {},
                ),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return loadProducts();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
        child: Text(
      textAlign: TextAlign.center,
      "Aquí podrás encontrar el producto que buscas!",
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
    ));
  }
}
