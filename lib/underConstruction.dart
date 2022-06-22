import 'package:bazatlima/Models/usuario_model.dart';
import 'package:flutter/material.dart';

class UnderConstruction extends StatefulWidget {
  const UnderConstruction({Key? key, this.usuario}) : super(key: key);
  final UsuarioModel? usuario;

  @override
  State<UnderConstruction> createState() => _UnderConstructionState();
}

class _UnderConstructionState extends State<UnderConstruction> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Center(
              child: Icon(
                Icons.warning,
                size: 200,
              ),
            ),
          ),
          Center(
            child: Text(
              "En construcción",
              style: TextStyle(
                  backgroundColor: Colors.amber,
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      )),
    );
  }
}
