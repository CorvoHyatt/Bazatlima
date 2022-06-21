import 'package:bazatlima/api_service.dart';
import 'package:bazatlima/search.dart';
import 'package:flutter/material.dart';
import 'package:bazatlima/Models/producto_model.dart';
import 'package:bazatlima/comprador/producto_idem.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  List<ProductoModel> productos = List<ProductoModel>.empty(growable: true);

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: const [
              (Color.fromARGB(255, 0, 0, 0)),
              (Color.fromARGB(255, 57, 62, 63))
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Center(
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(left: 20, right: 20, top: 45),
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 2),
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: (Colors.white),
              ),
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: TextField(
                  cursorColor: Color.fromARGB(255, 202, 191, 34),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 202, 191, 34)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.search,
                        color: (Color.fromARGB(255, 0, 0, 0)),
                      )),
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: loadProducts(),
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
          return productList(model.data);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
