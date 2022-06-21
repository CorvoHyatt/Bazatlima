import 'package:flutter/material.dart';
import 'package:bazatlima/Models/producto_model.dart';

class ProductoItem extends StatelessWidget {
  const ProductoItem({Key? key, this.model, this.onDelete}) : super(key: key);
  final ProductoModel? model;
  final Function? onDelete;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
        child: Container(
            width: MediaQuery.of(context).size.width - 20,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(30),
            ),
            child: productWidget(context)),
      ),
    );
  }

  Widget productWidget(context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
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
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model!.nombreProducto!,
                          style: const TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "\$${model!.precio!}",
                          style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          model!.descripcion!,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                              fontSize: 14),
                          maxLines: 3,
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
        ],
      ),
    );
  }
}
