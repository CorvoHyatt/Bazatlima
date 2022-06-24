import 'dart:io';
import 'package:snippet_coder_utils/FormHelper.dart';

import 'package:bazatlima/Models/producto_model.dart';
import 'package:bazatlima/Models/usuario_model.dart';
import 'package:bazatlima/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class VistaProducto extends StatefulWidget {
  const VistaProducto({Key? key}) : super(key: key);

  @override
  State<VistaProducto> createState() => _VistaProductoState();
}

class _VistaProductoState extends State<VistaProducto> {
  UsuarioModel? usuarioVendedor;
  ProductoModel? model;
  int? idUsuario;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, (() {
      print(ModalRoute.of(context)?.settings.arguments);
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = (ModalRoute.of(context)?.settings.arguments)
            as Map<String, dynamic>;
        model = arguments["model"];
        setState(() {});
      }
    }));
    _cargarId();
  }

  _cargarId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      idUsuario = prefs.getInt("idUsuario") ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loadVendedor();
  }

  Widget loadVendedor() {
    return FutureBuilder(
      future: APIService.getUsuario(model?.idUsuario),
      builder:
          (BuildContext context, AsyncSnapshot<UsuarioModel?> usuarioVendedor) {
        if (usuarioVendedor.hasData) {
          return cuerpo(usuarioVendedor.data as UsuarioModel);
        }
        return const Center(
            child: CircularProgressIndicator(color: Colors.white));
      },
    );
  }

  Widget cuerpo(UsuarioModel usuarioVendedor) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Información de Producto",
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
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      model!.nombreProducto!,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                      maxLines: 4,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: TextButton(
                    style: ButtonStyle(),
                    onPressed: () {
                      print(usuarioVendedor);
                      Navigator.pushNamed(context, "/view-user",
                          arguments: {'usuario': usuarioVendedor});
                    },
                    child: Text("Por ${usuarioVendedor.nombreUsuario!}",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: Image.network(
                        model?.imagen ??
                            "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE4LqQX?ver=fe80&q=90&m=6&h=705&w=1253&b=%23FFFFFFFF&f=jpg&o=f&p=140&aim=true",
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),
              ),
              (model!.estadoProducto == 1)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, right: 0),
                          child: Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(left: 30),
                              child: Text(
                                "\$${model!.precio.toString()}",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 50),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25, right: 30),
                          child: Container(
                            height: 25,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  Text(
                                    "Disponible",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )
                                ]),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: 50,
                      width: 60,
                      decoration: BoxDecoration(color: Colors.red),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 15),
                child: Text(
                  "Descripción",
                  style: TextStyle(color: Colors.grey[700], fontSize: 30),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 30.0, top: 15, right: 30, bottom: 20),
                child: Text("${model!.descripcion}",
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.black, fontSize: 20)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Center(
                    child: TextButton(
                  onPressed: () async {
                    APIService.addProductoToCarrito(
                            model?.idProducto, idUsuario)
                        .then((response) {
                      if (response) {
                        //Guardar en local el id del usuario
                        return FormHelper.showSimpleAlertDialog(context,
                            "Exito!", "Producto agregado a carrito", "Ok", () {
                          Navigator.of(context).pop();
                        });
                      } else {
                        return FormHelper.showSimpleAlertDialog(
                            context,
                            "Error",
                            "Algo salio mal, intente más tarde",
                            "Ok", () {
                          Navigator.of(context).pop();
                        });
                      }
                    });
                  },
                  style: TextButton.styleFrom(
                      shadowColor: Colors.black,
                      backgroundColor: Colors.black,
                      fixedSize: Size(250, 50)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Icon(Icons.shopping_cart_checkout,
                            color: Colors.amber),
                      ),
                      Text("Agregar a carrito",
                          style: TextStyle(color: Colors.amber, fontSize: 20)),
                    ],
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
