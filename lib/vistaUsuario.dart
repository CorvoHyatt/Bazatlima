import 'package:bazatlima/Models/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';

class VistaUsuario extends StatefulWidget {
  const VistaUsuario({Key? key}) : super(key: key);

  @override
  State<VistaUsuario> createState() => _VistaUsuarioState();
}

class _VistaUsuarioState extends State<VistaUsuario> {
  UsuarioModel? usuario;
  double rating = 4.0;
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
                                onSubmitted: (response) {});
                          });
                    },
                    child: Text("Calificar Usuario")),
              )
            ]),
      ),
    );
  }

  void showRating() {}
}
