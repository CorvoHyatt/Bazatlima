import 'package:bazatlima/Models/calificacion_model.dart';
import 'package:bazatlima/Models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'api_service.dart';

class VistaUsuario extends StatefulWidget {
  const VistaUsuario({Key? key}) : super(key: key);

  @override
  State<VistaUsuario> createState() => _VistaUsuarioState();
}

class _VistaUsuarioState extends State<VistaUsuario> {
  UsuarioModel? usuario;
  double rating = 4.0;
  int? idUsuarioCalicador;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, (() {
      print(ModalRoute.of(context)?.settings.arguments);
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final Map arguments = (ModalRoute.of(context)?.settings.arguments)
            as Map<String, dynamic>;
        usuario = arguments["usuario"];
        setState(() {});
      }
    }));
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
                  cursorColor: Colors.amber,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.amber),
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
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                    height: 40,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          colors: const [
                            (Color.fromARGB(255, 0, 0, 0)),
                            (Color.fromARGB(255, 57, 62, 63))
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    ),
                    child: Center(
                      child: Text(
                        usuario?.rol == 1 ? "Vendedor" : " Comprador",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: SizedBox(
                      height: 300,
                      width: 300,
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
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  usuario?.nombreUsuario ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  usuario?.correo ?? "",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600]),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return RatingDialog(
                                title: Text(
                                  "Calificar ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                message: Text(
                                  "Da click en la estrella para calificar",
                                ),
                                commentHint:
                                    "Haz un comentario sobre el usuario",
                                image: Icon(
                                  Icons.star,
                                  size: 100,
                                  color: Colors.amber,
                                ),
                                submitButtonText: "Enviar",
                                onSubmitted: (response) async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  idUsuarioCalicador =
                                      prefs.getInt("idUsuario");
                                  CalificacionModel cal = CalificacionModel(
                                      usuario?.idUsuario,
                                      idUsuarioCalicador,
                                      rating.round(),
                                      response.comment);
                                  APIService.saveCalificacion(cal)
                                      .then((respons) {
                                    if (respons) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                actionsAlignment:
                                                    MainAxisAlignment.center,
                                                title: Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                  size: 50,
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .amber)),
                                                      onPressed: () {
                                                        prefs.setInt(
                                                            'index', 1);

                                                        Navigator.popUntil(
                                                            context,
                                                            ModalRoute.withName(
                                                                '/view-user'));
                                                      },
                                                      child: Text(
                                                        "Ok",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ))
                                                ],
                                                content: Text(
                                                  "Comentario enviado!",
                                                  style: TextStyle(
                                                      color: Colors.amber),
                                                  textAlign: TextAlign.center,
                                                ),
                                                backgroundColor: Colors.white,
                                              ));
                                    } else {
                                      // FormHelper.showSimpleAlertDialog(
                                      //     context, Config.appName, "Error Ocurred", "Ok", () {
                                      //   Navigator.of(context).pop();
                                      // });
                                    }
                                  });
                                });
                          });
                    },
                    child: Text("Calificar Usuario")),
              ),
              loadCalificacion(context),
              // loadCalificacion(context),
            ]),
      ),
    );
  }

  Widget rate3(double? rate) {
    print(rate);
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
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      textAlign: TextAlign.center,
                      "Aun no tiene una calificación este usuario :(",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
  }

  Widget loadCalificacion(context) {
    if (usuario?.idUsuario == null) {
      return loadCalificacion(context);
    }
    return FutureBuilder(
      future: APIService.getEstrellas(usuario?.idUsuario),
      builder: (BuildContext context, AsyncSnapshot<double?> rate) {
        if (rate.hasData) {
          print(rate.data);
          return rate3(rate.data);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
