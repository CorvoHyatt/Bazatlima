import 'package:bazatlima/Models/usuario_model.dart';
import 'package:bazatlima/api_service.dart';
import 'package:bazatlima/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class UsuarioInfo extends StatefulWidget {
  const UsuarioInfo({Key? key}) : super(key: key);

  @override
  State<UsuarioInfo> createState() => _UsuarioInfoState();
}

class _UsuarioInfoState extends State<UsuarioInfo> {
  int? idUsuario;
  UsuarioModel? usuario;
  int? rate;
  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "Mi cuenta",
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
      backgroundColor: Colors.white,
      body: loadUsuario(context),
    );
  }

  Widget usuarioInfo(context, UsuarioModel? usuario) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: SizedBox(
                  height: 250,
                  width: 250,
                  child: Image.network(
                    usuario?.imagen ??
                        "https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE4LqQX?ver=fe80&q=90&m=6&h=705&w=1253&b=%23FFFFFFFF&f=jpg&o=f&p=140&aim=true",
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30, left: 40, right: 30),
            child: Text(
              usuario!.nombreUsuario!,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 40, right: 15),
                  child: Icon(Icons.email),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 9, right: 30),
                  child: Text(
                    usuario.correo!,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 40,
                  bottom: 30,
                ),
                child: Icon(Icons.phone),
              ),
              Padding(
                padding: EdgeInsets.only(top: 9, right: 30, left: 15),
                child: Text(
                  usuario.telefono!,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
          usuario.rol != 1
              ? Column(
                  children: [
                    Center(
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                            child: Text("Comprador",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500))),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    actionsAlignment:
                                        MainAxisAlignment.spaceAround,
                                    title: Icon(
                                      Icons.monetization_on,
                                      color: Colors.amber,
                                      size: 50,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Cancelar",
                                          style: TextStyle(color: Colors.amber),
                                        ),
                                      ),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.amber)),
                                          onPressed: () async {
                                            usuario.rol = 1;
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            APIService.updateUsuario(usuario)
                                                .then((response) {
                                              if (response) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                          actionsAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          title: Icon(
                                                            Icons.check,
                                                            color: Colors.green,
                                                            size: 50,
                                                          ),
                                                          actions: [
                                                            ElevatedButton(
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            Colors.amber)),
                                                                onPressed: () {
                                                                  prefs.setInt(
                                                                      'indexMe',
                                                                      3);

                                                                  Navigator.popUntil(
                                                                      context,
                                                                      ModalRoute
                                                                          .withName(
                                                                              '/rootApp'));
                                                                  Navigator
                                                                      .popAndPushNamed(
                                                                    context,
                                                                    '/rootApp',
                                                                  );
                                                                },
                                                                child: Text(
                                                                  "Ok",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ))
                                                          ],
                                                          content: Text(
                                                            "Cambio de rol exitoso",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .amber),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          backgroundColor:
                                                              Colors.black,
                                                        ));
                                              } else {
                                                FormHelper
                                                    .showSimpleAlertDialog(
                                                        context,
                                                        Config.appName,
                                                        "Error Ocurred",
                                                        "Ok", () {
                                                  Navigator.of(context).pop();
                                                });
                                              }
                                            });
                                          },
                                          child: Text(
                                            "Cambiar",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))
                                    ],
                                    content: Text(
                                      "Cambia tu rol a vendedor y disfruta los privilegios de ofertar tus productos",
                                      style: TextStyle(color: Colors.amber),
                                      textAlign: TextAlign.justify,
                                    ),
                                    backgroundColor: Colors.black87,
                                  ));
                        },
                        child: Text("Cambiate a vendedor Aquí"),
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    Center(
                      child: Container(
                        height: 50,
                        width: 200,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: const [
                                  (Color.fromARGB(255, 0, 0, 0)),
                                  (Color.fromARGB(255, 85, 89, 90))
                                ]),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                            child: Text("Vendedor",
                                style: TextStyle(
                                    color: Colors.amber,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500))),
                      ),
                    ),
                  ],
                ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Center(child: loadCalificacion(context)),
          )
        ],
      ),
    );
  }

  Widget rating(double? rate) {
    return rate != -1
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SmoothStarRating(
                  color: Colors.amber,
                  borderColor: Colors.black,
                  rating: rate ?? 0,
                  allowHalfRating: true,
                  isReadOnly: true,
                  size: 35,
                  spacing: 8,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Center(
                  child: Text(
                    "Rating",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SmoothStarRating(
                  color: Colors.amber,
                  borderColor: Colors.black,
                  rating: 0,
                  allowHalfRating: true,
                  isReadOnly: true,
                  size: 35,
                  spacing: 8,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Center(
                  child: Text(
                    "Aun no tienes una calificación :(",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          );
  }

  Widget loadCalificacion(context) {
    return FutureBuilder(
      future: APIService.getEstrellas(idUsuario),
      builder: (BuildContext context, AsyncSnapshot<double?> rate) {
        if (rate.hasData) {
          return rating(rate.data);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget loadUsuario(context) {
    return FutureBuilder(
      future: APIService.getUsuario(idUsuario),
      builder: (BuildContext context, AsyncSnapshot<UsuarioModel?> usuario) {
        if (usuario.hasData) {
          return usuarioInfo(context, usuario.data);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
