// ignore: file_names
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, duplicate_ignore
import 'package:bazatlima/Models/usuario_model.dart';
import 'package:bazatlima/rootApp.dart';
import 'package:flutter/material.dart';
import 'package:bazatlima/signUpPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'api_service.dart';
import 'config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<LoginPage> {
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String? correo;
  String? password;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  initWidget() {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
            reverse: true,
            child: Form(
              key: globalKey,
              child: formulario(),
            )),
      ),
    );
  }

  Widget formulario() {
    return Column(
      children: [
        Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90),
                  bottomRight: Radius.circular(90)),
              color: Color(0xffF5591F),
              gradient: LinearGradient(colors: [
                (Color.fromARGB(255, 0, 0, 0)),
                (Color.fromARGB(255, 57, 62, 63))
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(),
                    padding: EdgeInsets.only(),
                    height: 300,
                    width: 300,
                    child: Image.asset("assets/images/login.png"),
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
              correo = onSavedVal;
            },
                isMultiline: false,
                multilineRows: 1,
                initialValue: "corvohyatt@gmail.com",
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
                context, "password", "Contraseña", (onValidate) {
              if (onValidate.isEmpty) {
                return 'Ingrese una contraseña';
              }
            }, (onSavedVal) {
              password = onSavedVal;
            },
                isMultiline: false,
                multilineRows: 1,
                obscureText: true,
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
            child: FormHelper.submitButton("Iniciar Sesión",
                btnColor: Colors.black,
                borderColor: Colors.black,
                width: 300,
                fontSize: 20, () async {
              if (validateAndSave()) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                APIService.exist(correo, password).then((response) {
                  if (response != -1) {
                    //Guardar en local el id del usuario
                    prefs.setInt('idUsuario', response.idUsuario);
                    Navigator.popAndPushNamed(context, "/rootApp");
                  } else {
                    return FormHelper.showSimpleAlertDialog(
                        context,
                        "Credenciales invalidas",
                        "Intente nuevamente con credenciales validas",
                        "Ok", () {
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
              Text("¿No tienes una cuenta todavia?"),
              GestureDetector(
                child: Text(
                  "¡Registrate aqui!",
                  style: TextStyle(color: Color(0xff1393aa)),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/signUpPage");
                },
              )
            ],
          ),
        )
      ],
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
