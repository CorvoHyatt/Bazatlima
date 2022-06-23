// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore, file_names

import 'package:bazatlima/Models/usuario_model.dart';
import 'package:bazatlima/api_service.dart';
import 'package:bazatlima/rootApp.dart';
import 'package:flutter/material.dart';
import 'package:bazatlima/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

///
/// [ignore: use_key_in_widget_constructors]
///
/// [@author	Unknown]
/// [ @since	v0.0.1 ]
/// [@version	v1.0.0	Thursday, June 23rd, 2022]
/// [@see		StatefulWidget]
/// [@global]
///
class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SignUpPage> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String? password;
  UsuarioModel? usuario;

  @override
  void initState() {
    super.initState();

    usuario = UsuarioModel();
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  initWidget() {
    return Scaffold(
      body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: globalKey,
            child: formulario(),
          )),
    );
  }

  Widget formulario() {
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: [
          Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(90),
                    bottomRight: Radius.circular(90)),
                color: Color(0xffF5591F),
                // ignore: prefer_const_constructors
                gradient: LinearGradient(
                  colors: [
                    (Color.fromARGB(255, 0, 0, 0)),
                    (Color.fromARGB(255, 57, 62, 63))
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(),
                      height: 200,
                      width: 200,
                      child: Image.asset("assets/images/signUp.png"),
                    )
                  ],
                ),
              )),
          Container(
              padding: EdgeInsets.only(top: 60),
              child: FormHelper.inputFieldWidget(context, "correo", "Correo",
                  (onValidate) {
                if (onValidate.isEmpty) {
                  return 'Ingrese un correo';
                }
              }, (onSavedVal) {
                usuario?.correo = onSavedVal;
              },
                  isMultiline: false,
                  multilineRows: 1,
                  initialValue: "Correo@gmail.com",
                  borderColor: Colors.black,
                  borderFocusColor: Colors.black,
                  textColor: Colors.black,
                  hintColor: Colors.black.withOpacity(.7),
                  borderRadius: 10,
                  showPrefixIcon: true,
                  prefixIcon: Icon(Icons.mail),
                  prefixIconColor: Colors.black)),
          Container(
              padding: EdgeInsets.only(top: 20),
              child: FormHelper.inputFieldWidget(
                  context, "Nombre", "Nombre y apellidos", (onValidate) {
                if (onValidate.isEmpty) {
                  return 'Ingrese un su nombre y apellidos';
                }
              }, (onSavedVal) {
                usuario?.nombreUsuario = onSavedVal;
              },
                  isMultiline: false,
                  multilineRows: 1,
                  initialValue: "Laura Alvarez Guevara",
                  borderColor: Colors.black,
                  borderFocusColor: Colors.black,
                  textColor: Colors.black,
                  hintColor: Colors.black.withOpacity(.7),
                  borderRadius: 10,
                  showPrefixIcon: true,
                  prefixIcon: Icon(Icons.person),
                  prefixIconColor: Colors.black)),
          Container(
              padding: EdgeInsets.only(top: 20),
              child: FormHelper.inputFieldWidget(
                  context, "password", "Contraseña", (onValidate) {
                if (onValidate.isEmpty) {
                  return 'Ingrese una contraseña';
                }
                password = onValidate;
              }, (onSavedVal) {},
                  obscureText: true,
                  isMultiline: false,
                  multilineRows: 1,
                  initialValue: "1234",
                  borderColor: Colors.black,
                  borderFocusColor: Colors.black,
                  textColor: Colors.black,
                  hintColor: Colors.black.withOpacity(.7),
                  borderRadius: 10,
                  showPrefixIcon: true,
                  prefixIcon: Icon(Icons.password),
                  prefixIconColor: Colors.black)),
          Container(
              padding: EdgeInsets.only(top: 20),
              child: FormHelper.inputFieldWidget(
                  context, "passwordConfirmation", "Confirmar Contraseña",
                  (onValidate) {
                if (onValidate.isEmpty) {
                  return 'Confirme la contraseña';
                } else if (password != onValidate) {
                  return 'Las contraseñas deben coincidir';
                }
              }, (onSavedVal) {
                usuario?.password = onSavedVal;
              },
                  obscureText: true,
                  isMultiline: false,
                  multilineRows: 1,
                  initialValue: "1234",
                  borderColor: Colors.black,
                  borderFocusColor: Colors.black,
                  textColor: Colors.black,
                  hintColor: Colors.black.withOpacity(.7),
                  borderRadius: 10,
                  showPrefixIcon: true,
                  prefixIcon: Icon(Icons.password),
                  prefixIconColor: Colors.black)),
          Container(
              padding: EdgeInsets.only(top: 20),
              child: FormHelper.inputFieldWidget(
                  context, "Teléfono", "Télefono", (onValidate) {
                if (onValidate.isEmpty) {
                  return 'Ingrese un número de teléfono';
                }
              }, (onSavedVal) {
                usuario?.telefono = onSavedVal;
              },
                  isNumeric: true,
                  isMultiline: false,
                  multilineRows: 1,
                  initialValue: "4492651758",
                  borderColor: Colors.black,
                  borderFocusColor: Colors.black,
                  textColor: Colors.black,
                  hintColor: Colors.black.withOpacity(.7),
                  borderRadius: 10,
                  showPrefixIcon: true,
                  prefixIcon: Icon(Icons.phone),
                  prefixIconColor: Colors.black)),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {},
              child: Text("¿Olvidaste tu contraseña?"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: FormHelper.submitButton("Registrate",
                  btnColor: Colors.black,
                  borderColor: Colors.black,
                  width: 300,
                  fontSize: 20, () async {
                if (validateAndSave()) {
                  print("nombre: ${usuario?.nombreUsuario}");
                  print("telefono: ${usuario?.telefono}");
                  print("contraseña: ${usuario?.password}");
                  print("correo: ${usuario?.correo}");
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  APIService.agregarUsuario(usuario).then((response) {
                    if (response != -1) {
                      prefs.setInt('idUsuario', response);
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext contexto) => AlertDialog(
                                title: Text("Bienvenido"),
                                content: Text("Registro exitoso!"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.popAndPushNamed(
                                            context, "/rootApp");
                                      },
                                      child: Text("Ok")),
                                ],
                              ));
                    } else {
                      FormHelper.showSimpleAlertDialog(
                          context, "Error", "Algo Salio mal", "Ok", () {
                        Navigator.of(context).pop();
                      });
                    }
                  });
                }
              }),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("¿Ya tienes una cuenta?"),
                GestureDetector(
                  child: Text(
                    "¡Logeate aqui!",
                    style: TextStyle(color: Color(0xff1393aa)),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
