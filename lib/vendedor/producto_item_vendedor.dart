import 'package:flutter/material.dart';
import 'package:bazatlima/Models/producto_model.dart';

class ProductoItemVendedor extends StatelessWidget {
  const ProductoItemVendedor({Key? key, this.model, this.onDelete})
      : super(key: key);
  final ProductoModel? model;
  final Function? onDelete;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/view-product",
            arguments: {'model': model});
      },
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: productWidgetVendedor(context)),
      ),
    );
  }

  Widget productWidgetVendedor(context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/view-product",
            arguments: {'model': model});
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                child: Image.network(
                  (model!.imagen == null || model!.imagen == "")
                      ? "https://m.media-amazon.com/images/I/81aylYdIRPL._AC_SL1500_.jpg"
                      : model!.imagen!,
                  height: 150,
                  fit: BoxFit.scaleDown,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model!.nombreProducto!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "\$${model!.precio!}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 19),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          model!.descripcion!,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              fontSize: 14),
                          maxLines: 5,
                          overflow: TextOverflow.fade,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width - 180,
            padding: const EdgeInsets.only(bottom: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: const Icon(
                    Icons.edit,
                    size: 30,
                    color: Colors.green,
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/edit-product',
                        arguments: {'model': model});
                  },
                ),
                GestureDetector(
                  child: const Icon(Icons.delete,
                      size: 30, color: Colors.redAccent),
                  onTap: () {
                    print("Delete|");
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => AlertDialog(
                              title: Text("Eliminar"),
                              content: Text(
                                  "¿Estas seguro que quieres eliminar este producto?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      onDelete!(model);
                                    },
                                    child: Text("Si")),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No")),
                              ],
                            ));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
